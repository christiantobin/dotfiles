#!/bin/bash
# Toggle workspace between float mode and tiled mode (dwm-style)
# Remembers floating window positions/sizes per workspace
# Auto-detects portrait monitors for correct tiling orientation

CACHE_DIR="/tmp/hypr-float-cache"
mkdir -p "$CACHE_DIR"

# Get active workspace ID
WORKSPACE=$(hyprctl activeworkspace | awk '/^workspace ID/{print $3}')
CACHE_FILE="$CACHE_DIR/ws-$WORKSPACE"

# Parse all windows on this workspace: address, position, size, float state
declare -A WIN_AT WIN_SIZE
WINDOWS=()
FLOATING_COUNT=0
TOTAL=0

addr=""
on_ws=0
w_at=""
w_size=""

while IFS= read -r line; do
    if [[ "$line" =~ ^Window\ ([a-f0-9]+) ]]; then
        # Save previous window if it was on our workspace
        if [[ "$on_ws" == 2 ]]; then
            WINDOWS+=("$addr")
            WIN_AT[$addr]="$w_at"
            WIN_SIZE[$addr]="$w_size"
        fi
        addr="${BASH_REMATCH[1]}"
        on_ws=0; w_at=""; w_size=""
    elif [[ "$line" =~ at:\ (.+) ]]; then
        w_at="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ size:\ (.+) ]]; then
        w_size="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ workspace:\ $WORKSPACE\  ]]; then
        on_ws=1
    elif [[ "$line" =~ floating:\ ([01]) ]] && [[ "$on_ws" == 1 ]]; then
        (( TOTAL++ ))
        [[ "${BASH_REMATCH[1]}" == "1" ]] && (( FLOATING_COUNT++ ))
        on_ws=2
    fi
done < <(hyprctl clients)
# Don't forget the last window
if [[ "$on_ws" == 2 ]]; then
    WINDOWS+=("$addr")
    WIN_AT[$addr]="$w_at"
    WIN_SIZE[$addr]="$w_size"
fi

[ "$TOTAL" -eq 0 ] && exit 0

# If majority floating -> tile all, otherwise float all
if [ "$FLOATING_COUNT" -gt $(( TOTAL / 2 )) ]; then
    # Switching to tiled: save current float positions/sizes
    > "$CACHE_FILE"
    for addr in "${WINDOWS[@]}"; do
        echo "$addr ${WIN_AT[$addr]} ${WIN_SIZE[$addr]}" >> "$CACHE_FILE"
    done

    for addr in "${WINDOWS[@]}"; do
        hyprctl dispatch settiled "address:0x$addr"
    done

    # Set correct tiling orientation based on monitor aspect ratio
    read -r WIDTH HEIGHT < <(hyprctl monitors | awk '/focused: yes/{found=1} found && /\tx/{gsub(/[^0-9x]/,""); split($0,a,"x"); print a[1], a[2]; exit}')
    if [ -n "$HEIGHT" ] && [ -n "$WIDTH" ] && [ "$HEIGHT" -gt "$WIDTH" ]; then
        hyprctl dispatch layoutmsg orientationtop
    else
        hyprctl dispatch layoutmsg orientationleft
    fi
else
    # Switching to float: restore saved positions if available
    declare -A SAVED_AT SAVED_SIZE
    if [ -f "$CACHE_FILE" ]; then
        while read -r saddr sat ssize; do
            SAVED_AT[$saddr]="$sat"
            SAVED_SIZE[$saddr]="$ssize"
        done < "$CACHE_FILE"
    fi

    for addr in "${WINDOWS[@]}"; do
        hyprctl dispatch setfloating "address:0x$addr"
        if [[ -n "${SAVED_SIZE[$addr]}" ]]; then
            IFS=',' read -r w h <<< "${SAVED_SIZE[$addr]}"
            hyprctl dispatch resizewindowpixel "exact $w $h,address:0x$addr"
        fi
        if [[ -n "${SAVED_AT[$addr]}" ]]; then
            IFS=',' read -r x y <<< "${SAVED_AT[$addr]}"
            hyprctl dispatch movewindowpixel "exact $x $y,address:0x$addr"
        fi
    done
fi
