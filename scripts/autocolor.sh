#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo -e "[+] Usage: autocolor <first_color> <second_color>"
    echo -e "\tExample: autocolor \"#FF0000\" \"#00FF00\""
    exit 1
fi

# Validate hex color format (basic check for #RRGGBB)
if ! [[ $1 =~ ^#[0-9A-Fa-f]{6}$ ]] || ! [[ $2 =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    echo "Error: Colors must be in #RRGGBB format (e.g., #FF0000)"
    exit 1
fi

FIRST_COLOR=$1
SECOND_COLOR=$2
CONFIG_DIR="$HOME/.config"

# Backup original files (optional but recommended)
#cp "$CONFIG_DIR/polybar/config.ini" "$CONFIG_DIR/polybar/config.ini.bak"
#cp "$CONFIG_DIR/kitty/colors.conf" "$CONFIG_DIR/kitty/colors.conf.bak"
#cp "$CONFIG_DIR/bspwm/start" "$CONFIG_DIR/bspwm/start.bak"
#cp "$CONFIG_DIR/bspwm/bspwmrc" "$CONFIG_DIR/bspwm/bspwmrc.bak"

# Replace first color lines
sed -i "s|^primary = #\([0-9A-Fa-f]\{6\}\)$|primary = $FIRST_COLOR|" "$CONFIG_DIR/polybar/config.ini"
sed -i "s|label-mounted = %{F#\([0-9A-Fa-f]\{6\}\)}%mountpoint%%{F-} %percentage_free%%|label-mounted = %{F$FIRST_COLOR}%mountpoint%%{F-} %percentage_free%%|" "$CONFIG_DIR/polybar/config.ini"
sed -i "s|date = %d/%m/%y %{F#\([0-9A-Fa-f]\{6\}\)} X %{F-} %I:%M:%S|date = %d/%m/%y %{F$FIRST_COLOR} X %{F-} %I:%M:%S|" "$CONFIG_DIR/polybar/config.ini"
sed -i "s|label = %{F#\([0-9A-Fa-f]\{6\}\)}BKL%{F-}%percentage:4:3%%|label = %{F$FIRST_COLOR}BKL%{F-}%percentage:4:3%%|" "$CONFIG_DIR/polybar/config.ini"
sed -i "s|^active_tab_foreground   #\([0-9A-Fa-f]\{6\}\)$|active_tab_foreground   $FIRST_COLOR|" "$CONFIG_DIR/kitty/colors.conf"
sed -i "s|hsetroot -solid \"#\([0-9A-Fa-f]\{6\}\)\" -center \"\$HOME/.config/bspwm/_img/kali.png\"|hsetroot -solid \"$FIRST_COLOR\" -center \"\$HOME/.config/bspwm/_img/kali.png\"|" "$CONFIG_DIR/bspwm/start"
sed -i "s|bspc config focused_border_color \"#\([0-9A-Fa-f]\{6\}\)\"|bspc config focused_border_color \"$FIRST_COLOR\"|" "$CONFIG_DIR/bspwm/bspwmrc"

# Replace second color lines
sed -i "s|^occupied = #\([0-9A-Fa-f]\{6\}\)$|occupied = $SECOND_COLOR|" "$CONFIG_DIR/polybar/config.ini"
sed -i "s|^cursor #\([0-9A-Fa-f]\{6\}\)$|cursor $SECOND_COLOR|" "$CONFIG_DIR/kitty/colors.conf"
sed -i "s|^active_border_color #\([0-9A-Fa-f]\{6\}\)$|active_border_color $SECOND_COLOR|" "$CONFIG_DIR/kitty/colors.conf"
sed -i "s|^inactive_border_color #\([0-9A-Fa-f]\{6\}\)$|inactive_border_color $SECOND_COLOR|" "$CONFIG_DIR/kitty/colors.conf"

echo "Colors updated successfully!"
echo "First color ($FIRST_COLOR) and Second color ($SECOND_COLOR) applied."
