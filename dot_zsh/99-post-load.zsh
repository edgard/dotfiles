#!/usr/bin/env zsh

#---------------------------------------
# Finalization and Cleanup
#---------------------------------------

# Refresh command hash table
hash -r 2>/dev/null || command rehash 2>/dev/null

# VSCode shell integration
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  if command -v code &>/dev/null; then
    local vscode_integration_path
    vscode_integration_path="$(code --locate-shell-integration-path zsh)"
    if [[ -n "$vscode_integration_path" && -r "$vscode_integration_path" ]]; then
      source "$vscode_integration_path"
    fi
  fi
fi
