#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vsftpd
PKG_VERSION:=2.3.4
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://security.appspot.com/downloads/
PKG_MD5SUM:=2ea5d19978710527bb7444d93b67767a

include $(INCLUDE_DIR)/package.mk

define Package/vsftpd
  SUBMENU:=File Transfer
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A fast and secure FTP server
  URL:=http://vsftpd.beasts.org/
  MAINTAINER:=Cezary Jackiewicz <cezary@eko.one.pl>
endef

define Package/vsftpd/conffiles
/etc/vsftpd.conf
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		vsftpd
endef

define Package/vsftpd/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_DIR) $(1)/usr/share/empty
	$(INSTALL_DIR) $(1)/var/log

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/$(PKG_NAME).conf $(1)/etc/$(PKG_NAME).conf
endef

$(eval $(call BuildPackage,vsftpd))
