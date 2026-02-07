# dotfiles

Dotfiles managed with [chezmoi](https://www.chezmoi.io/). Supports multiple profiles.

## Installation

```bash
curl -fsLS chezmoi.io/get | sh -s -- -b ~/.local/bin init --apply edgard/dotfiles
```

## Usage

```bash
update                  # Update everything (dotfiles, packages)
update install          # Install Homebrew packages from Brewfiles
update cleanup          # Remove unused Homebrew packages
update secrets          # Fetch profile files from Bitwarden
```

## Configuration

### Profile Files (Bitwarden)

Create a **Secure Note** named `_chezmoi_<profile>` (e.g., `_chezmoi_home`) and add machine-specific files as attachments. `update secrets` downloads these attachments to `~/.config/local/`.

Login and fetch:

```bash
bw login
update secrets
```

### Local Overrides

Any `*.zsh` files in `~/.config/local/` are sourced by zsh.

## Troubleshooting

Re-run bootstrap scripts:

```bash
chezmoi state delete-bucket --bucket=scriptState  # run_once_ scripts
chezmoi state delete-bucket --bucket=entryState   # run_onchange_ scripts
```
