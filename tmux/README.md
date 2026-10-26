# Tmux Configuration

Personal tmux configuration featuring vim-style navigation, Catppuccin Mocha theme, dynamic status bar with battery and online indicators, and session persistence across reboots.

---

## Features

- **TrueColor & Terminal Support**: 24-bit TrueColor support for Alacritty and xterm-256color.
- **Vim Navigation**: `h`, `j`, `k`, `l` pane selection and vi-mode keys.
- **Catppuccin Mocha Theme**: Minimalist top-positioned status bar styled with Catppuccin Mocha palette.
- **Session Persistence Across Shutdown**: Automated background saving, instant shutdown snapshotting, and headless boot restoration without dummy sessions.
- **Fuzzy Session Picker**: [`tmux-new.sh`](tmux-new.sh) interactive launcher powered by `fd` and `fzf`.

---

## Architecture: Zero-Loss Persistence & Boot Recovery

1. **At Boot / User Login (`tmux.service` + `tmux-start.sh`)**:
   - `tmux-start.sh` launches tmux in the background with a temporary bootstrap session.
   - It headlessly restores all saved sessions from the latest snapshot.
   - Once restored, it immediately kills the bootstrap session.
   - **Result**: `tmux ls` contains **only** your exact previous sessions (`shields`, `dotfiles`, etc.) with zero phantom/dummy sessions.
2. **While Working (`tmux-continuum`)**:
   - Continuously auto-saves state in the background every **10 minutes** to `~/.local/share/tmux/resurrect/`.
3. **On System Shutdown / Reboot (`ExecStop` hook)**:
   - Systemd runs `save.sh` at the exact moment of shutdown before terminating the server.
   - Preserves state even if new windows were opened seconds before shutting down.

---

## Plugins (TPM)

Plugins are managed with [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm):

| Plugin | Purpose |
|---|---|
| `tmux-plugins/tpm` | Plugin manager |
| `tmux-plugins/tmux-online-status` | Online/offline connectivity icon |
| `tmux-plugins/tmux-battery` | Battery charge percentage and status |
| `catppuccin/tmux` | Catppuccin Mocha theme |
| `tmux-plugins/tmux-resurrect` | Restores sessions, window layouts, pane contents, and processes |
| `tmux-plugins/tmux-continuum` | Continuous background saving every 10 minutes |

### Plugin Management Shortcuts

| Shortcut | Action |
|---|---|
| `prefix + I` | Install new plugins defined in `.tmux.conf` |
| `prefix + U` | Update installed plugins |
| `prefix + alt + u` | Uninstall plugins removed from `.tmux.conf` |

*(Default prefix is `Ctrl-b`)*

---

## Manual Shortcuts

| Shortcut | Action |
|---|---|
| `prefix + Ctrl-s` | **Save now**: Manually snapshot current tmux state immediately |
| `prefix + Ctrl-r` | **Restore now**: Manually restore tmux environment from the last saved snapshot |

### Restored Programs & Environments
- **Programs**: `nvim`, `vim`, `man`, `less`, `more`, `tail`, `top`, `htop`, `btop`, `yazi`, `git log`.
- **Neovim / Vim Sessions**: Automatically restores Neovim sessions if a session file is present.
- **Pane History**: Restores visible scrollback and pane contents.
- **Wayland Display**: Updates `WAYLAND_DISPLAY` and `XDG_CURRENT_DESKTOP` upon reconnecting to ensure clipboard (`wl-copy`) and GUI tools work seamlessly.

---

## Service Management

The systemd user service runs in the background and is managed via standard `systemctl --user` commands:

```bash
# Check status
systemctl --user status tmux.service

# Restart service (triggers save before restart)
systemctl --user restart tmux.service

# Stop service (triggers clean save)
systemctl --user stop tmux.service
```

---

## Keybindings Reference

- `prefix + r`: Reload `.tmux.conf` configuration.
- `prefix + h / j / k / l`: Navigate panes (Left / Down / Up / Right).
- `prefix + s`: Interactive session switcher with window previews.
- Mouse support is enabled for pane selection, resizing, and scrolling.
