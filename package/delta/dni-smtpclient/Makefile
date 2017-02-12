#
# Copyright (c) 2014 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-smtpclient
PKG_VERSION:=1.0
PKG_RELEASE:=4

include $(INCLUDE_DIR)/package.mk

define Package/dni-smtpclient
  SUBMENU:=SMTP Client Agent
  CATEGORY:=Delta Networks, INC.
  TITLE:=SMTP Client Agent
  URL:=http://www.engelschall.com/sw/smtpclient
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

define Package/dni-smtpclient/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/smtpclient $(1)/sbin/smtpclient
endef

$(eval $(call BuildPackage,dni-smtpclient))
