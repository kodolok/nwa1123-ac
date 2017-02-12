#!/bin/sh

for name in `ls ../*.html`; do 
    fname=`basename $name .html`
    if ! [ -L $fname ]; then
        ln -s /sbin/cgiMain $fname
    fi
done

ln -s /sbin/cgiMain config.cfg