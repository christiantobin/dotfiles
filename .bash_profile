#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start Hyprland on TTY1 (skip if booted to multi-user.target / CLI mode)
# NOTE: must `exec` — Hyprland has to replace this shell and own the tty1/seat so it
# can take input devices. Launching it as a child (no exec) renders but freezes input
# (gray screen, dead cursor). Do not remove the exec.
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && [ ! -e /tmp/.hyprland-started ] && ! grep -q 'systemd.unit=multi-user.target' /proc/cmdline; then
    touch /tmp/.hyprland-started
    exec start-hyprland
fi
