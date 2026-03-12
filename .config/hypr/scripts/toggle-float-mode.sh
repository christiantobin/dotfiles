#!/bin/bash
# Toggle workspace between float mode and tiled mode (dwm-style)
# Remembers floating window positions/sizes per workspace
# Auto-detects portrait monitors for correct tiling orientation
# New windows in float mode open small and centered via IPC listener

CACHE_DIR="/tmp/hypr-float-cache"
STATE_DIR="$CACHE_DIR/state"
LISTENER_PID_FILE="$CACHE_DIR/listener.pid"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
mkdir -p "$CACHE_DIR" "$STATE_DIR"

# Get active workspace ID
WORKSPACE=$(hyprctl activeworkspace | awk '/^workspace ID/{print $3}')
CACHE_FILE="$CACHE_DIR/ws-$WORKSPACE"
STATE_FILE="$STATE_DIR/ws-$WORKSPACE"

# --- Listener management ---
start_listener() {
    if [ -f "$LISTENER_PID_FILE" ] && kill -0 "$(cat "$LISTENER_PID_FILE")" 2>/dev/null; then
        return
    fi
    python3 "$SCRIPT_DIR/float-mode-listener.py" &
    echo $! > "$LISTENER_PID_FILE"
    disown
}

stop_listener() {
    if [ -f "$LISTENER_PID_FILE" ]; then
        kill "$(cat "$LISTENER_PID_FILE")" 2>/dev/null
        rm -f "$LISTENER_PID_FILE"
    fi
}

ensure_listener() {
    if ls "$STATE_DIR"/ws-* &>/dev/null; then
        start_listener
    else
        stop_listener
    fi
}

# --- Parse windows on current workspace ---
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
if [[ "$on_ws" == 2 ]]; then
    WINDOWS+=("$addr")
    WIN_AT[$addr]="$w_at"
    WIN_SIZE[$addr]="$w_size"
fi

# --- Toggle ---
# Empty workspace: toggle state only
if [ "$TOTAL" -eq 0 ]; then
    if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"

    else
        touch "$STATE_FILE"
        fi
    ensure_listener
    exit 0
fi

if [ "$FLOATING_COUNT" -gt $(( TOTAL / 2 )) ]; then
    # --- Switch to tiled ---
    rm -f "$STATE_FILE"

    # Save float positions/sizes
    > "$CACHE_FILE"
    for addr in "${WINDOWS[@]}"; do
        echo "$addr ${WIN_AT[$addr]} ${WIN_SIZE[$addr]}" >> "$CACHE_FILE"
    done

    for addr in "${WINDOWS[@]}"; do
        hyprctl dispatch settiled "address:0x$addr"
    done

    hyprctl keyword workspace "$WORKSPACE,defaultFloat:0"

    # Auto-detect orientation
    read -r WIDTH HEIGHT < <(hyprctl monitors | awk '/focused: yes/{found=1} found && /\tx/{gsub(/[^0-9x]/,""); split($0,a,"x"); print a[1], a[2]; exit}')
    if [ -n "$HEIGHT" ] && [ -n "$WIDTH" ] && [ "$HEIGHT" -gt "$WIDTH" ]; then
        hyprctl dispatch layoutmsg orientationtop
    else
        hyprctl dispatch layoutmsg orientationleft
    fi
else
    # --- Switch to float ---
    touch "$STATE_FILE"

    # Restore saved positions if available
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

ensure_listener
