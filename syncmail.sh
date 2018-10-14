#!/bin/bash

TRASH=/home/kriyer/mail/cornell/Trash/cur
MOVER=/home/kriyer/linux/dotfiles/mail-mover.py

nc -vz www.google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    msmtp-queue -r > /dev/null 2>&1
    mbsync -q cornell-channel && notmuch new > /dev/null 2>&1
    notmuch search --format=text0 --output=files 'tag:deleted and not (folder:"cornell/Trash" or folder:"cornell/Deleted Items")' | xargs -0 -I {} --no-run-if-empty python $MOVER {} $TRASH
else
    echo "no connectivity"
fi  
