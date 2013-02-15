#!/bin/bash
# suspend-low-battery.sh
# Alert+suspend when battery gets low
# Run this script as a cron job at intervals of 5 mins
# Found on archlinux forums
# https://bbs.archlinux.org/viewtopic.php?pid=536813#p536813
# Modified to my taste -- kris
# Needs a notification handler to display the alerts - 
# - try dunst, a dmenu-ish notification system

# low battery in %
LOW_BATTERY="20"

# critical battery in % (execute action)
CRITICAL_BATTERY="7"

# acpi battery name
BAT="BAT0"

# SUSPEND COMMAND
SUSPEND="systemctl suspend"

# display icon
# ICON="/usr/share/icons/gnome/48x48/status/battery-low.png"

# notify sound
# PLAY="aplay /usr/local/bin/bears01.wav"

SYSFSBATDIR="/sys/class/power_supply/"$BAT
PRESENT=$SYSFSBATDIR"/present"
CHARGING=$(cat $SYSFSBATDIR"/status")
CAPACITY=$(cat $SYSFSBATDIR"/capacity")

if [ -e $PRESENT ]; then
    if [ "$CAPACITY" -lt "$LOW_BATTERY" ] && [ "$CHARGING" = "Discharging" ]; then
        DISPLAY=:0.0 notify-send -u critical -t 10000 "LOW BATTERY: $CAPACITY% REMAINING"
    fi	
    
    if [ "$CAPACITY" -lt "$CRITICAL_BATTERY" ] && [ "$CHARGING" = "Discharging" ]; then
	DISPLAY=:0.0 notify-send -u critical -t 60000 "VERY LOW BATTERY: $CAPACITY% REMAINING." "SYSTEM SUSPEND IN 1 MIN"
	sleep 60
	CHARGING=$(cat $SYSFSBATDIR"/status")
	if [ "$CHARGING" = "Discharging" ]; then
	    $SUSPEND
	fi
    fi
    
fi

