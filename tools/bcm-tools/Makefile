# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=bcm-tools
PKG_VERSION:=$(strip $(subst ",, $(CONFIG_TARGET_SDK_VERSION)))

include $(INCLUDE_DIR)/host-build.mk

define Host/Prepare
endef
define Host/Compile
endef

BCM_NAND_TOOL:=
ifeq ($(CONFIG_NAND_FLASH),y)
BCM_NAND_TOOL+= [ ! -f $(TOOLCHAIN_DIR)/ubi-utils/trx ] || $(CP) $(TOOLCHAIN_DIR)/ubi-utils/trx $(STAGING_DIR_HOST)/bin
endif

define Host/Install
	mkdir -p $(STAGING_DIR_HOST)/bin
	[ ! -d $(TOOLCHAIN_DIR)/tools ] || $(CP) $(TOOLCHAIN_DIR)/tools/* $(STAGING_DIR_HOST)/bin
	[ ! -d $(TOPDIR)/tools/$(PKG_NAME)/$(PKG_VERSION) ] || $(CP) $(TOPDIR)/tools/$(PKG_NAME)/$(PKG_VERSION)/* $(STAGING_DIR_HOST)/bin
	$(BCM_NAND_TOOL)
endef

define Host/Clean
endef

$(eval $(call HostBuild))
