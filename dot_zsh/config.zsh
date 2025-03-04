# Core zsh configuration

# History options
setopt append_history        # Append to history file
setopt extended_history      # Save timestamp and duration
setopt hist_expire_dups_first # Remove duplicates first when trimming
setopt hist_fcntl_lock       # Use fcntl to lock history file
setopt hist_ignore_all_dups  # Remove older duplicates
setopt hist_reduce_blanks    # Remove superfluous blanks
setopt hist_save_no_dups     # Don't write duplicate commands
setopt inc_append_history    # Add commands incrementally

# Directory options
setopt auto_cd               # Change directory without cd command
setopt auto_pushd            # Make cd push the old directory onto the stack
setopt pushd_ignore_dups     # Don't push multiple copies of the same directory
setopt pushd_minus           # Make pushd - work like pushd +
setopt pushd_silent          # Don't print the directory stack after pushd/popd
setopt chase_links           # Resolve symlinks when cd'ing

# Completion options
setopt always_to_end         # Move cursor to end on completion
setopt auto_list             # List choices on ambiguous completion
setopt auto_menu             # Show completion menu on tab press
setopt complete_in_word      # Complete from both ends
setopt no_list_beep          # Don't beep on ambiguous completion

# Correction options
setopt correct               # Try to correct spelling of commands

# Input/output options
setopt interactive_comments  # Allow comments in interactive shells
setopt no_clobber            # Don't overwrite files with >
setopt no_flow_control       # Disable Ctrl+S/Ctrl+Q flow control
setopt no_beep               # Disable terminal beeping
