#!/usr/bin/env bash 

#xrandr --output eDP-1 --auto
#xrandr --output HDMI-1 --auto

#xrandr --output eDP-1 --off &
#setxkbmap -layout us &

xrandr --output HDMI-1 --primary --mode 3440x1440 --output eDP-1 --off

/home/z/appslnx/tools/linux/Flameshot.AppImage &

xscreensaver --no-splash &

/usr/local/bin/appslnx/tools/edition/Logseq/Logseq &

