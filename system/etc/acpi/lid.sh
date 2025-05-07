#!/bin/bash

# Log execution
echo "[$(date)] Lid event triggered (lock + suspend)" >> /tmp/lid.log

# Detect all X displays
XDISPLAYS=($(ls /tmp/.X11-unix/ | grep -oP 'X\d+' | sed 's/X/:/'))

for XDISPLAY in "${XDISPLAYS[@]}"; do
    XUSER=$(ps -eo user,args | grep "X.*$XDISPLAY" | grep -m1 -v grep | awk '{print $1}')
    [ -z "$XUSER" ] && continue

    XHOME=$(getent passwd "$XUSER" | cut -d: -f6)
    XAUTH=""

    # Check LY's custom Xauthority first (for root)
    [ "$XUSER" = "root" ] && [ -f "/run/user/0/lyxauth" ] && XAUTH="/run/user/0/lyxauth"

    # Fallback to standard locations
    [ -z "$XAUTH" ] && XAUTH=$(find "$XHOME" /run/user/$(id -u "$XUSER") -name ".Xauthority" -o -name "lyxauth" 2>/dev/null | head -n1)

    echo "Locking $XUSER on $XDISPLAY (Xauthority: ${XAUTH:-none})" >> /tmp/lid.log

    # Lock screen (replace with your preferred command)
    if command -v betterlockscreen >/dev/null; then
        if [ "$XUSER" = "root" ]; then
            DISPLAY="$XDISPLAY" XAUTHORITY="$XAUTH" betterlockscreen -l &!
        else
            su "$XUSER" -c "DISPLAY=$XDISPLAY XAUTHORITY=$XAUTH betterlockscreen -l" &!
        fi
        sleep 2  # Ensure lock is fully engaged
        break    # Exit loop after first successful lock
    fi
done

# Suspend (now handled by ACPI event)
echo "Screen locked; suspend will follow." >> /tmp/lid.log
systemctl suspend
