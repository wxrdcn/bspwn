#!/bin/bash

# Global configuration
CONFIG_DIR="$PWD/dot"
BACKUP_DIR="$HOME/_dotfiles_backup_$(date +'%Y%m%d%H%M%S')"
NVIM_VERSION="v0.10.4"
OBSIDIAN_VERSION="1.8.9"
NERD_FONTS_VERSION="v3.3.0"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Error handling function
error_exit() {
    log "ERROR: $1" >&2
    exit 1
}

# Create backup directory
create_backup_dir() {
    mkdir -p "$BACKUP_DIR" || error_exit "Failed to create backup directory"
    log "Backup directory created: $BACKUP_DIR"
}

# Backup existing configuration files
backup_existing_configs() {
    create_backup_dir

    # Backup dot files
    local dot_files=(".bashrc" ".vimrc" ".zshrc")
    for file in "${dot_files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            cp "$HOME/$file" "$BACKUP_DIR/$file" && 
            log "Backed up $file to $BACKUP_DIR"
        fi
    done

    # Backup .config directories
    local config_dirs=(
        "bspwm" "kitty" "nvim" "picom" 
        "polybar" "ranger" "rofi" "sxhkd"
    )
    for dir in "${config_dirs[@]}"; do
        if [ -d "$HOME/.config/$dir" ]; then
            cp -r "$HOME/.config/$dir" "$BACKUP_DIR/$dir" && 
            log "Backed up $dir config to $BACKUP_DIR"
        fi
    done
}

# Install system packages
install_packages() {
    local packages=(
        # Window Management
        bspwm sxhkd polybar rofi i3lock-color
        
        # Terminal & Utilities
        kitty neovim xclip dmenu
        
        # System Tools
        lxappearance lsd bat pavucontrol
        xfce4-screensaver xfce4-power-manager
        
        # Multimedia
        feh flameshot pamixer brightnessctl
        mpv vlc gimp
        
        # Development & Monitoring
        shellcheck htop gping fastfetch
        
        # Extras
        zathura ranger picom redshift
    )

    export DEBIAN_FRONTEND=noninteractive
    sudo apt update || error_exit "Failed to update package list"
    sudo apt install -y "${packages[@]}" || error_exit "Package installation failed"
}

# Install NeoVim globally
install_neovim() {
    local nvim_url="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
    local temp_dir="/dev/shm"

    # Download NeoVim
    wget -q "$nvim_url" -O "$temp_dir/nvim.tar.gz" || error_exit "Failed to download NeoVim"
    
    # Extract and move binaries
    tar -xzf "$temp_dir/nvim.tar.gz" -C "$temp_dir" || error_exit "Failed to extract NeoVim"
    
    # Backup existing NeoVim installation
    if [ -d "/usr/local/lib/nvim" ]; then
        sudo mv /usr/local/lib/nvim /usr/local/lib/nvim_backup
    fi

    # Install NeoVim
    sudo mv "$temp_dir/nvim-linux-x86_64/bin"/* /usr/local/bin/
    sudo mv "$temp_dir/nvim-linux-x86_64/share/man/man1/nvim.1" /usr/local/share/man/man1/
    sudo mv "$temp_dir/nvim-linux-x86_64/lib"/* /usr/local/lib/

    # Clean up
    rm -rf "$temp_dir/nvim-linux-x86_64" "$temp_dir/nvim.tar.gz"
}

# Install NVChad
install_nvchad() {
    local nvchad_dir="$HOME/.config/nvim"
    
    # Remove existing NeoVim config
    [ -d "$nvchad_dir" ] && rm -rf "$nvchad_dir"

    # Clone NVChad
    git clone https://github.com/NvChad/NvChad "$nvchad_dir" || error_exit "Failed to clone NVChad"
}

# Create symbolic links for configuration files
link_config_files() {
    # Link dot files
    local dot_files=(".bashrc" ".vimrc" ".zshrc")
    for file in "${dot_files[@]}"; do
        ln -sf "$CONFIG_DIR/$file" "$HOME/$file" && 
        log "Linked $file"
    done

    # Link .config directories
    local config_dirs=(
        "bspwm" "kitty" "nvim" "picom" 
        "polybar" "ranger" "rofi" "sxhkd"
    )
    for dir in "${config_dirs[@]}"; do
        ln -sfn "$CONFIG_DIR/.config/$dir" "$HOME/.config/$dir" && 
        log "Linked $dir config"
    done
}

# Install fonts
install_fonts() {
    local fonts=("FiraCode" "Hack")
    local fonts_dir="/usr/share/fonts"

    for font in "${fonts[@]}"; do
        local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/${font}.zip"
        
        # Download and extract fonts
        wget -q "$font_url" -O "/dev/shm/${font}.zip" || error_exit "Failed to download $font font"
        sudo mkdir -p "$fonts_dir/$font"
        sudo unzip -o "/dev/shm/${font}.zip" -d "$fonts_dir/$font" || error_exit "Failed to extract $font font"
        
        # Clean up
        rm "/dev/shm/${font}.zip"
    done
}

# Install themes and icons
install_themes() {
    # Copy themes and icons with forced override
    sudo cp -rf "$PWD/usr/share/themes"/* "/usr/share/themes/"
    sudo cp -rf "$PWD/usr/share/icons"/* "/usr/share/icons/"
}

# Main installation function
main() {
    # Parse command-line arguments
    local install_mode="full"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --config-only) install_mode="config" ;;
            --packages-only) install_mode="packages" ;;
            *) error_exit "Unknown argument: $1" ;;
        esac
        shift
    done

    # Run appropriate installation steps
    case "$install_mode" in
        "full")
            backup_existing_configs
            install_packages
            install_neovim
            install_nvchad
            link_config_files
            install_fonts
            install_themes
            ;;
        "config")
            backup_existing_configs
            link_config_files
            ;;
        "packages")
            install_packages
            ;;
    esac

    log "Installation completed successfully!"
}

# Run main function
main "$@"
