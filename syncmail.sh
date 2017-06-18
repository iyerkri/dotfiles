#!/bin/bash

nc -vz www.google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    msmtp-queue -r > /dev/null 2>&1
    mbsync -q cornell-channel && notmuch new > /dev/null 2>&1
else
    echo "no connectivity"
fi

    
