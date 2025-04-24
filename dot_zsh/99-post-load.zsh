#!/usr/bin/env zsh

#---------------------------------------
# Finalization and Cleanup
#---------------------------------------

# Refresh command hash table
hash -r 2>/dev/null || command rehash 2>/dev/null

#---------------------------------------
# WSL2 Runtime Directory Fix
#---------------------------------------

if [[ "$OSTYPE" == linux* ]]; then
    if grep -qi microsoft /proc/version; then
        export XDG_RUNTIME_DIR=/run/user/$(id -u)
        if [ ! -d "$XDG_RUNTIME_DIR" ]; then
            sudo mkdir -p $XDG_RUNTIME_DIR
            sudo chmod 700 $XDG_RUNTIME_DIR
            sudo chown $(id -u):$(id -g) $XDG_RUNTIME_DIR
        fi
    fi
fi

#---------------------------------------
# VSCode Integration Fix
#---------------------------------------
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  if command -v code &>/dev/null; then
    local vscode_integration_path
    vscode_integration_path="$(code --locate-shell-integration-path zsh)"
    if [[ -n "$vscode_integration_path" && -r "$vscode_integration_path" ]]; then
      source "$vscode_integration_path"
    fi
  fi
fi
