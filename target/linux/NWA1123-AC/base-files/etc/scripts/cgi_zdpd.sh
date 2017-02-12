#!/bin/sh
#########################################################################
##  cgi_zdpd.sh
##  Usage:
##  Create ZON daemon
##  Jeff.lin
#########################################################################

##
# kill running zdpd
##
    killall -q zdpd

##
# restart zdpd
##
    if [ -f /sbin/zdpd ]
    then
            /sbin/zdpd &
    fi
exit 0
