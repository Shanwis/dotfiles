#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo "Usage: $0 <vault-name>"
	exit 1
fi

VAULT="$1"
SOURCE="$HOME/Data/obsidian/$VAULT/.obsidian/"
DEST=".obsidian"

rsync -a --delete \
  --exclude='workspace.json' \
  --exclude='workspace-mobile.json' \
  "$SOURCE" \
  "$DEST"

if [ $? -eq 0 ]; then
    echo "Synced Obsidian configuration from: $VAULT"
else
    echo "Failed to sync Obsidian configuration from: $VAULT"
    exit 1
fi
