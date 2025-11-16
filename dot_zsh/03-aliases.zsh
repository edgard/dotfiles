#!/usr/bin/env zsh
# shellcheck disable=all

alias history='atuin history list --cmd-only'
alias ls='ls -F -G'

(( $+commands[kubectl] )) && alias k='kubectl'
(( $+commands[kubens] ))  && alias kns='kubens'
(( $+commands[kubectx] )) && alias kctx='kubectx'

# ---- Local aliases ----
{
    local _alias_local="${HOME}/.config/local/aliases.zsh"
    [[ -r "${_alias_local}" ]] && source "${_alias_local}"
    unset _alias_local
}
