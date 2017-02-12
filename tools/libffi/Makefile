#
# Copyright (c) 2013 The Linux Foundation. All rights reserved.
# Copyright (C) 2009-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libffi
PKG_VERSION:=3.0.11
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=ftp://sourceware.org/pub/libffi/
PKG_MD5SUM:=f69b9693227d976835b4857b1ba7d0e3

include $(INCLUDE_DIR)/host-build.mk

$(eval $(call HostBuild))
