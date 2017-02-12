#!/bin/sh
# Create by Eric Chen
####################################################################
## MIB script
## 
## This script is used to setting MIB users. 
##
## snmp_user_config.sh
##
####################################################################
if [ "${1}" = "" ]; then
    echo "Please specify the OID."
    exit 255
fi

OID=$1
VALUE=$2


## System Contact
if [ "${OID}" = "1" ];then
    ## read
    if [ "${VALUE}" = "" ]; then
        SYSCONTACT=`cfg -v SYS_CONTACT`
        echo -e ${SYSCONTACT}
        exit 0
    fi
    ## write
    cfg -a SYS_CONTACT=${VALUE}
    cfg -c
    exit 0
fi

## System Location
if [ "${OID}" = "2" ];then
    ## read
    if [ "${VALUE}" = "" ]; then
        SYSLOCATION=`cfg -v SYS_LOCATION`
        echo -e ${SYSLOCATION}
        exit 0
    fi
    ## write
    cfg -a SYS_LOCATION=${VALUE}
    cfg -c
    exit 0
fi

## System Name
if [ "${OID}" = "3" ];then
    ## read
    if [ "${VALUE}" = "" ]; then
        SYSNAME=`cfg -v SYS_NAME`
        echo -e ${SYSNAME}
        exit 0
    fi
    ## write
    cfg -a SYS_NAME=${VALUE}
    hostname ${VALUE}
    cfg -c
    exit 0
fi

exit 0
