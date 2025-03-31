#!/bin/bash

get_ipaddr() {
    local interfaces=("tun0" "tap0" "eth0" "wlan0" "wlan1")
    for iface in "${interfaces[@]}"; do
        if ip link show "$iface" &>/dev/null; then
            local ipaddr=$(ip -4 addr show "$iface" 2>/dev/null | grep -Po 'inet \K\d{1,3}(\.\d{1,3}){3}' | head -n1)
            [[ -n $ipaddr ]] && { echo "$ipaddr"; return; }
        fi
    done
    echo "offline"
}

get_ipaddr
