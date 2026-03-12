#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start Hyprland on TTY1 (only if not returning from a session)
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && [ ! -e /tmp/.hyprland-started ]; then
    touch /tmp/.hyprland-started
    exec start-hyprland
fi
