# -----------------------------------------------------------------------------
# plugin management
# -----------------------------------------------------------------------------

# sane zplug installation defaults
if [[ -z "$ZPLUG_HOME" ]]; then
  ZPLUG_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zplug"
fi
if [[ -z "$ZPLUG_CACHE_DIR" ]]; then
  ZPLUG_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zplug"
fi

# Ensure zplug is installed and load it
if [[ ! -d "$ZPLUG_HOME" ]]; then
  git clone https://github.com/zplug/zplug "$ZPLUG_HOME"
  source "$ZPLUG_HOME/init.zsh" && zplug --self-manage update
else
  source "$ZPLUG_HOME/init.zsh"
fi

# self-manage
zplug "zplug/zplug", hook-build:"zplug --self-manage"

# add zsh plugins
zplug "agkozak/zsh-z"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions", depth:1
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "agkozak/agkozak-zsh-prompt"

# add fzf/fd
zplug "junegunn/fzf", hook-build:"./install --bin && ln -sf $ZPLUG_REPOS/junegunn/fzf/bin/fzf $ZPLUG_BIN", use:"shell/*.zsh"
[[ "${OSTYPE}" == "linux"* ]] && zplug "sharkdp/fd", from:gh-r, as:command, rename-to:fd, use:"*x86_64*linux-gnu*"
[[ "${OSTYPE}" == "darwin"* ]] && zplug "sharkdp/fd", from:gh-r, as:command, rename-to:fd, use:"*x86_64*darwin*"

# install plugins if there are plugins that have not been installed
if ! zplug check; then
    zplug install
fi

# Load plugins
zplug load
