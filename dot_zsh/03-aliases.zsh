#!/usr/bin/env zsh
# shellcheck disable=all

(( $+commands[atuin] )) && alias history='atuin history list --cmd-only'
alias ls='ls -F -G'

(( $+commands[kubectl] )) && alias k='kubectl'
(( $+commands[kubens] ))  && alias kns='kubens'
(( $+commands[kubectx] )) && alias kctx='kubectx'
