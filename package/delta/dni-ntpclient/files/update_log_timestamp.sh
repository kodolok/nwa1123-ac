#!/bin/sh

LOG_FILE=/var/log/messages
TMP_FILE=/var/log/mesg

if [ -f "$TMP_FILE" ] && [ "`config get dut_bootup`" != "" ]; then
	# bootup timestampe offset calculation
	DUT_BOOTUP=`config get dut_bootup`
	#NTP_BOOTUP=`cat $LOG_FILE | grep "Time synchronized with NTP server" | awk '{print $(NF-1)}'`
	NTP_BOOTUP=`config get ntp_bootup`
	DUT_UPTIME=`config get dut_uptime`
	#offset=$(($NTP_BOOTUP-$DUT_BOOTUP))
	offset=$(($(($NTP_BOOTUP-$DUT_BOOTUP))-$DUT_UPTIME))

	for item in `cat $TMP_FILE | grep "NETGEAR" | awk '{print $(NF-1)}'`
	do
		O_time=$item
		N_time=$(($O_time+$offset))
		pattern=`date -d 1970.01.01-00:00:$N_time +'%A, %B %d,%Y %R:%S'`
		sed -i "/NETGEAR/s/$O_time NETGEAR/$pattern/g" $TMP_FILE
	done

	tmp_line=`wc -l $TMP_FILE | awk '{print $1}'`
	log_line=`wc -l $LOG_FILE | awk '{print $1}'`

	sed -i "1,"$tmp_line"d" $LOG_FILE
	cat $LOG_FILE >> $TMP_FILE
	mv $TMP_FILE $LOG_FILE
	config unset dut_bootup
fi

