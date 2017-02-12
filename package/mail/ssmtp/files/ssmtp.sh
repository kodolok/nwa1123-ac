#!/bin/sh
#

RETVAL=0
prog_name="ssmtp"
prog="/sbin/$prog_name"

username=`config get email_username`
password=`config get email_password`
smtp=`config get email_smtp`
toaddr=`config get email_addr`
fromaddr=`config get email_from_assign`
subject=`config get email_subject`
usessl=`config get email_usessl`
port=`config get email_port`
log_file="/tmp/log/messages"
send_log_file="/tmp/log/send_messages"
ssmtp_conf="/tmp/ssmtp.conf"

start() {
	# Start daemons.
	echo $"Starting up $prog_name "

	echo  "root=$fromaddr" > $ssmtp_conf
	echo  "mailhub=$smtp:$port" >> $ssmtp_conf
	echo  "AuthUser=$username" >> $ssmtp_conf
	echo  "AuthPass=$password" >> $ssmtp_conf
	if [ "$usessl" = "1" ]; then
     		echo  "UseSTARTTLS=YES" >> $ssmtp_conf
	fi
	echo  "Subject: $subject" > $send_log_file
	echo  "==========" >> $send_log_file
	cat  $log_file >> $send_log_file

	${prog} ${toaddr} -d < ${send_log_file} &

	RETVAL=$?
	echo
	return $RETVAL
}

stop() {
	# Stop daemons.
	echo $"Shutting down $prog_name "
	killall $prog_name

	RETVAL=$?
	echo
	return $RETVAL
}

# See how we were called.
case "$1" in
  start)
	start $2
	;;
  stop)
	stop
	;;
  restart|reload)
	stop
	start $2
	RETVAL=$?
	;;
  *)
	echo $"Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $RETVAL



