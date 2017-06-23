#!/bin/bash
# store this in /usr/lib/systemd/system-sleep This file is run by
# systemd each time the system is put to sleep (with args pre suspend)
# and each time the system is resumed (with args post suspend). 

if [ $1 == pre ]
then
    systemctl stop mailsync.service
elif [ $1 == post ]
then
    systemctl restart mailsync.service     
else
    echo "unknown argument to sleep-resume mail script" 
fi
