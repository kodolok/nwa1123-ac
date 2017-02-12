# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=cvimage

include $(INCLUDE_DIR)/host-build.mk

define Host/Prepare
	mkdir -p $(HOST_BUILD_DIR)
endef

define Host/Configure

endef

define Host/Compile
	$(HOSTCC) -c -o $(HOST_BUILD_DIR)/cvimg.o -g -DUNIVERSAL_REPEATER -DWIFI_SIMPLE_CONFIG -DCONFIG_RTL_819X -DCONFIG_RTL_819XD -static -s  src/cvimg.c
	$(HOSTCC) -o $(HOST_BUILD_DIR)/cvimg -g -DUNIVERSAL_REPEATER -DWIFI_SIMPLE_CONFIG -DCONFIG_RTL_819X -DCONFIG_RTL_819XD -static -s $(HOST_BUILD_DIR)/cvimg.o
endef

define Host/Install
	mkdir -p $(STAGING_DIR_HOST)/bin
	$(CP) $(HOST_BUILD_DIR)/cvimg $(STAGING_DIR_HOST)/bin/
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/cvimg
endef

$(eval $(call HostBuild))

