
#!/usr/bin/env bash

SEARCH_ROOTS=(
    "$HOME"
    "/mnt/Data"
)

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

[[ -z "$dir" ]] && exit 0

default_session="$(basename "$dir")"

printf "Session name [%s]: " "$default_session"
read -r session

session="${session:-$default_session}"

tmux new-session -A -s "$session" -c "$dir"

