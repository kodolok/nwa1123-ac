#!/bin/sh

#add checksum in the tail of fw
TMP_IMG=$1
FW_IMG=$2
CAL_CKSUM=`md5sum ${TMP_IMG} | cut -d ' ' -f 1`
TMP_MD5="fw.md5"

echo ${CAL_CKSUM} | xxd -r -p > $TMP_MD5

# combine fw and md5
cat ${TMP_IMG} ${TMP_MD5} > ${FW_IMG}
#rm ${TMP_IMG} ${TMP_MD5}

