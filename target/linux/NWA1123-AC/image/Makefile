# Copyright (c) 2013 The Linux Foundation. All rights reserved.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

MODEL_NAME:=$(call qstrip,$(CONFIG_TARGET_MODELNAME))
FW_MAJOR_VER:=$(call qstrip,$(CONFIG_TARGET_FW_MAJOR_VER))
FW_MINOR_VER:=$(call qstrip,$(CONFIG_TARGET_FW_MINOR_VER))
PRODUCT_ID:=$(call qstrip,$(CONFIG_TARGET_PRODUCT_ID))
FW_PATCH_NO:=$(call qstrip,$(CONFIG_TARGET_FW_PATCH_NO))
RELEASE_VERSION:=$(call qstrip,$(CONFIG_TARGET_FW_RELEASE_VERSION))

FW_VERSION_STRING:=V$(FW_MAJOR_VER)$(FW_MINOR_VER)$(PRODUCT_ID)$(FW_PATCH_NO)$(RELEASE_VERSION)
FW_INFO_STRING:=$(MODEL_NAME)_$(FW_MAJOR_VER).$(FW_MINOR_VER)($(PRODUCT_ID).$(FW_PATCH_NO))$(RELEASE_VERSION)
FW_NAME_STRING:=V$(FW_MAJOR_VER).$(FW_MINOR_VER)($(PRODUCT_ID).$(FW_PATCH_NO))
FILENAME:=$(FW_VERSION_STRING).bin

BOARD_TYPE:=$(call qstrip,$(CONFIG_TARGET_BOARD_TYPE))
ETH_CONFIG:=$(call qstrip,$(CONFIG_TARGET_ETH_CONFIG))
BUILD_EXT:=$(ETH_CONFIG)
BUILD_CONFIG:=$(call qstrip,$(CONFIG_TARGET_BUILD_CONFIG))

TARGETFSSIZE=$(call qstrip,$(CONFIG_TARGET_FS_SIZE))
RIMAGE=root.squashfs
RIMAGE_PADDED=mi124$(ETH_CONFIG)-jffs2
LZMA_UIMG=vmlinux$(BUILD_CONFIG)$(BUILD_EXT).lzma.uImage
KERNELARCH=$(ARCH)
KERNELPATH=$(LINUX_DIR)
KERNELTARGET=vmlinux.bin
KTFILE=$(KERNELTARGET:.bin=$(BUILD_CONFIG)$(BUILD_EXT).bin)
export IMAGEPATH=$(BIN_DIR)
export TFTPPATH=$(BIN_DIR)

VMLINUXBINPATH=$(KERNELPATH)/arch/$(KERNELARCH)/boot
VMLINUXBIN=$(VMLINUXBINPATH)/$(KERNELTARGET)
KERNEL_ENTRY=`readelf -a $(VMLINUXBIN)|grep "Entry"|head -1|cut -d":" -f 2`
#LDADDR=`readelf -a $(VMLINUXBIN)|grep "\[ 1\]"|head -1|cut -d" " -f 26`

define Image/GPL/Release
	echo "Image:$(FW_VERSION_STRING)" >> $(TOPDIR)/module_name ;
endef

define Build/Clean
endef

define Image/dni/firmwareinfo
	cd $(TARGET_DIR) && rm -rf dev && mkdir -p dev -m 715
	cd $(TARGET_DIR) && mkdir -p dev/pts -m 715
	cd $(TARGET_DIR) && rm -rf sys && mkdir -p sys -m 715

	cd $(TARGET_DIR) && rm -rf mnt && ln -s /tmp/mnt mnt
	#cd $(TARGET_DIR) && rm -rf dev/log && ln -sf /tmp/log dev/log
	cd $(TARGET_DIR) && rm -rf etc/mini_httpd.conf &&ln -sf /tmp/mini_httpd.conf etc/mini_httpd.conf
	cd $(TARGET_DIR) && rm -rf etc/mini_httpd_ssl.conf &&ln -sf /tmp/mini_httpd_ssl.conf etc/mini_httpd_ssl.conf
	cd $(TARGET_DIR) && rm -rf etc/resolv.conf && ln -sf /tmp/resolv.conf etc/resolv.conf
	cd $(TARGET_DIR) && mv etc/vsftpd.conf etc/vsftpd_def.conf && ln -sf /tmp/vsftpd.conf etc/vsftpd.conf
	cd $(TARGET_DIR) && rm -rf etc/TZ && ln -sf /tmp/TZ etc/TZ
	cd $(TARGET_DIR) && rm -rf dev/log && ln -sf /tmp/log dev/log
	cd $(TARGET_DIR) && rm -rf var/run && ln -sf /tmp var/run
	cd $(TARGET_DIR) && rm -rf var/spool && ln -sf /tmp/spool var/spool
	cd $(TARGET_DIR) && rm -rf var/net-snmp && ln -sf /tmp/net-snmp var/net-snmp
	cd $(TARGET_DIR) && rm -rf usr/local && ln -sf /tmp/local usr/local
	cd $(TARGET_DIR) && rm -rf etc/ssmtp/ssmtp.conf && ln -sf /tmp/ssmtp/ssmtp.conf etc/ssmtp/ssmtp.conf
	cd $(TARGET_DIR) && rm -rf etc/ssmtp/revaliases && ln -sf /tmp/ssmtp/revaliases etc/ssmtp/revaliases
	cd $(TARGET_DIR) && rm -rf etc/passwd && ln -sf /tmp/passwd etc/passwd
	cd $(TARGET_DIR) && rm -rf etc/shadow && ln -sf /tmp/shadow etc/shadow

	echo '$(FW_VERSION_STRING)_'`date +%Y%m%d` > $(TARGET_DIR)/etc/firmware_version
	echo '$(FW_INFO_STRING)_'`date +%Y%m%d` > $(TARGET_DIR)/etc/firmware_info
	echo '$(FW_NAME_STRING)' > $(TARGET_DIR)/etc/firmware_name
	echo $(BOARD_TYPE)/`date +%F-%H:%M` >$(TARGET_DIR)/version
	echo `date "+%Y-%m-%d %T"` > $(TARGET_DIR)/etc/release_date
	echo 'V1.1.4' > $(TARGET_DIR)/etc/boot_version
endef

define Image/dni/firmware
	cd $(VMLINUXBINPATH) && \
	$(STAGING_DIR_HOST)/bin/lzma e $(KERNELTARGET) $(KERNELTARGET).lzma && \
	cp $(KERNELTARGET).lzma $(IMAGEPATH)/$(KTFILE).lzma && \
	gzip -9c $(KERNELTARGET) > $(KERNELTARGET).gz && \
	cp $(KERNELTARGET).gz $(IMAGEPATH)/$(KTFILE).gz
	if [ -e $(TOPDIR)/module_name ];then \
		$(call Image/GPL/Release) \
	fi
	$(TOPDIR)/target/linux/$(BOARD)/mkuImage.sh $(STAGING_DIR_HOST)/bin $(KERNELPATH) $(BUILD_CONFIG)$(BUILD_EXT) lzma

	cd $(IMAGEPATH) && \
	tar -jcv -f tmp.bin $(RIMAGE_PADDED) $(LZMA_UIMG)
	. $(TOPDIR)/target/linux/$(BOARD)/add_md5.sh $(IMAGEPATH)/tmp.bin $(IMAGEPATH)/$(FILENAME)
	chmod 644 $(IMAGEPATH)/$(RIMAGE)
endef

define Image/vendor/firmware
endef

define Image/mkfs/ubifs
endef

ifneq ($(CONFIG_TARGET_ROOTFS_UBIFS),)
define Image/mkfs/ubifs_fit
	$(call Image/mkfs/ubifs/generate,$(1))
	$(call Image/Build,ubi,$(1))
endef
endif

define Image/BuildKernel
endef

define Image/BuildRootfs/squashfs
	$(STAGING_DIR_HOST)/bin/mksquashfs4-lzma $(TARGET_DIR) $(IMAGEPATH)/$(RIMAGE) -noappend -b 65536 -all-root -processors 1 -pf $(TOPDIR)/target/linux/$(BOARD)/dev.txt
	#$(STAGING_DIR_HOST)/bin/mksquashfs4-lzma $(TARGET_DIR) $(IMAGEPATH)/$(RIMAGE) -noappend -b 65536 -all-root
	
	dd bs=$(TARGETFSSIZE) if=/dev/zero count=1 of=$(IMAGEPATH)/pad.img
	cat $(IMAGEPATH)/$(RIMAGE) $(IMAGEPATH)/pad.img | head -c $(TARGETFSSIZE) > $(IMAGEPATH)/$(RIMAGE_PADDED)
endef

define Image/Build
	$(call Image/Build/$(1),$(1))
endef

$(eval $(call BuildImage))
