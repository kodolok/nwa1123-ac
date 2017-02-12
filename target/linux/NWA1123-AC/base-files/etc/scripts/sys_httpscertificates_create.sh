HTTPS_CNF_FILE="/etc/mini_httpd.cnf"
HTTPS_CERT_FLAG="`cfg -v HTTPS_CERT_FLAG`"

if [ ${HTTPS_CERT_FLAG:=0} = "0" ]
then
    killall -q mini_httpd
    echo "`openssl req -nodes -sha256 -newkey rsa:2048 -x509 -days 3650 -config $HTTPS_CNF_FILE -out /tmp/mini_httpd.pem -keyout /tmp/mini_httpd.pem << EOF






    EOF`"
    echo "`openssl x509 -sha256 -noout -in /tmp/mini_httpd.pem`"
# #    echo "`chmod 600 mini_httpd.pem`"
    
    if [ ! -d "/tmp/certs/" ]; then
        tar -zcv -f /tmp/mtd4.tar /tmp/mini_httpd.pem
    else
        tar -zcv -f /tmp/mtd4.tar /tmp/certs /tmp/mini_httpd.pem
    fi
    TMP_CERT_LENGTH=`wc -c /tmp/mtd4.tar | awk '{print $1}'`
    dd if=/tmp/mtd4.tar of=/dev/mtdblock4 bs=$TMP_CERT_LENGTH count=1
    cfg -a CERT_LENGTH="$TMP_CERT_LENGTH"
    cfg -a HTTPS_CERT_FLAG="1"
    cfg -c
    rm /tmp/mtd4.tar

    if [ -f /usr/sbin/mini_httpd ]
    then
        /usr/sbin/mini_httpd -C /tmp/mini_httpd.conf
        /usr/sbin/mini_httpd -C /tmp/mini_httpd_ssl.conf
    fi
fi

exit 0
