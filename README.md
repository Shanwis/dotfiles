# Dotfiles

Personal Linux development environment configuration files of mine.

I am currently running fedora with niri as my WM and DankMaterialShell as my desktop shell.

My terminal emulator is currently Alacritty, thinking of switching to ghostty next.

I currently using bash as my shell, planning on switching to zsh or fish.

My terminal emulator is tmux and I am using the tmux plugin manager and currently have the catppucin/tmux plugin.

I use obsidian for most of my note taking needs.

I am currently trying to switch my coding to nvim, but that still requires a lot of configuration.

For my AI-assisted coding I use OpenCode.

## Tools

* Alacritty
* grub
* Neovim (Kickstart.nvim based)
* obsidian
* Starship prompt
* DankMaterialShell
* Niri
* tmux
* yazi 

## Theme

* Catppuccin Mocha
* JetBrainsMono Nerd Font

## Setup

Clone the repository:

```bash
git clone https://github.com/Shanwis/dotfiles.git ~/Data/PROJECTS/dotfiles
cd ~/Data/PROJECTS/dotfiles
```

### Quick Setup (Recommended)

Run the included automated bootstrap script to safely link all configurations with backup support:

```bash
chmod +x setup.sh
./setup.sh
```

---

### Manual Setup

If you prefer to symlink individual components manually:

#### Shell & Terminal
```bash
ln -s ~/Data/PROJECTS/dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/Data/PROJECTS/dotfiles/alacritty ~/.config/alacritty
ln -s ~/Data/PROJECTS/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -s ~/Data/PROJECTS/dotfiles/atuin/config.toml ~/.config/atuin/config.toml
```

#### Window Manager & Desktop
```bash
ln -s ~/Data/PROJECTS/dotfiles/niri ~/.config/niri
ln -s ~/Data/PROJECTS/dotfiles/DankMaterialShell ~/.config/DankMaterialShell
```

#### Multiplexer & CLI Tools
```bash
ln -s ~/Data/PROJECTS/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/Data/PROJECTS/dotfiles/tmux/tmux-new.sh ~/.local/bin/tmux-new.sh
ln -s ~/Data/PROJECTS/dotfiles/nvim ~/.config/nvim
ln -s ~/Data/PROJECTS/dotfiles/yazi ~/.config/yazi
ln -s ~/Data/PROJECTS/dotfiles/zathura ~/.config/zathura
```

### Obsidian Configuration Backup
To sync your vault configuration into the repository:
```bash
cd obsidian
chmod +x sync.sh
./sync.sh <vault-name>
```
