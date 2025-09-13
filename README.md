# dotfiles

## Install dotfiles

    curl -fsLS chezmoi.io/get | sh -s - -b ~/.local/bin init --apply --verbose --force git@github.com:edgard/dotfiles.git

## Brewfile profiles

- Profiles: `common` (always), plus `work` or `home`.
- Usage examples:
  - `update install --profile work` installs common + work
  - `update install --profile home` installs common + home
- You can set `BREW_PROFILE=work` (or `home`) to avoid passing `--profile` each time.
