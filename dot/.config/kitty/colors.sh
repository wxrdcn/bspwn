#!/bin/bash

#kitty @ set-colors -a -c <path-to-config-file>

for i in {0..15}; do
    printf "\x1b[48;5;%sm%3s\e[0m " "$i" "$i"
    if ((i == 7)); then
        printf "\n"
    fi
done

