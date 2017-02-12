#!/bin/sh

FS_USAGE_TMP=`df | grep mtd | awk '{print $3}'`
FS_USAGE=`echo $(( $FS_USAGE_TMP * 100 / 8192 ))`

echo -n $FS_USAGE
