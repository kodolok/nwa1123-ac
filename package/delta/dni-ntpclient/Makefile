#
# Copyright (c) 2015 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-ntpclient
PKG_VERSION:=1.0
PKG_RELEASE:=9

PKG_BUILD_USE_DNI_CONFIG:=y

TARGET_MANUFACTURER:=$(call qstrip,$(CONFIG_TARGET_MANUFACTURER))
SRC_DIR:=src
ifeq (ZyXEL,$(findstring ZyXEL, $(TARGET_MANUFACTURER)))
  SRC_DIR:=src_zyxel
endif
PACKAGE_SRC_DIR:=${CURDIR}/$(SRC_DIR)
include $(INCLUDE_DIR)/package.mk

define Package/dni-ntpclient
  SUBMENU:=NTP client
  CATEGORY:=Delta Networks, INC.
  TITLE:=NTP Client
  URL:=http://doolittle.icarus.com/ntpclient/
  DEPENDS:=$(DEP_TARGET)
endef

ifneq ($(wildcard $(PREBUILT_DIR)/*.ipk),)
PKG_BUILD_FILES_CLEAN += find ${CURDIR}/ -maxdepth 1 -mindepth 1 -not -name $(SRC_DIR) -not -name Makefile -not -name patch* -not -name files -not -name Config.in -not -name config -exec rm -rf '{}' ';' ;
endif

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
                $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -I. $(EXTRA_CFLAGS)" \
		LDFLAGS="$(EXTRA_LDFLAGS)" 
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ntpclient $(1)/sbin/ntpclient
	cd $(1)/usr/sbin;ln -s ../../sbin/ntpclient ntpclient

	$(INSTALL_DIR) $(1)/etc/rc.d
	$(CP) ./files/ntpclient.sh $(1)/etc/rc.d
	$(CP) ./files/ntp_success.sh $(1)/etc/rc.d
	$(CP) ./files/update_log_timestamp.sh $(1)/etc/rc.d
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
