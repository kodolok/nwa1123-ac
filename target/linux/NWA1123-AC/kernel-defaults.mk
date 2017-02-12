
KERNEL_CC=$(KERNEL_CROSS)gcc
KERNEL_LD=$(KERNEL_CROSS)ld
KERNEL_AS=$(KERNEL_CROSS)as

export PATH:=$(TOOLCHAIN_DIR)/bin:$(TARGET_PATH)
export CROSS_COMPILE=$(KERNEL_CROSS)

KERNEL_CROSS_OPT1:= CROSS_COMPILE=$(KERNEL_CROSS) CC=$(KERNEL_CC) LD=$(KERNEL_LD) AS=$(KERNEL_AS) ARCH=$(LINUX_KARCH)
KERNEL_CROSS_OPT2:= $(KERNEL_CROSS_OPT1)
KERNEL_CROSS_OPT3:= $(KERNEL_CROSS_OPT1)
KERNEL_CROSS_OPT4:=

export LINUX_CONFIG:=$(TOPDIR)/target/linux/$(BOARD)/config-$(LINUX_VERSION)
SDK_VER:=$(call qstrip,$(CONFIG_TARGET_SDK_VERSION))

define Kernel/Prepare/Default
	@rm -rf $(KERNEL_BUILD_DIR)
	mkdir -p $(KERNEL_BUILD_DIR)
	echo "EXTRAVERSION=-LSDK-$(SDK_VER)" > $(LINUX_SRCDIR)/linux-$(LINUX_VERSION)/ath_version.mk
	ln -s $(LINUX_SRCDIR)/linux-$(LINUX_VERSION) $(LINUX_DIR)
	rm -f $(LINUX_SRCDIR)/linux-$(LINUX_VERSION)/Kconfig.DNI
	[ ! -f $(TOPDIR)/target/linux/$(BOARD)/Kconfig.DNI ] || ln -s $(TOPDIR)/target/linux/$(BOARD)/Kconfig.DNI $(LINUX_SRCDIR)/linux-$(LINUX_VERSION)/Kconfig.DNI
endef

define Kernel/Configure/Default
	@$(CP) $(LINUX_CONFIG) $(LINUX_DIR)/.config
	$(MAKE) $(KERNEL_JFLAG) -C $(LINUX_DIR) $(KERNEL_CROSS_OPT1) oldconfig $(KERNEL_BUILD_OPT)
	rm -rf $(KERNEL_BUILD_DIR)/modules
endef

#OBJCOPY_STRIP = -R .reginfo -R .notes -R .note -R .comment -R .mdebug -R .note.gnu.build-id
OBJCOPY_STRIP = --remove-section=.reginfo --remove-section=.mdebug --remove-section=.comment --remove-section=.note --remove-section=.pdr --remove-section=.options --remove-section=.MIPS.options

define Kernel/CopyImage
	$(KERNEL_CROSS)objcopy -O binary $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(LINUX_KERNEL)$(1)
	$(KERNEL_CROSS)objcopy $(OBJCOPY_STRIP) -S $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux$(1).elf
	$(CP) $(LINUX_DIR)/vmlinux $(KERNEL_BUILD_DIR)/vmlinux$(1).debug
ifneq ($(subst ",,$(KERNELNAME)),)
	#")
	$(foreach k,$(filter-out dtbs,$(subst ",,$(KERNELNAME))),$(CP) $(LINUX_DIR)/arch/$(LINUX_KARCH)/boot/$(IMAGES_DIR)/$(k) $(KERNEL_BUILD_DIR)/$(k)$(1);)
	#")
endif
endef

define Kernel/CompileImage/Default
	#$(MAKE) $(KERNEL_JFLAG) -C $(LINUX_DIR) $(KERNEL_CROSS_OPT3)
	$(MAKE) $(KERNEL_JFLAG) -C $(LINUX_DIR) $(KERNEL_CROSS_OPT3) $(subst ",,$(KERNELNAME))
	$(call Kernel/CopyImage)
endef

define Kernel/CompileModules/Default
	$(MAKE) $(KERNEL_JFLAG) -C $(LINUX_DIR) $(KERNEL_CROSS_OPT2) modules
endef

define Kernel/Clean/Default
	rm -f $(LINUX_DIR)/.linux-compile
	rm -f $(KERNEL_BUILD_DIR)/linux-$(LINUX_VERSION)/{.configured,.compiled,.image,.modules,.prepared}
	rm -f $(LINUX_KERNEL)
	$(MAKE) $(KERNEL_CROSS_OPT4) -C $(LINUX_SRCDIR)/linux-$(LINUX_VERSION) distclean
	rm -f $(LINUX_DIR)/.prepared $(LINUX_DIR)/Kconfig.DNI
endef