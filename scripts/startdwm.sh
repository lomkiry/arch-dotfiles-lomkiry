#!/bin/sh
feh --bg-scale ~/wm/dwm/wallpeper.png
setxkbmap -layout us,ru -option grp:alt_shift_toggle &
slstatus &

while true; do

  dwm 2> ~/.dwm.log

done
