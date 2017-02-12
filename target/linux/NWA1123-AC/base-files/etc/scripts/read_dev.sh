#!/bin/sh 

#if [ $# -gt 0 ];then 
#exec 0<$1; 
#fi 

LOOP_COUNT=0
RX=""
TX=""
FCS=""
OUTPUT="$2"

FOUND_WIFI=0

print_wifi()
{
#echo "----------wifi"$LOOP_COUNT"-------------------"
#echo "Received Packets   : "$RX
#echo "Transmitted Packets: "$TX
#echo "FCS Error Frames   : "$FCS
#echo "------------------------------------"
echo "\"RX\":\""$RX"\","
if [ "x${OUTPUT}" = "xweb" ]; then
    echo "\"TX\":\""$TX"\""
else
    echo "\"TX\":\""$TX"\","
    echo "\"FCS\":\""$FCS"\""
fi
}


while read line 
do 

    if [ "$1" = "WLAN1" ]
    then
        FOUND_WIFI=`echo $line|grep wifi0`
	elif [ "$1" = "WLAN2" ]
	then
        FOUND_WIFI=`echo $line|grep wifi1`
    fi
	
if [ "$FOUND_WIFI" ]
then

    #Output the last WIFI information
    if [ $LOOP_COUNT -gt 0 ]
    then
        #If we have got at least one WIFI info
        print_wifi

        #reset the count of WIFI info
        RX=""
        TX=""
        FCS=""
    fi
    #End of Output the last VAP

    RX=`echo $line|grep wifi|awk '{print $3}'`
    FCS=`echo $line|grep wifi|awk '{print $7}'`
    TX=`echo $line|grep wifi|awk '{print $11}'`

    LOOP_COUNT=$(($LOOP_COUNT+1))

fi

done;

#print the last one VAP if needed
if [ $LOOP_COUNT -gt 0 ]
then
    print_wifi
fi

exit 0