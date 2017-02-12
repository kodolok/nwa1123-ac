#
# Copyright (c) 2014 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-cli
PKG_VERSION:=1.0
PKG_RELEASE:=9

TARGET_BOARD:=$(call qstrip,$(CONFIG_TARGET_BOARD))
SRC_VER:=1100
ifneq (,$(findstring 1123,$(TARGET_BOARD)))
SRC_VER:=1123
endif
PACKAGE_SRC_DIR=${CURDIR}/src_$(SRC_VER)
include $(INCLUDE_DIR)/package.mk

define Package/dni-cli
  SUBMENU:=Command Line Interface Utility
  CATEGORY:=Delta Networks, INC.
  TITLE:=CLI Utility
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Package/dni-cli/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/cli $(1)/sbin/cli
endef

$(eval $(call BuildPackage,dni-cli))
