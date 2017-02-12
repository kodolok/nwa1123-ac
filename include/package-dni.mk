ifneq ($(PKG_NAME),dni-config)
PKG_DEFAULT_DEPENDS += $(DNI_CONFIG)
endif

ifeq ($(PKG_BUILD_USE_DNI_CONFIG),y)

	export BOARD_PLATFORM:=$(call qstrip,$(CONFIG_TARGET_PLATFORM))
	export TARGET_BOARD:=$(call qstrip,$(CONFIG_TARGET_PLATFORM_BOARD))
	export PRODUCT_MODEL_NAME:=$(call qstrip,$(CONFIG_TARGET_MODELNAME))

	ifneq ($(DNI_DATALIB_DEPEND),n)
		ifeq ($(CONFIG_PACKAGE_dni-datalib),y)
  			EXTRA_LDFLAGS += -lconfig
  			DEP_TARGET:=dni-datalib
		endif
	endif

	ifneq (,$(findstring broadcom,$(BOARD_PLATFORM)))
		EXTRA_LDFLAGS += -lgcc_s -lnvram -lshared
	endif
endif

ifneq ($(PKG_NAME),curl)
#ifneq (,$(findstring autoreconf,$(PKG_FIXUP)))
EXTRA_CFLAGS += -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/include
EXTRA_LDFLAGS += -L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/lib
endif

PKG_BUILD_FILES_CLEAN:=\
rm -f $(PKG_BUILD_DIR)/.version*;\
rm -f $(PKG_BUILD_DIR)/.prepared*;\
rm -f $(PKG_BUILD_DIR)/.configured*;\
rm -f $(PKG_BUILD_DIR)/.config*;\
rm -f $(PKG_BUILD_DIR)/.built;

PACKAGE_SRC_DIR ?= ${CURDIR}/src
ifneq ($(wildcard $(PACKAGE_SRC_DIR)),)
PACKAGE_SRC_CLEAN=cd ${PACKAGE_SRC_DIR} && make clean;$(PKG_BUILD_FILES_CLEAN)
else
PACKAGE_SRC_DIR=${CURDIR}/src_$(PKG_VERSION)
ifneq ($(wildcard $(PACKAGE_SRC_DIR)),)
PACKAGE_SRC_CLEAN=cd ${PACKAGE_SRC_DIR} && make clean;$(PKG_BUILD_FILES_CLEAN)
else
PACKAGE_SRC_DIR=
PACKAGE_SRC_CLEAN=
endif
endif

ifeq ($(wildcard $(PACKAGE_SRC_DIR)/Makefile),)
PACKAGE_SRC_CLEAN=
endif

ifneq ($(wildcard $(PACKAGE_SRC2_DIR)),)
PACKAGE_SRC2_CLEAN=cd ${PACKAGE_SRC2_DIR} && make clean
else
PACKAGE_SRC2_DIR=
PACKAGE_SRC2_CLEAN=
endif

ifeq ($(wildcard $(PACKAGE_SRC2_DIR)/Makefile),)
PACKAGE_SRC2_CLEAN=
endif

define Build/Clean
	-$(PACKAGE_SRC_CLEAN)
	-$(PACKAGE_SRC2_CLEAN)
	-@$(PKG_BUILD_FILES_CLEAN)
	@rm -rf $(PKG_INSTALL_DIR)
	@rm -rf $(PKG_BUILD_DIR)/ipkg*
	@rm -rf $(PKG_BUILD_DIR)
endef
