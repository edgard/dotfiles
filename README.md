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

All per-machine overrides live under `~/.config/local` (not tracked by chezmoi).

- Zsh: any `~/.config/local/*.zsh` files are sourced after the base config, in lexicographic order (e.g., `10-path.zsh`, `20-env.zsh`, `30-aliases.zsh`).
- Git: `~/.config/local/gitconfig` is included from the global git config for machine-specific settings.

Examples:

```zsh
# ~/.config/local/10-path.zsh
path=("${HOME}/.config/local/bin" "${HOME}/.poetry/bin" "${path[@]}")
```

```zsh
# ~/.config/local/20-env.zsh
export BREW_PROFILE=home
export DOCKER_HOST=unix:///Users/edgard/.colima/default/docker.sock
```

```zsh
# ~/.config/local/30-aliases.zsh
alias kctx='kubectx my-work-cluster'
```

```ini
# ~/.config/local/gitconfig
[user]
    name = Jane Doe
    email = jane@work.example
```

## Shell history (Atuin)

1. Create or sign into your Atuin account: `atuin register` (or `atuin login` if you already have credentials).
1. Import previous history so nothing is lost: `atuin import auto` reads whichever shell history files it finds.
1. Trigger the first sync with `atuin sync`.
1. Remove `~/.zsh_history`
