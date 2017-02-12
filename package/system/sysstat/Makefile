#
# Copyright (C) 2007-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=sysstat
PKG_VERSION:=6.0.1
PKG_RELEASE:=4

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
#PKG_SOURCE_URL:=http://sebastien.godard.pagesperso-orange.fr/
#PKG_MD5SUM:=42670b66b01b830f82e86117659cd43d

include $(INCLUDE_DIR)/package.mk

define Package/sysstat
  SUBMENU:=Performance monitoring tools
  CATEGORY:=System tools
  URL:=http://perso.wanadoo.fr/sebastien.godard/
  TITLE:=Performance monitoring tools
endef

define Package/sysstat/description
 System performance tools for the Linux operating system...
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	rm -f $(PKG_BUILD_DIR)/sysstat.cron.daily
	rm -f $(PKG_BUILD_DIR)/sysstat.cron.hourly
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) 
endef

define Package/sysstat/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sar $(1)/sbin/sar
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/sadc $(1)/sbin/sadc
endef

$(eval $(call BuildPackage,sysstat))
