#
# Copyright (c) 2014 Qualcomm Atheros, Inc..
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=qca-artlna
PKG_VERSION:=1.0
PKG_RELEASE:=3

include $(INCLUDE_DIR)/package.mk

define Package/qca-artlna
  SUBMENU:=Utility
  CATEGORY:=Qualcomm Atheros
  DEFAULT:=n
  TITLE:=Apply the LNA value to ART. 
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Package/qca-artlna/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/artlna $(1)/sbin/artlna
endef

$(eval $(call BuildPackage,qca-artlna))
