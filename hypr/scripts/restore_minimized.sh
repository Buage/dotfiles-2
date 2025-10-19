#!/usr/bin/env bash
# restore_minimized.sh
# récupère la workspace courante (nom)
cw=$(hyprctl monitors -j | jq -r '.[] | select(.active==true) | .activeWorkspace.name')
# prend la première fenêtre trouvée sur la workspace spéciale "minimized"
addr=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:minimized") | .address' | head -n1)
if [ -n "$addr" ]; then
  # remet la fenêtre sur la workspace courante
  hyprctl dispatch movetoworkspacesilent name:$cw,address:$addr
fi
