#!/bin/sh
picom &
slstatus &
/home/tobin/.screenlayout/default.sh
nitrogen --restore
dunst &
exec dwm
