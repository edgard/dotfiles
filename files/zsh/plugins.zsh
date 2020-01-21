# -----------------------------------------------------------------------------
# plugins
# -----------------------------------------------------------------------------

# plugins
if command -v brew 1>/dev/null 2>&1; then
  if [[ -d "$(brew --prefix)/opt/zplug" ]]; then
    export ZPLUG_HOME="$(brew --prefix)/opt/zplug"
    source "${ZPLUG_HOME}/init.zsh"
  fi
fi

# plugin list
zplug "zsh-users/zsh-completions"
zplug "rupa/z", use:z.sh
zplug "zsh-users/zsh-autosuggestions", defer:1
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# install plugins which haven't been installed yet
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
      echo; zplug install
  else
      echo
  fi
fi

# load zplug
zplug load
