#!/bin/sh

RADIO1_ESSID=`iwconfig ath0 | grep ESSID`
RADIO2_ESSID=`iwconfig ath8 | grep ESSID`

if [ "$RADIO1_ESSID" = "" -a "$RADIO2_ESSID" = "" ]; then
    echo "0"
else
    echo "1"
fi
