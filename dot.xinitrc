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
xrandr | grep HDMI | grep " connected"
if [ $? -eq 0 ]; then
    xrandr --output eDP1 --off --output HDMI1 --auto --output HDMI2 --auto
    # If laptop is in the base, then start the music player daemon
    #mpdscribble
    #mpd /home/kriyer/.mpd/config
    # Alternative command in case of trouble:
    # (sleep 2; xrandr --auto) &
fi
xset -b
#xset +fp /usr/share/fonts/local
#xset fp rehash
xsetroot -cursor_name left_ptr
xbacklight =40
#files=(/home/kriyer/art/wallpapers/tiling-wallpapers/*)
files=(/home/kriyer/linux/wallpapers/tiles/best/*)
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
xrdb -merge .Xresources
redshift -l 45:-93 &
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t -a emacs -nw"
export VISUAL="emacsclient -c -a emacs"
export TERMINAL="urxvtc"
export XDG_MUSIC_DIR=~/Music
urxvtd -q -o -f 
# emacs --daemon
compton --xrender-sync --xrender-sync-fence -i 0.85 &
exec /usr/bin/i3
# exec /usr/bin/bspwm
# exec /usr/bin/wmii
# exec /usr/bin/xmonad
# exec /usr/bin/gnome-session
# exec /usr/bin/openbox-session
# exec /usr/bin/subtle
