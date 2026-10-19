#!/usr/bin/env bash

set -euo pipefail

SEARCH_ROOTS=(
    "$HOME"
    "/mnt/Data"
)

# Use fd if available for fast multi-threaded search with gitignore awareness
if command -v fd &>/dev/null; then
    dir="$(
        fd --type d --hidden --follow \
            --exclude .git \
            --exclude node_modules \
            --exclude .cache \
            --exclude .local \
            --exclude .cargo \
            --exclude .rustup \
            --exclude .npm \
            --exclude target \
            . "${SEARCH_ROOTS[@]}" 2>/dev/null |
        fzf \
            --height=100% \
            --reverse \
            --border \
            --scheme=path \
            --prompt="Directory > "
    )"
else
    dir="$(
        find "${SEARCH_ROOTS[@]}" -type d \
            -not -path '*/.git/*' \
            -not -path '*/node_modules/*' \
            -not -path '*/.cache/*' \
            2>/dev/null |
        fzf \
            --height=100% \
            --reverse \
            --border \
            --scheme=path \
            --prompt="Directory > "
    )"
fi

[[ -z "$dir" ]] && exit 0

default_session="$(basename "$dir" | tr . _)"

printf "Session name [%s]: " "$default_session"
read -r session

session="${session:-$default_session}"

tmux new-session -A -s "$session" -c "$dir"
