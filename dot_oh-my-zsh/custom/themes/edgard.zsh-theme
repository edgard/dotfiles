#!/usr/bin/env zsh

# Fast, minimal zsh theme by Edgard Castro

# Load required zsh modules
autoload -Uz colors && colors

# Define colors using named variables (Catppuccin Frappé palette)
local color_user='yellow'
local color_at='blue'
local color_host='green'
local color_colon='blue'
local color_dir='blue'
local color_git_branch='red'
local color_git_brackets='blue'
local color_git_status='cyan'
local color_duration='yellow'
local color_jobs='blue'
local color_char_success='magenta'
local color_char_error='red'

# Use zsh associative arrays for caching
typeset -gA _prompt_data
_prompt_data=(
  git_dir ""
  git_branch ""
  git_status ""
  git_last_pwd ""
  git_last_check 0
)

# Use zsh's vcs_info system for git tracking
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

# Define precmd hook with typeset -g for proper scope
typeset -g -a precmd_functions
typeset -g -a preexec_functions

# Performance: use direct zsh builtins for checks, avoid slow use of [[ ]] where possible
# Optimized prompt_git_info function using zsh's vcs_info + manual status checks
function prompt_git_info() {
  local formatted_branch git_status status_symbols

  # Exit early if we already know we're not in a git repo
  [[ -z $_prompt_data[git_dir] ]] && return

  # Format branch name with proper color
  formatted_branch="%{$fg[$color_git_branch]%}${_prompt_data[git_branch]}%{$reset_color%}"

  # Format status if we have any symbols
  if [[ -n $_prompt_data[git_status] ]]; then
    git_status="%{$fg[$color_git_brackets]%}[%{$fg[$color_git_status]%}${_prompt_data[git_status]}%{$fg[$color_git_brackets]%}]%{$reset_color%}"
  fi

  # Always add trailing space
  print -n "${formatted_branch}${git_status} "
}

# Update git information - runs in precmd
function update_git_info() {
  local now status_symbols branch porcelain stashed
  local -a counts

  now=$EPOCHSECONDS

  # Fast checks to see if we need to refresh git information
  # Only refresh when:
  # 1. Directory changed
  # 2. Git cache is older than 2 seconds
  # 3. After a git command was run (tracked in preexec)
  if [[ $PWD != $_prompt_data[git_last_pwd] || $((now - $_prompt_data[git_last_check])) -gt 2 ]]; then
    # Save current state
    _prompt_data[git_last_check]=$now
    _prompt_data[git_last_pwd]=$PWD

    # Use zsh's built-in stat to check if we're in a git repo instead of running git
    # This is much faster than executing git command
    local git_dir=${PWD}/.git(N)
    if [[ -z $git_dir ]]; then
      # Try using git command only if necessary
      git_dir=${${:-$(git rev-parse --git-dir 2>/dev/null)}:A}
      [[ -z $git_dir ]] && {
        _prompt_data[git_dir]=""
        _prompt_data[git_branch]=""
        _prompt_data[git_status]=""
        return
      }
    fi

    # We're in a git repo
    _prompt_data[git_dir]=${${:-$(git rev-parse --git-dir 2>/dev/null)}:A}

    # Use vcs_info to get branch (faster than git commands)
    vcs_info 2>/dev/null
    branch=${vcs_info_msg_0_%%|*}
    _prompt_data[git_branch]=${branch:-unknown}

    # Reset status symbols
    status_symbols=""

    # Get git status with a single command execution - store full output
    local git_status_output
    git_status_output=$(git status --porcelain 2>/dev/null)

    # Use zsh native array parsing and pattern matching
    if [[ -n $git_status_output ]]; then
      # Convert output to array, each line becomes an element (f flag)
      local -a status_lines
      status_lines=("${(f)git_status_output}")

      # Loop through lines and use zsh pattern matching
      local line
      for line in $status_lines; do
        # Simple pattern matching with case statement
        case $line in
          \?\?*)     status_symbols=${status_symbols/\?/}; status_symbols+="?" ;; # untracked
          " M"*)     status_symbols=${status_symbols/\!/}; status_symbols+="!" ;; # modified
          " D"*)     status_symbols=${status_symbols/\!/}; status_symbols+="!" ;; # deleted not staged
          "M "*)     status_symbols=${status_symbols/\+/}; status_symbols+="+" ;; # modified staged
          "A "*)     status_symbols=${status_symbols/\+/}; status_symbols+="+" ;; # added staged
          "D "*)     status_symbols=${status_symbols/x/}; status_symbols+="x" ;; # deleted staged
          "R "*)     status_symbols=${status_symbols/\>/}; status_symbols+=">" ;; # renamed
        esac
      done
    fi

    # Use zsh glob qualifier for more efficient file check
    [[ -n ${_prompt_data[git_dir]}/refs/stash(#qN) || -n ${_prompt_data[git_dir]}/stashed(#qN) ]] &&
      status_symbols+="\$"  # stashed

    # Check for upstream and commits ahead/behind more efficiently
    # with a single git command that works even without upstream configured
    if git rev-parse @{u} &>/dev/null; then
      # Get counts in one go - use zsh array assignment directly
      counts=(${=$(git rev-list --left-right --count @{u}...HEAD 2>/dev/null)})

      # Use direct integer checks for efficiency
      (( ${counts[1]:-0} > 0 && ${counts[2]:-0} > 0 )) && status_symbols+="⇕"  # diverged
      (( ${counts[2]:-0} > 0 && ${counts[1]:-0} == 0 )) && status_symbols+="⇡"  # ahead
      (( ${counts[1]:-0} > 0 && ${counts[2]:-0} == 0 )) && status_symbols+="⇣"  # behind
    fi

    _prompt_data[git_status]=$status_symbols
  fi
}

# Variables for command duration tracking
typeset -gi _last_cmd_start=0
typeset -gi _last_cmd_duration=0
typeset -gi _show_cmd_duration=0
typeset -gi _CACHED_SSH_STATUS=0

# Handle command execution start
function prompt_preexec() {
  # Only track time for non-empty commands
  if [[ -n "${1//[[:space:]]/}" ]]; then
    _last_cmd_start=$EPOCHSECONDS
    _show_cmd_duration=1
  else
    _last_cmd_start=0
    _show_cmd_duration=0
  fi

  # Reset git cache when running git commands
  [[ $1 == git* ]] && _prompt_data[git_last_check]=0
}

# Handle before prompt display
function prompt_precmd() {
  # Calculate command duration
  if (( _last_cmd_start > 0 && _show_cmd_duration == 1 )); then
    _last_cmd_duration=$(( EPOCHSECONDS - _last_cmd_start ))
    _last_cmd_start=0
  else
    _last_cmd_duration=0
    _show_cmd_duration=0
  fi

  update_git_info
}

# Show command duration
function prompt_cmd_duration() {
  if (( _last_cmd_duration >= 1 && _show_cmd_duration )); then
    print -n "%{$fg[$color_duration]%}${_last_cmd_duration}s%{$reset_color%} "
  fi
}

# Reset duration flag after prompt is displayed
function prompt_reset_duration_flag() {
  _show_cmd_duration=0
  return 1
}

# Show background jobs
function prompt_jobs() {
  local jobs_count=$#jobstates
  (( jobs_count > 0 )) && print -n "%{$fg[$color_jobs]%}✦${jobs_count}%{$reset_color%} "
}

# Render prompt character with exit status color
function prompt_char() {
  local exit_status=$?
  local symbol_color

  # Color based on exit status
  if (( exit_status == 0 )); then
    symbol_color=$color_char_success
  else
    symbol_color=$color_char_error
  fi

  print -n "%{$fg[$symbol_color]%}❯%{$reset_color%}"
}

# Show SSH connection indicator
function prompt_is_ssh() {
  # Cache SSH status
  if [[ -z $_CACHED_SSH_STATUS ]]; then
    typeset -g _CACHED_SSH_STATUS=0
    if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT || -n $SSH_TTY ]]; then
      _CACHED_SSH_STATUS=1
    fi
  fi

  if (( $_CACHED_SSH_STATUS == 1 )); then
    print -n "%{$fg[$color_at]%}@%{$reset_color%}%{$fg[$color_host]%}%m%{$reset_color%}"
  fi
}

# Build the prompt
PROMPT=""
PROMPT+="%{$fg[$color_user]%}%n%{$reset_color%}"
PROMPT+='$(prompt_is_ssh)'
PROMPT+="%{$fg[$color_colon]%}:%{$reset_color%}%{$fg[$color_dir]%}%1d%{$reset_color%} "
PROMPT+='$(prompt_git_info)'
PROMPT+='$(prompt_cmd_duration)'
PROMPT+='$(prompt_jobs)'
PROMPT+='$(prompt_char)'
PROMPT+='$(prompt_reset_duration_flag) '

# No right prompt
RPROMPT=""

# Register hooks
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_precmd
add-zsh-hook preexec prompt_preexec
