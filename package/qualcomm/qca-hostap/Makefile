#
# Copyright (c) 2014 Qualcomm Atheros, Inc..
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

include $(TOPDIR)/.config
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qca-hostap
PKG_VERSION:=$(call qstrip,$(CONFIG_TARGET_RF_VERSION))
PKG_RELEASE:=10

TARGET_BOARD:=$(call qstrip,$(CONFIG_TARGET_PLATFORM_BOARD))

ifeq ($(PKG_VERSION),10.4)
ifeq ($(TARGET_BOARD),ipq40xx)
WLAN_VER:=10.4_$(TARGET_BOARD)
else
WLAN_VER:=10.4
endif
HOSTAPD_CONF:=hostapd-default.config
WPA_SUPPLICANT_CONF:=wpa_supplicant-10.4-default.config
else
ifeq ($(PKG_VERSION),10.2)
WLAN_VER:=10.2
HOSTAPD_CONF:=hostapd-default.config
WPA_SUPPLICANT_CONF:=wpa_supplicant-default.config
else
WLAN_VER:=$(PKG_VERSION)
HOSTAPD_CONF:=athr_hostapd.conf
WPA_SUPPLICANT_CONF:=athr_supplicant.conf
endif
endif

PACKAGE_SRC_ROOT_DIR=${CURDIR}/src_$(WLAN_VER)
PACKAGE_SRC_DIR=$(PACKAGE_SRC_ROOT_DIR)/hostapd
PACKAGE_SRC2_DIR=$(PACKAGE_SRC_ROOT_DIR)/wpa_supplicant
include $(INCLUDE_DIR)/package.mk

ifeq ($(CONFIG_PACKAGE_libnl-bf),y)
  DEP_TARGET += +libnl-bf
endif

ifeq ($(CONFIG_PACKAGE_librt),y)
  EXTRA_LDFLAGS += -lrt
  DEP_TARGET += +librt
endif

ifeq ($(CONFIG_PACKAGE_libopenssl),y)
  EXTRA_LDFLAGS += -lcrypto -lssl
  DEP_TARGET += +libopenssl
endif

define Package/qca-hostap/Default
  SUBMENU:=Utility
  CATEGORY:=Qualcomm Atheros
  DEPENDS:=kmod-qca-wifi $(DEP_TARGET)
  URL:=http://www.qca.qualcomm.com
  MAINTAINER:=Qualcomm Atheros
endef

define Package/qca-hostap
  $(call Package/qca-hostap/Default)
  TITLE:=Hostap authenticator
endef

define Package/qca-hostap/description
 This package contains the IEEE 802.1x/WPA/EAP/RADIUS Authenticator.
endef

define Package/qca-wpa-supplicant
  $(call Package/qca-hostap/Default)
  TITLE:=WPA Supplicant
endef

define Package/qca-wpa-supplicant/Description
  WPA Supplicant
endef

HOSTAPD_TOOLS:= hostapd hostapd_cli
WPA_SUPPLICANT_TOOLS:= wpa_supplicant wpa_cli

TARGET_CPPFLAGS += \
	-I$(STAGING_DIR)/usr/include \
	-I$(STAGING_DIR)/usr/include/qca-nss-macsec

ifeq ($(CONFIG_PACKAGE_libnl-bf),y)
  EXTRA_LDFLAGS += -lnl-3 -lnl-genl-3 -lm
endif

ifeq ($(CONFIG_PACKAGE_libopenssl),y)
  EXTRA_LDFLAGS += -lssl -lcrypto
endif

ifeq ($(CONFIG_PACKAGE_librt),y)
  EXTRA_LDFLAGS += -lrt
endif

TARGET_CFLAGS += -DDNI_PATCH

define Build/RunMake
	CFLAGS="$(TARGET_CPPFLAGS) $(TARGET_CFLAGS)" \
	$(MAKE) -C $(PKG_BUILD_DIR)/$(1) \
	$(TARGET_CONFIGURE_OPTS) \
	ATHEROSPATH="$(PACKAGE_SRC_ROOT_DIR)/../../qca-wifi/src_$(WLAN_VER)"\
	LIBS="$(TARGET_LDFLAGS) $(EXTRA_LDFLAGS)" \
	$(2)
endef

define Build/Compile/qca-hostap
	cp -f ./files/$(WLAN_VER)/$(HOSTAPD_CONF) $(PKG_BUILD_DIR)/hostapd/.config
	$(MAKE) -C $(PACKAGE_SRC_ROOT_DIR)/hostapd clean
	$(call Build/RunMake,hostapd, \
		$(HOSTAPD_TOOLS) \
	)
endef

define Build/Compile/qca-supplicant
	cp -f ./files/$(WLAN_VER)/$(WPA_SUPPLICANT_CONF) $(PKG_BUILD_DIR)/wpa_supplicant/.config
	$(MAKE) -C $(PACKAGE_SRC_ROOT_DIR)/wpa_supplicant clean
	$(call Build/RunMake,wpa_supplicant, \
		$(WPA_SUPPLICANT_TOOLS) \
	)
endef

WIRELESS_H_INSTALL := $(INSTALL_DIR) $(STAGING_DIR)/usr/include;cp -f $(LINUX_SRC_DIR)/include/linux/wireless.h $(STAGING_DIR)/usr/include/wireless.h
ifneq (,$(findstring 9.2,$(PKG_VERSION)))
WIRELESS_H_INSTALL := 
endif

ifneq ($(wildcard $(PREBUILT_DIR)/*.ipk),)
PKG_BUILD_FILES_CLEAN += find ${CURDIR}/files -maxdepth 1 -mindepth 1 -not -name $(PKG_VERSION) -exec rm -rf '{}' ';' ;
endif

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_ROOT_DIR) $(PKG_BUILD_DIR)

	$(WIRELESS_H_INSTALL)
endef

COMPILE_PACKAGES:=
ifeq ($(CONFIG_PACKAGE_qca-hostap),y)
	COMPILE_PACKAGES+= $(call Build/Compile/qca-hostap);
endif
ifeq ($(CONFIG_PACKAGE_qca-wpa-supplicant),y)
	COMPILE_PACKAGES+= $(call Build/Compile/qca-supplicant);
endif

define Build/Compile
	$(COMPILE_PACKAGES)
endef

ifeq (,$(findstring 9.2,$(PKG_VERSION)))
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/src/common/wpa_ctrl.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/common/ieee802_11_defs.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/includes.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/build_config.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/eloop.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/os.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/common.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/wpa_debug.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/utils/wpabuf.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/drivers/linux_ioctl.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/drivers/linux_wext.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/drivers/netlink.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/drivers/priv_netlink.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/src/common/wpa_ctrl.o $(1)/usr/lib/
	[ ! -f $(PKG_BUILD_DIR)/src/drivers/netlink.o ] || $(CP) $(PKG_BUILD_DIR)/src/drivers/netlink.o $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/src/utils/eloop.o $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/src/utils/wpa_debug.o $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/src/utils/common.o $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/src/utils/os_unix.o $(1)/usr/lib/
endef
endif

define Package/qca-hostap/install
	$(INSTALL_DIR) $(1)/sbin
	$(CP) $(foreach file,$(HOSTAPD_TOOLS),$(PKG_BUILD_DIR)/hostapd/$(file)) $(1)/sbin

	$(INSTALL_DIR) $(1)/etc/ath
	[ ! -d $(PLATFORM_DIR)/cgiCommon/etc/ath/hostapd0.7.0_conf/ ] || cp $(PLATFORM_DIR)/cgiCommon/etc/ath/hostapd0.7.0_conf/* $(1)/etc/ath
	[ ! -f $(1)/etc/ath/hostapd0.7.0_conf ] || rm -rf $(1)/etc/ath/hostapd0.7.0_conf
	mkdir -p $(1)/etc/wpa2
endef

define Package/qca-wpa-supplicant/install
	$(INSTALL_DIR) $(1)/sbin
	$(CP) $(foreach file,$(WPA_SUPPLICANT_TOOLS),$(PKG_BUILD_DIR)/wpa_supplicant/$(file)) $(1)/sbin
endef

$(eval $(call BuildPackage,qca-hostap))
$(eval $(call BuildPackage,qca-wpa-supplicant))
