# Copyright (c) 2013 The Linux Foundation. All rights reserved.
#
include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=NWA1123-AC
BOARDNAME:=NWA1123-AC
FEATURES:=squashfs
CPU_TYPE:=mips

LINUX_VERSION:=2.6.31
export KERNELNAME:=vmlinux.bin

LINUX_SRCDIR:=$(TOPDIR)/target/linux/linuxsrc-qualcomm

# Kernel clone path and local repository reference can be done through menu config, else we we
# can hardcode it as below, this is just for a reference
export CONFIG_EXTERNAL_KERNEL_TREE=$(LINUX_SRCDIR)/linux-$(LINUX_VERSION)

CFLAGS:=-Os -pipe -funit-at-a-time -march=74kc -mtune=74kc
#CFLAGS:=-Os -pipe -mips32 -mtune=mips32 -funit-at-a-time

export PLATFORM_KERNEL_DEFAULT:=1

include $(INCLUDE_DIR)/target.mk

define Target/Description
	Build firmware images for QCA DB120 (mips) platform.
endef

$(eval $(call BuildTarget))
