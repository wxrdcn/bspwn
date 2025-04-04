#!/bin/bash

if [ "$1" = "close" ]; then
    wmctrl -c "btop"  # Close window with "btop" in title
else
    xterm -T "btop" -e btop &  # Launch with a specific title
fi
