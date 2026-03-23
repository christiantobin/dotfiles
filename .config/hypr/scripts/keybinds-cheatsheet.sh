#!/bin/bash
# Keybinds cheatsheet — dynamically parses keybinds.conf and shows in wofi

CONF="$HOME/.config/hypr/keybinds/keybinds.conf"

generate() {
    local section=""
    while IFS= read -r line; do
        # Section comment (single #, not ##)
        if [[ "$line" =~ ^#[^#] ]]; then
            local comment="${line#\# }"
            # Skip sub-comments and inline noise
            [[ "$comment" =~ ^[\(] ]] && continue
            [[ -z "$comment" ]] && continue
            section="$comment"
            echo "── ${section^^} ──"
            continue
        fi

        # Skip non-bind lines
        [[ ! "$line" =~ ^bind ]] && continue
        # Skip mouse and lid switch
        [[ "$line" =~ mouse:|switch: ]] && continue

        # Parse: bind[flags] = MODS, KEY, DISPATCHER, ARGS  # optional comment
        local rest="${line#*= }"
        IFS=',' read -r mods key dispatcher args <<< "$rest"

        # Clean whitespace
        mods="${mods// /}"; key="${key## }"; key="${key%% }"
        dispatcher="${dispatcher## }"; dispatcher="${dispatcher%% }"
        args="${args## }"; args="${args%% }"

        # Format modifier names
        mods="${mods//\$mainMod/Super}"
        mods="${mods//SHIFT/Shift}"
        mods="${mods//CTRL/Ctrl}"
        [[ -n "$mods" ]] && mods="${mods//+/+}"

        # Handle keycode
        if [[ "$key" =~ code:61 ]]; then
            if [[ "$mods" == *Shift* ]]; then
                mods="${mods/+Shift/}"
                mods="${mods/Shift+/}"
                key="?"
            else
                key="/"
            fi
        fi

        # Build combo
        local combo
        [[ -n "$mods" ]] && combo="${mods}+${key}" || combo="$key"

        # Get description: prefer inline comment, otherwise derive from action
        local desc=""
        if [[ "$line" =~ \#\  ]]; then
            desc="${line##*\# }"
        else
            case "$dispatcher" in
                exec)
                    case "$args" in
                        *terminal*|*alacritty*) [[ "$args" =~ btop ]] && desc="System monitor (btop)" || desc="Terminal" ;;
                        *wofi\ --show*) desc="App launcher" ;;
                        *theme-switch*) desc="Theme switcher" ;;
                        *claude*) desc="Claude scratchpad" ;;
                        *hyprlock*) desc="Lock screen" ;;
                        *reboot*) desc="Reboot" ;;
                        *wppicker*) desc="Wallpaper picker" ;;
                        *fontpicker*) desc="Font picker" ;;
                        *makoctl*) desc="Dismiss notifications" ;;
                        *hyprpicker*) desc="Color picker" ;;
                        *WaybarStyles*) desc="Waybar style switcher" ;;
                        *wlogout*) desc="Power menu" ;;
                        *cliphist*) desc="Clipboard history" ;;
                        *grim*) desc="Screenshot (region)" ;;
                        *waybar*) desc="Toggle bar" ;;
                        *float-mode*) desc="Toggle float mode" ;;
                        *keybinds-cheat*) desc="Keybinds cheatsheet" ;;
                        *settings-hub*) desc="Settings hub" ;;
                        *thunar*|*nautilus*|*dolphin*) desc="File manager" ;;
                        *wpctl*mute*toggle*) desc="Toggle mute" ;;
                        *wpctl*5%+*) desc="Volume up" ;;
                        *wpctl*5%-*) desc="Volume down" ;;
                        *brightnessctl*+*) desc="Brightness up" ;;
                        *brightnessctl*-*) desc="Brightness down" ;;
                        *playerctl\ next*) desc="Next track" ;;
                        *playerctl\ play*) desc="Play/pause" ;;
                        *playerctl\ prev*) desc="Previous track" ;;
                        *) desc="${args}" ;;
                    esac
                    ;;
                killactive) desc="Close window" ;;
                exit) desc="Quit Hyprland" ;;
                fullscreen) desc="Fullscreen (monocle)" ;;
                workspace)
                    case "$args" in
                        previous) desc="Previous workspace" ;;
                        e+*|e-*) desc="Scroll workspaces" ;;
                        *) desc="Workspace $args" ;;
                    esac
                    ;;
                movetoworkspace) desc="Move to workspace $args" ;;
                focusmonitor) desc="Focus monitor" ;;
                movewindow) desc="Move window to monitor" ;;
                layoutmsg)
                    case "$args" in
                        cyclenext) desc="Focus next" ;;
                        cycleprev) desc="Focus prev" ;;
                        swapnext) desc="Swap next" ;;
                        swapprev) desc="Swap prev" ;;
                        *swapwithmaster*) desc="Swap with master" ;;
                        *mfact\ -*) desc="Shrink master" ;;
                        *mfact\ +*) desc="Grow master" ;;
                        *orientationcycle*) desc="Toggle portrait / landscape" ;;
                        *orientationleft*) desc="Tiled layout" ;;
                        *) desc="$args" ;;
                    esac
                    ;;
                hidespecialworkspace) desc="" ;;
                dpms) desc="" ;;
                *) desc="$dispatcher $args" ;;
            esac
        fi

        [[ -z "$desc" ]] && continue
        printf "%-27s ·  %s\n" "$combo" "$desc"

    done < "$CONF"
}

generate | wofi --dmenu --prompt "Keybinds" --width 500 --height 650 --cache-file /dev/null --insensitive
