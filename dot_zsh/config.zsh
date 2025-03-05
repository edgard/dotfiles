# Core zsh configuration

# History options
setopt APPEND_HISTORY        # Append to history file
setopt EXTENDED_HISTORY      # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST # Remove duplicates first when trimming
setopt HIST_FCNTL_LOCK       # Use fcntl to lock history file
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicates
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks
setopt HIST_SAVE_NO_DUPS     # Don't write duplicate commands
setopt INC_APPEND_HISTORY    # Add commands incrementally

# Directory options
setopt AUTO_CD               # Change directory without cd command
setopt AUTO_PUSHD            # Make cd push the old directory onto the stack
setopt PUSHD_IGNORE_DUPS     # Don't push multiple copies of the same directory
setopt PUSHD_MINUS           # Make pushd - work like pushd +
setopt PUSHD_SILENT          # Don't print the directory stack after pushd/popd
setopt CHASE_LINKS           # Resolve symlinks when cd'ing

# Completion options
setopt ALWAYS_TO_END         # Move cursor to end on completion
setopt AUTO_LIST             # List choices on ambiguous completion
setopt AUTO_MENU             # Show completion menu on tab press
setopt COMPLETE_IN_WORD      # Complete from both ends
unsetopt LIST_BEEP           # Don't beep on ambiguous completion

# Correction options
setopt CORRECT               # Try to correct spelling of commands

# Input/output options
setopt INTERACTIVE_COMMENTS  # Allow comments in interactive shells
unsetopt CLOBBER             # Don't overwrite files with >
unsetopt FLOW_CONTROL        # Disable Ctrl+S/Ctrl+Q flow control
unsetopt BEEP                # Disable terminal beeping
