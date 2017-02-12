#!/bin/sh
#########################################################################
##  Mini_httpd Conf.
##  MGMT_HTTP_PORT=<http port number>
##  MGMT_HTTPS_PORT=<https port number>
##  Usage:
##  sh cgi_httpd_config.sh <default>
##  By mike.hc.chen
##  Modified By zc.lin
#########################################################################

if [ $1 ] && [ "$1" = default ]
then
  unset MGMT_HTTP_PORT
  unset MGMT_HTTPS_PORT
else
  MGMT_HTTP_PORT=`cfg -v MGMT_HTTP_PORT` 
  MGMT_HTTPS_PORT=`cfg -v MGMT_HTTPS_PORT` 

  if [ ! -n "$MGMT_HTTP_PORT" ]
  then
      unset MGMT_HTTP_PORT
  fi

  if [ ! -n "$MGMT_HTTPS_PORT" ]
  then
      unset MGMT_HTTPS_PORT
  fi
  #  . /etc/ath/apcfg
  # use cfg -v instead of soucing to get great efficient improvement
fi

##
# make new conf file
##

HTTP_CONFIG_FILE="/tmp/mini_httpd.conf"
HTTPS_CONFIG_FILE="/tmp/mini_httpd_ssl.conf"

#cat $HTTP_CONFIG_FILE | sed /port/d  > $HTTP_CONFIG_FILE

echo "dir=/usr/www" > $HTTP_CONFIG_FILE
echo "cgipat=cgi-bin/*" >> $HTTP_CONFIG_FILE
echo "user=root" >> $HTTP_CONFIG_FILE
echo port=${MGMT_HTTP_PORT:=80} >> $HTTP_CONFIG_FILE

echo "dir=/usr/www" > $HTTPS_CONFIG_FILE
echo "cgipat=cgi-bin/*" >> $HTTPS_CONFIG_FILE
echo "user=root" >> $HTTPS_CONFIG_FILE
echo port=${MGMT_HTTPS_PORT:=443} >> $HTTPS_CONFIG_FILE
echo ssl >> $HTTPS_CONFIG_FILE
echo "certfile=/tmp/mini_httpd.pem" >> $HTTPS_CONFIG_FILE

##
# kill running mini_httpd
##
    killall -q mini_httpd

##
# restart mini_httpd
##
if [ -f /usr/sbin/mini_httpd ]
then
    /usr/sbin/mini_httpd -C $HTTP_CONFIG_FILE 2>/dev/null
    /usr/sbin/mini_httpd -C $HTTPS_CONFIG_FILE 2>/dev/null
fi

##
# set ACL rules
##
    sh /etc/scripts/acl_setrule

exit 0
