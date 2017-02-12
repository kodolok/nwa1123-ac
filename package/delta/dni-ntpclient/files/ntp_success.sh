#!/bin/sh

# This script is called when DUT synchronizes with NTP server

config set ntp_bootup="`date +%s`"
config set dut_uptime="`cat /proc/uptime  | awk '{print $1}' | awk -F'.' '{print $1}'`"
/etc/rc.d/update_log_timestamp.sh
/etc/rc.d/cmdsched.sh restart both

#ticket 64 connection status-obtain time and lease time
if [ "`config get dhcpc_lease_obtain_update`" = 1 ]; then
	config set dhcpc_lease_obtain="`date +%c`"
	config unset dhcpc_lease_obtain_update
fi



