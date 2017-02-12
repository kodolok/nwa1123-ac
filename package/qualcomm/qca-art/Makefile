#
# Copyright (c) 2014 Qualcomm Atheros, Inc..
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qca-art
PKG_VERSION:=$(call qstrip,$(CONFIG_TARGET_RF_VERSION))
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

define Package/qca-art
  SUBMENU:=Utility
  CATEGORY:=Qualcomm Atheros
  DEFAULT:=n
  TITLE:=Atheros Radio Test. 
endef

define Package/qca-art/description
  Atheros Radio Test 
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s $(PACKAGE_SRC_DIR) $(PKG_BUILD_DIR)
endef

ART_ENVOPTS:=\
                $(TARGET_CONFIGURE_OPTS) \
                	ART_ROOT="$(PKG_BUILD_DIR)" \
	KERNELARCH=$(ARCH)\
	WORKAREA=$(PKG_BUILD_DIR)\
	KDIR=$(LINUX_DIR)\
	TOOLARCH="$(ARCH)" \
	TOOL_PREFIX="$(TARGET_CROSS)" \
	LINUX_SRC="$(LINUX_DIR)" 

define Build/Compile
	$(INSTALL_DIR) $(BIN_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) -f makefile.soc.linux.$(ARCH) clean wasp_osprey $(ART_ENVOPTS)
	$(CP) $(PKG_BUILD_DIR)/modules/art.ko $(BIN_DIR)/art-wasp-osprey.ko
	$(MAKE) -C $(PKG_BUILD_DIR) -f makefile.soc.linux.$(ARCH) clean wasp $(ART_ENVOPTS)
	$(CP) $(PKG_BUILD_DIR)/modules/art.ko $(BIN_DIR)/art-wasp.ko
endef

PKG_BUILD_FILES_CLEAN+=\
	cd $(PACKAGE_SRC_DIR) && $(MAKE) -f makefile.soc.linux.$(ARCH) clean;\
	rm -f $(BIN_DIR)/art-*

define Package/qca-art/install
	$(INSTALL_DIR) $(BIN_DIR)
endef

$(eval $(call BuildPackage,qca-art))
