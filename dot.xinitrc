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
    #mpd /home/kriyer/.mpd/config
    # Alternative command in case of trouble:
    # (sleep 2; xrandr --auto) &
fi
xset -b
xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -cursor_name left_ptr
xbacklight =40
files=(/home/kriyer/art/wallpapers/tiling-wallpapers/*)
feh --bg-tile `printf "%s\n" "${files[RANDOM % ${#files[@]}]}"`
#feh --bg-scale '/home/kriyer/art/wallpapers/wallpaper.png'
# while true; 
# do
# battery="BAT=$(acpi -b | sed -e 's/.*, \(.*%\).*/\1/') | ";
# clock="$(date +"%a %b %d %H:%M")";
# xsetroot -name "${battery}${clock}";
# sleep 37;
# done &
# exec /home/kriyer/dwm/dwm-072c62ed10f2/dwm
xmodmap ~/.Xmodmap
xrdb .Xresources
redshift -l 42:-76 &
compton --xrender-sync --xrender-sync-fence -i 0.85 -b
exec /usr/bin/i3
# exec /usr/bin/wmii
# exec /usr/bin/xmonad
# exec /usr/bin/gnome-session
# exec /usr/bin/openbox-session
# exec /usr/bin/subtle
