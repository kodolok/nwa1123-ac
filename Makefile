# Makefile for OpenWrt
#
# Copyright (C) 2007 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

TOPDIR:=${CURDIR}
LC_ALL:=C
LANG:=C
export TOPDIR LC_ALL LANG

BUILD_START_TIME_FILE=$(TOPDIR)/btime.log
STARTTIME=`cat $(BUILD_START_TIME_FILE)`

world:

include $(TOPDIR)/include/host.mk

ifneq ($(OPENWRT_BUILD),1)
  # XXX: these three lines are normally defined by rules.mk
  # but we can't include that file in this context
  empty:=
  space:= $(empty) $(empty)
  _SINGLE=export MAKEFLAGS=$(space);

  override OPENWRT_BUILD=1
  export OPENWRT_BUILD
  GREP_OPTIONS=
  export GREP_OPTIONS
  include $(TOPDIR)/include/debug.mk
  include $(TOPDIR)/include/depends.mk
  include $(TOPDIR)/include/toplevel.mk
else
  include rules.mk
  include $(INCLUDE_DIR)/depends.mk
  include $(INCLUDE_DIR)/subdir.mk
  include target/Makefile
  include package/Makefile
  include tools/Makefile
  include toolchain/Makefile

$(toolchain/stamp-install): $(tools/stamp-install)
$(target/stamp-compile): $(toolchain/stamp-install) $(tools/stamp-install) $(BUILD_DIR)/.prepared
$(package/stamp-cleanup): $(target/stamp-compile)
$(package/stamp-compile): $(target/stamp-compile) $(package/stamp-cleanup)
$(package/stamp-install): $(package/stamp-compile)
$(package/stamp-rootfs-prepare): $(package/stamp-install)
$(target/stamp-install): $(package/stamp-compile) $(package/stamp-install) $(package/stamp-rootfs-prepare)

printdb:
	@true

openwrt_start_build_time:
	@echo "openWRT start build time"
	@echo "${shell date +%s}" > $(BUILD_START_TIME_FILE)

ifneq ($(CONFIG_EXTERNAL_TOOLCHAIN),)

GCC-BIN:= ar as gcc ld nm objcopy objdump strip g++ ranlib size readelf

TARGET_PLATFORM:=$(call qstrip,$(CONFIG_TARGET_PLATFORM))
TARGET_NAME:=$(call qstrip,$(CONFIG_TARGET_NAME))
TOOLCHAIN_PREFIX:=$(call qstrip,$(CONFIG_TOOLCHAIN_PREFIX))
TOOLCHAIN_FILENAME:=$(call qstrip,$(CONFIG_TOOLCHAIN_FILENAME))
TOOLCHAIN_SRC_FILE:=$(TOPDIR)/toolchain/$(TARGET_PLATFORM)/$(TOOLCHAIN_FILENAME)_src.tar.gz

ifneq ($(wildcard $(TOOLCHAIN_SRC_FILE)),)
externel_toolchain_install: .config $(tools/stamp-install)
	@if [ ! -d $(TOOLCHAIN_DIR) ] ; then \
		mkdir -p $(BUILD_DIR_BASE); \
		cd $(BUILD_DIR_BASE); \
		tar xzvf $(TOOLCHAIN_SRC_FILE); \
		cd $(TOOLCHAIN_FILENAME);make; \
		rm -rf $(TOOLCHAIN_DIR);ln -s $(BUILD_DIR_BASE)/$(TOOLCHAIN_FILENAME)/staging_dir/$(TOOLCHAIN_FILENAME) $(TOOLCHAIN_DIR);\
	fi
else
externel_toolchain_install:
endif
	@if [ ! -d $(TOOLCHAIN_DIR) ] ; then \
		cd $(STAGING_DIR_BASE); \
		tar xzvf $(TOPDIR)/toolchain/$(TARGET_PLATFORM)/$(TOOLCHAIN_FILENAME).tar.gz; \
		cd $(TOOLCHAIN_ROOT_DIR)/bin;\
		for gcc in $(GCC-BIN) ; do \
			[ -f $(ARCH)-linux-uclibc-$${gcc} ] || ln -sf $(TOOLCHAIN_PREFIX)$${gcc} $(ARCH)-linux-uclibc-$${gcc} ; \
			[ -f $(ARCH)-linux-$${gcc} ] || ln -sf $(TOOLCHAIN_PREFIX)$${gcc} $(ARCH)-linux-$${gcc} ; \
		done ; \
	fi
	@if [ -d $(TOOLCHAIN_DIR)/$(TARGET_NAME)/sysroot/usr ] ; then \
		rm -rf $(TOOLCHAIN_DIR)/usr;\
		ln -sf $(TOOLCHAIN_DIR)/$(TARGET_NAME)/sysroot/usr $(TOOLCHAIN_DIR)/usr;\
	fi
	@if [ -d $(TOOLCHAIN_DIR)/$(TARGET_NAME)/sysroot/lib ] ; then \
		mkdir -p $(TOOLCHAIN_DIR)/lib;\
		$(CP) $(TOOLCHAIN_DIR)/$(TARGET_NAME)/sysroot/lib/* $(TOOLCHAIN_DIR)/lib/;\
	fi
	@if [ ! -d $(TOOLCHAIN_DIR)/usr ] ; then \
		mkdir -p $(TOOLCHAIN_DIR)/usr;cd $(TOOLCHAIN_DIR)/usr;\
		ln -sf $(TOOLCHAIN_DIR)/$(TOOLCHAIN_INC_PATH) include;\
		ln -sf $(TOOLCHAIN_DIR)/$(TOOLCHAIN_LIB_PATH) lib;\
	fi
	@rm -rf $(CONFIG_TOOLCHAIN_ROOT)/bin/auto*

prepare: openwrt_start_build_time externel_toolchain_install $(target/stamp-compile)
else
prepare: openwrt_start_build_time $(target/stamp-compile)
endif

clean: FORCE
	$(_SINGLE)$(SUBMAKE) package/clean V=s
	$(_SINGLE)$(SUBMAKE) target/linux/clean V=s
	rm -rf $(BUILD_DIR) $(BIN_DIR) $(BUILD_LOG_DIR)
	@rm -rf $(BIN_DIR_BASE) $(BUILD_DIR_BASE) $(STAGING_DIR_BASE)
	@rm -rf $(TMP_DIR) $(BUILD_START_TIME_FILE)
	@$(MAKE) -C  $(SCRIPT_DIR)/config clean

dirclean: clean
ifneq ($(CONFIG_EXTERNAL_TOOLCHAIN),)
	rm -rf $(STAGING_DIR_HOST) $(BUILD_DIR_HOST)
else
	rm -rf $(STAGING_DIR) $(STAGING_DIR_HOST) $(STAGING_DIR_TOOLCHAIN) $(TOOLCHAIN_DIR) $(BUILD_DIR_HOST) $(BUILD_DIR_TOOLCHAIN)
endif
	rm -rf $(TMP_DIR)

ifndef DUMP_TARGET_DB
$(BUILD_DIR)/.prepared: Makefile
	@mkdir -p $$(dirname $@)
	@touch $@

tmp/.prereq_packages: .config
	unset ERROR; \
	for package in $(sort $(prereq-y) $(prereq-m)); do \
		$(_SINGLE)$(NO_TRACE_MAKE) -s -r -C package/$$package prereq || ERROR=1; \
	done; \
	if [ -n "$$ERROR" ]; then \
		echo "Package prerequisite check failed."; \
		false; \
	fi
	touch $@
endif

# check prerequisites before starting to build
prereq: $(target/stamp-prereq) tmp/.prereq_packages
	@if [ ! -f "$(INCLUDE_DIR)/site/$(REAL_GNU_TARGET_NAME)" ]; then \
		echo 'ERROR: Missing site config for target "$(REAL_GNU_TARGET_NAME)" !'; \
		echo '       The missing file will cause configure scripts to fail during compilation.'; \
		echo '       Please provide a "$(INCLUDE_DIR)/site/$(REAL_GNU_TARGET_NAME)" file and restart the build.'; \
		exit 1; \
	fi

prepare: .config $(tools/stamp-install) $(toolchain/stamp-install)
world: prepare $(target/stamp-compile) $(package/stamp-cleanup) $(package/stamp-compile) $(package/stamp-install) $(package/stamp-rootfs-prepare) $(target/stamp-install) FORCE
	$(_SINGLE)$(SUBMAKE) -r package/index
	@$(TOPDIR)/buildtime.sh $(STARTTIME) "OpenWRT COMPLETE BUILD TIME : "

# update all feeds, re-create index files, install symlinks
package/symlinks:
	$(SCRIPT_DIR)/feeds update -a
	$(SCRIPT_DIR)/feeds install -a

# re-create index files, install symlinks
package/symlinks-install:
	$(SCRIPT_DIR)/feeds update -i
	$(SCRIPT_DIR)/feeds install -a

# remove all symlinks, don't touch ./feeds
package/symlinks-clean:
	$(SCRIPT_DIR)/feeds uninstall -a

.PHONY: clean dirclean prereq prepare world package/symlinks package/symlinks-install package/symlinks-clean

package/%: .pkginfo FORCE
	$(MAKE) -C package $(patsubst package/%,%,$@)
	
publish: FORCE
	-$(MAKE) -C $(TOPDIR)/prebuild
	-@rm -rf $(TOPDIR)/prebuild/
	$(MAKE) V=s clean

endif
