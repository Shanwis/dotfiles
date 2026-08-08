# Dotfiles

Personal Linux development environment configuration files of mine.

## Tools

* Alacritty
* grub
* Neovim (Kickstart.nvim based)
* obsidian
* Starship prompt

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
