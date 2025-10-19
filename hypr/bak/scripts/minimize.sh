#!/usr/bin/env bash
# minimize.sh
addr=$(hyprctl activewindow -j | jq -r .address)
[ -z "$addr" ] && exit 1
# envoie la fenêtre dans la workspace spéciale "minimized" sans y switcher
hyprctl dispatch movetoworkspacesilent special:minimized,address:$addr
