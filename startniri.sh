#!/bin/sh
#
# Set environment variables for wayland

export XDG_CURRENT_DESKTOP=niri
export XDG_SESSION_DESKTOP="niri"
export XDG_SESSION_TYPE="wayland"
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1

export TERMINAL="foot"
export EDITOR="emacsclient -t -a emacs"
export VISUAL="emacsclient -c -a emacs"
export BROWSER="firefox"

exec niri-session
