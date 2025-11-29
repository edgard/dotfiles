#!/usr/bin/env zsh
# shellcheck disable=all

# Source any local overrides from ~/.config/local/*.zsh in lexicographic order
{
    local _local_dir="${HOME}/.config/local"
    [[ -d "${_local_dir}" ]] || return
    for _local_file in "${_local_dir}"/*.zsh(N-.); do
        source "${_local_file}"
    done
    unset _local_dir _local_file
}
