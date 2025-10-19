#!/bin/bash

# Récupère le statut de la fenêtre active
floating=$(hyprctl activewindow -j | jq '.floating')
window=$(hyprctl activewindow -j | jq '.initialClass' | tr -d "\"")

# Fonction pour activer le mode flottant, redimensionner et centrer
function toggle() {
    width=$1
    height=$2
    hyprctl --batch "dispatch togglefloating; dispatch resizeactive exact ${width} ${height}; dispatch centerwindow"
}

# Fonction pour désactiver le mode flottant
function untoggle() {
    hyprctl dispatch togglefloating
}

# Applique les actions en fonction de la fenêtre active
case $window in
    kitty) handle "50%" "55%" ;;
    *) handle "80%" "75%" ;;
esac
