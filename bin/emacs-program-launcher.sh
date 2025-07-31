#!/usr/bin/env bash
set -euo pipefail

frame_exists() {
    hyprctl clients 2>/dev/null | grep -q "GNU Emacs"
}

if frame_exists; then
    hyprctl dispatch workspace name:Emacs
else
    emacsclient -a "" -c &
fi
