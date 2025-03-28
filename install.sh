#!/bin/bash

# Global configuration
CONFIG_DIR="$HOME/bspwn/dot"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +'%Y%m%d%H%M%S').tar.gz"
NVIM_VERSION="v0.11.0"

# Ensure project is in $HOME/bspwn
setup_project_dir() {
    if [[ "$PWD" != "$HOME/bspwn" ]]; then
        mkdir -p "$HOME/bspwn" || error_exit "Failed to create bspwn directory"
        mv -- * .[!.]* ..?* "$HOME/bspwn/" 2>/dev/null
        cd "$HOME/bspwn" || error_exit "Failed to enter bspwn directory"
        log "Project moved to $HOME/bspwn"
    fi
}

# Enhanced logging
log() {
    printf "[%s] %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

# Error handling
error_exit() {
    log "ERROR: $1" >&2
    exit 1
}

# Create compressed backup
create_backup() {
    local backup_files=()
    
    # Collect dotfiles
    while IFS= read -r -d $'\0' file; do
        backup_files+=("$file")
    done < <(find "$CONFIG_DIR" -maxdepth 1 -type f -print0)
    
    # Collect .config directories
    while IFS= read -r -d $'\0' dir; do
        backup_files+=("$dir")
    done < <(find "$CONFIG_DIR/.config" -maxdepth 1 -type d -print0)
    
    # Create compressed backup
    tar -czf "$BACKUP_DIR" --ignore-failed-read "${backup_files[@]}" && 
    log "Created compressed backup at $BACKUP_DIR"
}

# Safer symlink creation
link_configs() {
    # Handle dotfiles
    find "$CONFIG_DIR" -maxdepth 1 -type f -exec bash -c '
        for file do
            base_file="${file##*/}"
            ln -sfv "$file" "$HOME/$base_file"
        done' bash {} +
    
    # Handle .config directories
    find "$CONFIG_DIR/.config" -maxdepth 1 -type d -exec bash -c '
        for dir do
            base_dir="${dir##*/}"
            ln -sfnv "$dir" "$HOME/.config/$base_dir"
        done' bash {} +
}

# Enhanced package installation
install_packages() {
    local required_packages=(
      bspwm kitty neovim polybar rofi sxhkd flameshot pamixer brightnessctl i3lock-color feh libnotify-bin xclip dmenu betterlockscreen lxappearance lsd bat pavucontrol xfce4-screensaver xfce4-power-manager xfce4-goodies xfce4 scrub shellcheck hsetroot lxpolkit zathura xinput xsel fastfetch htop gping apg pwgen moreutils iftop translate-shell redshift chrony ncal calc moreutils mpv vlc timg gimp ranger ueberzug picom btm 
  )

    log "Updating package list..."
    sudo apt update || error_exit "Failed to update packages"
    
    log "Installing required packages..."
    sudo apt install -y "${required_packages[@]}" || error_exit "Package installation failed"
    
    log "Removing existing NeoVim..."
    sudo apt remove --purge -y neovim* || log "No existing NeoVim found"
}

# NeoVim installation
install_neovim() {
    local nvim_url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
    local temp_dir=$(mktemp -d)
    
    log "Installing NeoVim ${NVIM_VERSION}..."
    wget -q "$nvim_url" -O "$temp_dir/nvim.tar.gz" || error_exit "Failed to download NeoVim"
    tar -xzf "$temp_dir/nvim.tar.gz" -C "$temp_dir" || error_exit "Failed to extract NeoVim"
    
    sudo install -Dm755 "$temp_dir/nvim-linux-x86_64/bin/nvim" "/usr/local/bin/nvim"
    sudo cp -rv "$temp_dir/nvim-linux-x86_64/share/man/man1/nvim.1" "/usr/local/share/man/man1/"
    sudo cp -rv "$temp_dir/nvim-linux-x86_64/lib" "/lib"

    rm -rf "$temp_dir"
    log "NeoVim installed successfully"
}

install_obsidian(){

    wget -q "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.9/obsidian_1.8.9_amd64.deb" -O "/dev/shm/obsidian_1.8.9_amd64.deb"
    sudo dpkg -i "/dev/shm/obsidian_1.8.9_amd64.deb"
}

install_gtk_theme(){
    sudo cp -rv "$CONFIG_DIR/usr/share/themes" "/usr/share/themes"
    sudo cp -rv "$CONFIG_DIR/usr/share/icons" "/usr/share/icons"
}

install_fonts() {
    local fonts=("FiraCode" "Hack")
    local tmp_dir="/dev/shm/nerd-fonts"

    mkdir -p "$tmp_dir"
    
    for font in "${fonts[@]}"; do
        wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/$font.zip" -O "$tmp_dir/$font.zip" &&
        unzip -q "$tmp_dir/$font.zip" -d "/usr/share/fonts/$font"
    done

    fc-cache -fv  # Refresh the font cache
    rm -rf "$tmp_dir"
}

# Main installation flow
main() {
    setup_project_dir
    create_backup
    install_packages
    install_neovim
    install_obsidian
    install_fonts
    link_configs
    log "Installation completed successfully!"
    log "Backup available at: $BACKUP_DIR"
}
main "$@"
