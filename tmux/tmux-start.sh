#!/usr/bin/env bash

set -euo pipefail

# If a tmux server is already running, nothing to do
if tmux ls >/dev/null 2>&1; then
    exit 0
fi

# 1. Start tmux in background with a temporary bootstrap session
tmux new-session -d -s __bootstrap__

# Brief pause to allow tmux server and plugins to initialize
sleep 0.5

# 2. Locate the latest resurrect save file
resurrect_file="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/last"
if [[ ! -f "$resurrect_file" ]]; then
    resurrect_file="$HOME/.tmux/resurrect/last"
fi

# 3. If a save file exists, restore sessions headlessly
if [[ -f "$resurrect_file" ]] && [[ -f "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh" ]]; then
    socket="$(tmux display-message -p '#{socket_path}' 2>/dev/null || echo '')"
    if [[ -n "$socket" ]]; then
        TMUX="${socket},0,0" "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh" >/dev/null 2>&1 || true
    fi
fi

# 4. Clean up the temporary bootstrap session
# If real sessions were restored, kill __bootstrap__ so only restored sessions exist.
# If no other sessions exist (e.g. first boot), keep it and rename to 'main'.
other_sessions="$(tmux ls -F '#{session_name}' 2>/dev/null | grep -v '^__bootstrap__$' || true)"

if [[ -n "$other_sessions" ]]; then
    tmux kill-session -t __bootstrap__ 2>/dev/null || true
else
    tmux rename-session -t __bootstrap__ main 2>/dev/null || true
fi
