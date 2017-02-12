#!/bin/sh

#LINE_NUM=0
RETURN=0
GOT_START_BRACE=""
GOT_END_BRACE=""

#cat iwconfig.log | sh read_iwconfig.sh >> /tmp/temp.$$
#cat dev.log | sh read_dev.sh >> /tmp/temp.$$

#catch current frequency
TMPW1_STR=`iwlist ath0 channel 2> /dev/null | grep 'Current Frequency'`
TMPW2_STR=`iwlist ath8 channel 2> /dev/null | grep 'Current Frequency'`

ACTSTAT=`cfg -v STAT_INTVL_ACTION`


#This function will print like> "DESCRIPTION": "WLAN1", "WMODE": "802.11b/g/n",
printWLAN()
{

if [ "$1" = "WLAN1" ]
then
    WLAN_ENABLE=`cfg -v WLAN_UP_1`
    CHMODE_STR=`cfg -v AP_CHMODE_1`
    N_STATE=`cfg -v PUREN_1`
    START_MODE=`cfg -v AP_STARTMODE_1`
    CHANNEL=`expr "$TMPW1_STR" : '.*Channel \(.*\))'`
elif [ "$1" = "WLAN2" ]
then
    WLAN_ENABLE=`cfg -v WLAN_UP_2`
    CHMODE_STR=`cfg -v AP_CHMODE_2`
    N_STATE=`cfg -v PUREN_2`
    START_MODE=`cfg -v AP_STARTMODE_2`
    CHANNEL=`expr "$TMPW2_STR" : '.*Channel \(.*\))'`
else
    exit 1
fi

if [ "${WLAN_ENABLE}" = "" ] || [ "${WLAN_ENABLE}" = "0" ]
then
#    echo -n "\"WMODE\":\"n/a\","
#    echo -n "\"CHANNEL\":\"n/a\","
#    echo -n "\"RETRY\":\"n/a\","
#    echo -n "\"RX\":\"n/a\","
#    echo -n "\"TX\":\"n/a\","
#    echo -n "\"FCS\":\"n/a\"}"
#    exit 1;
     return
fi

# output the AP info of each VAP to a temp file
#iwconfig 2>/dev/null | read_iwconfig.sh $1>> /tmp/temp.$$
#cat /proc/net/dev | read_dev.sh $1>> /tmp/temp.$$


echo -n "\"DESCRIPTION\":\""$1"\",\"CHANNEL\":\""$CHANNEL"\","

# if Wifi device is in client mode, get the 802.11 mode from iwconfig
if [ "${START_MODE}" = "client" ]
then
    if [ "$1" = "WLAN1" ]
    then
        CLIENT_MODE=`iwconfig 2>/dev/null | grep 'ath0'|awk '{print $3}'`
    elif [ "$1" = "WLAN2" ]
    then
        CLIENT_MODE=`iwconfig 2>/dev/null | grep 'ath8'|awk '{print $3}'`
    fi

    if [ "${CLIENT_MODE}" = "802.11na" ]
    then
        echo -n "\"WMODE\":\"802.11a/n\","
    elif [ "${CLIENT_MODE}" = "802.11ng" ]
    then
        echo -n "\"WMODE\":\"802.11b/g/n\","
    elif [ "${CLIENT_MODE}" = "802.11g" ]
    then
        echo -n "\"WMODE\":\"802.11b/g\","
    else
        echo -n "\"WMODE\":\"${CLIENT_MODE}\","
    fi
else
    if [ "${CHMODE_STR}" = "11G" ]
    then
        echo -n "\"WMODE\":\"802.11b/g\","   
    elif [ "${CHMODE_STR}" = "11A" ]
    then
        echo -n "\"WMODE\":\"802.11a\","        
    elif [ "${CHMODE_STR}" = "11NGHT" ]
    then
        if [ "${N_STATE}" = "1" ]
        then
            echo -n "\"WMODE\":\"802.11n\","
           
        else
            echo -n "\"WMODE\":\"802.11b/g/n\","
        fi
    elif [ "${CHMODE_STR}" = "11NAHT" ]
    then
        if [ "${N_STATE}" = "1" ]
        then
            echo -n "\"WMODE\":\"802.11n\","

        else
            echo -n "\"WMODE\":\"802.11a/n\","
        fi
    elif [ "${CHMODE_STR}" = "11ACVHT" ]
    then
        echo -n "\"WMODE\":\"802.11a/n/ac\","
    fi
fi

#echo -n "}"
}

###############################################
#  Main Routine Start Here
###############################################

#Print WLAN1 statistics
echo -n "[{"

WLAN1_ENABLE=`cfg -v WLAN_UP_1`
if [ "${WLAN1_ENABLE}" = "1" ]
then

    # "DESCRIPTION":"WLAN1", "WMODE":"802.11b/g/n",
    printWLAN WLAN1
    # "RETRY":"10",
    # iwconfig 2>/dev/null | read_iwconfig.sh WLAN1>> /tmp/temp.$$
    WLAN1_RETRIES="0"
    WLAN1_FCS="`athstats -i wifi0 -r | grep FCS | awk '{print $1}'`"
    if [ "$START_MODE" = "mbssid" ] || [ "$START_MODE" = "root-mbssid" ]; then
        WLAN1_RETRIES=`apstats -i wifi0 -r | grep failures | cut -d "=" -f2`
    fi
    if [ "x${WLAN1_RETRIES}" = "x" ]; then
        echo -n "\"RETRY\":\"0\","
    else
        echo -n "\"RETRY\":\""$WLAN1_RETRIES"\","
    fi
    if [ "x${WLAN1_FCS}" = "x" ]; then
        echo -n "\"FCS\":\"0\","
    else
        echo -n "\"FCS\":\""$WLAN1_FCS"\","
    fi

    # "RX":"500","TX":"600","FCS":"3"
    cat /proc/net/dev | read_dev.sh WLAN1 web >> /tmp/temp.$$
    # process each line in temp file
    while read line
    do
    #   LINE_NUM=$(($LINE_NUM+1))
    #   echo "got #"$LINE_NUM" : "$line
        echo -n $line
    done < /tmp/temp.$$
fi

#Print WLAN2 statistics

WLAN2_ENABLE=`cfg -v WLAN_UP_2`
if [ "${WLAN2_ENABLE}" = "1" ]
then
    if [ "${WLAN1_ENABLE}" = "1" ]
    then
        echo -n "},{"
    fi
    
    printWLAN WLAN2
    WLAN2_RETRIES="0"
    WLAN2_FCS="0"
    WLAN2_RXPKTS="0"
    WLAN2_TXPKTS="0"
    
    if [ "$START_MODE" = "mbssid" ] || [ "$START_MODE" = "root-mbssid" ]; then
        WLAN2_RXPKTS=`apstats -i wifi1 -r | grep 'Rx Mgmt' | cut -d "=" -f2`
        WLAN2_TXPKTS=`apstats -i wifi1 -r | grep 'Tx Mgmt' | cut -d "=" -f2`
        WLAN2_RETRIES=`apstats -i wifi1 -r | grep failures | cut -d "=" -f2`
        #WLAN2_FCS=`apstats -i wifi1 -r | grep CRC | cut -d "=" -f2`
		if [ "x$WLAN2_RXPKTS" = "x0" ] || [ "x$WLAN2_RXPKTS" = "x" ]; then
			WLAN2_RXPKTS=`athstats -i wifi1 -r | grep 'ast_rx_packets' | awk '{print $3}'`
			WLAN2_TXPKTS=`athstats -i wifi1 -r | grep 'ast_tx_packets' | awk '{print $3}'`
		fi
    else    
        WLAN2_RXPKTS=`athstats -i wifi1 -r | grep 'ast_rx_packets' | awk '{print $3}'`
        WLAN2_TXPKTS=`athstats -i wifi1 -r | grep 'ast_tx_packets' | awk '{print $3}'`
    fi

    if [ "x${WLAN2_RXPKTS}" = "x" ]; then
        echo -n "\"RX\":\"0\","
    else
        echo -n "\"RX\":\""$WLAN2_RXPKTS"\","
    fi
    if [ "x${WLAN2_TXPKTS}" = "x" ]; then
        echo -n "\"TX\":\"0\","
    else
        echo -n "\"TX\":\""$WLAN2_TXPKTS"\","
    fi
    if [ "x${WLAN2_RETRIES}" = "x" ]; then
        echo -n "\"RETRY\":\"0\","
    else
        echo -n "\"RETRY\":\""$WLAN2_RETRIES"\","
    fi
    echo -n "\"FCS\":\""$WLAN2_FCS"\""

    #printWLAN WLAN2
    #iwconfig 2>/dev/null | read_iwconfig.sh WLAN2> /tmp/temp.$$
    #cat /proc/net/dev | read_dev.sh WLAN2>> /tmp/temp.$$
    # process each line in temp file
    #while read line
    #do
    #    LINE_NUM=$(($LINE_NUM+1))
    #    echo "got #"$LINE_NUM" : "$line
    #     echo -n $line
    #done < /tmp/temp.$$
fi

echo -n "}]"

rm -f /tmp/temp.$$
