#!/bin/sh

MEM=`cat /proc/meminfo | grep '^Mem'`

MEM_TOTAL=`echo ${MEM} | cut -d ' ' -f2`
MEM_FREE=`echo ${MEM} | cut -d ' ' -f5`

#MEM_USED=$(($MEM_TOTAL-$MEM_FREE))

MEM_USAGE=$(((1000*($MEM_TOTAL-$MEM_FREE)/$MEM_TOTAL+5)/10))

#echo "${MEM_TOTAL}, ${MEM_FREE}, ${MEM_FREE}, ${MEM_USAGE}%"

echo -n "${MEM_USAGE}"
