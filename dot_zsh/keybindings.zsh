# -----------------------------------------------------------------------------
# key bindings
# -----------------------------------------------------------------------------

bindkey -e
bindkey ' ' magic-space
bindkey '\ew' kill-region
bindkey '^?' backward-delete-char

bindkey '^[[1;2D' backward-word         # shift left arrow
bindkey '^[[1;2C' forward-word          # shift right arrow
bindkey '^[[1;2A' end-of-line           # shift up arrow
bindkey '^[[1;2B' beginning-of-line     # shift down arrow

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kich1]}" overwrite-mode
bindkey "${terminfo[kdch1]}" delete-char
bindkey "${terminfo[kcuu1]}" up-line-or-history
bindkey "${terminfo[kcud1]}" down-line-or-history
bindkey "${terminfo[kcub1]}" backward-char
bindkey "${terminfo[kcuf1]}" forward-char
bindkey "${terminfo[kpp]}" beginning-of-buffer-or-history
bindkey "${terminfo[knp]}" end-of-buffer-or-history
bindkey "${terminfo[kcbt]}" reverse-menu-complete

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish() {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
