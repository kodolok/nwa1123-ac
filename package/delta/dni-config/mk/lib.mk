
define Build/DniLibConfig
	echo "" >> ${PKG_BUILD_DIR}/dniconfig.h
	echo "/* Libraries Information */" >> ${PKG_BUILD_DIR}/dniconfig.h
#
# Broadcom Corporation
#
	$(call Build/DniConfig,libbcm=,__CONFIG_BCM_LIB__,,)
	$(call Build/DniConfig,libbcmcrypto,__CONFIG_BCM_CRYPTO_LIB__,,)
	$(call Build/DniConfig,libnetconf,__CONFIG_BCM_NETCONF_LIB__,,)
	$(call Build/DniConfig,libnvram,__CONFIG_BCM_NVRAM_LIB__,,)
	$(call Build/DniConfig,libshared,__CONFIG_BCM_SHARED_LIB__,,)
#
# Filesystem
#
	$(call Build/DniConfig,libext2fs,__CONFIG_EXT2FS_LIB__,,)
	$(call Build/DniConfig,libfuse,__CONFIG_FUSE_LIB__,,)
#
# SSL
#
	$(call Build/DniConfig,libcyassl,__CONFIG_CYASSL_LIB__,,)
	$(call Build/DniConfig,libgnutls,__CONFIG_GNUTLS_LIB__,,)
	$(call Build/DniConfig,libopenssl,__CONFIG_OPENSSL_LIB__,,)
	$(call Build/DniConfig,libavahi,__CONFIG_AVAHI_LIB__,,)
	$(call Build/DniConfig,libavahi-client,__CONFIG_AVAHI_CLINET_LIB__,,)
	$(call Build/DniConfig,libavahi-dbus-support,__CONFIG_AVAHI_DBUS_SUPPORT_LIB__,,)
	$(call Build/DniConfig,libdaemon,__CONFIG_DAEMON_LIB__,,)
	$(call Build/DniConfig,libdbus,__CONFIG_DBUS_LIB__,,)
	$(call Build/DniConfig,libgdbm,__CONFIG_GDBM_LIB__,,)
#
# database
#
	$(call Build/DniConfig,libsqlite3,__CONFIG_SQLITE3_LIB__,,)
	$(call Build/DniConfig,alsa-lib,__CONFIG_ALSA_LIB__,,)
	$(call Build/DniConfig,fdk-aac,__CONFIG_FDK_AAC_LIB__,,)
	$(call Build/DniConfig,glib2,__CONFIG_GLIB2_LIB__,,)
	$(call Build/DniConfig,libattr,__CONFIG_ATTR_LIB__,,)
	$(call Build/DniConfig,libblkid,__CONFIG_BLKID_LIB__,,)
	$(call Build/DniConfig,libbz2,__CONFIG_BZ2_LIB__,,)
	$(call Build/DniConfig,libcharset,__CONFIG_CHARSET_LIB__,,)
	$(call Build/DniConfig,libcurl,__CONFIG_CURL_LIB__,,)
	$(call Build/DniConfig,libexif,__CONFIG_EXIF_LIB__,,)
	$(call Build/DniConfig,libexpat,__CONFIG_EXPAT_LIB__,,)
	$(call Build/DniConfig,libffi,__CONFIG_FFI_LIB__,,)
	$(call Build/DniConfig,libffmpeg,__CONFIG_FFMPEG_LIB__,,)
	$(call Build/DniConfig,libflac,__CONFIG_FLAC_LIB__,,)
	$(call Build/DniConfig,libgcrypt,__CONFIG_GCRYPT_LIB__,,)
	$(call Build/DniConfig,libgpg-error,__CONFIG_GPG_ERROR_LIB__,,)
	$(call Build/DniConfig,libiconv,__CONFIG_ICONV_LIB__,,)
	$(call Build/DniConfig,libid3tag,__CONFIG_ID3TAG_LIB__,,)
	$(call Build/DniConfig,libintl,__CONFIG_INTL_LIB__,,)
	$(call Build/DniConfig,libiw,__CONFIG_IW_LIB__,,)
	$(call Build/DniConfig,libjpeg,__CONFIG_JPEG_LIB__,,)
	$(call Build/DniConfig,libltdl,__CONFIG_LTDL_LIB__,,)
	$(call Build/DniConfig,liblzo,__CONFIG_LZO_LIB__,,)
	$(call Build/DniConfig,libmount,__CONFIG_MOUNT_LIB__,,)
	$(call Build/DniConfig,libncurses,__CONFIG_NCURSES_LIB__,,)
	$(call Build/DniConfig,libnss,__CONFIG_NSS_LIB__,,)
	$(call Build/DniConfig,libnl-tiny,__CONFIG_NL_TINY_LIB__,,)
	$(call Build/DniConfig,libogg,__CONFIG_OGG_LIB__,,)
	$(call Build/DniConfig,libpcap,__CONFIG_PCAP_LIB__,,)
#
# Configuration
#
	$(call Build/DniConfig,libgcc,__CONFIG_GCC_LIB__,,)
	$(call Build/DniConfig,libpam,__CONFIG_PAM_LIB__,,)
	$(call Build/DniConfig,libpthread,__CONFIG_PTHREAD_LIB__,,)
	$(call Build/DniConfig,librt,__CONFIG_RT_LIB__,,)
	$(call Build/DniConfig,libstdcpp,__CONFIG_STD_CPP_LIB__,,)
	$(call Build/DniConfig,libqmi,__CONFIG_QMI_LIB__,,)
	$(call Build/DniConfig,libreadline,__CONFIG_READLINE_LIB__,,)
	$(call Build/DniConfig,librpc,__CONFIG_RPC_LIB__,,)
	$(call Build/DniConfig,libuuid,__CONFIG_UUID_LIB__,,)
	$(call Build/DniConfig,libupnp,__CONFIG_UPNP_LIB__,,)
	$(call Build/DniConfig,libvorbis,__CONFIG_VORBIS_LIB__,,)
	$(call Build/DniConfig,libwrap,__CONFIG_WRAP_LIB__,,)
	$(call Build/DniConfig,libxml2,__CONFIG_XML2_LIB__,,)
	$(call Build/DniConfig,opencore-amr,__CONFIG_OPENCORE_AMR_LIB__,,)
	$(call Build/DniConfig,terminfo,__CONFIG_TERMINIFO_LIB__,,)
	$(call Build/DniConfig,_uclibc,__CONFIG_UCLIBC_LIB__,,)
	$(call Build/DniConfig,zlib,__CONFIG_ZLIB_LIB__,,)
endef