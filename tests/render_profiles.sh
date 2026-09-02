#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly SOURCE_DIR

render_profile() {
    local profile="$1"
    local workspace
    workspace="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-render-${profile}.XXXXXX")"
    trap 'rm -rf "$workspace"' RETURN
    mkdir -p "$workspace/destination"

    chezmoi \
        --source "$SOURCE_DIR" \
        --destination "$workspace/destination" \
        --config "$workspace/chezmoi.toml" \
        --cache "$workspace/cache" \
        --persistent-state "$workspace/state.boltdb" \
        --skip-secrets \
        --no-tty \
        init --apply \
        --exclude scripts \
        --promptChoice "Profile=${profile}"

    test -f "$workspace/destination/.config/mise/config.toml"
    test -f "$workspace/destination/.config/mise/config.lock"
    test -x "$workspace/destination/.local/bin/update"
    test ! -e "$workspace/destination/tests"

    case "$profile" in
        home)
            grep -q '^opentofu = "prefix:1.12"$' "$workspace/destination/.config/mise/config.toml"
            ! grep -q '^terraform = ' "$workspace/destination/.config/mise/config.toml"
            ;;
        work)
            grep -q '^terraform = "prefix:1.16"$' "$workspace/destination/.config/mise/config.toml"
            ! grep -q '^opentofu = ' "$workspace/destination/.config/mise/config.toml"
            ;;
    esac
}

render_profile home
render_profile work
