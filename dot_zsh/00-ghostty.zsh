#!/usr/bin/env zsh
# shellcheck disable=all

# Ghostty shell integration for zsh
# This should be loaded FIRST (00- prefix) to ensure proper initialization
# Source: https://ghostty.org/docs/features/shell-integration

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi
