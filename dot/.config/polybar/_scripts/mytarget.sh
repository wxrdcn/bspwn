#!/bin/bash
TARGET_FILE="$HOME/.current_target"

# Function to validate IP address format
validate_ip() {
    local ip=$1
    local stat=1
    
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a ip_segments <<< "$ip"
        [[ ${ip_segments[0]} -le 255 && ${ip_segments[1]} -le 255 \
            && ${ip_segments[2]} -le 255 && ${ip_segments[3]} -le 255 ]]
        stat=$?
    fi
    
    return $stat
}

# Copy target to clipboard if --copy flag is provided
if [ "$1" = "--copy" ]; then
    if [ -f "$TARGET_FILE" ] && [ "$(cat "$TARGET_FILE")" != "none" ]; then
        cat "$TARGET_FILE" | tr -d "\n" | xclip -selection clipboard
        echo "Target copied to clipboard"
        notify-send -u low "$(cat $TARGET_FILE) copied to clipboard"
        exit 0
    else
        echo "No target to copy"
        exit 1
    fi
fi

# Clear target if -c flag is provided
if [ "$1" = "-c" ]; then
    echo none > "$TARGET_FILE"
    echo "Target cleared"
    exit 0
fi

# Set or get target
if [ "$1" ]; then
    # Validate IP address
    if validate_ip "$1"; then
        echo "$1" > "$TARGET_FILE"
        echo "Target set to: $1"
    else
        echo "Error: Invalid IP address format"
        echo -e "Usage:\n\ttarget 192.168.1.1 : sets a new target\n\ttarget -c : clears the target\n\ttarget : prints the current target"
        exit 1
    fi
elif [ -f "$TARGET_FILE" ]; then
    echo "R: $(cat "$TARGET_FILE")"
else
    echo "R: none"
fi
