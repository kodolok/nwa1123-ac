#!/bin/sh 

if [ $# -gt 0 ];then 
exec 0<$1; 
fi 

#echo $0 $1

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
FOUND_SSID=0
FOUND_CHAN=0
FOUND_FREQ=0
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
 echo "{\"SSID\":\""$SSID"\","
 echo "\"CHANNEL\":\""$CHANNEL"\","
 echo "\"MAC\":\""$ADDRESS"\","
 echo "\"MODE\":\"802.11"$WMODE"\","
 echo "\"QUALITY\":\""$QUALITY"%\","
 echo "\"SECURITY\":\""$SECURITY"\"}"
}

determine_wlan_mode()
{
    if [ $FOUND_11B_RATE -eq 1 ]
    then
        WMODE="b"
        if [ $FOUND_11AG_RATE -eq 1 ]
        then
            WMODE="b/g"
            if [ $FOUND_11N_RATE -eq 1 ]
            then
                WMODE="b/g/n"
            fi
        fi
    elif [ $FOUND_11AG_RATE -eq 1 ]
    then
        WMODE="a"
        if [ $FOUND_11N_RATE -eq 1 ]
        then
            WMODE="a/n"
        fi
    elif [ $FOUND_11AG_RATE -eq 1 ]
    then
        WMODE="g"
        if [ $FOUND_11N_RATE -eq 1 ]
        then
            WMODE="g/n"
        fi
    elif [ $FOUND_11N_RATE -eq 1 ]
    then
        WMODE="n"
    else
        WMODE=""
    fi
}

while read line 
do 

SKIP_LINE=`echo $line|egrep 'Mode|Extra|Cipher|Unknown'`
if [ "$SKIP_LINE" ]
then
    continue
fi

FOUND_NEW_AP=`echo $line|grep Cell`
if [ "$FOUND_NEW_AP" ]
then

    #Output the last AP information

    if [ $LOOP_COUNT -gt 0 ]
    then

    #If we have got at least one AP info

    determine_wlan_mode

    print_ap

    # Rest variables

    SSID=""
    CHANNEL=""
    ADDRESS=""
    WMODE=""
    QUALITY=""
    SECURITY=""
    CRYPTION=""

    #reset the found flag of AP info 

    FOUND_SSID=0
    FOUND_CHAN=0
    FOUND_FREQ=0
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

    fi

    #End of Output Last AP info

LOOP_COUNT=$(($LOOP_COUNT+1))

fi

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
    SSID=`echo $line|grep ESSID|cut -d '"' -f 2`
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

#if [ $FOUND_FREQ -eq 1 ] && [ $FOUND_11B_RATE -eq 0 ] || [ $FOUND_11AG_RATE -eq 0 ] || [ $FOUND_11N_RATE -eq 0 ]
if [ $FOUND_FREQ -eq 1 ] && [ $FOUND_11B_RATE -eq 0 ] || [ $FOUND_11AG_RATE -eq 0 ]
then
    BITRATE_STRING=`echo $line|grep 'Mb/s'`

    if [ "$BITRATE_STRING" ]
    then
        # Searching 802.11b rates
        if [ $FOUND_11B_RATE -eq 0 ]
        then
            for bitrates in "1 Mb" "2 Mb" "5.5 Mb" "11 Mb"
            do
                # produce regular expression for searching completed matching string
                ADD_RE="[: ]+"${bitrates}
                #echo "ADD_RE="$ADD_RE

                # add empty char before $line for searching the first bitrate leading without ':'
                BITRATE_STRING=`echo " $line"|egrep "${ADD_RE}"`
            
                if [ "$BITRATE_STRING" ]
                then
                    FOUND_11B_RATE=1
                    #echo "We Found 11b Rate at "$bitrates
                    break
                fi
            done
        fi
       
       # Searching 802.11a or 802.11g rates
        if [ $FOUND_11AG_RATE -eq 0 ]
        then
            for bitrates in "6 Mb" "9 Mb" "12 Mb" "18 Mb" "24 Mb" "36 Mb" "48 Mb" "54 Mb"
            do
                # produce regular expression for searching completed matching string
                ADD_RE="[: ]+"${bitrates}
                #echo "ADD_RE="$ADD_RE

                BITRATE_STRING=`echo " $line"|egrep "${ADD_RE}"`

                if [ "$BITRATE_STRING" ]
                then
                    FOUND_11AG_RATE=1
                    #echo "We Found 11a/g Rate at "$bitrates
                    break
                fi
            done
        fi       

        # Searching 802.11n rates
#        if [ $FOUND_11N_RATE -eq 0 ]
#        then
#            for bitrates in "7.2 Mb" "14.4 Mb" "21.7 Mb" "28.9 Mb" "43.3 Mb" "57.8 Mb" "65 Mb" "72.2 Mb" "15 Mb" "30 Mb" "45 Mb" "60 Mb" "90 Mb" "120 Mb" "135 Mb" "150 Mb"
#            do
#                # produce regular expression for searching completed matching string
#                ADD_RE="[: ]+"${bitrates}
#                #echo "ADD_RE="$ADD_RE

#                BITRATE_STRING=`echo " $line"|egrep "${ADD_RE}"`

#                if [ "$BITRATE_STRING" ]
#                then
#                    FOUND_11N_RATE=1
                    #echo "We Found 11n Rate at "$bitrates
#                    break
#                fi
#            done
#        fi
    fi
fi

if [ $FOUND_11B_RATE -eq 1 ] && [ $FOUND_11AG_RATE -eq 1 ]
then
    BITRATE_STRING=`echo $line|grep 'Mb/s'`

    if [ "$BITRATE_STRING" ]
    then
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
if [ $LOOP_COUNT -gt 0 ]
then
    determine_wlan_mode
    print_ap
fi
