#
# Copyright (c) 2014 Qualcomm Atheros, Inc..
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

-include $(TOPDIR)/.config
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/kernel-build.mk

PKG_NAME:=qca-wifi
PKG_VERSION:=$(call qstrip,$(CONFIG_TARGET_RF_VERSION))
PKG_RELEASE:=22

PKG_BUILD_USE_DNI_CONFIG:=y
DNI_DATALIB_DEPEND:=n

TARGET_BOARD:=$(call qstrip,$(CONFIG_TARGET_PLATFORM_BOARD))

VER_DIR:=$(PKG_VERSION)
ifeq ($(PKG_VERSION),10.4)
ifeq ($(TARGET_BOARD),ipq40xx)
VER_DIR:=$(PKG_VERSION)_$(TARGET_BOARD)
endif
WLAN_VER:=10.4
WIFI_FW_VER_INFO_FILE_INSTALL:= $(INSTALL_DIR)
else 
ifeq ($(PKG_VERSION),10.2)
WLAN_VER:=10.2
WIFI_FW_VER_INFO_FILE_INSTALL:= $(CP) $(PKG_BUILD_DIR)/include/wifi_fw_version.info
else
WLAN_VER:=$(PKG_VERSION)
WIFI_FW_VER_INFO_FILE_INSTALL:= $(INSTALL_DIR)
endif
endif

PACKAGE_SRC_DIR=${CURDIR}/src_$(VER_DIR)
include $(INCLUDE_DIR)/package.mk

export INSTALL_ROOT=$(PKG_INSTALL_DIR)

QCAWLAN_HEADERS_FORCE_DISABLE:=0
ATHTESTCMD_TOOLS_FORCE_DISABLE:=0
OL_FW_FORCE_DISABLE:=0
ifneq (,$(findstring 9.2,$(WLAN_VER)))
QCAWLAN_HEADERS_FORCE_DISABLE:=1
ATHTESTCMD_TOOLS_FORCE_DISABLE:=1
OL_FW_FORCE_DISABLE:=1
else
ifneq (,$(findstring 10.2.,$(WLAN_VER)))
QCAWLAN_HEADERS_FORCE_DISABLE:=1
ATHTESTCMD_TOOLS_FORCE_DISABLE:=1
OL_FW_FORCE_DISABLE:=1
endif
endif

KERNEL_CROSS:=$(TARGET_CROSS)
BOARD_CONFIG_DIR:=conf/$(ARCH)/$(VER_DIR)

DFS_ENABLE:=1
PKTLOG_ENABLE:=1
SPECTRAL_ENABLE:=0
TX99_ENABLE:=0
GPIO_MODULE_ENABLE:=0
CONFIGIN_FILE:=Config.in
CONFIGIN_FILE_INSTALL:=
BOARD_FLAGS_FILE:=${CURDIR}/$(BOARD_CONFIG_DIR)/BoardFlags.mk
ifneq ($(wildcard $(BOARD_FLAGS_FILE)),)
include $(BOARD_FLAGS_FILE)
CONFIGIN_FILE:=$(BOARD_CONFIG_DIR)/Config.in
CONFIGIN_FILE_INSTALL:=rm -f ${CURDIR}/Config.in;cp -f ${CURDIR}/$(BOARD_CONFIG_DIR)/Config.in ${CURDIR}/Config.in
endif

ATH_TOOLS:= wlanconfig cgiMain wifitool 80211stats athstats apstats
ifneq (,$(findstring 9.2,$(WLAN_VER)))
ATH_TOOLS:= wlanconfig cgiMain 80211stats athstats athstatsclr
endif
ifneq ($(CONFIG_TARGET_RF_VERSION),)
CONF_PATH:=${CURDIR}/$(BOARD_CONFIG_DIR)
ifneq ($(wildcard $(CONF_PATH)),)
include $(CONF_PATH)/config.$(TARGET_BOARD)
endif
endif
KERNEL_TARGET:=$(TARGETARCH)

DEP_TARGET:=
ifeq ($(CONFIG_PACKAGE_kmod-qca-nss-drv),y)
  	DEP_TARGET:=kmod-qca-nss-drv
endif

MADWIFI_AUTOLOAD:= \
	adf \
	asf \
	ath_hal \
	ath_rate_atheros \
	ath_dev \
	umac

MOD_FILES:= \
	$(PKG_BUILD_DIR)/adf/adf.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/asf/asf.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/lmac/ath_dev/ath_dev.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/os/linux/ath_hal/ath_hal.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/lmac/ratectrl/ath_rate_atheros.$(LINUX_KMOD_SUFFIX) \
	$(PKG_BUILD_DIR)/umac/umac.$(LINUX_KMOD_SUFFIX)
	
ifeq ($(PKTLOG_ENABLE),1)
	ATH_TOOLS += pktlogconf
  	MADWIFI_AUTOLOAD += ath_pktlog
  	MOD_FILES += $(PKG_BUILD_DIR)/lmac/ath_pktlog/ath_pktlog.$(LINUX_KMOD_SUFFIX)
endif

ifeq ($(DFS_ENABLE),1)
	ATH_TOOLS += pktlogconf
ifeq ($(CONFIG_SUPPORT_DFS_NOL_CHECK),y)
	BOARD_FLAGS+=-DDNI_PATCH_FOR_DFS_NOL_CHECK
	ATH_TOOLS += radartool
endif
  	MADWIFI_AUTOLOAD += ath_dfs
  	MOD_FILES += $(PKG_BUILD_DIR)/lmac/dfs/ath_dfs.$(LINUX_KMOD_SUFFIX)
endif

ATHTESTCMD_TOOLS :=
ifeq ($(ATHTESTCMD_ENABLE),1)
	ATHTESTCMD_TOOLS := athtestcmd
endif

ifeq ($(SPECTRAL_ENABLE),1)
  	MADWIFI_AUTOLOAD += ath_spectral
  	MOD_FILES += $(PKG_BUILD_DIR)/lmac/spectral/ath_spectral.$(LINUX_KMOD_SUFFIX)
endif

ifeq ($(TX99_ENABLE),1)
  	MADWIFI_AUTOLOAD += hst_tx99
  	MOD_FILES += $(PKG_BUILD_DIR)/lmac/tx99/hst_tx99.$(LINUX_KMOD_SUFFIX)
endif

ifeq ($(GPIO_MODULE_ENABLE),1)
  	MADWIFI_AUTOLOAD += ath_gpio
  	MOD_FILES += $(PKG_BUILD_DIR)/lmac/gpio/ath_gpio.$(LINUX_KMOD_SUFFIX)
endif

QCAWLAN_HEADERS:= \
   adf/include/os/adf_os_types.h \
   asf/include/asf_amem.h \
   include/ieee80211_defines.h \
   include/_ieee80211.h \
   include/ieee80211.h \
   include/ieee80211_wnm_proto.h \
   include/if_upperproto.h \
   include/compat.h \
   include/wlan_opts.h \
   include/sys/queue.h \
   include/ieee80211_phytype.h \
   include/ieee80211_rrm.h \
   hal/linux/ah_osdep.h \
   os/linux/include/ath_ald_external.h \
   os/linux/include/ieee80211_external.h \
   os/linux/include/ieee80211_ioctl.h \
   os/linux/include/ieee80211_ev.h \
   os/linux/include/ieee80211_wpc.h \
   os/linux/tools/athrs_ctrl.h \
   lmac/ath_dev/if_athioctl.h \
   lmac/dfs/dfs_ioctl.h \
   lmac/spectral/spectral_ioctl.h \
   umac/include/ieee80211_aow_shared.h \
   include/acfg_event_types.h \
   include/acfg_drv_if.h \
   include/acfg_api_types.h\
   include/acfg_wsupp_types.h \
   include/acfg_wsupp_api.h \
   include/acfg_misc.h \
   include/acfg_event.h \
   include/acfg_api.h \
   include/appbr_if.h \
   include/appbr_types.h \
   include/bypass_types.h \
   offload/include/a_types.h \
   offload/include/ol_txrx_stats.h \
   offload/include/ol_params.h

ifeq ($(WLAN_VER),10.2)
QCAWLAN_HEADERS += \
   include/athdefs.h \
   include/wal_dbg_stats.h \
   offload/os/linux/include/athtypes_linux.h
else
QCAWLAN_HEADERS += \
   offload/include/athdefs.h \
   offload/include/wlan_defs.h
endif

ifeq ($(BAND_STEERING_ENABLE),1)
QCAWLAN_HEADERS += include/ieee80211_band_steering_api.h
endif

ifeq ($(QCAWLAN_HEADERS_FORCE_DISABLE),1)
QCAWLAN_HEADERS:=
QCAWLAN_HEADERS_INSTALL :=
else
QCAWLAN_HEADERS_INSTALL := $(INSTALL_DIR) $(STAGING_DIR)/usr/include;$(CP) $(foreach header,$(QCAWLAN_HEADERS),$(PKG_BUILD_DIR)/$(header)) $(STAGING_DIR)/usr/include
endif

define KernelPackage/qca-wifi
  SUBMENU:=WiFi Driver
  CATEGORY:=Qualcomm Atheros
  DEPENDS:=$(DEP_TARGET) +libc +libgcc_s
  TITLE:=Module for QCA WLAN $(PKG_VERSION)
  VERSION:=$(LINUX_VERSION)+$(PKG_VERSION)-$(BOARD)-$(PKG_RELEASE)
  FILES:= $(MOD_FILES)
  #AUTOLOAD:=$(call AutoLoad,50,$(MADWIFI_AUTOLOAD))
endef

define KernelPackage/qca-wifi/description
This package contains a LSDK WLAN kernel modules.
endef

KERNEL_MAKEOPTS=PATH="$(KERNEL_STAGING_DIR):$(TARGET_PATH)" \
		TOOLPREFIX="$(KERNEL_CROSS)" \
		TOOLPATH="$(KERNEL_CROSS)"

MADWIFI_ENVOPTS:= \
		ARCH=$(LINUX_KARCH) CROSS_COMPILE=$(TARGET_CROSS)\
		KERNELPATH="$(LINUX_DIR)" \
		TARGET="$(TARGETARCH)" \
		COMMON_CFLAGS="-DCONFIG_NO_SAVE_CALDATA $(BOARD_FLAGS)"
		
DUT_INC="-I$(PKG_BUILD_DIR) -I$(PKG_BUILD_DIR)/os/linux/include -I$(PKG_BUILD_DIR)/include"
MADWIFI_TOOLOPTS:= $(MADWIFI_ENVOPTS) INC=$(DUT_INC) CC=$(TARGET_CROSS)gcc LD=$(TARGET_CROSS)ld

ifeq ($(CONFIG_TARGET_ipq806x),y)
# To fix compile fail issue on the pre-buit toolchain
MADWIFI_TOOLOPTS += KERNELPATH=$(PKG_BUILD_DIR)
endif

ATH_TOOLS_COMPILE1 :=
ATH_TOOLS_COMPILE2 :=
ATH_TOOLS_COMPILE3 :=
ATH_TOOLS_INSTALL := $(INSTALL_DIR)
ATH_TOOLS_UNINSTALL :=
ifneq ($(ATH_TOOLS),)
	ATH_TOOLS_COMPILE1 := cd $(PKG_BUILD_DIR)/os/linux/tools
	ATH_TOOLS_COMPILE2 :=  && rm -f $(ATH_TOOLS)
	ATH_TOOLS_COMPILE3 :=  && make $(MADWIFI_TOOLOPTS) clean $(ATH_TOOLS)
	ATH_TOOLS_INSTALL := $(CP) $(foreach file,$(ATH_TOOLS),$(PKG_BUILD_DIR)/os/linux/tools/$(file))
	ATH_TOOLS_UNINSTALL := rm -rf $(foreach file,$(ATH_TOOLS),$(PKG_BUILD_DIR)/os/linux/tools/$(file))
endif


ATHTESTCMD_TOOLS_COMPILE1 :=
ATHTESTCMD_TOOLS_COMPILE2 :=
ATHTESTCMD_TOOLS_INSTALL := $(INSTALL_DIR)
ATHTESTCMD_TOOLS_LIB_INSTALL := $(INSTALL_DIR)
ATHTESTCMD_TOOLS_UNINSTALL := rm -rf $(PKG_INSTALL_DIR)
ATHTESTCMD_TOOLS_LIB_UNINSTALL := rm -rf $(PKG_INSTALL_DIR)

ifneq ($(ATHTESTCMD_TOOLS),)
	ifeq ($(PKG_VERSION),10.4)
		ATHTESTCMD_TOOLS_DIR := $(PKG_BUILD_DIR)/halphy_tools/host/testcmd_tlv
	else
		ATHTESTCMD_TOOLS_DIR := $(PKG_BUILD_DIR)/offload/tools/systemtools/testcmd_tlv
	endif
	ATHTESTCMD_TOOLS_OUT_DIR := $(ATHTESTCMD_TOOLS_DIR)/Linux
	ATHTESTCMD_TOOLS_MAKEFILE := -f makefile.linux WORKAREA=$(PERF_PWR_OFFLOAD_DIR_PATH)
	ATHTESTCMD_TOOLS_COMPILE1 := cd $(ATHTESTCMD_TOOLS_DIR)
	ATHTESTCMD_TOOLS_COMPILE2 :=  && make $(ATHTESTCMD_TOOLS_MAKEFILE)

	ATHTESTCMD_TOOLS_INSTALL := $(CP) $(foreach file,$(ATHTESTCMD_TOOLS),$(ATHTESTCMD_TOOLS_OUT_DIR)/$(file))
	ATHTESTCMD_TOOLS_LIB_INSTALL := $(CP) $(ATHTESTCMD_TOOLS_OUT_DIR)/*.so
	ATHTESTCMD_TOOLS_UNINSTALL := rm -rf $(foreach file,$(ATHTESTCMD_TOOLS),$(ATHTESTCMD_TOOLS_OUT_DIR)/$(file))
	ATHTESTCMD_TOOLS_LIB_UNINSTALL := rm -rf $(ATHTESTCMD_TOOLS_OUT_DIR)/*.so $(ATHTESTCMD_TOOLS_OUT_DIR)/*.o
endif

ifeq ($(ATHTESTCMD_TOOLS_FORCE_DISABLE),1)
ATHTESTCMD_TOOLS_COMPILE1 :=
ATHTESTCMD_TOOLS_COMPILE2 :=
ATHTESTCMD_TOOLS_INSTALL := $(INSTALL_DIR)
ATHTESTCMD_TOOLS_LIB_INSTALL := $(INSTALL_DIR)
ATHTESTCMD_TOOLS_UNINSTALL := rm -rf $(PKG_INSTALL_DIR)
ATHTESTCMD_TOOLS_LIB_UNINSTALL := rm -rf $(PKG_INSTALL_DIR)
endif

OL_FW_HW1_BIN_DIR :=$(call qstrip,$(CONFIG_TARGET_RF_FW1_VERSION))
OL_FW_HW2_BIN_DIR :=$(call qstrip,$(CONFIG_TARGET_RF_FW2_VERSION))
OL_FW_HW1_FILES :=
OL_FW_HW2_FILES :=
OL_FW_HW1_INSTALL_DIR := lib/firmware
OL_FW_HW2_INSTALL_DIR := $(OL_FW_HW1_INSTALL_DIR)

ifeq ($(WLAN_VER),10.4)

ifeq ($(TARGET_BOARD),ipq40xx)

ifeq ($(OL_FW_HW1_BIN_DIR),)
#OL_FW_HW1_BIN_DIR := qca-wifi-fw-CNSS.BL.4.0-00063-S-1
#OL_FW_HW1_BIN_DIR := qca-wifi-fw-CNSS.BL.3.0.3-00009-S-1
OL_FW_HW1_BIN_DIR := qca-wifi-fw-CNSS.BL.3.0.3-00033-S-1
endif

ifeq ($(OL_FW_HW2_BIN_DIR),)
OL_FW_HW2_BIN_DIR :=
endif

OL_FW_HW1_INSTALL_DIR := lib/firmware/IPQ4019/hw.1
OL_FW_HW2_INSTALL_DIR := $(OL_FW_HW1_INSTALL_DIR)

else

ifeq ($(OL_FW_HW1_BIN_DIR),)
OL_FW_HW1_BIN_DIR := qca-wifi-fw-CNSS.BL.1.0-00453-S-1
endif

ifeq ($(OL_FW_HW2_BIN_DIR),)
OL_FW_HW2_BIN_DIR := qca-wifi-fw-CNSS.BL.1.0-00453-S-1
endif

OL_FW_HW1_INSTALL_DIR := lib/firmware/AR900B/hw.1
OL_FW_HW2_INSTALL_DIR := lib/firmware/AR900B/hw.2

endif

endif

ifeq ($(OL_FW_FORCE_DISABLE),1)
OL_FW_HW1_BIN_DIR :=
OL_FW_HW2_BIN_DIR :=
OL_FW_HW1_FILES :=
OL_FW_HW2_FILES :=
OL_FW_HW1_INSTALL_DIR := lib/firmware
OL_FW_HW2_INSTALL_DIR := $(OL_FW_HW1_INSTALL_DIR)
endif

ifeq ($(LOAD_ARRAY_FW),1)
	OL_FW_HW1_BIN_DIR :=
	OL_FW_HW2_BIN_DIR :=
endif

ifneq ($(OL_FW_HW1_BIN_DIR),)
	OL_FW_HW1_OUT_DIR := ${CURDIR}/files/hw.1/$(OL_FW_HW1_BIN_DIR)
endif
ifneq ($(OL_FW_HW2_BIN_DIR),)
	OL_FW_HW2_OUT_DIR := ${CURDIR}/files/hw.2/$(OL_FW_HW2_BIN_DIR)
endif

MODEL_NAME:=$(call qstrip,$(CONFIG_TARGET_MODELNAME))
MODEL_FW_HW_BIN_PATH:=${CURDIR}/model/$(MODEL_NAME)
ifneq ($(MODEL_NAME),)
ifneq ($(wildcard $(MODEL_FW_HW_BIN_PATH)),)

ifneq ($(OL_FW_HW1_OUT_DIR),)
MODEL_FW_HW_BIN_DIR:=$(MODEL_FW_HW_BIN_PATH)/files/hw.1/$(OL_FW_HW1_BIN_DIR)
ifneq ($(wildcard $(MODEL_FW_HW_BIN_DIR)),)
OL_FW_HW1_OUT_DIR := $(MODEL_FW_HW_BIN_DIR)
endif
endif

ifneq ($(OL_FW_HW2_OUT_DIR),)
MODEL_FW_HW_BIN_DIR:=$(MODEL_FW_HW_BIN_PATH)/files/hw.2/$(OL_FW_HW2_BIN_DIR)
ifneq ($(wildcard $(MODEL_FW_HW_BIN_DIR)),)
OL_FW_HW2_OUT_DIR := $(MODEL_FW_HW_BIN_DIR)
endif
endif

endif
endif

OL_FW_HW1_FILES_INSTALL := $(INSTALL_DIR)
ifneq ($(OL_FW_HW1_BIN_DIR),)
	OL_FW_HW1_FILES_INSTALL := $(CP) $(OL_FW_HW1_OUT_DIR)/* $(OL_FW_HW1_OUT_DIR)/.filenames
ifeq ($(TARGET_BOARD),ipq40xx)
	OL_FW_HW1_FILES_INSTALL := $(CP) $(OL_FW_HW1_OUT_DIR)/*
endif
endif
OL_FW_HW2_FILES_INSTALL := $(INSTALL_DIR)
ifneq ($(OL_FW_HW2_BIN_DIR),)
	OL_FW_HW2_FILES_INSTALL := $(CP) $(OL_FW_HW2_OUT_DIR)/* $(OL_FW_HW2_OUT_DIR)/.filenames
ifeq ($(TARGET_BOARD),ipq40xx)
	OL_FW_HW1_FILES_INSTALL := $(CP) $(OL_FW_HW2_OUT_DIR)/*
endif
endif

ifneq ($(wildcard $(PREBUILT_DIR)/*.ipk),)
ifneq ($(OL_FW_HW1_BIN_DIR),)
PKG_BUILD_FILES_CLEAN += find ${CURDIR}/files/hw.1/ -maxdepth 1 -mindepth 1 -not -name $(OL_FW_HW1_BIN_DIR) -exec rm -rf '{}' ';' ;
else
PKG_BUILD_FILES_CLEAN += rm -rf ${CURDIR}/files/hw.1
endif
ifneq ($(OL_FW_HW2_BIN_DIR),)
PKG_BUILD_FILES_CLEAN += find ${CURDIR}/files/hw.2/ -maxdepth 1 -mindepth 1 -not -name $(OL_FW_HW2_BIN_DIR) -exec rm -rf '{}' ';' ;
else
PKG_BUILD_FILES_CLEAN += rm -rf ${CURDIR}/files/hw.2
endif
endif

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
	$(CONFIGIN_FILE_INSTALL)
	$(QCAWLAN_HEADERS_INSTALL)
	rm -rf $(INSTALL_ROOT)/usr/www/cgi-bin
	mkdir -p $(INSTALL_ROOT)/usr/www/cgi-bin
endef

PKG_BUILD_FILES_CLEAN+=\
	make -C $(PACKAGE_SRC_DIR)/hal/linux $(MADWIFI_ENVOPTS) clean;\
	make -C $(PACKAGE_SRC_DIR)/os/linux $(MADWIFI_ENVOPTS) clean;\
	make -C $(PACKAGE_SRC_DIR)/os/linux/tools clean;\
	[ ! -d $(PACKAGE_SRC_DIR)/halphy_tools/host/testcmd_tlv ] || make -C $(PACKAGE_SRC_DIR)/halphy_tools/host/testcmd_tlv -f makefile.linux $(MADWIFI_ENVOPTS) clean;\
	$(ATH_TOOLS_UNINSTALL);\
	$(ATHTESTCMD_TOOLS_UNINSTALL);\
	$(ATHTESTCMD_TOOLS_LIB_UNINSTALL)

define Build/Compile/tools
	$(ATH_TOOLS_COMPILE1) $(ATH_TOOLS_COMPILE2) $(ATH_TOOLS_COMPILE3)
	$(ATHTESTCMD_TOOLS_COMPILE1) $(ATHTESTCMD_TOOLS_COMPILE2)
endef

define Build/Compile/hal
	cd $(PKG_BUILD_DIR)/hal/linux && \
	make $(MADWIFI_ENVOPTS) clean && \
	make $(MADWIFI_ENVOPTS) && \
	make $(MADWIFI_ENVOPTS) release;
endef

define Build/Compile
	$(call Build/Compile/hal)
	cd $(PKG_BUILD_DIR)/os/linux && \
	make $(MADWIFI_ENVOPTS) && \
	$(call Build/Compile/tools)
endef

define KernelPackage/$(PKG_NAME)/config
	source "$(SOURCE)/$(CONFIGIN_FILE)"
endef

define KernelPackage/qca-wifi/install
	
	$(INSTALL_DIR) $(1)/sbin
	$(ATH_TOOLS_INSTALL) $(1)/sbin
	$(ATHTESTCMD_TOOLS_INSTALL) $(1)/sbin
	$(INSTALL_DIR) $(1)/usr/lib
	$(ATHTESTCMD_TOOLS_LIB_INSTALL) $(1)/usr/lib
	
	$(INSTALL_DIR) $(1)/$(OL_FW_HW1_INSTALL_DIR)
	$(OL_FW_HW1_FILES_INSTALL) $(1)/$(OL_FW_HW1_INSTALL_DIR)
	$(INSTALL_DIR) $(1)/$(OL_FW_HW2_INSTALL_DIR)
	$(OL_FW_HW2_FILES_INSTALL) $(1)/$(OL_FW_HW2_INSTALL_DIR)
	
	$(INSTALL_DIR) $(1)/usr/include
	$(WIFI_FW_VER_INFO_FILE_INSTALL) $(1)/usr/include
	
	cd $(1)/sbin;ln -sf cgiMain cfg
	cd $(1)/sbin;ln -sf wlanconfig self-test
endef

$(eval $(call KernelPackage,qca-wifi))
