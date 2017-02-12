
define Build/DniSdkConfig
	echo "" > ${PKG_BUILD_DIR}/dniconfig.h
	echo "/* Platform SDK Information */" > ${PKG_BUILD_DIR}/dniconfig.h
	echo "#define PLATFORM \"$(CONFIG_TARGET_PLATFORM)\"" >> ${PKG_BUILD_DIR}/dniconfig.h
	echo "#define PLATFORM_SDK_VERSION \"$(CONFIG_TARGET_SDK_VERSION)\"" >> ${PKG_BUILD_DIR}/dniconfig.h
	echo "#define PLATFORM_SDK_WLAN_VERSION \"$(CONFIG_TARGET_RF_VERSION)\"" >> ${PKG_BUILD_DIR}/dniconfig.h
endef