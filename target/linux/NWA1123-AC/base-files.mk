define Package/base-files/install-target
	rm -f $(1)/etc/config/network
endef

define Package/base-files/dni-install-target
	rm -rf $(1)
	mkdir -p $(1)
	mkdir -p $(1)/CONTROL
	$(CP) $(PLATFORM_DIR)/cgiCommon/* $(1)/
	$(CP) $(PLATFORM_DIR)/cgiCommon/etc/ath.dual/* $(1)/etc/ath
	$(CP) $(PLATFORM_DIR)/cgiCommon/usr/www.dual/* $(1)/usr/www
	$(CP) $(PLATFORM_DIR)/base-files/* $(1)/
	$(CP) $(PLATFORM_DIR)/base-files/etc/ath.dual/* $(1)/etc/ath
	[ ! -d $(PLATFORM_DIR)/cgiCommon/etc/ath/hostapd0.7.0_conf ] || $(CP) $(PLATFORM_DIR)/cgiCommon/etc/ath/hostapd0.7.0_conf/* $(1)/etc/ath
	mkdir -p $(1)/etc/wpa2
	rm -rf $(1)/etc/ath.single $(1)/etc/ath.dual
	rm -rf $(1)/usr/www.single $(1)/usr/www.dual
	rm -rf $(1)/etc/ath/hostapd0.7.0_conf
	rm -rf $(1)/lib/modules/2.6.15
	chmod 755 $(1)/etc/rc.d/*
	chmod 755 $(1)/etc/ath/*
	mv -f $(1)/etc/ath/apoob $(1)/sbin
	mv -f $(1)/etc/ath/wpscli_ap $(1)/sbin
	mv -f $(1)/etc/ath/wpscli_sta $(1)/sbin
	cd $(1)/usr/www/cgi-bin;./create_ln.sh
endef