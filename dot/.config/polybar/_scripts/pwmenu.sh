#!/usr/bin/env bash
dir="$HOME/.config/rofi/pwmenu/"
uptime=$(uptime -p | sed -e 's/up //g')

# Rofi command with theme
rofi_command="rofi -theme $dir/powermenu.rasi"

# Options (with standard Unicode/emojis)
shutdown="⏻ Shutdown"
reboot="🔄 Restart"
lock="🔒 Lock"
suspend="💤 Sleep"
logout="🚪 Logout"

# Function: Confirmation dialog
confirm_exit() {
	rofi -dmenu \
		-i \
		-no-fixed-num-lines \
		-p "Are you sure? : " \
		-theme "$dir/confirm.rasi"
}

# Function: Message dialog
msg() {
	rofi -theme "$dir/message.rasi" -e "$1"
}

# Function: Handle confirmation
handle_confirmation() {
	local action=$1
	ans=$(confirm_exit)
	case "$ans" in
		[yY]*)
			eval "$action"
			;;
		[nN]*)
			exit 0
			;;
		*)
			msg "Invalid input. Please type 'yes' or 'no'."
			;;
	esac
}

# Rofi menu options
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

# Get user selection
chosen=$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)

# Handle the selected option
case "$chosen" in
	$shutdown)
		handle_confirmation "shutdown -h now"
		;;
	$reboot)
		handle_confirmation "shutdown -r now"
		;;
	$lock)
		if command -v xfce4-screensaver-command &> /dev/null; then
			xfce4-screensaver-command --lock
		else
			msg "Lock command 'xfce4-screensaver-command' not found. Please install it."
		fi
		;;
	$suspend)
		handle_confirmation "mpc -q pause; amixer set Master mute; systemctl suspend"
		;;
	$logout)
		handle_confirmation "
			if [[ \"$DESKTOP_SESSION\" == \"bspwm\" ]]; then
				bspc quit
			else
				msg 'Unsupported desktop session: $DESKTOP_SESSION'
			fi
		"
		;;
	*)
		msg "No valid option selected."
		;;
esac
