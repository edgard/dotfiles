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

- Git: `~/.config/local/gitconfig`
- Early zsh env (before `~/.zshrc`): `~/.config/local/zshenv`
- Zsh env overlays: `~/.config/local/env.zsh`
- Zsh aliases: `~/.config/local/aliases.zsh`

Examples:

```
# ~/.config/local/gitconfig
[user]
    name = Jane Doe
    email = jane@work.example
```

```
# ~/.config/local/env.zsh
export AWS_PROFILE=personal
export DOCKER_HOST=unix:///Users/edgard/.colima/default/docker.sock
```

```
# ~/.config/local/aliases.zsh
alias kctx='kubectx my-work-cluster'
alias please='sudo $(fc -ln -1)'
```
