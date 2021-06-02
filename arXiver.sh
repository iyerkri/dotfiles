#!/bin/bash

ARXIV_RAND_NAME=`uuidgen`
mkdir -p $ARXIV_RAND_NAME
shopt -s nullglob
for i in *.{tex,bib,bbl,sty}; do
    cp "$i" "$ARXIV_RAND_NAME"/"$i"
done
for i in {images,plots}/*; do
    grep "$i" *.tex
    EXISTS=$?
    if [ $EXISTS -eq 0 ]; then
	cp --parents "$i" "$ARXIV_RAND_NAME"
    fi
done
shopt -u nullglob
tar cvfz "$ARXIV_RAND_NAME".tar.gz "$ARXIV_RAND_NAME"

