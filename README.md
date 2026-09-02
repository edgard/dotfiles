# dotfiles

macOS dotfiles with an explicit split of responsibilities:

- Chezmoi renders and applies files.
- Homebrew installs applications, Mac App Store applications, and system tools.
- mise installs Go, Node, Erlang, Elixir, and the profile-specific IaC runtime.
- `update` is the only orchestrator for networked and interactive maintenance.

The `home` profile installs OpenTofu; the `work` profile installs Terraform.
Python tooling remains managed by `uv`.
Bitwarden CLI and Prettier are Homebrew-owned; the Homebrew Node dependency
they require is the explicit exception to mise's runtime ownership.

## Install

Xcode Command Line Tools and Homebrew are the only implicit one-time
prerequisites. Initialize Chezmoi and choose `home` or `work` when prompted:

```bash
curl -fsLS chezmoi.io/get | sh -s -- -b ~/.local/bin init --apply edgard/dotfiles
update --profile home bootstrap
```

`bootstrap` reconciles packages, installs the locked mise toolset and pinned AI
skills, optionally retrieves secrets, initializes Atuin, and applies macOS
defaults. A locked or unavailable Bitwarden vault produces a warning and does
not block the remaining bootstrap.

## Maintenance

```text
update [--profile {home,work}] [--dry-run] [--yes] COMMAND

bootstrap  packages -> tools -> skills -> optional secrets -> Atuin -> macOS
all        dotfiles -> packages -> tools -> skills -> macOS
dotfiles   pull and apply Chezmoi
packages   update and reconcile the merged profile Brewfile
tools      install the profile's committed mise lock
skills     install commit-pinned sources with skills@1.5.23
secrets    retrieve allowlisted Bitwarden attachments atomically
macos      apply user-scoped macOS defaults
cleanup    remove undeclared Homebrew content after confirmation
doctor     run non-mutating health, drift, permission, and ownership checks
```

`update cleanup --zap` is required to remove associated application data.
There is no automatic cleanup or automatic secret retrieval during routine
updates.

## Private files

Create a Bitwarden Secure Note named `_chezmoi_home` or `_chezmoi_work` with
only these attachments:

- `gitconfig`
- `secrets.zsh`

They are atomically installed under `~/.config/local` with directory mode
`0700` and file mode `0600`. For the home profile, `secrets.zsh` also contains
the private Restic transport values:

```zsh
export RESTIC_REPOSITORY='rest:http://backup-host.example:8000/'
export RESTIC_REST_USERNAME='restic'
```

The current HTTP endpoint is intentionally retained until the backup server gains TLS;
the installers and `update doctor` warn about unencrypted transport.

## Restic scheduler

The installers preserve the existing Documents backup, daily 03:00 schedule,
root/SYSTEM execution, password files, and remote snapshots:

```bash
sudo extras/setup-restic.sh install --repository "$RESTIC_REPOSITORY" \
  --username "${RESTIC_REST_USERNAME:-restic}"
```

```powershell
.\extras\setup-restic.ps1 install -Repository $env:RESTIC_REPOSITORY `
  -RestUsername $env:RESTIC_REST_USERNAME
```

Reinstalling replaces the scheduler and generated runtime configuration
idempotently. Generated files contain the repository URL and username, never
the repository password.

## Development

```bash
task check
pre-commit run --all-files
```

`task check` validates Bash, Zsh, Python, PowerShell contracts, Actions,
Brewfiles, tests, and isolated renders of both profiles. Pull requests require
the single `Quality Gate` status check. The default branch is `main`.
