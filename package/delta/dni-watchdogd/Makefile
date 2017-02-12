#
# Copyright (c) 2014 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-watchdogd
PKG_VERSION:=1.0
PKG_RELEASE:=3

include $(INCLUDE_DIR)/package.mk

define Package/dni-watchdogd
  SUBMENU:=Watchdog Daemon
  CATEGORY:=Delta Networks, INC.
  TITLE:=Watchdog Daemon
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Package/dni-watchdogd/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/watchdogd $(1)/sbin/watchdogd
endef

$(eval $(call BuildPackage,dni-watchdogd))
