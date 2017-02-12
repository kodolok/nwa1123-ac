#!/bin/sh 
############################################
# This script need some input              #
# Ex: iwlist ath0 scanning|site_survey.sh  #
############################################

#if [ $# -gt 0 ];then 
#exec 0<$1; 
#fi 


LOOP_COUNT=0
SSID=""
FREQ=""
CHANNEL=""
ADDRESS=""
WMODE=""
QUALITY=""
SECURITY=""
CRYPTION=""
BITRATE=""
NSUPPORT=""
FOUND_SSID=0
FOUND_CHAN=0
FOUND_FREQ=0
#FOUND_5G_FREQ=0
FOUND_ADDR=0
FOUND_MODE=0
FOUND_QUAL=0
FOUND_SCUR=0
FOUND_CRYP=0
FOUND_WPA2=0
FOUND_WPA1=0
FOUND_11B_RATE=0
FOUND_11AG_RATE=0
FOUND_11N_RATE=0
FOUND_PROTOCOL=0

#echo -n "["

print_ap()
{
#echo "----------CELL "$LOOP_COUNT"-------------------"
#echo "SSID           : "$SSID
#echo "Frequency      : "$FREQ" GHz"
#echo "Channel        : "$CHANNEL
#echo "MAC Address    : "$ADDRESS
#echo "Wireless Mode  : 802.11"$WMODE
#echo "Singal Strength: "${QUALITY}%
#echo "Encryption     : "$CRYPTION
#echo "Security       : "$SECURITY
#echo "------------------------------------"
echo -n "{\"SSID\":\""$SSID"\",\"CHANNEL\":\""$CHANNEL"\",\"MAC\":\""$ADDRESS"\",\"MODE\":\"802.11"$WMODE"\",\"QUALITY\":\""$QUALITY"%\",\"SECURITY\":\""$SECURITY"\"}"
# echo "{\"SSID\":\""$SSID"\","
# echo "\"CHANNEL\":\""$CHANNEL"\","
# echo "\"MAC\":\""$ADDRESS"\","
# echo "\"MODE\":\"802.11"$WMODE"\","
# echo "\"QUALITY\":\""$QUALITY"%\","
# echo "\"SECURITY\":\""$SECURITY"\"}"
}

determine_wlan_mode()
{

if [ $FOUND_PROTOCOL -eq 1 ]
then
    
    case $IEEE_MODE in
    "802.11b")
        WMODE="b"
        ;;
    "802.11bg")
        WMODE="b/g"
        ;;
    "802.11g")
        WMODE="g"
        ;;
    "802.11ng")
        WMODE="b/g/n"
        ;;
    "802.11a")
        WMODE="a"
        ;;
    "802.11na")
        WMODE="a/n"
        ;;
    "802.11ac")
        WMODE="a/n/ac"
        ;;
    *)
        WMODE="Unknown"
        ;;
    esac
    
else
    WMODE="Unknown"
fi

}

while read line 
do 

SKIP_LINE=`echo $line|egrep 'Scan|Mode|bcn_int|wme_ie|Cipher|Unknown'`
if [ "$SKIP_LINE" ]
then
    continue
fi


FOUND_NEW_AP=`echo $line|grep Cell`
if [ "$FOUND_NEW_AP" ]
then

    #Output the last AP information except the first call of program

    if [ $LOOP_COUNT -gt 0 ]
    then

    #If we have got at least one AP info

#	if [ $FOUND_5G_FREQ -eq 0 ]
#	then
	
        determine_wlan_mode

        print_ap

        echo -n ","
#	fi
    # Rest variables

    SSID=""
    CHANNEL=""
    ADDRESS=""
    WMODE=""
    QUALITY=""
    SECURITY=""
    CRYPTION=""
    NSUPPORT=""
    IEEE_MODE=""

    #reset the found flag of AP info 

    FOUND_SSID=0
    FOUND_CHAN=0
    FOUND_FREQ=0
#    FOUND_5G_FREQ=0
    FOUND_ADDR=0
    FOUND_MODE=0
    FOUND_QUAL=0
    FOUND_SCUR=0
    FOUND_CRYP=0
    FOUND_WPA2=0
    FOUND_WPA1=0
    FOUND_11B_RATE=0
    FOUND_11AG_RATE=0
    FOUND_11N_RATE=0
    FOUND_PROTOCOL=0

    fi

    #End of Output Last AP info

LOOP_COUNT=$(($LOOP_COUNT+1))

fi


# if this AP use 5G Hz, skip this AP
#if [ $FOUND_5G_FREQ -eq 1 ]
#then
#    continue
#fi


if [ $FOUND_ADDR -eq 0 ]
then
   ADDRESS=`echo $line|grep Address|cut -d ' ' -f 5`
   if [ "$ADDRESS" ]
   then
      FOUND_ADDR=1
#      echo $LOOP_COUNT": "$line", MAC Address: "$ADDRESS
      continue
   fi
fi


if [ $FOUND_SSID -eq 0 ]
then
    SSID=`echo $line|grep ESSID|awk '{print substr($0, 8, length($0)-8)}'|sed 's/\"/\\\\\"/'`
    if [ "$SSID" ]
    then
        FOUND_SSID=1
#        echo $line", SSID: "$SSID
        continue
    fi
fi

if [ $FOUND_CHAN -eq 0 ]
then
    CHANNEL=`echo $line|grep Channel|cut -d ' ' -f 4|cut -d ')' -f 1`
    if [ "$CHANNEL" ]
    then
        FOUND_CHAN=1
#        echo $line", Channel: "$CHANNEL
    fi
fi

if [ $FOUND_FREQ -eq 0 ]
then
    FREQ=`echo $line|grep 'Frequency'`
    if [ "$FREQ" ]
    then
        FREQ=`echo $FREQ|cut -d ':' -f 2|cut -d '.' -f 1`
        FOUND_FREQ=1
       # if [ "$FREQ" = "5" ]
       # then
       #     FOUND_5G_FREQ=1
       # fi
	continue
    fi
fi

if [ $FOUND_QUAL -eq 0 ]
then
    QUALITY_STRING=`echo $line|grep Quality|cut -d ' ' -f 1`

    if [ "$QUALITY_STRING" ]
    then
        SIG_LEVEL=`echo $QUALITY_STRING|cut -d '/' -f 1|cut -d '=' -f 2`
        MAX_LEVEL=`echo $QUALITY_STRING|cut -d '/' -f 2`

        if [ "SIG_LEVEL" ] && [ "MAX_LEVEL" ] && [ "SIG_LEVEL" != "0" ] && [ "MAX_LEVEL" != "0" ]
        then
            
            # count rounded percent of signal strength 
            QUALITY=$(((1000*$SIG_LEVEL/$MAX_LEVEL+5)/10))
            FOUND_QUAL=1
#            echo $line", Signal Strength: "$SIG_LEVEL"/"$MAX_LEVEL" = "$QUALITY"%"
            continue
        fi
    fi
fi


if [ $FOUND_PROTOCOL -eq 0 ]
then
   
   IEEE_MODE=`echo $line|grep Protocol|cut -d ' ' -f 2`
   if [ "$IEEE_MODE" != "" ]
   then
       FOUND_PROTOCOL=1
       continue
   fi
fi


if [ $FOUND_CRYP -eq 0 ]
then

    CRYPTION=`echo $line|grep Encryption|cut -d ':' -f 2`
    
    if [ "$CRYPTION" ]
    then
        FOUND_CRYP=1
    fi

    if [ "$CRYPTION" = "on" ]
    then
        SECURITY="WEP"
    elif [ "$CRYPTION" = "off" ]
    then
        SECURITY="NONE"
        FOUND_SCUR=1
#       echo "CRYPTION is off"
    fi

    continue
fi

if [ $FOUND_SCUR -eq 0 ]
then

    if [ $FOUND_WPA2 -eq 0 ]
    then
        WPA2_STRING=`echo $line|grep WPA2`
        if [ "$WPA2_STRING" ]
        then
            FOUND_WPA2=1
            SECURITY="WPA2"
            continue
        fi
    fi

    if [ $FOUND_WPA1 -eq 0 ]
    then
        WPA1_STRING=`echo $line|grep 'WPA '`
        if [ "$WPA1_STRING" ]
        then
            FOUND_WPA1=1
            if [ $FOUND_WPA2 -eq 0 ]
            then
                SECURITY="WPA"
            fi
        fi
    fi

    # WPA isn't shown before WPA2 in iwlist output format
    # So we can determine which version of WPA this PSK belongs to

    if [ $FOUND_WPA1 -eq 1 ] || [ $FOUND_WPA2 -eq 1 ]
    then
        PSK_STRING=`echo $line|grep PSK`
        if [ "$PSK_STRING" ]
        then
            # If this PSK belongs WPA2
            if [ $FOUND_WPA2 -eq 1 ] && [ $FOUND_WPA1 -eq 0 ]
            then
                SECURITY="WPA2-PSK"

            # If this PSK belongs WPA, but WPA2 also set
            elif [ $FOUND_WPA2 -eq 1 ] && [ $FOUND_WPA1 -eq 1 ]
            then
                # SECURITY has been recoreded as "WPA2"
                true

            # If this PSK belong WPA and WPA2 didn't set
            elif [ $FOUND_WPA1 -eq 1 ]
            then
                SECURITY="WPA-PSK"
            fi

            # Do not need to check this AP's security info afterwards
            FOUND_SCUR=1
        fi
    fi

fi

# END OF LOOP
done;

#print the last one AP if needed
#if [ $LOOP_COUNT -gt 0 ] && [ $FOUND_5G_FREQ -eq 0 ]
if [ $LOOP_COUNT -gt 0 ]
then
    determine_wlan_mode
    print_ap
fi

#echo -n "]"
