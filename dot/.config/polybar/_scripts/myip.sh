#!/bin/bash

get_ipaddr() {
    local interfaces=("tun0" "tap0" "eth0" "wlan0" "wlan1")
    for iface in "${interfaces[@]}"; do
        if ip link show "$iface" &>/dev/null; then
            local ipaddr=$(ip -4 addr show "$iface" 2>/dev/null | grep -Po 'inet \K\d{1,3}(\.\d{1,3}){3}' | head -n1)
            [[ -n $ipaddr ]] && { echo "L: $ipaddr"; return; }
        fi
    done
    echo "offline"
}

# Copy IP to clipboard if --copy flag is provided
if [ "$1" = "--copy" ]; then
    ip_to_copy=$(get_ipaddr)
    if [ "$ip_to_copy" != "offline" ]; then
        echo -n "$ip_to_copy" | xclip -selection clipboard
        notify-send -u low "$ip_to_copy copied to clipboard"
        echo "IP address copied to clipboard"
        exit 0
    else
        echo "No IP address to copy (offline)"
        exit 1
    fi
fi

# Default behavior: just output the IP
get_ipaddr
