# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

-include $(TOPDIR)/.config
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/target.mk

PKG_NAME:=u-boot
PKG_VERSION:=$(call qstrip,$(CONFIG_TARGET_SDK_VERSION))
PKG_RELEASE:=3

PRODUCT_MODEL_NAME:=$(call qstrip,$(CONFIG_TARGET_MODELNAME))
TARGET_BOARD:=$(call qstrip,$(CONFIG_TARGET_PLATFORM_BOARD))
TARGET_SDK_PATH:=$(call qstrip,$(CONFIG_TARGET_SDK_PATH))

ifeq ($(CONFIG_TARGET_DUAL_FW_SUPPORT),y)
DUAL_IMAGE_CONFIG = _DUALBOOT
endif

PKG_BUILD_LOCATION:=$(BUILD_DIR)/$(PKG_VERSION)-$(PKG_NAME)-$(PKG_RELEASE)
UBOOT_BUILD_DIR:=$(PKG_BUILD_LOCATION)
UBOOT_SRC_DIR:=${CURDIR}/src
BOARD_CONFIG:=db12x_config

export CROSS_COMPILE=$(TARGET_CROSS)
export LZMA=$(STAGING_DIR_HOST)/bin/lzma
export COMPRESSED_UBOOT=0
export UBOOT_GCC_4_3_3_EXTRA_CFLAGS=-fPIC

ETH_CONFIG=$(call qstrip,$(CONFIG_TARGET_ETH_CONFIG))
ifeq ($(ETH_CONFIG),)
ETH_CONFIG=_f1e
endif
BUILD_CONFIG=$(call qstrip,$(CONFIG_TARGET_BUILD_CONFIG))
ifeq ($(BUILD_CONFIG),)
BUILD_CONFIG=_mi124
endif

PKG_BUILD_DIR:=$(PKG_BUILD_LOCATION)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install

include $(INCLUDE_DIR)/package.mk
UBOOT_MAKEOPTS ?= $(PKG_BUILD_MAKEOPTS)

UBOOT_MAKEOPTS:= ETH_CONFIG=$(ETH_CONFIG)  BUILD_CONFIG=$(BUILD_CONFIG) FLASH_SIZE=16
UBOOT_CONFIGURE := cd $(PKG_BUILD_DIR) && make $(UBOOT_MAKEOPTS) $(BOARD_CONFIG)
UBOOT_COMPILE := cd $(PKG_BUILD_DIR) && make clean && make $(UBOOT_MAKEOPTS) BUILD_DIR=$(PKG_BUILD_DIR)
UBOOT_BIN_INSTALL := $(CP) $(UBOOT_BUILD_DIR)/u-boot.bin $(BIN_DIR)

define Package/u-boot
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=U-Boot $(PKG_VERSION)
endef

define Build/Prepare
	-rm -rf $(PKG_BUILD_DIR)
	ln -s $(UBOOT_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Build/Configure
	$(UBOOT_CONFIGURE)
endef 

PKG_BUILD_FILES_CLEAN+=\
	$(MAKE) -C $(UBOOT_SRC_DIR) clean;\
	rm -f $(UBOOT_SRC_DIR)/u-boot* $(UBOOT_SRC_DIR)/*.map;

define Build/Compile
	$(UBOOT_COMPILE)
endef 

define Package/u-boot/install
	$(UBOOT_BIN_INSTALL)
endef

$(eval $(call BuildPackage,u-boot))
