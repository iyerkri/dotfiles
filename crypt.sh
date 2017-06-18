#!/bin/bash

gpg2 -d --for-your-eyes-only -q --no-tty --batch --passphrase-file /home/kriyer/linux/dotfiles/pp $1
