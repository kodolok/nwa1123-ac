#!/bin/sh

####################################################
#
#  cgi_check_mac.sh
#  
#  The Shell Script for checking valid MAC
#
#  1 Oct 2012
#
####################################################

# Usage: cgi_check_mac.sh [MAC]

ECHO="echo"

ERR_VALID=0
ERR_INVALID=1
ERR_BROADCAST=3
ERR_RESERVED=4
ERR_MULTICAST=5
ERR_NOARG=10

if [ "$1" ] && [ ! "$2" ]
then
    VALID_MAC=`echo $1|egrep "^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$"`

    if [ ! "$VALID_MAC" ]
    then
        $ECHO "Invalid MAC. Return ${ERR_INVALID}"
        exit ${ERR_INVALID}
    fi

    BOARDCAST_MAC=`echo $1|egrep "^([fF]{2}:){5}[fF]{2}$"`

    if [ "$BOARDCAST_MAC" ] 
    then
        $ECHO "Boardcast MAC. Return ${ERR_BROADCAST}"
        exit ${ERR_BROADCAST}
    fi

    RESERVED_MAC=`echo $1|egrep "^([0]{2}:){5}[0]{2}$"`

    if [ "$RESERVED_MAC" ]
    then
        $ECHO "Reserved MAC. Return ${ERR_RESERVED}"
        exit ${ERR_RESERVED}
    fi

    MULTICAST_MAC=`echo $1|egrep "^[0-9a-fA-F][13579bBdDfF]:"`
    
    if [ "$MULTICAST_MAC" ]
    then
        $ECHO "Multicast MAC. Return ${ERR_MULTICAST}"
        exit ${ERR_MULTICAST}
    fi

    $ECHO "Valid MAC. Return ${ERR_VALID}"
    exit ${ERR_VALID}

else
    echo "Usage: $0 [XX:XX:XX:XX:XX:XX]"
    echo "X: 0-9, a-f, A-F"
    exit ${ERR_NOARG}
fi
