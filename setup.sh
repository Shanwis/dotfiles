#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Create required directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/atuin"
mkdir -p "$HOME/.config/systemd/user"

link_file() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        local current_canon src_canon
        current_canon="$(readlink -f "$dest" 2>/dev/null || true)"
        src_canon="$(readlink -f "$src" 2>/dev/null || true)"
        if [ "$current_canon" = "$src_canon" ]; then
            success "Already linked: $dest"
            return
        else
            warn "Updating link for $dest (was -> $current_canon)"
            rm -f "$dest"
        fi
    elif [ -e "$dest" ]; then
        local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
        warn "Existing file found at $dest; moving to $backup"
        mv "$dest" "$backup"
    fi

    ln -s "$src" "$dest"
    success "Linked $src -> $dest"
}

info "Installing dotfiles from $DOTFILES_DIR..."

# Shell & Core Tools
link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link_file "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty"
link_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/tmux/tmux-new.sh" "$HOME/.local/bin/tmux-new.sh"
link_file "$DOTFILES_DIR/tmux/tmux-start.sh" "$HOME/.local/bin/tmux-start.sh"
link_file "$DOTFILES_DIR/tmux/tmux.service" "$HOME/.config/systemd/user/tmux.service"
link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/niri" "$HOME/.config/niri"
link_file "$DOTFILES_DIR/DankMaterialShell" "$HOME/.config/DankMaterialShell"
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_file "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"
link_file "$DOTFILES_DIR/zathura" "$HOME/.config/zathura"
link_file "$DOTFILES_DIR/atuin/config.toml" "$HOME/.config/atuin/config.toml"

# Obsidian application wrapper symlink if AppImage exists
if [ -f "$HOME/Applications/Obsidian-1.12.7.AppImage" ] && [ ! -e "$HOME/.local/bin/obsidian-app" ]; then
    link_file "$HOME/Applications/Obsidian-1.12.7.AppImage" "$HOME/.local/bin/obsidian-app"
fi

# Ensure scripts are executable
chmod +x "$DOTFILES_DIR/tmux/tmux-new.sh" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/tmux/tmux-start.sh" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/obsidian/sync.sh" 2>/dev/null || true
chmod +x "$DOTFILES_DIR/grub/shorten-grub-entries" 2>/dev/null || true

# Enable tmux systemd user service for auto-start and graceful shutdown saves
systemctl --user daemon-reload 2>/dev/null || true
systemctl --user enable tmux.service 2>/dev/null || true

success "All dotfiles successfully configured!"
