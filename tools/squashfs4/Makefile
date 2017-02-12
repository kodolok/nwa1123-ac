#
# Copyright (C) 2009-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(TOPDIR)/target/linux/$(BOARD)/config-*

PKG_NAME:=squashfs4
PKG_VERSION:=4.2

PKG_SOURCE:=squashfs$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@SF/squashfs
PKG_MD5SUM:=1b7a781fb4cf8938842279bd3e8ee852
PKG_CAT:=zcat

HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/squashfs$(PKG_VERSION)

ifneq ($(CONFIG_SQUASHFS_XZ),)
SQUASHFSOPTS:=\
		XZ_SUPPORT=1 \
		LZMA_XZ_SUPPORT=1
SQUASHFS_CMDNAME:=
else
SQUASHFSOPTS:=\
		XZ_SUPPORT=0 \
		LZMA_SUPPORT=1\
		LZMA_DIR="../../lzma"
SQUASHFS_CMDNAME:=-lzma
endif

include $(INCLUDE_DIR)/host-build.mk

define Host/Compile
	$(MAKE) -C $(HOST_BUILD_DIR)/squashfs-tools \
		CC="$(HOSTCC)" \
		$(SQUASHFSOPTS) \
		XATTR_SUPPORT= \
		LZMA_LIB="$(STAGING_DIR_HOST)/lib/liblzma.a" \
		EXTRA_CFLAGS="-I$(STAGING_DIR_HOST)/include" \
		EXTRA_LDFLAGS="$(HOST_STATIC_LINKING)" \
		mksquashfs unsquashfs
endef

define Host/Install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/squashfs-tools/mksquashfs $(STAGING_DIR_HOST)/bin/mksquashfs4$(SQUASHFS_CMDNAME)
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/squashfs-tools/unsquashfs $(STAGING_DIR_HOST)/bin/unsquashfs4$(SQUASHFS_CMDNAME)
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/mksquashfs4$(SQUASHFS_CMDNAME)
	rm -f $(STAGING_DIR_HOST)/bin/unsquashfs4$(SQUASHFS_CMDNAME)
endef

$(eval $(call HostBuild))
