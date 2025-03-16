#!/bin/bash

# config files mainly for "Kali Linux"

backup_files(){
    files=$(find ./dot/ -maxdepth 2  | sed  "s/^config\///g"|sed -r '/^\s*$/d')
    backup_directory="$HOME/_dotfiles_backup_$(date +'%Y%m%d%H%M%S/')"
    mkdir -p "$backup_directory"
    for file in "${files[@]}"; do
        cp -r "$file" -t "$backup_directory"
    done
}

install_config(){
    export DEBIAN_FRONTEND=noninteractive
    sudo apt -y update
    sudo apt -y install \
        bspwm \
        kitty \
        neovim \
        polybar \
        rofi \
        sxhkd \
        flameshot \
        pamixer \
        brightnessctl \
        i3lock-color \
        feh \
        libnotify-bin \
        xclip \
        dmenu \
        betterlockscreen \
        lxappearance \
        lsd \
        bat \
        pavucontrol \
        xfce4-screensaver \
        xfce4-power-manager \
        xfce4-goodies \
        xfce4 \
        scrub \
        shellcheck \
        hsetroot \
        lxpolkit \
        zathura \
        xinput \
        xsel \
        fastfetch \
        htop \
        gping \
        apg \
        pwgen \
        moreutils \
        iftop \
        btm

    # global install of neovim
    sudo wget -q "https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz" -O "/dev/shm/nvim-linux-x86_64.tar.gz"
    sudo tar -xzf "/dev/shm/nvim-linux-x86_64.tar.gz" -C "/dev/shm/"
    sudo mv /dev/shm/nvim-linux-x86_64/bin/* /usr/local/bin/
    sudo mv /dev/shm/nvim-linux-x86_64/lib/* /usr/local/lib/
    sudo mv /dev/shm/nvim-linux-x86_64/share/man/man1/nvim.1 /usr/local/share/man/man1/
     

    # global install of obsidian
    wget -q "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.9/obsidian_1.8.9_amd64.deb" -O "/dev/shm/obsidian_1.8.9_amd64.deb"
    sudo dpkg -i "/dev/shm/obsidian_1.8.9_amd64.deb"

    # global install of red darkest gtk theme
    sudo cp -rv "$PWD/usr/share/themes/*" "/usr/share/themes"
    sudo cp -rv "$PWD/usr/share/icons/*" "/usr/share/icons"

    # global install of fonts
    for i in FiraCode Hack; do
        wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/$i.zip" -O "/dev/shm/$i.zip"
        unzip "/dev/shm/$i.zip" -d "/usr/share/fonts/$i"
    done
    
    # local user config install
    cp -rv "$PWD/dot/.*" "$HOME"
}

backup_files
install_config
