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

```
git clone [dotfiles](https://github.com/Shanwis/dotfiles)
```

### Alacritty

```
ln -s ~/Data/PROJECTS/dotfiles/alacritty ~/.config/alacritty
```

### Neovim
```
ln -s ~/Data/PROJECTS/dotfiles/nvim ~/.config/nvim
```

### Starship
```
ln -s ~/Data/PROJECTS/dotfiles/starship/starship.toml ~/.config/starship.toml
```

### Obsidian
To sync up your configuration to the repo run
```
cd obsidian
chmod +x sync.sh
./sync.sh
```

### DankMaterialShell
```
ln -s ~/Data/PROJECTS/dotfiles/DankMaterialShell/ ~/.config/DankMaterialShell
```

### Niri
```
ln -s ~/Data/PROJECTS/dotfiles/niri/config.kdl ~/.config/niri/config.kdl
```
