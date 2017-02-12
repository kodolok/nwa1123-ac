#!/bin/sh 
############################################
# This script need some args               #
#   $1: output style {web|mib}             #
# Ex: site_survey.sh web                   #
############################################

# grep information
filePath="/tmp/scan_result_1"
iwlist ath0 scanning 2>/dev/null \
| egrep 'Cell|ESSID|Protocol|Frequency|Quality|IE: IEEE 802.11i/WPA2|IE: WPA Version 1|Authentication Suites|Encryption key:' \
> $filePath

if [ -e $filePath ]; then
	sed 's/\\/\\\\/g' $filePath > /tmp/scan_result
	rm -f $filePath
fi

site_reader /tmp/scan_result $1

exit 0
