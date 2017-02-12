#!/bin/sh
# By Mike Chen @ DNI

PREV_TOTAL=0
PREV_IDLE=0
LOOP_TIMES=0
LOOP_LIMIT=1    # limit for loop times

while [ $LOOP_TIMES -le $LOOP_LIMIT ]; do


  CPU=`cat /proc/stat | grep '^cpu '` # Get the total CPU statistics.

  USER=`echo $CPU | awk '{print $2}'`   # Get the user CPU time
  NICE=`echo $CPU | awk '{print $3}'`   # Get the nice CPU time
  SYSTEM=`echo $CPU | awk '{print $4}'` # Get the system CPU time
  IDLE=`echo $CPU | awk '{print $5}'`   # Get the idle CPU time
  IO=`echo $CPU | awk '{print $6}'`     # Get the I/O wating time
  IRQ=`echo $CPU | awk '{print $7}'`    # Get the IRQ time
  SIRQ=`echo $CPU | awk '{print $8}'`   # Get the SoftIRQ time
  STEAD=`echo $CPU | awk '{print $9}'`  # Get the steal - stolen time
  GUEST=`echo $CPU | awk '{print $10}'` # Get the guest time

  # Calculate the total CPU time.
  TOTAL=$(($USER+$NICE+$SYSTEM+$IDLE+$IO+$IRQ+$SIRQ+$STEAD+$GUEST))

  # if it is not first time to enter this while loop
  if [ $LOOP_TIMES -ge 1 ] 
  then

    # Calculate the CPU usage since we last checked.
    DIFF_IDLE=$(($IDLE-$PREV_IDLE))
    #let "DIFF_IDLE=$IDLE-$PREV_IDLE"
    DIFF_TOTAL=$(($TOTAL-$PREV_TOTAL))
    #let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
    DIFF_USAGE=$(((1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10))
    #let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10" #Cal the % of CPU usage with auto round
  
    echo -en "$DIFF_USAGE"
    if [ $LOOP_TIMES -ge $LOOP_LIMIT ]
    then
        exit
    fi
  fi

  # Remember the total and idle CPU times for the next check.
  PREV_TOTAL="$TOTAL"
  PREV_IDLE="$IDLE"
  LOOP_TIMES=$((${LOOP_TIMES}+1))
  # Wait before checking again.
  sleep 1
done
