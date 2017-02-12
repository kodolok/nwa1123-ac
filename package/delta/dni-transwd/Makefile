#
# Copyright (c) 2014 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-transwd
PKG_VERSION:=1.0
PKG_RELEASE:=3

include $(INCLUDE_DIR)/package.mk

define Package/dni-transwd
  SUBMENU:=Password Utility
  CATEGORY:=Delta Networks, INC.
  TITLE:=Password Utility
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Package/dni-transwd/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/transwd $(1)/sbin/transwd
endef

$(eval $(call BuildPackage,dni-transwd))
