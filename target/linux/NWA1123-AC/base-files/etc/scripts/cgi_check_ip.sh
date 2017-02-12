#!/bin/sh

####################################################
#
#  cgi_check_ip.sh
#  
#  The Shell Script for checking valid IPv4 ip
#
#  1 Oct 2012
#
####################################################

# Usage: cgi_check_ip.sh [ipv4addr]

ECHO="echo"

ERR_VALID=0
ERR_INVALID=1
ERR_LOOPBACK=2
ERR_BROADCAST=3
ERR_RESERVED=4
ERR_MULTICAST=5
ERR_CLASSE=6
ERR_NOARG=10

if [ "$1" ] && [ ! "$2" ]
then

    VALID_IP_FORMAT=`echo $1 | egrep "^((([2][5][0-5]|([2][0-4]|[1][0-9]|[0-9])?[0-9])\.){3})([2][5][0-5]|([2][0-4]|[1][0-9]|[0-9])?[0-9])$"`
    #INVALID_IP=`sipcalc $1|grep 'ERR'`

    if [ ! "$VALID_IP_FORMAT" ]
    then
        $ECHO "Invalid IP. Return ${ERR_INVALID}"
        exit ${ERR_INVALID}
    fi

    IP_1=`echo $1|cut -d '.' -f 1`
    IP_2=`echo $1|cut -d '.' -f 2`
    IP_3=`echo $1|cut -d '.' -f 3`
    IP_4=`echo $1|cut -d '.' -f 4`

    if [ "$IP_1" -eq 127 ]
    then
        $ECHO "Loopback IP. Return ${ERR_LOOPBACK}"
        exit ${ERR_LOOPBACK}
    fi

    if [ "$IP_1" -eq 255 ] && [ "$IP_2" -eq 255 ] && [ "$IP_3" -eq 255 ] && [ "$IP_4" -eq 255 ] 
    then
        $ECHO "Boardcast IP. Return ${ERR_BROADCAST}"
        exit ${ERR_BROADCAST}
    fi

    if [ "$IP_1" -eq 0 ] && [ "$IP_2" -eq 0 ] && [ "$IP_3" -eq 0 ] && [ "$IP_4" -eq 0 ]
    then
        $ECHO "Reserved IP. Return ${ERR_RESERVED}"
        exit ${ERR_RESERVED}
    fi

    if [ "$IP_1" -ge 224 ] && [ "$IP_1" -le 239 ]
    then
        $ECHO "Multicast IP. Return ${ERR_MULTICAST}"
        exit ${ERR_MULTICAST}
    fi

    if [ "$IP_1" -ge 240 ] && [ "$IP_1" -le 255 ]
    then
        $ECHO "Class E IP. Return ${ERR_CLASSE}"
        exit ${ERR_CLASSE}
    fi

    $ECHO "Valid IP. Return ${ERR_VALID}"
    exit ${ERR_VALID}

else
    echo "Usage: $0 [X.X.X.X]"
    echo "X: 0~255"
    exit ${ERR_NOARG}
fi
