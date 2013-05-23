#!/bin/bash
# Best way to choose a random file in bash
# http://stackoverflow.com/questions/701505/best-way-to-choose-a-random-file-from-a-directory-in-a-shell-script
#
files=(/path/to/dir/*)
printf "%s\n" "${files[RANDOM % ${#files[@]}]}"
