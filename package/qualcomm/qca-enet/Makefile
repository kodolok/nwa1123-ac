#
# Copyright (c) 2014 Qualcomm Atheros, Inc..
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

include $(TOPDIR)/.config
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qca-enet
PKG_VERSION:=$(call qstrip,$(CONFIG_TARGET_RF_VERSION))
PKG_RELEASE:=7

include $(INCLUDE_DIR)/package.mk

WLAN_VER=$(PKG_VERSION)
TARGET_BOARD:=$(call qstrip,$(CONFIG_TARGET_PLATFORM_BOARD))
ENET_CONF_PATH:=${CURDIR}/conf/$(ARCH)/$(WLAN_VER)
ifneq ($(wildcard $(ENET_CONF_PATH)),)
include $(ENET_CONF_PATH)/config.$(TARGET_BOARD)
endif
export ENETDIR=$(PACKAGE_SRC_DIR)

MOD_FILES = $(PKG_BUILD_DIR)/athrs_gmac.$(LINUX_KMOD_SUFFIX)

define KernelPackage/qca-enet
  	SUBMENU:=AR7240 gigabit MAC and Phys
  	CATEGORY:=Qualcomm Atheros
	TITLE:=AR7240 gigabit MAC and Phys
	FILES:=$(MOD_FILES)
endef

define KernelPackage/qca-enet/description
	Kernel module for Ar7240 gigabit MAC and Phys
endef

MAKE_OPTS:= \
	ARCH=$(ARCH) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	M="$(PKG_BUILD_DIR)"

define KernelPackage/$(PKG_NAME)/config
	source "$(SOURCE)/Config.in"
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s ${ENETDIR} $(PKG_BUILD_DIR)
	if [ x$(CONFIG_SUPPORT_SSDK_BIN) != x ]; then \
		$(INSTALL_BIN) ./files/ssdk/$(ARCH)/ssdk_mod.a $(PKG_BUILD_DIR)/phys/;\
	fi
endef

define Build/Compile
	$(MAKE) -C ${ENETDIR} -f Makefile.inc enet_config.h
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

define KernelPackage/$(PKG_NAME)/install
	if [ x$(CONFIG_SUPPORT_SSDK_BIN) != x ]; then \
		$(INSTALL_DIR) $(1)/sbin;\
		$(INSTALL_BIN) ./files/ssdk/$(ARCH)/ssdk_sh $(1)/sbin/ssdk_sh;\
	fi
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)/net
	cd $(1)/lib/modules/$(LINUX_VERSION)/net;ln -s ../athrs_gmac.$(LINUX_KMOD_SUFFIX) athrs_gmac.$(LINUX_KMOD_SUFFIX)
endef

$(eval $(call KernelPackage,qca-enet))
