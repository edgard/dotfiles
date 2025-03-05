# Core zsh configuration
# Contains basic zsh options, history settings, and key bindings

# History Configuration
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000              # Maximum events in internal history
SAVEHIST=10000             # Maximum events in history file

# History Options
setopt APPEND_HISTORY        # Append to history file
setopt EXTENDED_HISTORY      # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST # Remove duplicates first when trimming
setopt HIST_FCNTL_LOCK       # Use fcntl to lock history file
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicates
setopt HIST_IGNORE_SPACE     # Don't save commands starting with space
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks
setopt HIST_SAVE_NO_DUPS     # Don't write duplicate commands
setopt HIST_VERIFY           # Show history expansion before executing
setopt INC_APPEND_HISTORY_TIME # Add commands to history immediately with timestamp
setopt SHARE_HISTORY         # Share history between sessions

# Directory Navigation
setopt AUTO_CD               # Change directory without cd command
setopt AUTO_PUSHD            # Make cd push the old directory onto the stack
setopt PUSHD_IGNORE_DUPS     # Don't push multiple copies of the same directory
setopt PUSHD_MINUS           # Make pushd - work like pushd +
setopt PUSHD_SILENT          # Don't print the directory stack after pushd/popd
setopt PUSHD_TO_HOME         # pushd with no arguments goes to ~
setopt CHASE_LINKS           # Resolve symlinks when cd'ing

# Completion System
setopt ALWAYS_TO_END         # Move cursor to end on completion
setopt AUTO_LIST             # List choices on ambiguous completion
setopt AUTO_MENU             # Show completion menu on tab press
setopt COMPLETE_IN_WORD      # Complete from both ends
setopt HASH_LIST_ALL         # Hash entire command path first
setopt LIST_PACKED           # Make completion lists more compact
unsetopt LIST_BEEP           # Don't beep on ambiguous completion

# Error Correction
setopt CORRECT               # Try to correct spelling of commands

# Job Control
setopt AUTO_RESUME          # Treat single word simple commands as candidates for resumption
setopt LONG_LIST_JOBS       # List jobs in the long format
setopt NOTIFY               # Report status of background jobs immediately

# Input/Output
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shells
setopt NO_CLOBBER           # Don't overwrite files with > (use >| to override)
setopt RM_STAR_WAIT         # Wait 10 seconds before executing rm *
unsetopt FLOW_CONTROL       # Disable Ctrl+S/Ctrl+Q flow control
unsetopt BEEP               # Disable terminal beeping

# Security
setopt RC_QUOTES            # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
unsetopt MAIL_WARNING       # Don't print warning if a mail file was accessed

# Key Bindings
bindkey -e                  # Use emacs key bindings
