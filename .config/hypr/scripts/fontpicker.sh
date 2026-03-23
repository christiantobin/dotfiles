#!/bin/bash
# Font picker — switch monospace font across alacritty + waybar

ALACRITTY_CONF="$HOME/.config/alacritty/alacritty.toml"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"

# Available nerd fonts (display name -> font family)
declare -A FONTS=(
    ["JetBrains Mono"]="JetBrainsMono Nerd Font"
    ["Hack"]="Hack Nerd Font"
    ["FiraCode"]="FiraCode Nerd Font"
    ["Iosevka"]="Iosevka Nerd Font"
    ["Victor Mono"]="VictorMono Nerd Font"
    ["Cascadia Code"]="CaskaydiaCove Nerd Font"
    ["MesloLG"]="MesloLGS Nerd Font"
)

# Show picker
selected=$(printf '%s\n' "${!FONTS[@]}" | sort | wofi --dmenu -p "Font")

[ -z "$selected" ] && exit 0

FONT="${FONTS[$selected]}"

if [ -z "$FONT" ]; then
    notify-send "Font Picker" "Unknown font: $selected"
    exit 1
fi

# Update alacritty — add or replace font section
if grep -q '^\[font\.normal\]' "$ALACRITTY_CONF"; then
    sed -i '/^\[font\.normal\]/,/^family = /{s/^family = .*/family = "'"$FONT"'"/}' "$ALACRITTY_CONF"
else
    cat >> "$ALACRITTY_CONF" << EOF

[font]
size = 13.0

[font.normal]
family = "$FONT"
EOF
fi

# Update waybar
sed -i "s/font-family: \"[^\"]*\",/font-family: \"$FONT\",/g" "$WAYBAR_STYLE"

# Restart waybar
pkill waybar
sleep 0.3
waybar &>/dev/null &
disown

notify-send "Font" "Switched to: $selected"
