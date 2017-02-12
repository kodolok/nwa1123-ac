#!/bin/sh 

if [ $# -gt 0 ];then 
exec 0<$1; 
fi 

LOOP_CTRL=""

print_vap()
{
#echo "----------ath"$LOOP_COUNT"-------------------"
#echo "Wireless Mode  : "$WMODE
#echo "Frequency      : "$FREQ
#echo "Channel        : "$CHANNEL
#echo "Retry Counts   : "$RETRY
#echo "Total Retries  : "$TOTAL_RETRY
#echo "------------------------------------"
echo "${VAP_NAME},${SSID},${FREQ}"
}

while read line 
do 

FOUND_NEW_VAP=`echo $line|grep ath`
FOUND_NEW_VAP_FREQ=`echo $line|grep Frequency`
if [ "$FOUND_NEW_VAP" ] && [ "$LOOP_CTRL" = "" ]; then

    # We only grep VAP name & SSID from the athX device
    VAP_NAME=`echo "$line"|awk '{print $1}'`
    SSID=`echo "$line"|sed 's/^.*ESSID://'|awk '{print substr($0,2,length($0)-2)}'`

    LOOP_CTRL="a"

elif [ "$FOUND_NEW_VAP_FREQ" ] && [ "$LOOP_CTRL" = "a" ]; then

    # We only grep VAP name & SSID from the athX device
    FREQ=`echo "$FOUND_NEW_VAP_FREQ"|cut -d ':' -f 3 |cut -c -1`

    LOOP_CTRL="ab"
    print_vap

elif [ "$LOOP_CTRL" = "ab" ]; then

    VAP_NAME=""
    SSID=""
    FREQ=""
    LOOP_CTRL=""

fi

# END OF LOOP
done;

#print the last one VAP if needed
if [ "$LOOP_CTRL" = "ab" ]
then
    print_vap
fi