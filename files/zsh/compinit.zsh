# compinit
autoload -Uz compinit && compinit

{
  zcompdump=${HOME}/.zcompdump

  if [[ -s ${zcompdump} && ( ! -s ${zcompdump}.zwc || ${zcompdump} -nt ${zcompdump}.zwc) ]]; then
    zcompile ${zcompdump}
  fi

  unset zcompdump
} &!
