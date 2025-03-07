#!/usr/bin/env zsh

## HISTORY CONFIGURATION ##
HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

## SHELL OPTIONS BY CATEGORY ##

# History options
setopt EXTENDED_HISTORY          # Time stamps and durations
setopt SHARE_HISTORY             # Share between sessions
setopt HIST_VERIFY               # Don't execute immediately on expansion
setopt HIST_FCNTL_LOCK           # Modern file-locking
setopt HIST_IGNORE_ALL_DUPS      # No duplicate entries
setopt HIST_EXPIRE_DUPS_FIRST    # Remove duplicates first when exceeding HISTSIZE
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_FIND_NO_DUPS         # No duplicates in history search

# Directory navigation
setopt AUTO_CD                   # cd to dir when name is used as command
setopt AUTO_PUSHD                # cd pushes old dir onto stack
setopt PUSHD_IGNORE_DUPS         # No duplicate directories
setopt PUSHD_TO_HOME             # pushd defaults to $HOME
setopt PUSHD_MINUS               # Swap +/- operators
setopt PUSHD_SILENT              # No stack printing

# Globbing and patterns
setopt EXTENDED_GLOB             # Extended syntax
setopt RC_EXPAND_PARAM           # Array expansion with parameters
unsetopt CASE_GLOB               # Case insensitive globbing
unsetopt CASE_MATCH              # Case insensitive matching

# Completion
setopt COMPLETE_IN_WORD          # Complete from both ends
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt COMPLETE_ALIASES          # Complete aliases
setopt MAGIC_EQUAL_SUBST         # Completion after =

# Tab completion
setopt AUTO_LIST                 # List on ambiguous completion
setopt AUTO_MENU                 # Menu after second tab
setopt LIST_PACKED               # Compact completion list
unsetopt LIST_BEEP               # No completion beep

# Correction (disabled)
unsetopt CORRECT                 # Don't correct commands
unsetopt CORRECT_ALL             # Don't correct arguments

# Job control
setopt AUTO_RESUME               # Resume by name
setopt LONG_LIST_JOBS            # Long format
setopt NOTIFY                    # Immediate status reporting
unsetopt HUP                     # Don't kill background jobs
unsetopt CHECK_JOBS              # Don't report on exit
unsetopt BG_NICE                 # No background job priority

# Shell behavior
setopt INTERACTIVE_COMMENTS      # Allow comments
setopt COMBINING_CHARS           # Handle multi-byte characters
setopt MULTIOS                   # Multiple redirections
setopt SHORT_LOOPS               # Short control structures
setopt HASH_LIST_ALL             # Hash entire command path
setopt HASH_CMDS                 # Hash command locations
setopt PATH_SCRIPT               # Path expansion for scripts
setopt CLOBBER                   # Allow > to overwrite files
unsetopt BEEP                    # No error beep
unsetopt FLOW_CONTROL            # No flow control
unsetopt MAIL_WARNING            # No mail warnings

## KEY BINDINGS ##
bindkey -e
