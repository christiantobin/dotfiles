#!/usr/bin/env bash
# Waybar style switcher — pick a CSS style via rofi

STYLES_DIR="$HOME/.config/waybar/styles"
WAYBAR_CSS="$HOME/.config/waybar/style.css"

# List available styles
entries=""
for css in "$STYLES_DIR"/*.css; do
    [ -f "$css" ] || continue
    entries+="$(basename "$css" .css)\n"
done

if [ -z "$entries" ]; then
    notify-send "Waybar Styles" "No styles found in $STYLES_DIR"
    exit 1
fi

selected=$(echo -en "$entries" | rofi -dmenu -p "Waybar Style")

[ -z "$selected" ] && exit 0

STYLE_PATH="$STYLES_DIR/${selected}.css"

if [ ! -f "$STYLE_PATH" ]; then
    notify-send "Waybar Styles" "Style not found: $STYLE_PATH"
    exit 1
fi

cp "$STYLE_PATH" "$WAYBAR_CSS"
pkill waybar
sleep 0.3
nohup waybar >/dev/null 2>&1 &

notify-send "Waybar" "Style: $selected"
