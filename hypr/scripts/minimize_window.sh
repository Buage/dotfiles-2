#!/usr/bin/env bash
set -euo pipefail

TARGET_WS=9

# try JSON first (works on newer hyprctl), fallback to text parsing
WIN_ADDR=$(hyprctl -j activewindow 2>/dev/null | grep -Po '"address"\s*:\s*"\K[^"]+' || true)
if [ -z "$WIN_ADDR" ]; then
  WIN_ADDR=$(hyprctl activewindow 2>/dev/null | grep -o 'window:[0-9a-fx]\+' | head -n1 || true)
fi

if [ -z "$WIN_ADDR" ]; then
  echo "Window not found" >&2
  exit 1
fi

# get current workspace id (try JSON monitors -> activeWorkspace.id, fallback text)
CURRENT_WS=$(hyprctl -j monitors 2>/dev/null | grep -Po '"activeWorkspace"\s*:\s*\{\s*"id"\s*:\s*\K[0-9]+' | head -n1 || true)
if [ -z "$CURRENT_WS" ]; then
  CURRENT_WS=$(hyprctl monitors 2>/dev/null | grep -oP 'active workspace: \K[0-9]+' | head -n1 || true)
fi

if [ -z "$CURRENT_WS" ]; then
  echo "Unable to detect current workspace, aborting." >&2
  exit 1
fi

# Try silent mover first (if supported)
if hyprctl dispatch movetoworkspacesilent "$TARGET_WS,window:$WIN_ADDR" 2>/dev/null; then
  # done, movetoworkspacesilent shouldn't change focus
  exit 0
fi

# fallback: use movetoworkspace then return to previous workspace
if hyprctl dispatch movetoworkspace "$TARGET_WS,window:$WIN_ADDR"; then
  # small sleep to let hyprland process
  sleep 0.05
  hyprctl dispatch workspace "$CURRENT_WS"
  exit 0
else
  echo "Failed to move window." >&2
  exit 1
fi

