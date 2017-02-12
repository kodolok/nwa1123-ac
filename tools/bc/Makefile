# 
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=bc
PKG_VERSION:=1.06.95

PKG_SOURCE:=$(PKG_NAME)_$(PKG_VERSION).orig.tar.gz
PKG_SOURCE_URL:=ftp://ftp.debian.org/debian/pool/main/b/bc
PKG_MD5SUM:=24d0831812d8262b6cac8316b0bac483

include $(INCLUDE_DIR)/host-build.mk

$(eval $(call HostBuild))
