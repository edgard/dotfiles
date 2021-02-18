# -----------------------------------------------------------------------------
# completion
# -----------------------------------------------------------------------------

# completion styles
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' add-space true
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*:complete:*' use-cache true
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:corrections' format $'-- %d --'
zstyle ':completion:*:descriptions' format $'-- %d --'
zstyle ':completion:*:messages' format $'-- %d --'
zstyle ':completion:*:warnings' format $'-- no matches found --'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# auto suggestion config
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)
