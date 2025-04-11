# bspwn
> dotfiles configuration for kali-linux

## install.sh
install the configuration (recomended -full for first time)

```bash
Usage: install.sh [OPTIONS]
Options:
	-full      Perform full installation (includes all options below)
	-pkg       Install system packages
	-config    Link configuration files
	-nvim      Install NeoVim
	-nvchad    Install NvChad configuration
	-fonts     Install fonts
	-theme     Install GTK theme and icons
	-obsidian  Install Obsidian
	-xfcepwr   Configure XFCE power manager settings
```

## scripts 

### scripts/autocolor.sh
can change a bit of the colorscheme (experimental)

```bash
$ bash scripts/autocolor.sh
[+] Usage: autocolor <first_color> [<second_color> <background_color>]
	Example with one color: autocolor "#FF0000"
	Example with three colors: autocolor "#FF0000" "#00FF00" "#0000FF"
```

### power-manager-settings.sh
run the scripts/power-manager-settings.sh to enable suspend on lid close and such

```bash
$ bash scripts/power-manager-settings.sh
```
