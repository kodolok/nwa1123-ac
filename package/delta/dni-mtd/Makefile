#
# Copyright (c) 2014 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-mtd
PKG_VERSION:=1.0
PKG_RELEASE:=4

include $(INCLUDE_DIR)/package.mk

define Package/dni-mtd
  SUBMENU:=utils
  CATEGORY:=Delta Networks, INC.
  TITLE:=Update utility for trx firmware images
  URL:=http://www.linux-mtd.infradead.org
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Package/dni-mtd/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mtd $(1)/sbin/mtd
endef

$(eval $(call BuildPackage,dni-mtd))
