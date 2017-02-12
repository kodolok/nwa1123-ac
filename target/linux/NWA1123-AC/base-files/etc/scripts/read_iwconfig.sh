#!/bin/sh 

#if [ $# -gt 0 ];then 
#exec 0<$1; 
#fi 

LOOP_COUNT=0
RETRY=""
#WMODE=""
#FREQ=""
#CHANNEL=""
TOTAL_RETRY=""

FOUND_RETRY=0
#FOUND_FREQ=0
#FOUND_WMODE=0

print_vap()
{
#echo "----------ath"$LOOP_COUNT"-------------------"
#echo "Wireless Mode  : "$WMODE
#echo "Frequency      : "$FREQ
#echo "Channel        : "$CHANNEL
#echo "Retry Counts   : "$RETRY
#echo "Total Retries  : "$TOTAL_RETRY
#echo "------------------------------------"
#echo "\"WMODE\":\""$WMODE"\","
#echo "\"CHANNEL\":\""$CHANNEL"\","
echo "\"RETRY\":\""$TOTAL_RETRY"\","
}


while read line 
do 

FOUND_NEW_VAP=`echo $line|grep ath`
if [ "$FOUND_NEW_VAP" ]
then
    VAP_NAME=`echo $line|grep ath|awk '{print $1}'`
	# ex: ath3
    if [ "$1" = "WLAN1" ]
    then
		if [ "$VAP_NAME" = "ath0" ] || [ "$VAP_NAME" = "ath1" ] || [ "$VAP_NAME" = "ath2" ] || [ "$VAP_NAME" = "ath3" ] || [ "$VAP_NAME" = "ath4" ] || [ "$VAP_NAME" = "ath5" ] || [ "$VAP_NAME" = "ath6" ] || [ "$VAP_NAME" = "ath7" ]
		then
		    CHECK_THIS_VAP=1
		else
		    CHECK_THIS_VAP=0
		fi
	elif [ "$1" = "WLAN2" ]
	then
		if [ "$VAP_NAME" = "ath8" ] || [ "$VAP_NAME" = "ath9" ] || [ "$VAP_NAME" = "ath10" ] || [ "$VAP_NAME" = "ath11" ] || [ "$VAP_NAME" = "ath12" ] || [ "$VAP_NAME" = "ath13" ] || [ "$VAP_NAME" = "ath14" ] || [ "$VAP_NAME" = "ath15" ]
		then
		    CHECK_THIS_VAP=1
		else
		    CHECK_THIS_VAP=0
		fi
	else
	    exit 1;
	fi
	
    #Output the last VAP information
    if [ $LOOP_COUNT -gt 0 ] && [ $CHECK_THIS_VAP -eq 1 ]
    then
        #If we have got at least one AP info
        #print_vap

        #reset the found flag of AP info 
        FOUND_RETRY=0
        # We only grep Frequency & Wireless Mode from the first athX device
        #FOUND_FREQ=0
        #FOUND_WMODE=0
    fi
    #End of Output the last VAP

LOOP_COUNT=$(($LOOP_COUNT+1))

fi

if [ $FOUND_RETRY -eq 0 ] && [ $CHECK_THIS_VAP -eq 1 ]
then
    RETRY=`echo $line|grep retries|cut -d ':' -f 2|cut -d ' ' -f 1`
    if [ "$RETRY" ]
    then
        FOUND_RETRY=1
        TOTAL_RETRY=$((${TOTAL_RETRY}+${RETRY}))
    fi
fi

# END OF LOOP
done;

#print the last one VAP if needed
if [ $LOOP_COUNT -gt 0 ]
then
    print_vap
fi

exit 0