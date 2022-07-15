# -----------------------------------------------------------------------------
# options
# -----------------------------------------------------------------------------

setopt always_to_end          # When completing from the middle of a word, move the cursor to the end of the word
setopt append_history         # Allow multiple terminal sessions to all append to one zsh command history
setopt auto_list              # Automatically list choices on an ambiguous completion
setopt auto_pushd             # Make cd push the old directory onto the directory stack
setopt case_glob              # Make globbing (filename generation) sensitive to case
setopt chase_links            # Resolve symbolic links to their true values when changing directory
setopt complete_in_word       # Allow completion from within a word/phrase
setopt correct                # Spelling correction for commands
setopt extended_history       # Save timestamp of command and duration
setopt hist_expire_dups_first # When trimming history, lose oldest duplicates first
setopt hist_fcntl_lock        # With this option locking is done by means of the system's fcntl call, where this method is available
setopt hist_find_no_dups      # When searching history don't display results already cycled through twice
setopt hist_ignore_all_dups   # If a new command line being added to the history list duplicates an older one, the older command is removed from the list
setopt hist_ignore_dups       # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space      # Remove command line from history list when first character on the line is a space
setopt hist_lex_words         # When this option is set, words read in from a history file are divided up in a similar fashion to normal shell command line handling
setopt hist_reduce_blanks     # Remove extra blanks from each command line being added to history
setopt hist_save_no_dups      # When writing out the history file, older commands that duplicate newer ones are omitted
setopt hist_verify            # Don't execute, just expand history
setopt inc_append_history     # Add comamnds as they are typed, don't wait until shell exit
setopt interactive_comments   # Allow comments even in interactive shells
setopt long_list_jobs         # List jobs in the long format by default
setopt multios                # Perform implicit tees or cats when multiple redirections are attempted
setopt prompt_subst           # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt pushd_ignore_dups      # Don't push multiple copies of the same directory onto the directory stack
setopt pushd_minus            # Exchanges the meanings of '+' and '-' when used with a number to specify a directory in the stack
setopt sh_word_split          # Causes field splitting to be performed on unquoted parameter expansions
setopt share_history          # Imports new commands and appends typed commands to history
unsetopt beep                 # Don't beep on error
unsetopt flow_control         # Output flow control via start/stop characters (usually assigned to ^S/^Q) is disabled in the shell's editor
