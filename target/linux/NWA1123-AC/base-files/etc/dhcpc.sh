#!/bin/sh
#########################################################################
##  DHCPC Configuration
#########################################################################

. /etc/ath/apcfg
IPADDRESS="192.168.1.2"
NETMASK="netmask 255.255.255.0"
BROADCAST="broadcast 192.168.1.255"

    if [ "${WAN_MODE}" != "dhcp" ]
    then
       exit 0
    fi

    if [ ! -n "$1" ]
    then
        echo "Please input the name of new interface.."
        exit 0
    fi

##
# modify /etc/dhcp6c.conf
##
    if [ -f /etc/dhcp6c.conf ]
    then
        new_dhcp6c_conf=/tmp/dhcp6c.conf.tmp
        echo "interface $1 {" > $new_dhcp6c_conf
        sed /interface/d /etc/dhcp6c.conf >> $new_dhcp6c_conf
        mv -f $new_dhcp6c_conf /tmp/dhcp6c.conf
        unset new_dhcp6c_conf
    fi

##
# kill current processing
##
    killall -q udhcpc
    killall -q dhcp6c

##
# restart vsftpd daemon
##
    if [ -f /sbin/udhcpc ]
    then
        /sbin/ifconfig $1 $IPADDRESS $BROADCAST $NETMASK
        udhcpc -b -i $1 &
    fi

    if [ -f /sbin/dhcp6c ]
    then
        /sbin/dhcp6c -c /tmp/dhcp6c.conf $1
    fi

exit 0

