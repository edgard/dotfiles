# dotfiles

## Install dotfiles

    curl -fsLS chezmoi.io/get | sh -s - -b ~/.local/bin init --apply --verbose --force git@github.com:edgard/dotfiles.git

## Brewfile profiles

- Profiles: `common` (always), plus `work` or `home`.
- Usage examples:
  - `update install --profile work` installs common + work
  - `update install --profile home` installs common + home
- You can set `BREW_PROFILE=work` (or `home`) to avoid passing `--profile` each time.

## Local overrides

All per-machine overrides live under one directory: `~/.config/local`. Create these files locally as needed — they are not tracked by chezmoi.

- `~/.config/local/path.zsh` — appended after the default PATH configuration.
- `~/.config/local/env.zsh` — appended after the core env setup.
- `~/.config/local/aliases.zsh` — appended after the default aliases.
- `~/.config/local/gitconfig` — included from the global git config for machine-specific settings.

Examples:

```zsh
# ~/.config/local/path.zsh
path=("${HOME}/.config/local/bin" "${HOME}/.poetry/bin" "${path[@]}")
```

```zsh
# ~/.config/local/env.zsh
export BREW_PROFILE=home
export DOCKER_HOST=unix:///Users/edgard/.colima/default/docker.sock
```

```zsh
# ~/.config/local/aliases.zsh
alias kctx='kubectx my-work-cluster'
alias please='sudo $(fc -ln -1)'
```

```ini
# ~/.config/local/gitconfig
[user]
    name = Jane Doe
    email = jane@work.example
```
