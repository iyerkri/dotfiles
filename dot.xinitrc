#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

#Following automatically switches output if external monitor is connected.
xrandr | grep VGA1 | grep " connected"
if [ $? -eq 0 ]; then
    xrandr --output LVDS1 --off --output VGA1 --auto
    # If laptop is in the base, then start the music player daemon
    #mpdscribble
    #mpd /home/kris/.mpd/config
    # Alternative command in case of trouble:
    # (sleep 2; xrandr --auto) &
fi
xset -b
xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -cursor_name left_ptr
xbacklight =40
feh --bg-scale '/home/kris/art/wallpapers/wallpaper.png'
# while true; 
# do
# battery="BAT=$(acpi -b | sed -e 's/.*, \(.*%\).*/\1/') | ";
# clock="$(date +"%a %b %d %H:%M")";
# xsetroot -name "${battery}${clock}";
# sleep 37;
# done &
# exec /home/kris/dwm/dwm-072c62ed10f2/dwm
exec /usr/bin/xmonad
# exec /usr/bin/gnome-session
# exec /usr/bin/openbox-session
# exec /usr/bin/subtle
