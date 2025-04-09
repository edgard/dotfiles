#!/usr/bin/env zsh

##############################################################################
# Input/Output Behavior
##############################################################################

setopt MULTIOS                   # Allow multiple redirections for a single command
setopt CLOBBER                   # Allow redirection to overwrite existing files
setopt COMBINING_CHARS           # Properly display Unicode characters
setopt INTERACTIVE_COMMENTS      # Enable comments in interactive mode
setopt NO_BEEP                   # Suppress terminal bell sounds
setopt NO_FLOW_CONTROL           # Disable start/stop characters control
setopt NO_MAIL_WARNING           # Suppress "you have mail" warnings

##############################################################################
# History Configuration
##############################################################################

HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

setopt SHARE_HISTORY             # Share command history between zsh sessions
setopt EXTENDED_HISTORY          # Save timestamp and duration information
setopt HIST_VERIFY               # Show expanded history before executing
setopt HIST_FCNTL_LOCK           # Better file locking for concurrent sessions
setopt HIST_LEX_WORDS            # Better handling of shell metacharacters
setopt HIST_REDUCE_BLANKS        # Remove unnecessary whitespace
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_FIND_NO_DUPS         # Skip duplicates when searching history
setopt HIST_EXPIRE_DUPS_FIRST    # Remove duplicates first when trimming history
setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate commands
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate commands to history

##############################################################################
# Directory Navigation
##############################################################################

setopt AUTO_PUSHD                # Make cd push old directory onto stack
setopt PUSHD_TO_HOME             # Make pushd without arguments act like 'pushd ~'
setopt PUSHD_MINUS               # Make 'cd -n' work like 'cd +n' for consistency
setopt PUSHD_SILENT              # Don't print directory stack after pushd/popd
setopt PUSHD_IGNORE_DUPS         # Don't push duplicate directories onto stack
setopt NO_AUTO_CD                # Require explicit 'cd' command

##############################################################################
# Completion System
##############################################################################

setopt ALWAYS_TO_END             # Move cursor to end of completed word
setopt AUTO_LIST                 # Automatically list choices on completion
setopt AUTO_MENU                 # Use menu after second consecutive tab
setopt AUTO_PARAM_SLASH          # Append slash to completed directories
setopt COMPLETE_ALIASES          # Treat aliases as distinct commands
setopt COMPLETE_IN_WORD          # Allow completion from middle of word
setopt LIST_PACKED               # Make completion lists more compact
setopt MAGIC_EQUAL_SUBST         # Expand filenames after equals signs
setopt NO_CORRECT                # Don't try to correct command spelling
setopt NO_CORRECT_ALL            # Don't try to correct all arguments
setopt NO_LIST_BEEP              # Don't beep on ambiguous completions

##############################################################################
# Job Control
##############################################################################

setopt AUTO_RESUME                # Resume existing job instead of creating new one
setopt CHECK_JOBS                 # Report job status before exiting shell
setopt LONG_LIST_JOBS             # Show job notifications in long format
setopt NOTIFY                     # Report job status immediately
setopt NO_BG_NICE                 # Don't run background jobs at lower priority
setopt NO_HUP                     # Don't kill jobs on shell exit

##############################################################################
# Pattern Matching and Globbing
##############################################################################

setopt EXTENDED_GLOB              # Enable advanced pattern matching features
setopt RC_EXPAND_PARAM            # Array expansion of parameters
setopt NO_CASE_GLOB               # Case-insensitive pathname expansion
setopt NO_CASE_MATCH              # Case-insensitive pattern matching
setopt NO_NOMATCH                 # Pass glob patterns with no matches unchanged

##############################################################################
# Shell Behavior
##############################################################################

setopt HASH_LIST_ALL              # Hash entire command path first time used
setopt PATH_SCRIPT                # Allow path search for script execution
setopt PROMPT_SUBST               # Perform parameter/command substitution in prompt
setopt SHORT_LOOPS                # Allow short forms of for, repeat, select, if, function
setopt NO_WARN_CREATE_GLOBAL      # Don't warn about creating global parameters

##############################################################################
# Key Bindings
##############################################################################

bindkey -e                        # Emacs key bindings
