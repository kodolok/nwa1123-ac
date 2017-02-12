#!/bin/bash
# Simple calculate duration between current time and $1 ,show with prefix string $2
COMPLETE_TIME=$(date '+%s')

function getplayelapsedtime()
{       
        local  stime=$1
        etime=$(date '+%s')
        if [[ -z "$stime" ]]; then stime=$etime; fi

        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        
        retval=$(printf '%02d(hour):%02d(min):%02d(sec)' $dh $dm $ds)
        echo $retval
}

#echo "STARTTIME="$1 
#echo "COMPLETE_TIME="$COMPLETE_TIME 

TOTAL_TIME_STRING="|  							 $2 $(getplayelapsedtime $1 $2)                  |" 
    
echo "----------------------------------------------------------"
echo "|                                                         |"
echo $TOTAL_TIME_STRING
echo "|                                                         |"
echo "----------------------------------------------------------"