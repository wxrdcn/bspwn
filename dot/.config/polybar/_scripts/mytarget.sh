#!/bin/bash
TARGET_FILE="$HOME/.current_target"

# Only handle display and copying
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

# Simply display current target
if [ -f "$TARGET_FILE" ]; then
  echo "R:$(cat "$TARGET_FILE")"
else
  echo "R:none"
fi
