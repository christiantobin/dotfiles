#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start Hyprland on TTY1 (skip if booted to multi-user.target / CLI mode)
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && [ ! -e /tmp/.hyprland-started ] && ! grep -q 'systemd.unit=multi-user.target' /proc/cmdline; then
    touch /tmp/.hyprland-started
    exec start-hyprland
fi
