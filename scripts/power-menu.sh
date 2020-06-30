#!/usr/bin/env bash

options="  lock
    logout
    sleep
    hibernate
    reboot
    shutdown"
themes_dir=$HOME/dotfiles/rofi
theme=${1:-$themes_dir/onoff.rasi}
#selection=$(echo -e "${options}" | rofi -dmenu -config $theme -columns 6 -lines 1 -width 1500)

chosen=$(echo -e " lock\n logout\n sleep\n hibernate\n reboot\n shutdown" | rofi -dmenu -config $theme -columns 6 -lines 1 -width 1500)

echo "This is your selection: $chosen"

if [[ $chosen = " lock" ]]; then
	/usr/bin/i3lock-fancy-multimonitor -n -p
elif [[ $chosen = " logout" ]]; then
	/usr/bin/i3-msg exit
  echo "exit i3"
elif [[ $chosen = " sleep" ]]; then
  /usr/bin/i3lock-fancy-multimonitor -n -p && /usr/bin/systemctl suspend
elif [[ $chosen = " hibernate" ]]; then
  /usr/bin/i3lock-fancy-multimonitor -n -p && /usr/bin/systemctl hibernate
elif [[ $chosen = " reboot" ]]; then
  /usr/bin/reboot
elif [[ $chosen = " shutdown" ]]; then
  /usr/bin/poweroff -i
fi

#case "${selection}" in
#    	"      lock")
#        	i3lock-fancy-multimonitor -n -p
#		;;
#    	"       logout")
#        	i3-msg exit
#		;;
#    	"        sleep")
#        	i3lock-fancy-multimonitor -n -p && systemctl suspend
#		;;
#    	"   hibernate")
#        	i3lock-fancy-multimonitor -n -p && systemctl hibernate
#		;;
#    	"      reboot")
#        	reboot
#		;;
#    	"      shutdown")
#        	poweroff -i
#		;;
#esac
