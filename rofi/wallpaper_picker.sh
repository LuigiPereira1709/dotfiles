#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Picker" "Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

list_wallpapers() {
    for file in "$WALLPAPER_DIR"/*; do
        if [[ "$file" =~ \.(jpg|jpeg|png|gif|webp)$ ]]; then
            filename=$(basename "$file")
            # Format for rofi: display_name\0icon\x1f/path/to/icon
            echo -en "$filename\0icon\x1f$file\n"
        fi
    done
}

selected=$(list_wallpapers | rofi -dmenu -i -p "󰸉" -theme ~/.config/rofi/wallpaper.rasi)

if [ -n "$selected" ]; then
    # Set wallpaper using swww
    swww img "$WALLPAPER_DIR/$selected" --transition-type wipe --transition-angle 30 --transition-duration 1
    notify-send "Wallpaper" "Changed to $selected"
fi
