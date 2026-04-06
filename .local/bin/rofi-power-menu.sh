#!/usr/bin/env bash

case "$(printf "ZZZ\nReboot\nShutdown" | rofi -dmenu -p "Selection" -i)" in
    ZZZ) systemctl suspend -i ;;
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot -i ;;
    *) exit 1 ;;
esac
                 
