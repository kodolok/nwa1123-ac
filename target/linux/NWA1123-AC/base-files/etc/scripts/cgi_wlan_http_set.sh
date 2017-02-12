#!/bin/sh
#########################################################################
##  Mini_httpd Conf.
##  Usage:
##  sh cgi_wlan_http_set.sh <default>
##  By mike.hc.chen
#########################################################################

if [ $1 ] && [ $1 = default ]
then
  unset MODE
  unset MGMT_WWW_PORT
else
  . /etc/ath/apcfg
fi

# if HTTP_SERVER_MODE is not defined, MODE=http ; else MODE=$HTTP_SERVER_MODE
MODE=${HTTP_SERVER_MODE="http"}

##
# make new conf file
##

HTTP_CONFIG_FILE="/tmp/mini_httpd.conf"
HTTPS_CONFIG_FILE="/tmp/mini_httpd_ssl.conf"


if [ $MODE = https ]
then
    CONFIG_FILE=$HTTPS_CONFIG_FILE
else
    CONFIG_FILE=$HTTP_CONFIG_FILE
fi


#cat $CONFIG_FILE | sed /port/d  > $CONFIG_FILE

echo "dir=/usr/www" > $CONFIG_FILE
echo "cgipat=cgi-bin/*" >> $CONFIG_FILE
echo "user=root" >> $CONFIG_FILE


if [ $MODE = https ]
then
    echo port=${MGMT_WWW_PORT:=443} >> $CONFIG_FILE
    echo ssl >> $CONFIG_FILE
    echo "certfile=/tmp/mini_httpd.pem" >> $CONFIG_FILE
else
    echo port=${MGMT_WWW_PORT:=80} >> $CONFIG_FILE
fi

##
# kill running mini_httpd
##
    killall -q mini_httpd

##
# restart mini_httpd
##
    if [ -f /usr/sbin/mini_httpd ]
    then
        /usr/sbin/mini_httpd -C $CONFIG_FILE
    fi

##
# set ACL rules
##
    sh /etc/scripts/acl_setrule

exit 0
