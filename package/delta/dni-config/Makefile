#
# Copyright (c) 2015 Delta Network,Inc..
#
# All Rights Reserved.
# Delta Network Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dni-config
PKG_VERSION:=2.0
PKG_RELEASE:=5

DEP_TARGET:=
DNI_CONFIG_DEPEND:=
DNI_DATALIB_DEPEND:=n
PKG_BUILD_USE_DNI_CONFIG:=y
ifeq ($(CONFIG_PACKAGE_kmod-dni-logd),y)
DEP_TARGET:=kmod-dni-logd
endif

include $(INCLUDE_DIR)/package.mk

define Package/dni-config
  SUBMENU:=DNI Configuration
  CATEGORY:=Delta Networks, INC.
  TITLE:=DNI config utility
  DEPENDS:=$(DEP_TARGET)
endef

define Package/dni-config/description
  This package contains an utility to define the DNI compile label.
endef

define Build/DniConfig
	if [ x"`cat $(TOPDIR)/.config | grep "="  | grep $(1)`" != "x" ]; then \
		[ "$(2)" = "PRODUCT_MODEL_NAME" ] && echo " $4" > ${PKG_BUILD_DIR}/product_name.h;\
		if [ x"$(3)" = "x" ]; then \
			echo "#define $2 1" >> ${PKG_BUILD_DIR}/dniconfig.h;\
		else\
			if [ x"`cat $(TOPDIR)/.config | grep "=" | grep $(3)`" != "x" ]; then \
				if [ x"$(5)" = "xstring" ]; then \
					echo "#define $2 \"$4\"" >> ${PKG_BUILD_DIR}/dniconfig.h;\
				else\
					if [ x"$(4)" = "x" ]; then \
						echo "#define $2 1" >> ${PKG_BUILD_DIR}/dniconfig.h;\
					else\
						echo "#define $2 $4" >> ${PKG_BUILD_DIR}/dniconfig.h;\
					fi\
				fi\
			fi\
		fi\
	fi
endef

include ./mk/*.mk

define Build/DniConfigFile
	$(call Build/DniSdkConfig)
	$(call Build/DniPltConfig)
	$(call Build/DniRfConfig)
	$(call Build/DniLibConfig)
	$(call Build/DniModConfig)
	$(call Build/DniPkgConfig)
endef

define Build/Prepare
	rmdir $(PKG_BUILD_DIR)
	ln -s ${CURDIR}/include $(PKG_BUILD_DIR)
	rm -f $(PKG_BUILD_DIR)/.prepared*
endef

PKG_BUILD_FILES_CLEAN+=\
	rm -f $(PKG_BUILD_DIR)/product_name.h;\
	rm -f $(PKG_BUILD_DIR)/dniconfig.h

define Build/Compile
	$(call Build/DniConfigFile)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/*.h $(1)/usr/include/
	
	$(INSTALL_DIR) $(STAGING_DIR)/usr/include
	$(INSTALL_DIR) $(STAGING_DIR)/usr/lib
	$(CP) ${CURDIR}/include/dni/*.h $(STAGING_DIR)/usr/include
	[ ! -f ${CURDIR}/include/dni/libconfig.so ] || $(CP) ${CURDIR}/include/dni/*.so $(STAGING_DIR)/usr/lib
	if [ "x$(BOARD_PLATFORM)" = "xbroadcom" ]; then\
		$(CP) ${CURDIR}/include/bcm/*.h $(STAGING_DIR)/usr/include;\
		[ ! -f ${CURDIR}/include/bcm/libnvram.so ] || $(CP) ${CURDIR}/include/bcm/*.so $(STAGING_DIR)/usr/lib;\
		$(INSTALL_DIR) $(BIN_DIR);\
		[ ! -f ${CURDIR}/include/bcm/vmlinuz ] || $(CP) ${CURDIR}/include/bcm/vmlinuz* $(BIN_DIR);\
		[ ! -f ${CURDIR}/include/bcm/zImage ] || $(CP) ${CURDIR}/include/bcm/zImage $(BIN_DIR);\
	fi
endef

define Build/UninstallDev
endef

define Package/dni-config/install
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/dni/*.h $(1)/usr/include/
	if [ "x$(BOARD_PLATFORM)" = "xbroadcom" ]; then\
		$(CP) $(PKG_BUILD_DIR)/bcm/*.h $(1)/usr/include;\
	fi
endef

$(eval $(call BuildPackage,dni-config))

