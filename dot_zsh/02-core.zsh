#!/usr/bin/env zsh

##############################################################################
# History Configuration
##############################################################################

HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# History options
setopt EXTENDED_HISTORY          # Timestamped history
setopt SHARE_HISTORY             # Share history across sessions
setopt HIST_VERIFY               # Confirm before executing expanded history
setopt HIST_FCNTL_LOCK           # Use modern file locking
setopt HIST_IGNORE_ALL_DUPS      # Ignore duplicated commands
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_FIND_NO_DUPS         # No duplicates in search results

##############################################################################
# Directory Navigation
##############################################################################

setopt AUTO_CD                   # Implicit 'cd' when directory name typed
setopt AUTO_PUSHD                # Push old dir onto stack on 'cd'
setopt PUSHD_IGNORE_DUPS         # No duplicate entries in dir stack
setopt PUSHD_TO_HOME             # 'pushd' with no args goes to $HOME
setopt PUSHD_MINUS               # Swap +/- behavior
setopt PUSHD_SILENT              # Don't print dir stack on pushd/popd

##############################################################################
# Globbing and Pattern Matching
##############################################################################

setopt EXTENDED_GLOB             # Advanced globbing
setopt RC_EXPAND_PARAM           # Array expansion with parameters
unsetopt CASE_GLOB               # Case-insensitive globbing
unsetopt CASE_MATCH              # Case-insensitive matching

##############################################################################
# Completion Behavior
##############################################################################

setopt COMPLETE_IN_WORD          # Complete from both ends of word
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt COMPLETE_ALIASES          # Complete aliases
setopt MAGIC_EQUAL_SUBST         # Complete after '=' in assignments

setopt AUTO_LIST                 # List choices on ambiguous completion
setopt AUTO_MENU                 # Menu selection on second tab
setopt LIST_PACKED               # Compact completion list
unsetopt LIST_BEEP               # No beep on ambiguous completion

##############################################################################
# Correction (Disabled)
##############################################################################

unsetopt CORRECT                 # Disable command correction
unsetopt CORRECT_ALL             # Disable argument correction

##############################################################################
# Job Control
##############################################################################

setopt AUTO_RESUME               # Resume jobs by command name
setopt LONG_LIST_JOBS            # Long format for jobs
setopt NOTIFY                    # Immediate job status
unsetopt HUP                     # Don't send HUP on shell exit
unsetopt CHECK_JOBS              # Don't warn about running jobs
unsetopt BG_NICE                 # Don't lower priority of background jobs

##############################################################################
# Shell Behavior
##############################################################################

setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shell
setopt COMBINING_CHARS           # Handle multi-byte characters
setopt MULTIOS                   # Multiple redirections
setopt SHORT_LOOPS               # Short loop syntax
setopt HASH_LIST_ALL             # Hash all commands in PATH
setopt HASH_CMDS                 # Hash command locations
setopt PATH_SCRIPT               # Path expansion for scripts
setopt CLOBBER                   # Allow overwriting files with '>'
unsetopt BEEP                    # Disable error beep
unsetopt FLOW_CONTROL            # Disable XON/XOFF flow control
unsetopt MAIL_WARNING            # Disable mail check warning

##############################################################################
# Key Bindings
##############################################################################

bindkey -e                       # Emacs key bindings
