#
# Copyright (c) 2014 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-zdp
PKG_VERSION:=1.0
PKG_RELEASE:=5

include $(INCLUDE_DIR)/package.mk

define Package/dni-zdp
  SUBMENU:=ZyXEL ZDP Daemon
  CATEGORY:=Delta Networks, INC.
  TITLE:=ZyXEL ZDP Daemon
  DEPENDS:=+libpthread
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

define Build/Compile/Default
	+$(MAKE_VARS) \
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/$(MAKE_PATH) \
		$(MAKE_FLAGS) \
		LIBS="$(TARGET_LDFLAGS) -lpthread $(PKG_BUILD_DIR)/$(ARCH)/libZDP.a"\
		$(1);
endef

define Package/dni-zdp/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/zdpd $(1)/sbin/zdpd
endef

$(eval $(call BuildPackage,dni-zdp))
