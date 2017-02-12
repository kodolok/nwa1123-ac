
define Build/DniPkgConfig

	echo "" >> ${PKG_BUILD_DIR}/dniconfig.h
	echo "/* Package Information */" >> ${PKG_BUILD_DIR}/dniconfig.h
	
	$(call Build/DniConfig,TARGET_ROOTFS_INITRAMFS,__CONFIG_TARGET_ROOTFS_INITRAMFS__,,)
#
# Delta Networks, INC.
#
	$(call Build/DniConfig,dni-cal,__CONFIG_CAL__,,)
	$(call Build/DniConfig,dni-chkpwd,__CONFIG_CHKPWD__,,)
	$(call Build/DniConfig,dni-cli,__CONFIG_CLI__,,)
	$(call Build/DniConfig,dni-clusterd,__CONFIG_CLUSTERD__,,)
	$(call Build/DniConfig,dni-clusterd,CLI_CLUSTER_SUPPORT,klish,)
	$(call Build/DniConfig,dni-datalib,__CONFIG_DATALIB__,,)
	$(call Build/DniConfig,SUPPORT_DNI_UCI,__CONFIG_DNI_UCI__,dni-datalib,)
	$(call Build/DniConfig,dni-gpio-ctrl,__CONFIG_GPIOD__,,)
	$(call Build/DniConfig,dni-gpio-ctrl,CLI_GPIOCTL_SUPPORT,klish,)
	$(call Build/DniConfig,dni-i1905d1,__CONFIG_DNI_IEEE1905D1__,,)
	$(call Build/DniConfig,dni-i2c-ctrl,__CONFIG_I2C_CTL__,,)
	$(call Build/DniConfig,dni-i2c-ctrl,EEPROM_I2C_DEV,dni-i2c-ctrl,"/dev/i2c-0",string)
	$(call Build/DniConfig,dni-i2c-ctrl,EEPROM_I2C_ADDR,dni-i2c-ctrl,0x50,)
	$(call Build/DniConfig,dns-ipupdate,__CONFIG_DNS_IPUPDATE__,,)
	$(call Build/DniConfig,dni-llmnr,__CONFIG_LLMNR__,,)
	$(call Build/DniConfig,dni-logd,__CONFIG_LOGD__,,)
	$(call Build/DniConfig,dni-plcd,__CONFIG_DNI_PLCD__,,)
	$(call Build/DniConfig,dni-misc,__CONFIG_DNI_MISC__,,)
	$(call Build/DniConfig,dni-mtd,__CONFIG_DNI_MTD__,,)
	$(call Build/DniConfig,dni-net-disk,__CONFIG_DNI_NET_DISK__,,)
	$(call Build/DniConfig,dni-net-scan,__CONFIG_NETSCAN__,,)
	$(call Build/DniConfig,dni-netbios-ns,__CONFIG_NETBIOS_NS__,,)
	$(call Build/DniConfig,dni-net-web,__CONFIG_NETWEB__,,)
	$(call Build/DniConfig,SUPPORT_HTTPS,__CONFIG_NETWEB_HTTPS__,dni-net-web,)
	$(call Build/DniConfig,dni-ntpclient,__CONFIG_NTPCLIENT__,,)
	$(call Build/DniConfig,dni-ntpclient,CLI_NTPCLIENT_SUPPORT,klish,)
	$(call Build/DniConfig,dni-transwd,__CONFIG_TRANSWD__,,)
	$(call Build/DniConfig,dni-svcwdogd,__CONFIG_SVCWDOGD__,,)
	$(call Build/DniConfig,dni-ripd,__CONFIG_DNI_RIPD__,,)
	$(call Build/DniConfig,dni-userlogin,__CONFIG_USERLOGIN__,,)
	$(call Build/DniConfig,dni-watchdogd,__CONFIG_WATCHDOGD__,,)
	$(call Build/DniConfig,dni-wide-dhcpv6,__CONFIG_WIDE_DHCPV6__,,)
	$(call Build/DniConfig,dni-zdp,__CONFIG_ZDP__,,)
#
# Base system
#
	$(call Build/DniConfig,base-files,__CONFIG_BASE_FILES__,,)
	$(call Build/DniConfig,bridge,__CONFIG_BRIDGE__,,)
	$(call Build/DniConfig,busybox,__CONFIG_BUSYBOX__,,)
	$(call Build/DniConfig,BUSYBOX_CONFIG_FDISK,__CONFIG_FDISK_COMMAND__,busybox,)
#
# System Logging Utilities
#
	$(call Build/DniConfig,dnsmasq,__CONFIG_DNSMASQ__,,)
#
# Configuration
#
	$(call Build/DniConfig,dropbear,__CONFIG_DROPBEAR__,,)
	$(call Build/DniConfig,encrypt,__CONFIG_ENCRYPT__,,)
	$(call Build/DniConfig,hotplug2,__CONFIG_HOTPLUG2__,,)
	$(call Build/DniConfig,lltd,__CONFIG_LLTD__,,)
	$(call Build/DniConfig,lltd,THE_SAME_NETBIOS_HOSTNAME,,)
	#$(call Build/DniConfig,_mtd=,__CONFIG_MTD__,,)
	$(call Build/DniConfig,opkg=,__CONFIG_OPKG__,,)
	$(call Build/DniConfig,proccgi,__CONFIG_PROCCGI__,,)
	$(call Build/DniConfig,tacacs,__CONFIG_TACACS__,,)
	$(call Build/DniConfig,resolveip,__CONFIG_RESOLVEIP__,,)
	$(call Build/DniConfig,wireless-tools,__CONFIG_WIRELESS_TOOLS__,,)
#
# Network
#
	$(call Build/DniConfig,ebtables,__CONFIG_EBTABLES__,,)
	$(call Build/DniConfig,iftop,__CONFIG_IFTOP__,,)
	$(call Build/DniConfig,_ip=,__CONFIG_IP__,,)
	$(call Build/DniConfig,iperf=,__CONFIG_IPERF__,,)
	$(call Build/DniConfig,iperf3=,__CONFIG_IPERF3__,,)
	$(call Build/DniConfig,iperf-mt,__CONFIG_IPERF_MT__,,)
	$(call Build/DniConfig,minidlna,__CONFIG_MINIDLNA__,,)
	$(call Build/DniConfig,rstp,__CONFIG_RSTP__,,)
	$(call Build/DniConfig,rstp,CLI_RSTP_SUPPORT,klish,)
	$(call Build/DniConfig,snmpd,__CONFIG_NETSNMP__,,)
	$(call Build/DniConfig,snmpd-static,__CONFIG_NETSNMP_STATIC__,,)
	$(call Build/DniConfig,_tc=,__CONFIG_IPROUTE2__,,)
#
# File Transfer
#
	$(call Build/DniConfig,curl=,__CONFIG_CURL__,,)
	$(call Build/DniConfig,proftpd,__CONFIG_PROFTPD__,,)
	$(call Build/DniConfig,vsftpd,__CONFIG_VSFTPD__,,)
#
# Filesystem
#
	$(call Build/DniConfig,samba,__CONFIG_SAMBA__,,)
#
# Firewall
#
	$(call Build/DniConfig,_iptables=,__CONFIG_IPTABLES__,,)
	$(call Build/DniConfig,_ip6tables=,__CONFIG_IP6TABLES__,,)
#
# Routing and Redirection
#
	$(call Build/DniConfig,_lldpd=,__CONFIG_LLDPD__,,)
#
# Web Servers/Proxies
#
	$(call Build/DniConfig,_mini-httpd=,__CONFIG_MINI_HTTPD__,,)
	$(call Build/DniConfig,_mini-httpd-htpasswd,__CONFIG_MINI_HTTPD_HTPASSWD__,,)
	$(call Build/DniConfig,_mini-httpd-openssl,__CONFIG_MINI_HTTPD_OPENSSL__,,)
#
# IP Addresses and Names
#
	$(call Build/DniConfig,avahi-autoipd,__CONFIG_AVAHI_AUTOIPD__,,)
	$(call Build/DniConfig,avahi-daemon,__CONFIG_AVAHI_DAEMON__,,)
	$(call Build/DniConfig,avahi-dnsconfd,__CONFIG_AVAHI_DNSCONFD__,,)
	$(call Build/DniConfig,avahi-utils,__CONFIG_AVAHI_UTILS__,,)
	$(call Build/DniConfig,mini-upnp,__CONFIG_MINI_UPNP__,,)
	$(call Build/DniConfig,miniigd,__CONFIG_MINIIGD__,,)
	$(call Build/DniConfig,udhcp,__CONFIG_U_DHCP__,,)
#
# Performance monitoring tools
#
	$(call Build/DniConfig,sysstat,__CONFIG_SYSTAT__,,)
#
# Mail
#
	$(call Build/DniConfig,ssmtp,__CONFIG_SSMTP__,,)
	$(call Build/DniConfig,udhcp,__CONFIG_U_DHCP__,,)
#
# IPv6
#

#
# wide-dhcpv6
#
	$(call Build/DniConfig,wide-dhcpv6-client,__CONFIG_DHCPV6C__,,)
	$(call Build/DniConfig,wide-dhcpv6-control,__CONFIG_DHCPV6S_CONTROL__,,)
	$(call Build/DniConfig,wide-dhcpv6-relay,__CONFIG_DHCPV6S_RELAY__,,)
	$(call Build/DniConfig,wide-dhcpv6-server,__CONFIG_DHCPV6S__,,)
#
# Boot Loaders
#
	$(call Build/DniConfig,u-boot,__CONFIG_U_BOOT__,,)
#
# Utilities
#
	$(call Build/DniConfig,flatfsd,__CONFIG_FLATFSD__,,)
	$(call Build/DniConfig,dbus,__CONFIG_DBUS__,,)
	$(call Build/DniConfig,openssl-util,__CONFIG_OPENSSL_UTIL__,,)
	$(call Build/DniConfig,snarf,__CONFIG_SNARF__,,)
#
# Filesystem
#
	$(call Build/DniConfig,badblocks,__CONFIG_BADBLOCKS__,,)
	$(call Build/DniConfig,blkid,__CONFIG_BLKID__,,)
	$(call Build/DniConfig,dosfsck,__CONFIG_DOSFSCK__,,)
	$(call Build/DniConfig,dosfslabel,__CONFIG_DOSFSLABEL__,,)
	$(call Build/DniConfig,dosfstools,__CONFIG_DOSFSTOOLS__,,)
	$(call Build/DniConfig,e2fsprogs,__CONFIG_E2FSPROGS__,,)
	$(call Build/DniConfig,mkdosfs,__CONFIG_MKDOSFS__,,)
	$(call Build/DniConfig,ntfs-3g,__CONFIG_NTFS_3G__,,)
	$(call Build/DniConfig,ntfs-3g-low,__CONFIG_NTFS_3G_LOW__,,)
	$(call Build/DniConfig,ntfs-3g-utils,__CONFIG_NTFS_3G_UTILS__,,)
	$(call Build/DniConfig,ntfsprogs,__CONFIG_NTFSPROGS__,,)
	$(call Build/DniConfig,resize2fs,__CONFIG_RESIZE2FS__,,)
	$(call Build/DniConfig,tune2fs,__CONFIG_TUNE2FS__,,)
	$(call Build/DniConfig,uuidgen,__CONFIG_UUIDGEN__,,)
#
# disc
#
	$(call Build/DniConfig,hdparm,__CONFIG_HDPARM__,,)
	$(call Build/DniConfig,sdparm,__CONFIG_SDPARM__,,)
	$(call Build/DniConfig,_bc=,__CONFIG_BC__,,)
	$(call Build/DniConfig,_dc=,__CONFIG_DC__,,)
	$(call Build/DniConfig,dropbearconvert,__CONFIG_DROPBEARCONVERT__,,)
	$(call Build/DniConfig,iconv,__CONFIG_ICONV__,,)
	$(call Build/DniConfig,iozone,__CONFIG_IOZONE__,,)
	$(call Build/DniConfig,klish,__CONFIG_DNI_KLISH_CLI__,,)
	$(call Build/DniConfig,openssl-util,__CONFIG_OPENSSL_UTIL_CLI__,,)
	$(call Build/DniConfig,parted,__CONFIG_PARTED__,,)
	$(call Build/DniConfig,_udev=,__CONFIG_UDEV__,,)
	$(call Build/DniConfig,_udevtrigger,__CONFIG_UDEVTRIGGER__,,)
#
# database
#
	$(call Build/DniConfig,ffmpeg,__CONFIG_FFMPEG__,,)

	$(call Build/DniConfig,buffaloddns,__CONFIG_BUFFALO_DDNS_,,)
	$(call Build/DniConfig,ez-ipupdate,__CONFIG_EZ_IPUPDATE__,,)
	$(call Build/DniConfig,_ppp=,__CONFIG_PPP__,,)
endef