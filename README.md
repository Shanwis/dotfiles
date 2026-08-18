# Dotfiles

Personal Linux development environment configuration files of mine.

I am currently running fedora with niri as my WM and DankMaterialShell as my desktop shell.

I might try out noctalia soon.

## Tools

* Alacritty
* grub
* Neovim (Kickstart.nvim based)
* obsidian
* Starship prompt
* DankMaterialShell
* Niri

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
