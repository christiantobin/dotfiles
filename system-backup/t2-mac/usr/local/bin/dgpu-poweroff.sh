#!/bin/sh
# MacBookPro16,1: power off the unused AMD dGPU via vga_switcheroo to free the
# thermal/power budget. Runs at Hyprland start AND after resume (t2-resume drop-in).
# Match the discrete-GPU line by any index (switcheroo index is not stable; the
# 'DIS:' colon excludes the 'DIS-Audio' line).
SW=/sys/kernel/debug/vgaswitcheroo/switch
for i in 1 2 3 4 5 6 7 8; do
    if grep -qE '^[0-9]+:DIS:' "$SW" 2>/dev/null; then
        echo OFF > "$SW" && exit 0
    fi
    sleep 1
done
exit 1
