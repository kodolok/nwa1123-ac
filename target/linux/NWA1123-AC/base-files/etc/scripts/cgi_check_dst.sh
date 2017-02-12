#!/bin/sh
#########################################################################
##  cgi_check_dst.sh
##  Usage:
##  Check Daylight Saving Time
##  Tony.Kuo
#########################################################################

NTP_TIME_ZONE=`cfg -v NTP_TIME_ZONE`
NTP_DAYLIGHT_SAVING=`cfg -v NTP_DAYLIGHT_SAVING`
TIME_ZONE_FILE=/tmp/TZ

##
# start cal
##
	if [ -f /sbin/cal ]
	then
		 /sbin/cal
		ret=$?
		echo "cal: " $ret
		if [ $ret = 0 ]
		then
			if [ "$NTP_TIME_ZONE" = "0" ]
			then    
			    echo GMT12 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "1" ]
			then
			     echo BST11 > $TIME_ZONE_FILE 
			elif [ "$NTP_TIME_ZONE" = "2" ]
			then
			    echo HST10 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "3" ]
			then
			    echo AST9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "4" ]
			then
			    echo PST8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "5" ]
			then
			    echo MST7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "6" ]
			then
			    echo MST7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "7" ]
			then
			    echo MST7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "8" ]
			then
			    echo CST6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "9" ]
			then
			    echo CST6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "10" ]
			then
			    echo CST6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "11" ]
			then
			    echo CST6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "12" ]
			then
			    echo EST5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "13" ]
			then
			    echo EST5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "14" ]
			then
			    echo EST5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "15" ]
			then
			    echo AST4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "16" ]
			then
			    echo AST4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "17" ]
			then
			    echo GMT+3:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "18" ]
			then
			    echo AST3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "19" ]
			then
			    echo AST3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "20" ]
			then
			    echo FALKST2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "21" ]
			then
			    echo AZOT1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "22" ]
			then
			    echo GMT0 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "23" ]
			then
			    echo CUT0 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "24" ]
			then
			    echo NFT-1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "25" ]
			then
			    echo NFT-1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "26" ]
			then
			    echo NFT-1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "27" ]
			then
			    echo NFT-1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "28" ]
			then
			    echo NFT-1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "29" ]
			then
			    echo USAST-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "30" ]
			then
			    echo USAST-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "31" ]
			then
			    echo WET-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "32" ]
			then
			    echo WET-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "33" ]
			then
			    echo SAUST-3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "34" ]
			then
			    echo MEST-3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "35" ]
			then
			    echo GMT-3:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "36" ]
			then
			    echo WST-4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "37" ]
			then
			    echo WST-4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "38" ]
			then
			    echo GMT-4:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "39" ]
			then
			    echo PAKST-5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "40" ]
			then
			    echo PAKST-5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "41" ]
			then
			    echo GMT-5:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "42" ]
			then
			    echo GMT-5:45 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "43" ]
			then
			    echo TASHST-6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "44" ]
			then
			    echo TASHST-6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "45" ]
			then
			    echo TASHST-6 > $TIME_ZONE_FILE 
			elif [ "$NTP_TIME_ZONE" = "46" ]
			then
			    echo GMT-6:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "47" ]
			then
			    echo THAIST-7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "48" ]
			then
			    echo THAIST-7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "49" ]
			then
			    echo WAUST-8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "50" ]
			then
			    echo WAUST-8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "51" ]
			then
			    echo WAUST-8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "52" ]
			then
			    echo WAUST-8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "53" ]
			then
			    echo KORST-9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "54" ]
			then
			    echo KORST-9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "55" ]
			then
			    echo GMT-9:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "56" ]
			then
			    echo EET-10 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "57" ]
			then
			    echo EET-10 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "58" ]
			then
			    echo EET-10 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "59" ]
			then
			    echo MET-11 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "60" ]
			then
			    echo NZST-12 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "61" ]
			then
			    echo NZST-12 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "62" ]
			then
			    echo GMT-13 > $TIME_ZONE_FILE
			else
			    echo CUT0 > $TIME_ZONE_FILE
			fi
		else
			if [ "$NTP_TIME_ZONE" = "0" ]
			then    
			    echo GDT11 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "1" ]
			then
			     echo GDT10 > $TIME_ZONE_FILE 
			elif [ "$NTP_TIME_ZONE" = "2" ]
			then
			    echo GDT9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "3" ]
			then
			    echo GDT8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "4" ]
			then
			    echo GDT7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "5" ]
			then
			    echo GDT6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "6" ]
			then
			    echo GDT6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "7" ]
			then
			    echo GDT6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "8" ]
			then
			    echo GDT5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "9" ]
			then
			    echo GDT5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "10" ]
			then
			    echo GDT5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "11" ]
			then
			    echo GDT5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "12" ]
			then
			    echo GDT4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "13" ]
			then
			    echo GDT4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "14" ]
			then
			    echo GDT4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "15" ]
			then
			    echo GDT3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "16" ]
			then
			    echo GDT3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "17" ]
			then
			    echo GDT+2:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "18" ]
			then
			    echo GDT2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "19" ]
			then
			    echo GDT2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "20" ]
			then
			    echo GDT1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "21" ]
			then
			    echo GDT0 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "22" ]
			then
			    echo GDT-1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "23" ]
			then
			    echo GDT-1 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "24" ]
			then
			    echo GDT-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "25" ]
			then
			    echo GDT-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "26" ]
			then
			    echo GDT-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "27" ]
			then
			    echo GDT-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "28" ]
			then
			    echo GDT-2 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "29" ]
			then
			    echo GDT-3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "30" ]
			then
			    echo GDT-3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "31" ]
			then
			    echo GDT-3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "32" ]
			then
			    echo GDT-3 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "33" ]
			then
			    echo GDT-4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "34" ]
			then
			    echo GDT-4 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "35" ]
			then
			    echo GDT-4:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "36" ]
			then
			    echo GDT-5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "37" ]
			then
			    echo GDT-5 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "38" ]
			then
			    echo GDT-5:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "39" ]
			then
			    echo GDT-6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "40" ]
			then
			    echo GDT-6 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "41" ]
			then
			    echo GDT-6:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "42" ]
			then
			    echo GDT-6:45 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "43" ]
			then
			    echo GDT-7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "44" ]
			then
			    echo GDT-7 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "45" ]
			then
			    echo GDT-7 > $TIME_ZONE_FILE 
			elif [ "$NTP_TIME_ZONE" = "46" ]
			then
			    echo GDT-7:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "47" ]
			then
			    echo GDT-8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "48" ]
			then
			    echo GDT-8 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "49" ]
			then
			    echo GDT-9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "50" ]
			then
			    echo GDT-9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "51" ]
			then
			    echo GDT-9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "52" ]
			then
			    echo GDT-9 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "53" ]
			then
			    echo GDT-10 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "54" ]
			then
			    echo GDT-10 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "55" ]
			then
			    echo GDT-10:30 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "56" ]
			then
			    echo GDT-11 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "57" ]
			then
			    echo GDT-11 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "58" ]
			then
			    echo GDT-11 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "59" ]
			then
			    echo GDT-12 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "60" ]
			then
			    echo GDT-13 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "61" ]
			then
			    echo GDT-13 > $TIME_ZONE_FILE
			elif [ "$NTP_TIME_ZONE" = "62" ]
			then
			    echo GDT-14 > $TIME_ZONE_FILE
			else
			    echo GDT-1 > $TIME_ZONE_FILE
			fi
		fi
	fi
    
exit 0
