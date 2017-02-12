#!/bin/sh
#########################################################################
##  cgi_lldpd.sh
##  Usage:
##  Create lldpd daemon
##  Tony.Kuo
#########################################################################

VERSION=`/root/bin/version`

##
# kill running lldpd
##
    killall -q lldpd

##
# restart lldpd
##
    if [ -f /sbin/lldpd ]
    then
            /sbin/lldpd -L /sbin/lldpcli -S $VERSION
    fi
exit 0
