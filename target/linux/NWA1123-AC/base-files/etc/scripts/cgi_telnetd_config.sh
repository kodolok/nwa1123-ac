#!/bin/sh
#########################################################################
##  Telnetd Conf.
##  Usage:
##  sh cgi_telnetd_config.sh <default>
##  By mike.hc.chen
#########################################################################

if [ "$1" = "restart" ]; then
    status=`cfg -v MGMT_TELNET_ACCESS`

    [ "$status" = "0" ] && exit 1
fi

FACTORY_DEFAULT=0

if [ $1 ] && [ $1 = default ]
then
  FACTORY_DEFAULT=1
else
  MGMT_TELNET_PORT=`cfg -v MGMT_TELNET_PORT`
#  . /etc/ath/apcfg
# use cfg -v instead of . /etc/ath/apcfg to get a great efficient improvement
fi

##
# kill running telnetd
##
#    killall -q telnetd
TELNET_PID=`ps|grep "\/usr\/sbin\/telnetd"|awk '{print $1}'`
USE_PORT=`ps|grep "\/usr\/sbin\/telnetd"|grep "\-p"|sed 's/^.*-p //g'|awk '{print $1}'`
if [ -n "$TELNET_PID" ]
then
    if [ -z "$USE_PORT" ]
    then
        USE_PORT=23
    fi
fi
DONT_KILL=0
##
# restart telnetd
##
    if [ -f /usr/sbin/telnetd ]
    then
        if [ $FACTORY_DEFAULT -eq 1 ]
        then
            if [ -n "$TELNET_PID" ]
            then
                if [ $USE_PORT -eq 23 ]
                then
                    ## port already in use
                    DONT_KILL=1
                else
                    /usr/sbin/telnetd -l /etc/telnetd.script
                fi
            else
                DONT_KILL=1
                /usr/sbin/telnetd -l /etc/telnetd.script
            fi      
        elif [ $MGMT_TELNET_PORT ]
        then
            if [ -n "$TELNET_PID" ]
            then
                if [ "$MGMT_TELNET_PORT" = "$USE_PORT" ]
                then
                    ## port already in use
                    DONT_KILL=1
                else
                    /usr/sbin/telnetd -l /etc/telnetd.script -p $MGMT_TELNET_PORT
                fi
            else
                DONT_KILL=1
                /usr/sbin/telnetd -l /etc/telnetd.script -p $MGMT_TELNET_PORT
            fi
        else
            if [ -n "$TELNET_PID" ]
            then
                if [ $USE_PORT -eq 23 ]
                then
                    ## port already in use
                    DONT_KILL=1
                else
                    /usr/sbin/telnetd -l /etc/telnetd.script
                fi
            else
                DONT_KILL=1
                /usr/sbin/telnetd -l /etc/telnetd.script
            fi
        fi
    fi
##
# set ACL rules
##
    sh /etc/scripts/acl_setrule
if [ $DONT_KILL -eq 0 ]
then
    kill $TELNET_PID
fi
exit 0
