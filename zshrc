# if not running interactively, don't do anything
[[ $- != *i* ]] && return


# plugins
source ~/.zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/.zsh/plugins/z/z.sh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh


# config
source ~/.zsh/options.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/keybindings.zsh
source ~/.zsh/compinit.zsh
