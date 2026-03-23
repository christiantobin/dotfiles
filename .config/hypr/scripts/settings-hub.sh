#!/bin/bash
# Settings hub — quick access to system settings panels

selected=$(cat << 'EOF' | wofi --dmenu --prompt "Settings" --width 300 --height 350 --cache-file /dev/null
 Network
 Bluetooth
 Audio
 Disks
 Display
EOF
)

case "$selected" in
    *Network*)    nm-connection-editor ;;
    *Bluetooth*)  blueman-manager ;;
    *Audio*)      pavucontrol ;;
    *Disks*)      gnome-disks ;;
    *Display*)    wdisplays || nwg-displays 2>/dev/null || notify-send "Display" "No display manager found" ;;
esac
