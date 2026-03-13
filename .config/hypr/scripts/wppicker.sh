#!/bin/bash
# Wallpaper picker — uses rofi to select, matugen to apply colors + swww wallpaper

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Build list of wallpapers with icon previews
shopt -s nullglob
entries=""
for img in "$WALLPAPER_DIR"/*.jpg "$WALLPAPER_DIR"/*.png "$WALLPAPER_DIR"/*.gif "$WALLPAPER_DIR"/*.jpeg; do
    name="$(basename "$img")"
    entries+="$name\0icon\x1f$img\n"
done

if [ -z "$entries" ]; then
    notify-send "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Show picker
selected=$(echo -en "$entries" | rofi -dmenu -p "Wallpaper" -show-icons -theme-str 'listview { columns: 3; }')

[ -z "$selected" ] && exit 0

WALLPAPER_PATH="$WALLPAPER_DIR/$selected"

if [ ! -f "$WALLPAPER_PATH" ]; then
    notify-send "Wallpaper Picker" "File not found: $WALLPAPER_PATH"
    exit 1
fi

# Run matugen — sets wallpaper via swww and generates all color configs
matugen --source-color-index 0 --contrast 0.5 -m dark image "$WALLPAPER_PATH"

# Symlink for reference
ln -sf "$WALLPAPER_PATH" "$HOME/.config/hypr/current_wallpaper"

# Restart waybar (matugen color changes can crash the mpris module)
pkill waybar
sleep 0.5
waybar &>/dev/null &
disown

notify-send "Wallpaper" "Applied: $selected"
