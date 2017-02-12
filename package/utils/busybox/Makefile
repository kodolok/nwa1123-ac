# 
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=busybox
PKG_VERSION=$(call qstrip,$(CONFIG_TARGET_BUSYBOX_VERSION))
ifeq ($(PKG_VERSION),)
PKG_VERSION:=1.19.4
endif
PKG_RELEASE:=12
#PKG_FLAGS:=essential

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
#PKG_SOURCE_URL:=http://www.busybox.net/downloads \
#		http://distfiles.gentoo.org/distfiles/
#PKG_MD5SUM:=9c0cae5a0379228e7b55e5b29528df8e

#PKG_BUILD_DEPENDS:=BUSYBOX_CONFIG_FEATURE_HAVE_RPC:librpc
PKG_BUILD_PARALLEL:=1

PACKAGE_SRC_DIR=${CURDIR}/src_$(PKG_VERSION)
include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
  STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_BUSYBOX_' $(TOPDIR)/.config | md5s)
endif

ifneq ($(findstring c,$(OPENWRT_VERBOSE)),)
  BB_MAKE_VERBOSE := V=1
else
  BB_MAKE_VERBOSE :=
endif

ifeq ($(CONFIG_PACKAGE_librpc),y)
  DEP_TARGET:=librpc
endif

init-y :=
init-$(CONFIG_BUSYBOX_CONFIG_HTTPD) += httpd
init-$(CONFIG_BUSYBOX_CONFIG_CROND) += cron
init-$(CONFIG_BUSYBOX_CONFIG_TELNETD) += telnet
init-$(CONFIG_BUSYBOX_CONFIG_IFPLUGD) += ifplugd

define Package/busybox
  SECTION:=base
  CATEGORY:=Base system
  MAINTAINER:=Nicolas Thill <nico@openwrt.org>
  TITLE:=Core utilities for embedded Linux
  URL:=http://busybox.net/
#  DEPENDS:=+BUSYBOX_CONFIG_FEATURE_HAVE_RPC:librpc
  DEPENDS:=$(DEP_TARGET)
  MENU:=1
endef

define Package/busybox/description
 The Swiss Army Knife of embedded Linux.
 It slices, it dices, it makes Julian Fries.
endef

ifneq ($(wildcard $(PREBUILT_DIR)/*.ipk),)
PKG_BUILD_FILES_CLEAN += find ${CURDIR}/ -maxdepth 1 -mindepth 1 -not -name src_$(PKG_VERSION) -not -name Makefile -not -name patch* -not -name files -not -name Config.in -not -name config -exec rm -rf '{}' ';' ;
endif

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

ifneq (,$(findstring 1.01,$(PKG_VERSION)))

ifneq ($(wildcard $(PREBUILT_DIR)/*.ipk),)
PKG_BUILD_FILES_CLEAN += find ${CURDIR}/ -maxdepth 1 -mindepth 1 -not -name src_$(PKG_VERSION) -not -name Makefile -exec rm -rf '{}' ';' ;
endif

BOARD_TYPE=$(call qstrip,$(CONFIG_TARGET_BOARD_TYPE))
PROJECT_NAME=$(call qstrip,$(CONFIG_TARGET_PROJECT_NAME))
define Build/Compile
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) clean
	cp -f $(PKG_BUILD_DIR)/defconfig-$(BOARD_TYPE)-$(PROJECT_NAME) $(PKG_BUILD_DIR)/.config
	
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/$(MAKE_PATH) \
		$(MAKE_FLAGS) \
		$(1);
	 $(MAKE) -C $(PKG_BUILD_DIR) PREFIX=$(PKG_INSTALL_DIR) install
endef

define Package/busybox/install
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

else

define Package/busybox/config
	source "$(SOURCE)/Config.in"
endef

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/.configured*
	grep 'CONFIG_BUSYBOX_' $(TOPDIR)/.config | sed -e "s,\\(# \)\\?CONFIG_BUSYBOX_\\(.*\\),\\1\\2,g" > $(PKG_BUILD_DIR)/.config
	yes '' | $(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KBUILD_HAVE_NLS=no \
		ARCH="$(ARCH)" \
		$(BB_MAKE_VERBOSE) \
		oldconfig
endef

ifdef CONFIG_GCC_VERSION_LLVM
  TARGET_CFLAGS += -fnested-functions
endif

LDLIBS:=m crypt
  TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include
ifdef CONFIG_BUSYBOX_CONFIG_FEATURE_HAVE_RPC
  export LDFLAGS=$(TARGET_LDFLAGS)
  LDLIBS += rpc
endif

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KBUILD_HAVE_NLS=no \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		ARCH="$(ARCH)" \
		SKIP_STRIP=y \
		EXTRA_LDFLAGS="$(EXTRA_LDFLAGS)" LDLIBS="$(LDLIBS)" \
		$(BB_MAKE_VERBOSE) \
		all
	rm -rf $(PKG_INSTALL_DIR)
	$(FIND) $(PKG_BUILD_DIR) -lname "*busybox" -exec rm \{\} \;
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		ARCH="$(ARCH)" \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)" \
		EXTRA_LDFLAGS="$(EXTRA_LDFLAGS)" LDLIBS="$(LDLIBS)" \
		$(BB_MAKE_VERBOSE) \
		install
endef

define Package/busybox/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
	for tmp in $(init-y); do \
		$(INSTALL_BIN) ./files/$$$$tmp $(1)/etc/init.d/$$$$tmp; \
	done
	-rm -rf $(1)/lib64
endef
endif

$(eval $(call BuildPackage,busybox))
