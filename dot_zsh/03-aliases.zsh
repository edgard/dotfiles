#!/usr/bin/env zsh
# shellcheck disable=all

alias history='fc -l 1'
alias ls='ls -F -G'
alias please='sudo $(fc -ln -1)'

(( $+commands[kubectl] )) && alias k='kubectl'
(( $+commands[kubens] ))  && alias kns='kubens'
(( $+commands[kubectx] )) && alias kctx='kubectx'

# ---- Local aliases ----
{
    local _alias_local="${HOME}/.config/local/aliases.zsh"
    [[ -r "${_alias_local}" ]] && source "${_alias_local}"
    unset _alias_local
}
