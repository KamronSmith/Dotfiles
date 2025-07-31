#!/usr/bin/env bash
set -euo pipefail

frame_exists() {
    hyprctl clients 2>/dev/null | grep -q "Firefox"
}

if frame_exists; then
    hyprctl dispatch workspace name:Internet
else
    firefox &
fi
