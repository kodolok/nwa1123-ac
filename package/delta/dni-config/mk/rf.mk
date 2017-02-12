
define Build/DniQcaRfConfig
#
# Qualcomm Atheros
#
	$(call Build/DniConfig,qca-art,__CONFIG_QCA_ART__,,)
	$(call Build/DniConfig,qca-art2,__CONFIG_QCA_ART2__,,)
	$(call Build/DniConfig,qca-artlna,__CONFIG_QCA_ARTLNA__,,)
	$(call Build/DniConfig,qca-hostap,__CONFIG_QCA_HOSTAP__,,)
	$(call Build/DniConfig,qca-spectral,__CONFIG_QCA_SPECTRAL__,,)
	$(call Build/DniConfig,qca-qcmbr,__CONFIG_QCA_QCMBR__,,)
	$(call Build/DniConfig,kmod-qca-wifi,__CONFIG_QCA_WLAN__,,)
	$(call Build/DniConfig,kmod-qca-wifi,CLI_QCA_WLAN_SUPPORT,klish,)
	$(call Build/DniConfig,kmod-qca-wifi,__FW_CHKSUM__,dni-misc,)
	$(call Build/DniConfig,SUPPORT_GPIO_MODULE,__QCA_GPIO_KO__,QCA_RF_WLAN_10_2,)
endef

define Build/DniMtkRfConfig
#
# Mediatek(Ralink) Inc.
#
	$(call Build/DniConfig,mtk-wsc_upnp,__CONFIG_MTK_WLAN__,,)
	$(call Build/DniConfig,mtk-wsc_upnp,__CONFIG_MTK_WSC_UPNP__,,)
	$(call Build/DniConfig,mtk-rt2880-app,__CONFIG_MTK_RT2880_APP__,,)
endef

define Build/DniRtkRfConfig
#
# Realtek Network
#
	$(call Build/DniConfig,rtk-auth,__CONFIG_RTK_WLAN__,,)
	$(call Build/DniConfig,rtk-auth,__FW_CHKSUM__,rtk-auth,)
	$(call Build/DniConfig,rtk-auth,UNIVERSAL_REPEATER,rtk-auth,)
	$(call Build/DniConfig,rtk-auth,WIFI_SIMPLE_CONFIG,rtk-auth,)
	$(call Build/DniConfig,rtk-auth,CONFIG_RTL_819X,rtk-auth,)
	$(call Build/DniConfig,rtk-auth,CONFIG_RTL_819XD,rtk-auth,)
	$(call Build/DniConfig,rtk-auth,DUAL_BAND,rtk-auth,)
	$(call Build/DniConfig,rtk-boot,__CONFIG_RTK_BOOT__,,)
	$(call Build/DniConfig,rtk-sigma-utils,__CONFIG_RTK_SIGMA__,,)
	$(call Build/DniConfig,rtk-mp-daemon,__CONFIG_RTK_MP_DAEMON__,,)
	$(call Build/DniConfig,rtk-wscd,__CONFIG_RTK_WSCD__,,)
endef

define Build/DniBcmRfConfig
#
# Broadcom Corporation
#
	$(call Build/DniConfig,kmod-wl,__CONFIG_BRCM_WLAN__,,)
	$(call Build/DniConfig,kmod-wl,__FW_CHKSUM__,dni-misc,)
endef

define Build/DniRfConfig
	echo "" >> ${PKG_BUILD_DIR}/dniconfig.h
	echo "/* RF Information */" >> ${PKG_BUILD_DIR}/dniconfig.h
	$(call Build/DniQcaRfConfig)
	$(call Build/DniRtkRfConfig)
	$(call Build/DniMtkRfConfig)
	$(call Build/DniBcmRfConfig)
endef