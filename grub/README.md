# GRUB Setup

Theme:
https://github.com/shvchk/fallout-grub-theme

Installed theme path:
`/boot/grub2/themes/fallout-grub-theme`

Apply config:

```bash
cd dotfiles
sudo cp grub/default-grub /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

Theme install:

```bash
git clone https://github.com/shvchk/fallout-grub-theme
cd fallout-grub-theme
sudo ./install.sh
```
