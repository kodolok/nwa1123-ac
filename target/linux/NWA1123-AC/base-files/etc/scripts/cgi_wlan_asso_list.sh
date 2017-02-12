#!/bin/sh

STA_NUM=0
GOT_START_BRACE=""
GOT_END_BRACE=""
BANNER=""
ATHEROS_RSSI_MAX=60
RSSI_THRESHOLD=50


#get our config in /tmp/.apcfg
#TZ=`cfg -v TZ`
# export TZ to the sytem environment. If we don't do this, Shell may use different TZ setting.
#export TZ=$TZ

#cat iwconfig.log | sh get_vap_ssid.sh > /tmp/.iwconfig.log
#cat dev.log | sh read_dev.sh >> temp.$$

# output the AP info of each VAP to a temp file
iwconfig 2>/dev/null | sed 's/\\/\\\\\\\\/g' | get_vap_ssid.sh > /tmp/.iwconfig.log

#echo "Start to Procss Output of iwconfig"

echo -n "["

# process each line in iwconfig.log file
while read line
do

#     STA_NUM=$(($LINE_NUM+1))
#    echo "got #"$LINE_NUM" : "$line

     VAP_NAME=`echo "$line" | cut -d ',' -f 1`
     SSID=`echo "$line" | cut -d ',' -f 2 | sed -e 's/\\\\/\\\\x5c/g' \
		-e 's/\"/\\\\x22/g' -e 's/</\\\\x3c/g' -e 's/>/\\\\x3e/g'`
     FREQ=`echo "$line" | cut -d ',' -f 3`

     if [ ! "$VAP_NAME" ] || [ ! "$SSID" ] || [ ! "$FREQ" ]
     then
         #echo "Cannot get vap and ssid @ association_list.sh"
         continue
     fi

     wlanconfig ${VAP_NAME} list sta > /tmp/.${VAP_NAME}.wlanconfig.log

     BANNER=""
     ADDR=""
     RSSI=0
     SIGNALSTR=0

     while read str
     do
     
         BANNER=`echo $str | grep 'ADDR'`
         if [ "$BANNER" ]
         then
             continue
         fi

         ADDR=`echo $str | awk '{print $1}'`

         ASSOCIATION=`echo $str | awk '{print $3}'`

         RSSI=`echo $str | awk '{print $7}'`

         if [ $RSSI ]
         then
             if [ $RSSI -gt $RSSI_THRESHOLD ]
             then
                 SIGNALSTR=100
             elif [ $RSSI -gt 0 ]
             then
                 SIGNALSTR=$(($RSSI*100/$RSSI_THRESHOLD))
             fi
         fi

         if [ "$ADDR" ] && [ "$FREQ" ] && [ "$SSID" ] && [ "$ASSOCIATION" ] && [ "$SIGNALSTR" ]
         then
             STA_NUM=$(($STA_NUM+1))
             if [ $STA_NUM -gt 1 ]
             then
                 echo -n ","
             fi

             echo -n "{\"NUMBER\":\""$STA_NUM"\",\"ADDR\":\""$ADDR"\",\"FREQ\":\""$FREQ"\",\"SSID\":\""$SSID"\",\"ASSOCIATION\":\""$ASSOCIATION"\",\"SIGNALSTR\":\""$SIGNALSTR"%\"}"
         fi

     done < /tmp/.${VAP_NAME}.wlanconfig.log
     
     rm -f /tmp/.${VAP_NAME}.wlanconfig.log

done < /tmp/.iwconfig.log

echo -n "]"

rm -f /tmp/.iwconfig.log
