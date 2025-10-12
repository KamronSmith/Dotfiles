#!/usr/bin/env bash
set -euo pipefail

frame_exists() {
    hyprctl clients 2>/dev/null | grep -q "GNU Emacs"
}

if frame_exists; then
    hyprctl dispatch workspace name:2
else
    emacsclient -a "" -c &
fi
