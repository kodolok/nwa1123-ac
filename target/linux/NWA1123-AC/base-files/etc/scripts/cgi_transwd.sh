#!/bin/sh
#########################################################################
##  cgi_transwd.sh
##  Usage:
##  excute transwd
##  Tony.Kuo
#########################################################################

##
# start transwd
##
    if [ -f /sbin/transwd ]
    then
            /sbin/transwd $1
    fi
exit 0
