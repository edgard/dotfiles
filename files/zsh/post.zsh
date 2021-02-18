# -----------------------------------------------------------------------------
# post-setup
# -----------------------------------------------------------------------------

# remove duplicate path entries
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

# zcompinit
{
    setopt extendedglob local_options
    autoload -Uz compinit
    local zcd=${HOME}/.zcompdump
    local zcdc="${zcd}.zwc"
    if [[ -f "${zcd}"(#qN.m+1) ]]; then
        compinit -i -d "${zcd}"
        { rm -f "${zcdc}" && zcompile "${zcd}" } &!
    else
        compinit -C -d "${zcd}"
        { [[ ! -f "${zcdc}" || "${zcd}" -nt "${zcdc}" ]] && rm -f "${zcdc}" && zcompile "${zcd}" } &!
    fi
}
