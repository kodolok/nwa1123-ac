#!/bin/sh

#[ -f /usr/local/sbin/ntpclient ] || exit 0
#[ -f /etc/resolv.conf ] || exit 0

RETVAL=0
prog="ntpclient"
PID_FILE="/var/run/ntpclient.pid"
COMPANY_NAME=`config get companyname`
ntp_server1=`config get ntp_server1`
ntp_server=$ntp_server1
dst_enabled=`config get ntp_dst_on`
ifname=`config get lan_ifname`

if [ "x$COMPANY_NAME" != "xD-Link" ]; then
set_by_GUI=$2
ntp_server2=`config get ntp_server2`
ntp_dst_offset=`config get ntp_dst_offset`
ntp_dst_sm=`config get ntp_dst_sm`
ntp_dst_sw=`config get ntp_dst_sw`
ntp_dst_sd=`config get ntp_dst_sd`
ntp_dst_st=`config get ntp_dst_st`
ntp_dst_em=`config get ntp_dst_em`
ntp_dst_ew=`config get ntp_dst_ew`
ntp_dst_ed=`config get ntp_dst_ed`
ntp_dst_et=`config get ntp_dst_et`
wan_proto=`config get wan_proto`
fi
ntp_time_on=`config get ntp_time_on`
time_zone=`config get ntp_tz`

interval=1

min_interval=15
max_interval=$(($min_interval*4))
	
if [ "x$COMPANY_NAME" != "xD-Link" ]; then
SKIP_CHECK=0
case "$1" in 
	serverip1|serverip2|show|ntp_mode|dst_mode|dst_offset|dst_m|dst_w|dst_d|dst_t)
			SKIP_CHECK=1
			;;
	*)
			;;
esac 

if [ "x$ntp_time_on" != "x1" ]; then
	if [ "x$SKIP_CHECK" != "x1" ]; then
		exit
	fi
fi

if [ "x$ntp_dst_offset" = "x" ]; then
	WL_COUN=`config get wl_country`
	if [ "x$wl_country" = "x10" ]; then
		config set ntp_tz=5
	else
		config set ntp_tz=27
	fi
	config set ntp_dst_offset=0
	config set ntp_dst_sm=1
	config set ntp_dst_sw=1
	config set ntp_dst_sd=0
	config set ntp_dst_st=0
	config set ntp_dst_em=1
	config set ntp_dst_ew=1
	config set ntp_dst_ed=0
	config set ntp_dst_et=0
	config set ntp_server1=north-america.pool.ntp.org
	config set ntp_server2=south-america.pool.ntp.org
fi

print_endis()
{
	local value=`echo $1`
	
	if [ "x$value" != "x1" ]; then
		echo "Disabled"
	else
		echo "Enabled"
	fi
}

print_ntp_dst_offset()
{
	local value=`echo $1`
	
	if [ "x$value" = "x0" ]; then
		echo "-02:00"
	elif [ "x$value" = "x1" ]; then
		echo "-01:30"
	elif [ "x$value" = "x2" ]; then
		echo "-01:00"
	elif [ "x$value" = "x3" ]; then
		echo "-00:30"
	elif [ "x$value" = "x4" ]; then
		echo "+00:30"
	elif [ "x$value" = "x5" ]; then
		echo "+01:00"
	elif [ "x$value" = "x6" ]; then
		echo "+01:30"
	else
		echo "+02:00"
	fi
}

print_ntp_dst_m()
{
	local value=`echo $1`

	if [ "x$value" = "x1" ]; then
		echo "January  "
	elif [ "x$value" = "x2" ]; then
		echo "February "
	elif [ "x$value" = "x3" ]; then
		echo "March    "
	elif [ "x$value" = "x4" ]; then
		echo "April    "
	elif [ "x$value" = "x5" ]; then
		echo "May      "
	elif [ "x$value" = "x6" ]; then
		echo "June     "
	elif [ "x$value" = "x7" ]; then
		echo "July     "
	elif [ "x$value" = "x8" ]; then
		echo "August   "
	elif [ "x$value" = "x9" ]; then
		echo "September"
	elif [ "x$value" = "x10" ]; then
		echo "October  "
	elif [ "x$value" = "x11" ]; then
		echo "November "
	else
		echo "December "
	fi
}

dst_m()
{
	local type=`echo $1`
	local value=`echo $2`

	if [ "x$value" = "xJanuary" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=1
		else
			config set ntp_dst_em=1
		fi
	elif [ "x$value" = "xFebruary" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=2
		else
			config set ntp_dst_em=2
		fi
	elif [ "x$value" = "xMarch" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=3
		else
			config set ntp_dst_em=3
		fi
	elif [ "x$value" = "xApril" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=4
		else
			config set ntp_dst_em=4
		fi
	elif [ "x$value" = "xMay" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=5
		else
			config set ntp_dst_em=5
		fi
	elif [ "x$value" = "xJune" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=6
		else
			config set ntp_dst_em=6
		fi
	elif [ "x$value" = "xJuly" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=7
		else
			config set ntp_dst_em=7
		fi
	elif [ "x$value" = "xAugust" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=8
		else
			config set ntp_dst_em=8
		fi
	elif [ "x$value" = "xSeptember" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=9
		else
			config set ntp_dst_em=9
		fi
	elif [ "x$value" = "xOctober" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=10
		else
			config set ntp_dst_em=10
		fi
	elif [ "x$value" = "xNovember" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=11
		else
			config set ntp_dst_em=11
		fi
	else
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sm=12
		else
			config set ntp_dst_em=12
		fi
	fi
}

print_ntp_dst_w()
{
	local value=`echo $1`

	if [ "x$value" = "x1" ]; then
		echo "1st "
	elif [ "x$value" = "x2" ]; then
		echo "2nd "
	elif [ "x$value" = "x3" ]; then
		echo "3rd "
	elif [ "x$value" = "x4" ]; then
		echo "4th "
	else
		echo "5th "
	fi
}

dst_w()
{
	local type=`echo $1`
	local value=`echo $2`

	if [ "x$value" = "x1st" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sw=1
		else
			config set ntp_dst_ew=1
		fi
	elif [ "x$value" = "x2nd" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sw=2
		else
			config set ntp_dst_ew=2
		fi
	elif [ "x$value" = "x3rd" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sw=3
		else
			config set ntp_dst_ew=3
		fi
	elif [ "x$value" = "x4th" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sw=4
		else
			config set ntp_dst_ew=4
		fi
	else
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sw=5
		else
			config set ntp_dst_ew=5
		fi
	fi
}

print_ntp_dst_d()
{
	local value=`echo $1`

	if [ "x$value" = "x0" ]; then
		echo "Sunday     "
	elif [ "x$value" = "x1" ]; then
		echo "Monday     "
	elif [ "x$value" = "x2" ]; then
		echo "Tuesday    "
	elif [ "x$value" = "x3" ]; then
		echo "Wednesday  "
	elif [ "x$value" = "x4" ]; then
		echo "Thursday   "
	elif [ "x$value" = "x5" ]; then
		echo "Friday     "
	else
		echo "Saturday   "
	fi
}

dst_d()
{
	local type=`echo $1`
	local value=`echo $2`

	if [ "x$value" = "xSunday" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sd=0
		else
			config set ntp_dst_ed=0
		fi
	elif [ "x$value" = "xMonday" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sd=1
		else
			config set ntp_dst_ed=1
		fi
	elif [ "x$value" = "xTuesday" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sd=2
		else
			config set ntp_dst_ed=2
		fi
	elif [ "x$value" = "xWednesday" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sd=3
		else
			config set ntp_dst_ed=3
		fi
	elif [ "x$value" = "xThursday" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sd=4
		else
			config set ntp_dst_ed=4
		fi
	elif [ "x$value" = "xFriday" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sd=5
		else
			config set ntp_dst_ed=5
		fi
	else
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_sd=6
		else
			config set ntp_dst_ed=6
		fi
	fi
}

print_ntp_dst_t()
{
	local value=`echo $1`

	if [ "x$value" = "x0" ]; then
		echo "12 am"
	elif [ "x$value" = "x1" ]; then
		echo "1 am  "
	elif [ "x$value" = "x2" ]; then
		echo "2 am  "
	elif [ "x$value" = "x3" ]; then
		echo "3 am  "
	elif [ "x$value" = "x4" ]; then
		echo "4 am  "
	elif [ "x$value" = "x5" ]; then
		echo "5 am  "
	elif [ "x$value" = "x6" ]; then
		echo "6 am  "
	elif [ "x$value" = "x7" ]; then
		echo "7 am  "
	elif [ "x$value" = "x8" ]; then
		echo "8 am  "
	elif [ "x$value" = "x9" ]; then
		echo "9 am  "
	elif [ "x$value" = "x10" ]; then
		echo "10 am"
	elif [ "x$value" = "x11" ]; then
		echo "11 am"
	elif [ "x$value" = "x12" ]; then
		echo "12 pm"
	elif [ "x$value" = "x13" ]; then
		echo "1 pm  "
	elif [ "x$value" = "x14" ]; then
		echo "2 pm  "
	elif [ "x$value" = "x15" ]; then
		echo "3 pm  "
	elif [ "x$value" = "x16" ]; then
		echo "4 pm  "
	elif [ "x$value" = "x17" ]; then
		echo "5 pm  "
	elif [ "x$value" = "x18" ]; then
		echo "6 pm  "
	elif [ "x$value" = "x19" ]; then
		echo "7 pm  "
	elif [ "x$value" = "x20" ]; then
		echo "8 pm  "
	elif [ "x$value" = "x21" ]; then
		echo "9 pm  "
	elif [ "x$value" = "x22" ]; then
		echo "10 pm"
	else
		echo "11 pm"
	fi
}

dst_t()
{
	local type=`echo $1`
	local value=`echo $2`

	if [ "x$value" = "x12am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=0
		else
			config set ntp_dst_et=0
		fi
	elif [ "x$value" = "x1am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=1
		else
			config set ntp_dst_et=1
		fi
	elif [ "x$value" = "x2am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=2
		else
			config set ntp_dst_et=2
		fi
	elif [ "x$value" = "x3am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=3
		else
			config set ntp_dst_et=3
		fi
	elif [ "x$value" = "x4am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=4
		else
			config set ntp_dst_et=4
		fi
	elif [ "x$value" = "x5am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=5
		else
			config set ntp_dst_et=5
		fi
	elif [ "x$value" = "x6am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=6
		else
			config set ntp_dst_et=6
		fi
	elif [ "x$value" = "x7am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=7
		else
			config set ntp_dst_et=7
		fi
	elif [ "x$value" = "x8am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=8
		else
			config set ntp_dst_et=8
		fi
	elif [ "x$value" = "x9am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=9
		else
			config set ntp_dst_et=9
		fi
	elif [ "x$value" = "x10am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=10
		else
			config set ntp_dst_et=10
		fi
	elif [ "x$value" = "x11am" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=11
		else
			config set ntp_dst_et=11
		fi
	elif [ "x$value" = "x12pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=12
		else
			config set ntp_dst_et=12
		fi
	elif [ "x$value" = "x1pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=13
		else
			config set ntp_dst_et=13
		fi
	elif [ "x$value" = "x2pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=14
		else
			config set ntp_dst_et=14
		fi
	elif [ "x$value" = "x3pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=15
		else
			config set ntp_dst_et=15
		fi
	elif [ "x$value" = "x4pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=16
		else
			config set ntp_dst_et=16
		fi
	elif [ "x$value" = "x5pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=17
		else
			config set ntp_dst_et=17
		fi
	elif [ "x$value" = "x6pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=18
		else
			config set ntp_dst_et=18
		fi
	elif [ "x$value" = "x7pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=19
		else
			config set ntp_dst_et=19
		fi
	elif [ "x$value" = "x8pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=20
		else
			config set ntp_dst_et=20
		fi
	elif [ "x$value" = "x9pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=21
		else
			config set ntp_dst_et=21
		fi
	elif [ "x$value" = "x10pm" ]; then
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=22
		else
			config set ntp_dst_et=22
		fi
	else
		if [ "x$type" = "xstart" ]; then
			config set ntp_dst_st=23
		else
			config set ntp_dst_et=23
		fi
	fi
}

ntp_mode(){
	local value=`echo $1`

	if [ "x$value" = "xEnabled" ]; then
		config set ntp_time_on=1
	else
		config set ntp_time_on=0
	fi
}

print_ntp_timezone()
{
	local value=`echo $1`

	if [ "x$value" = "x1" ]; then
		echo "(GMT-12:00) International Date Line West"
	elif [ "x$value" = "x2" ]; then
		echo "(GMT-11:00) Midway Island, Samoa"
	elif [ "x$value" = "x3" ]; then
		echo "(GMT-10:00) Hawaii"
	elif [ "x$value" = "x4" ]; then
		echo "(GMT-09:00) Alaska"
	elif [ "x$value" = "x5" ]; then
		echo "(GMT-08:00) Pacific Time (US & Canada); Tijuana"
	elif [ "x$value" = "x6" ]; then
		echo "(GMT-07:00) Arizona"
	elif [ "x$value" = "x7" ]; then
		echo "(GMT-07:00) Arizona, Chihuahua, La Paz, Mazatlan"
	elif [ "x$value" = "x8" ]; then
		echo "(GMT-07:00) Mountain Time (US & Canada)"
	elif [ "x$value" = "x9" ]; then
		echo "(GMT-06:00) Central America"
	elif [ "x$value" = "x10" ]; then
		echo "(GMT-06:00) Central Time (US & Canada)"
	elif [ "x$value" = "x11" ]; then
		echo "(GMT-06:00) Guadalajara, Mexico City, Monterrey"
	elif [ "x$value" = "x12" ]; then
		echo "(GMT-06:00) Saskatchewan"
	elif [ "x$value" = "x13" ]; then
		echo "(GMT-05:00) Bogota, Lima, Quito"
	elif [ "x$value" = "x14" ]; then
		echo "(GMT-05:00) Eastern Time (US & Canada)"
	elif [ "x$value" = "x15" ]; then
		echo "(GMT-05:00) Indiana (East)"
	elif [ "x$value" = "x16" ]; then
		echo "(GMT-04:00) Caracas"
	elif [ "x$value" = "x17" ]; then
		echo "(GMT-04:00) Atlantic Time (Canada)"
	elif [ "x$value" = "x18" ]; then
		echo "(GMT-04:00) Santiago, La Paz"
	elif [ "x$value" = "x19" ]; then
		echo "(GMT-03:30) Newfoundland"
	elif [ "x$value" = "x20" ]; then
		echo "(GMT-03:00) Brasilia"
	elif [ "x$value" = "x21" ]; then
		echo "(GMT-03:00) Buenos Aires, Georgetown"
	elif [ "x$value" = "x22" ]; then
		echo "(GMT-03:00) Greenland"
	elif [ "x$value" = "x23" ]; then
		echo "(GMT-02:00) Mid-Atlantic"
	elif [ "x$value" = "x24" ]; then
		echo "(GMT-01:00) Azores"
	elif [ "x$value" = "x25" ]; then
		echo "(GMT-01:00) Cape Verde Is."
	elif [ "x$value" = "x26" ]; then
		echo "(GMT) Casablanca, Monrovia"
	elif [ "x$value" = "x27" ]; then
		echo "(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London"
	elif [ "x$value" = "x28" ]; then
		echo "(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna"
	elif [ "x$value" = "x29" ]; then
		echo "(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague"
	elif [ "x$value" = "x30" ]; then
		echo "(GMT+01:00) Brussels, Copenhagen, Madrid, Paris"
	elif [ "x$value" = "x31" ]; then
		echo "(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb"
	elif [ "x$value" = "x32" ]; then
		echo "(GMT+01:00) West Central Africa"
	elif [ "x$value" = "x33" ]; then
		echo "(GMT+02:00) Athens, Istanbul, Minsk"
	elif [ "x$value" = "x34" ]; then
		echo "(GMT+02:00) Bucharest"
	elif [ "x$value" = "x35" ]; then
		echo "(GMT+02:00) Cairo"
	elif [ "x$value" = "x36" ]; then
		echo "(GMT+02:00) Harare, Pretoria"
	elif [ "x$value" = "x37" ]; then
		echo "(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius"
	elif [ "x$value" = "x38" ]; then
		echo "(GMT+02:00) Jerusalem"
	elif [ "x$value" = "x39" ]; then
		echo "(GMT+03:00) Baghdad"
	elif [ "x$value" = "x40" ]; then
		echo "(GMT+03:00) Kuwait, Riyadh"
	elif [ "x$value" = "x41" ]; then
		echo "(GMT+03:00) Nairobi"
	elif [ "x$value" = "x42" ]; then
		echo "(GMT+03:30) Tehran"
	elif [ "x$value" = "x43" ]; then
		echo "(GMT+04:00) Moscow, St.Petersburg, Volgograd"
	elif [ "x$value" = "x44" ]; then
		echo "(GMT+04:00) Abu Dhabi, Muscat"
	elif [ "x$value" = "x45" ]; then
		echo "(GMT+04:00) Baku, Tbilisi, Yerevan"
	elif [ "x$value" = "x46" ]; then
		echo "(GMT+04:30) Kabul"
	elif [ "x$value" = "x47" ]; then
		echo "(GMT+05:00) Islamabad, Karachi, Tashkent"
	elif [ "x$value" = "x48" ]; then
		echo "(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi"
	elif [ "x$value" = "x49" ]; then
		echo "(GMT+05:45) Kathmandu"
	elif [ "x$value" = "x50" ]; then
		echo "(GMT+06:00) Ekaterinburg"
	elif [ "x$value" = "x51" ]; then
		echo "(GMT+06:00) Almaty"
	elif [ "x$value" = "x52" ]; then
		echo "(GMT+06:00) Astana, Dhaka"
	elif [ "x$value" = "x53" ]; then
		echo "(GMT+06:00) Sri Jayawardenepura"
	elif [ "x$value" = "x54" ]; then
		echo "(GMT+06:30) Rangoon"
	elif [ "x$value" = "x55" ]; then
		echo "(GMT+07:00) Bangkok, Hanoi, Jakarta"
	elif [ "x$value" = "x56" ]; then
		echo "(GMT+07:00) Novosibirsk"
	elif [ "x$value" = "x57" ]; then
		echo "(GMT+08:00) Krasnoyarsk"
	elif [ "x$value" = "x58" ]; then
		echo "(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi"
	elif [ "x$value" = "x59" ]; then
		echo "(GMT+08:00) Ulaan Bataar"
	elif [ "x$value" = "x60" ]; then
		echo "(GMT+08:00) Kuala Lumpur, Singapore"
	elif [ "x$value" = "x61" ]; then
		echo "(GMT+08:00) Perth"
	elif [ "x$value" = "x62" ]; then
		echo "(GMT+08:00) Taipei"
	elif [ "x$value" = "x63" ]; then
		echo "(GMT+09:00) Irkutsk"		
	elif [ "x$value" = "x64" ]; then
		echo "(GMT+09:00) Osaka, Sapporo, Tokyo"
	elif [ "x$value" = "x65" ]; then
		echo "(GMT+09:00) Seoul"
	elif [ "x$value" = "x66" ]; then
		echo "(GMT+09:30) Adelaide"
	elif [ "x$value" = "x67" ]; then
		echo "(GMT+09:30) Darwin"
	elif [ "x$value" = "x68" ]; then
		echo "(GMT+10:00) Yakutsk"
	elif [ "x$value" = "x69" ]; then
		echo "(GMT+10:00) Brisbane"
	elif [ "x$value" = "x70" ]; then
		echo "(GMT+10:00) Canberra, Melbourne, Sydney"
	elif [ "x$value" = "x71" ]; then
		echo "(GMT+10:00) Guam, Port Moresby"
	elif [ "x$value" = "x72" ]; then
		echo "(GMT+10:00) Hobart"
	elif [ "x$value" = "x73" ]; then
		echo "(GMT+11:00) Vladivostok"
	elif [ "x$value" = "x74" ]; then
		echo "(GMT+11:00) Solomon Is., New Caledonia"
	elif [ "x$value" = "x75" ]; then
		echo "(GMT+12:00) Magadan"
	elif [ "x$value" = "x76" ]; then
		echo "(GMT+12:00) Auckland, Wellington"
	elif [ "x$value" = "x77" ]; then
		echo "(GMT+12:00) Fiji, Kamchatka, Marshall Is."
	else
		echo "(GMT+13:00) Nuku'alofa"
	fi
}

ntp_timezone(){
	config set ntp_tz=$1

##	local value=`echo $1`
##	local item=`echo $2`

##		config set ntp_tz=$1
##		if [ "x$value" = "x6" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=7
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=8
##			fi
##		elif [ "x$value" = "x9" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=10
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=11
##			elif [ "x$item" = "x#4" ]; then
##				config set ntp_tz=12
##			fi
##		elif [ "x$value" = "x13" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=14
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=15
##			fi
##		elif [ "x$value" = "x16" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=17
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=18
##			fi
##		elif [ "x$value" = "x20" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=21
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=22
##			fi
##		elif [ "x$value" = "x24" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=25
##			fi
##		elif [ "x$value" = "x26" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=27
##		fi
##	elif [ "x$value" = "x28" ]; then
##		if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=29
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=30
##			elif [ "x$item" = "x#4" ]; then
##				config set ntp_tz=31
##			elif [ "x$item" = "x#5" ]; then
##				config set ntp_tz=32
##			fi
##		elif [ "x$value" = "x33" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=34
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=35
##			elif [ "x$item" = "x#4" ]; then
##				config set ntp_tz=36
##			elif [ "x$item" = "x#5" ]; then
##				config set ntp_tz=37
##			elif [ "x$item" = "x#6" ]; then
##				config set ntp_tz=38
##			fi
##		elif [ "x$value" = "x39" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=40
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=41
##			fi
##		elif [ "x$value" = "x43" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=44
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=45
##			elif [ "x$item" = "x#4" ]; then
##				config set ntp_tz=46
##			fi
##		elif [ "x$value" = "x50" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=51
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=52
##			elif [ "x$item" = "x#4" ]; then
##				config set ntp_tz=53
##			fi
##		elif [ "x$value" = "x55" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=56
##			fi
##		elif [ "x$value" = "x57" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=58
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=59
##			elif [ "x$item" = "x#4" ]; then
##				config set ntp_tz=60
##			elif [ "x$item" = "x#5" ]; then
##				config set ntp_tz=61
##			elif [ "x$item" = "x#6" ]; then
##				config set ntp_tz=62
##			fi
##		elif [ "x$value" = "x63" ]; then
##			if [ "x$item" = "x#2" ]; then
##				##	config set ntp_tz=64
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=65
##			fi
##		elif [ "x$value" = "x66" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=67
##			fi
##		elif [ "x$value" = "x68" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=69
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=70
##			elif [ "x$item" = "x#4" ]; then
##				config set ntp_tz=71
##			elif [ "x$item" = "x#5" ]; then
##				config set ntp_tz=72
##			fi
##		elif [ "x$value" = "x73" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=74
##			fi
##		elif [ "x$value" = "x75" ]; then
##			if [ "x$item" = "x#2" ]; then
##				config set ntp_tz=76
##			elif [ "x$item" = "x#3" ]; then
##				config set ntp_tz=77
##			fi
##		else
##			config set ntp_tz=$1
##		fi

}

dst_mode(){
	local value=`echo $1`

	if [ "x$value" = "xEnabled" ]; then
		config set ntp_dst_on=1
	else
		config set ntp_dst_on=0
	fi
}

dst_offset(){
	local value=`echo $1`

	if [ "x$value" = "x-02:00" ]; then
		config set ntp_dst_offset=0
	elif [ "x$value" = "x-01:30" ]; then
		config set ntp_dst_offset=1
	elif [ "x$value" = "x-01:00" ]; then
		config set ntp_dst_offset=2
	elif [ "x$value" = "x-00:30" ]; then
		config set ntp_dst_offset=3
	elif [ "x$value" = "x+00:30" ]; then
		config set ntp_dst_offset=4
	elif [ "x$value" = "x+01:00" ]; then
		config set ntp_dst_offset=5
	elif [ "x$value" = "x+01:30" ]; then
		config set ntp_dst_offset=6
	else
		config set ntp_dst_offset=7
	fi
}

serverip1(){
	config set ntp_server1=$1
}

serverip2(){
	config set ntp_server2=$1
}

show() {
	ntp_time_on=`print_endis $ntp_time_on`
	ntp_time_zone=`print_ntp_timezone $time_zone`
	dst_endis=`print_endis $dst_enabled`
	dst_offset=`print_ntp_dst_offset $ntp_dst_offset`
		
	dst_sm=`print_ntp_dst_m $ntp_dst_sm`
	dst_sw=`print_ntp_dst_w $ntp_dst_sw`
	dst_sd=`print_ntp_dst_d $ntp_dst_sd`
	dst_st=`print_ntp_dst_t $ntp_dst_st`

	dst_em=`print_ntp_dst_m $ntp_dst_em`
	dst_ew=`print_ntp_dst_w $ntp_dst_ew`
	dst_ed=`print_ntp_dst_d $ntp_dst_ed`
	dst_et=`print_ntp_dst_t $ntp_dst_et`
		
	echo ""
	echo "NTP Configuration"
	echo "-------------------------------------------------------------------------------------------------------------"
	echo ""
	
		echo "NTP                    :   $ntp_time_on"	
	if [ "x$ntp_endis" = "xEnabled" ]; then
		
		echo "NTP time zone          :   $ntp_time_zone"
		num=0
		if [ "x$ntp_server1" != "x" ]; then
			num=$(($num+1)) 
			echo "Server IP$num             :   $ntp_server1"
		fi
		if [ "x$ntp_server2" != "x" ]; then
			num=$(($num+1)) 
			echo "Server IP$num             :   $ntp_server2"
		fi
		
		echo "Daylight Saving        :   $dst_endis"
		echo "Daylight Saving Offset :   $dst_offset"
		echo ""
		echo "Daylight Saving Dates  :"
		echo ""
		echo "                           Month              Week          Day of Week          Time"
		echo "Dst Start                  $dst_sm          $dst_sw          $dst_sd          $dst_st"
		echo "Dst End                    $dst_em          $dst_ew          $dst_ed          $dst_et"
	fi

	echo "-------------------------------------------------------------------------------------------------------------"
	echo ""
}
fi
start() {

	if [ "$ntp_time_on" != "1" ]; then
		RETVAL=$?
		echo
		return $RETVAL
	fi

	# Start daemons.
	echo $"Starting $prog: "
	if [ "x$COMPANY_NAME" != "xD-Link" ]; then
	num=0
	if [ "x$ntp_server1" != "x" ]; then
		num=$(($num+1)) 
		ntp_server=$ntp_server1
	fi
	if [ "x$ntp_server2" != "x" ]; then
		num=$(($num+1)) 
		ntp_server=$ntp_server2
	fi
	if [ "x$num" = "x2" ]; then
		ntp_server="$ntp_server1 -b $ntp_server2"
	fi
	fi

	echo "${prog} -z ${time_zone} -h ${ntp_server} -i ${min_interval} -m ${max_interval} -p 123 -s 2 -w ${ifname} -D ${dst_enabled}"
	#for Tokyo
	${prog} -z ${time_zone} -h ${ntp_server} -i $min_interval -m $max_interval -p 123 -s 2 -w $ifname -D $dst_enabled &

	RETVAL=$?
	echo
	return $RETVAL
}

stop() {
	# Stop daemons.
	echo $"Shutting down $prog: "
	#if [ -e ${PID_FILE} ]; then
	#	kill `cat ${PID_FILE}`
	#	rm -f ${PID_FILE}
	#fi
	killall -9 ntpclient
	rm -f ${PID_FILE}
	RETVAL=$?
	echo
	return $RETVAL
}

# See how we were called.
case "$1" in
  ntp_mode)
	ntp_mode $2
	;;
  ntp_timezone)
	ntp_timezone $2 $3
	;;
  dst_mode)
	dst_mode $2
	;;
  dst_offset)
	dst_offset $2
	;;
  dst_m)
	dst_m $2 $3
	;;
  dst_w)
	dst_w $2 $3
	;;
  dst_d)
	dst_d $2 $3
	;;
  dst_t)
	dst_t $2 $3
	;;
  serverip1)
	serverip1 $2
	;;
  serverip2)
	serverip2 $2
	;;
  show)
	show
	;;
  start)
	start
	;;
  stop)
	stop
	;;
  restart|reload)
	stop
	start
	RETVAL=$?
	;;
  *)
	echo $"Usage: $0 {start|stop|restart}"
	exit 1
esac
exit $RETVAL

