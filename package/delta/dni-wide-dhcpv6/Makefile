#
# Copyright (c) 2014 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-wide-dhcpv6
PKG_VERSION:=1.0
PKG_RELEASE:=5

include $(INCLUDE_DIR)/package.mk

define Package/dni-wide-dhcpv6
  SUBMENU:=WIDE-DHCPv6
  CATEGORY:=Delta Networks, INC.
  TITLE:=WIDE-DHCPv6
  URL:=http://sourceforge.net/projects/wide-dhcpv6/
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		prefix=$(PKG_INSTALL_DIR) all
endef

define Package/dni-wide-dhcpv6/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_DIR) $(1)/var/local/tmp
	
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dhcp6c $(1)/sbin/dhcp6c
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/dhcp6c.conf $(1)/etc/dhcp6c.conf
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/dhcp6c.script $(1)/etc/dhcp6c.script
endef

$(eval $(call BuildPackage,dni-wide-dhcpv6))
