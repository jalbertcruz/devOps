#!/usr/bin/env bash 

#xrandr --output eDP-1 --auto
#xrandr --output HDMI-1 --auto

#xrandr --output eDP-1 --off &
#setxkbmap -layout us &

xrandr --output HDMI-1 --primary --mode 3440x1440 --output eDP-1 --off
/usr/local/bin/appslnx/tools/linux/Flameshot.AppImage &
xscreensaver --no-splash &
mpd &
dunst &
/usr/local/bin/appslnx/tools/edition/LogseqDB/bin/logseq &

# este es el que estaba activo
#/usr/local/bin/emacs --daemon # &

#/usr/local/bin/emacs --daemon=emacsd # &
#/usr/local/bin/appslnx/tools/emacs/start-all-daemons.sh

