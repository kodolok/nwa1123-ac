
define Build/DniModConfig

	echo "" >> ${PKG_BUILD_DIR}/dniconfig.h
	echo "/* Kernel modules Information */" >> ${PKG_BUILD_DIR}/dniconfig.h
#
# Delta Networks, INC.
#
	$(call Build/DniConfig,kmod-dni-at24c08c,__CONFIG_AT24C08C_KO__,,)
	$(call Build/DniConfig,kmod-dni-at24c08c,EEPROM_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-dni-bridge,__CONFIG_BRIDGE_KO__,,)
	$(call Build/DniConfig,kmod-dni-dmapool,__CONFIG_DMAPOOL_KO__,,)
	$(call Build/DniConfig,kmod-dni-dsdt,__CONFIG_DSDT_KO__,,)
	$(call Build/DniConfig,kmod-dni-dsdt,CLI_SWITCH_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-dni-dsdt,CLI_VLAN_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-dni-dsdt,DSDT_SUBCPUPORT_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-dni-ipv6pass,__CONFIG_IPV6PASS_KO__,,)
	$(call Build/DniConfig,kmod-dni-logd,__CONFIG_LOGD_KO__,,)
	$(call Build/DniConfig,kmod-dni-lm75a,__CONFIG_LM75A_KO__,,)
	$(call Build/DniConfig,kmod-dni-lm75a,TEMPERATURE_SENSOR_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-dni-netfilter,__CONFIG_DNI_NETFILTER_KO__,,)
	$(call Build/DniConfig,kmod-dni-pcf857x,__CONFIG_PCF857X_KO__,,)
	$(call Build/DniConfig,kmod-dni-pcf857x,I2C_GPIO_EXPANDER_SUPPORT,dni-gpio-ctrl,)
	$(call Build/DniConfig,kmod-dni-pcf857x,CLI_I2C_GPIO_EXPANDER_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-dni-pca953x,__CONFIG_PCA953X_KO__,,)
	$(call Build/DniConfig,kmod-dni-pca953x,__CONFIG_PCF857X_KO__,,)
	$(call Build/DniConfig,kmod-dni-pca953x,I2C_GPIO_EXPANDER_SUPPORT,dni-gpio-ctrl,)
	$(call Build/DniConfig,kmod-dni-pca953x,CLI_I2C_GPIO_EXPANDER_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-dni-powr1014a,__CONFIG_PWR1014A_KO__,,)
	$(call Build/DniConfig,kmod-dni-powr1014a,VOLTAGE_SENSOR_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-qmi-gobinet,__CONFIG_DNI_CLI_SLQS__,,)
#
# Filesystems
#
	$(call Build/DniConfig,kmod-fs-autofs4,__CONFIG_FS_AUTOFS4_KO__,,)
	$(call Build/DniConfig,kmod-fs-exfat,__CONFIG_FS_EXFAT_KO__,,)
	$(call Build/DniConfig,kmod-fs-ext4,__CONFIG_FS_EXT4_KO__,,)
	$(call Build/DniConfig,kmod-fs-msdos,__CONFIG_FS_MSDOS_KO__,,)
	$(call Build/DniConfig,kmod-fs-ntfs,__CONFIG_FS_NTFS_KO__,,)
	$(call Build/DniConfig,kmod-fs-vfat,__CONFIG_FS_VFAT_KO__,,)
	$(call Build/DniConfig,kmod-fuse,__CONFIG_FUSE_KO__,,)
#
# Libraries
#
	$(call Build/DniConfig,kmod-lib-crc-ccitt,__CONFIG_LIB_CRC_CCITT_KO__,,)
	$(call Build/DniConfig,kmod-lib-crc16,__CONFIG_LIB_CRC16_KO__,,)
	$(call Build/DniConfig,kmod-lib-textsearch,__CONFIG_LIB_TEXTSEARCH_KO__,,)
	$(call Build/DniConfig,kmod-lib-zlib,__CONFIG_LIB_ZLIB_KO__,,)
#
# Native Language Support
#
	$(call Build/DniConfig,kmod-nls-base,__CONFIG_NLS_BASE_KO__,,)
	$(call Build/DniConfig,kmod-nls-cp437,__CONFIG_NLS_CP437_KO__,,)
	$(call Build/DniConfig,kmod-nls-cp850,__CONFIG_NLS_ISO850_KO__,,)
	$(call Build/DniConfig,kmod-nls-cp860,__CONFIG_NLS_ISO860_KO__,,)
	$(call Build/DniConfig,kmod-nls-cp932,__CONFIG_NLS_ISO932_KO__,,)
	$(call Build/DniConfig,kmod-nls-iso8859-1,__CONFIG_NLS_ISO8859_1_KO__,,)
	$(call Build/DniConfig,kmod-nls-iso8859-13,__CONFIG_NLS_ISO8859_13_KO__,,)
	$(call Build/DniConfig,kmod-nls-iso8859-2,__CONFIG_NLS_ISO8859_2_KO__,,)
	$(call Build/DniConfig,kmod-nls-iso8859-6,__CONFIG_NLS_ISO8859_6_KO__,,)
	$(call Build/DniConfig,kmod-nls-iso8859-8,__CONFIG_NLS_ISO8859_8_KO__,,)
	$(call Build/DniConfig,kmod-nls-utf8,__CONFIG_NLS_UTF8_KO__,,)
#
# Block Devices
#
	$(call Build/DniConfig,kmod-md-mod,__CONFIG_MD_MOD_KO__,,)
	$(call Build/DniConfig,kmod-md-linear,__CONFIG_MD_LINEAR_KO__,,)
	$(call Build/DniConfig,kmod-md-raid0,__CONFIG_MD_RAID0_KO__,,)
	$(call Build/DniConfig,kmod-md-raid1,__CONFIG_MD_RAID1_KO__,,)
	$(call Build/DniConfig,kmod-scsi-core,__CONFIG_SCSI_CORE_KO__,,)
	$(call Build/DniConfig,kmod-scsi-generic,__CONFIG_SCSI_GENERIC_KO__,,)
#
# Cryptographic API modules
#
	$(call Build/DniConfig,kmod-crypto-arc4,__CONFIG_CRYPTO_ARC4_KO__,,)
	$(call Build/DniConfig,kmod-crypto-core,__CONFIG_CRYPTO_CORE_KO__,,)
	$(call Build/DniConfig,kmod-crypto-ecb,__CONFIG_CRYPTO_ECB_KO__,,)
	$(call Build/DniConfig,kmod-crypto-hash,__CONFIG_CRYPTO_HASH_KO__,,)
	$(call Build/DniConfig,kmod-crypto-manager,__CONFIG_CRYPTO_MANAGER_KO__,,)
	$(call Build/DniConfig,kmod-crypto-ocf,__CONFIG_CRYPTO_OCF_KO__,,)
	$(call Build/DniConfig,kmod-crypto-sha1,__CONFIG_CRYPTO_SHA1_KO__,,)
#
# Netfilter Extensions
#
	$(call Build/DniConfig,kmod-ebtables,__CONFIG_NETFILTER_EBTABLES_KO__,,)
	$(call Build/DniConfig,kmod-ebtables-ipv4,__CONFIG_NETFILTER_EBTABLES_IPV4_KO__,,)
	$(call Build/DniConfig,kmod-ip6tables,__CONFIG_NETFILTER_IP6TABLES_KO__,,)
	$(call Build/DniConfig,kmod-ip6tables,__CONFIG_NETFILTER_IPT_CORE_KO__,,)
	$(call Build/DniConfig,kmod-ipt-conntrack,__CONFIG_NETFILTER_IPT_CONNTRACK_KO__,,)
	$(call Build/DniConfig,kmod-ipt-conntrack-extra,__CONFIG_NETFILTER_IPT_CONNTRACK_EXTRA_KO__,,)
	$(call Build/DniConfig,kmod-ipt-ct-sctp,__CONFIG_NETFILTER_IPT_CT_SCTP_KO__,,)
	$(call Build/DniConfig,kmod-ipt-extra,__CONFIG_NETFILTER_IPT_EXTRA_KO__,,)
	$(call Build/DniConfig,kmod-ipt-filter,__CONFIG_NETFILTER_IPT_FILTER_KO__,,)
	$(call Build/DniConfig,kmod-ipt-hashlimit,__CONFIG_NETFILTER_IPT_HASHLIMIT_KO__,,)
	$(call Build/DniConfig,kmod-ipt-ipopt,__CONFIG_NETFILTER_IPT_IPOPT_KO__,,)
	$(call Build/DniConfig,kmod-ipt-iprange,__CONFIG_NETFILTER_IPT_IPRANGE_KO__,,)
	$(call Build/DniConfig,kmod-ipt-ipsec,__CONFIG_NETFILTER_IPT_IPSEC_KO__,,)
	$(call Build/DniConfig,kmod-ipt-led,__CONFIG_NETFILTER_IPT_LED_KO__,,)
	$(call Build/DniConfig,kmod-ipt-mark2prio,__CONFIG_NETFILTER_IPT_MARK2PRIO_KO__,,)
	$(call Build/DniConfig,kmod-ipt-nat,__CONFIG_NETFILTER_IPT_NAT_KO__,,)
	$(call Build/DniConfig,kmod-ipt-nat-extra,__CONFIG_NETFILTER_IPT_NAT_EXTRA_KO__,,)
	$(call Build/DniConfig,kmod-ipt-nathelper,__CONFIG_NETFILTER_IPT_NATHELPER_KO__,,)
	$(call Build/DniConfig,kmod-ipt-nathelper-extra,__CONFIG_NETFILTER_IPT_NATHELPER_EXTRA_KO__,,)
	$(call Build/DniConfig,kmod-ipt-sctp,__CONFIG_NETFILTER_IPT_SCTP_KO__,,)
	$(call Build/DniConfig,kmod-ipt-tee,__CONFIG_NETFILTER_IPT_TEE_KO__,,)
	$(call Build/DniConfig,kmod-ipt-tproxy,__CONFIG_NETFILTER_IPT_TPROXY_KO__,,)
	$(call Build/DniConfig,kmod-ipt-u32,__CONFIG_NETFILTER_IPT_U32_KO__,,)
	$(call Build/DniConfig,kmod-ipt-ulog,__CONFIG_NETFILTER_IPT_ULOG_KO__,,)
	$(call Build/DniConfig,kmod-nf-conntrack-netlink,__CONFIG_NETFILTER_NF_CONNTRACK_NETLINK_KO__,,)
	$(call Build/DniConfig,kmod-nfnetlink,__CONFIG_NETFILTER_NFNETLINK_KO__,,)
#
# Network Support
#
	$(call Build/DniConfig,kmod-bonding,__CONFIG_BUNDING_KO__,,)
	$(call Build/DniConfig,kmod-ipip,__CONFIG_IPIP_KO__,,)
	$(call Build/DniConfig,kmod-iptunnel4,__CONFIG_IPTUNNEL4_KO__,,)
	$(call Build/DniConfig,kmod-iptunnel6,__CONFIG_IPTUNNEL6_KO__,,)
	$(call Build/DniConfig,kmod-ipv6,__CONFIG_IPV6_KO__,,)
	$(call Build/DniConfig,kmod-gre,__CONFIG_GRE_KO__,,)
	$(call Build/DniConfig,kmod-ip6-tunnel,__CONFIG_IP6_TUNNEL_KO__,,)
	$(call Build/DniConfig,kmod-l2tp,__CONFIG_L2TP_KO__,,)
	$(call Build/DniConfig,kmod-llc,__CONFIG_LLC_KO__,,)
	$(call Build/DniConfig,kmod-ppp,__CONFIG_PPP_KO__,,)
	$(call Build/DniConfig,kmod-mppe,__CONFIG_MPPE_KO__,,)
	$(call Build/DniConfig,kmod-pppoe,__CONFIG_PPPOE_KO__,,)
	$(call Build/DniConfig,kmod-pppol2tp,__CONFIG_PPPOL2TP_KO__,,)
	$(call Build/DniConfig,kmod-pppox,__CONFIG_PPPOX_KO__,,)
	$(call Build/DniConfig,kmod-pptp,__CONFIG_PPTP_KO__,,)
	$(call Build/DniConfig,kmod-sched-core,__CONFIG_SCHED_CORE_KO__,,)
	$(call Build/DniConfig,kmod-sit,__CONFIG_SIT_KO__,,)
	$(call Build/DniConfig,kmod-stp,__CONFIG_STP_KO__,,)
	$(call Build/DniConfig,kmod-tun,__CONFIG_TUN_KO__,,)
#
# Other modules
#
	$(call Build/DniConfig,kmod-regmap-spi,__CONFIG_REGMAP_SPI_KO__,,)
#
# USB Support
#
	$(call Build/DniConfig,kmod-usb-core,__CONFIG_USB_CORE_KO__,,)
	$(call Build/DniConfig,kmod-usb-gadget,__CONFIG_USB_GADGET_KO__,,)
	$(call Build/DniConfig,kmod-usb-gadget-dwc3,__CONFIG_USB_GADGET_DWC3_KO__,,)
	$(call Build/DniConfig,kmod-usb-gadget-dwc3-ipq,__CONFIG_USB_GADGET_DWC3_IPQ_KO__,,)
	$(call Build/DniConfig,kmod-usb-net,__CONFIG_USB_NET_KO__,,)
	$(call Build/DniConfig,kmod-usb-serial,__CONFIG_USB_SERIAL_KO__,,)
	$(call Build/DniConfig,kmod-usb-storage,__CONFIG_USB_STORAGE_KO__,,)
	$(call Build/DniConfig,kmod-usb-xhci,__CONFIG_USB_XHCI_KO__,,)
	$(call Build/DniConfig,kmod-usb2,__CONFIG_USB2_KO__,,)
endef