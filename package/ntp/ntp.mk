#############################################################
#
# ntp
#
#############################################################
NTP_VERSION:=4.2.4p4
NTP_SOURCE:=ntp-$(NTP_VERSION).tar.gz
NTP_SITE:=http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2
NTP_DIR:=$(BUILD_DIR)/ntp-$(NTP_VERSION)
NTP_CAT:=$(ZCAT)
NTP_BINARY:=ntpdate/ntpdate
NTP_TARGET_BINARY:=usr/bin/ntpdate

$(DL_DIR)/$(NTP_SOURCE):
	$(WGET) -P $(DL_DIR) $(NTP_SITE)/$(NTP_SOURCE)

$(NTP_DIR)/.patched: $(DL_DIR)/$(NTP_SOURCE)
	$(NTP_CAT) $(DL_DIR)/$(NTP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(NTP_DIR) package/ntp/ ntp\*.patch
	$(SED) "s,^#if.*__GLIBC__.*_BSD_SOURCE.*$$,#if 0," \
		$(NTP_DIR)/ntpd/refclock_pcf.c
	$(SED) '/[[:space:](]index[[:space:]]*(/s/[[:space:]]*index[[:space:]]*(/ strchr(/g' $(NTP_DIR)/libisc/*.c $(NTP_DIR)/arlib/sample.c
	$(SED) '/[[:space:](]rindex[[:space:]]*(/s/[[:space:]]*rindex[[:space:]]*(/ strrchr(/g' $(NTP_DIR)/ntpd/*.c
	#$(SED) 's/\(^#[[:space:]]*include[[:space:]]*<sys\/var.h>\)/\/\/ \1/' $(NTP_DIR)/util/tickadj.c
	$(CONFIG_UPDATE) $(NTP_DIR)
	$(CONFIG_UPDATE) $(NTP_DIR)/sntp
	touch $@

$(NTP_DIR)/.configured: $(NTP_DIR)/.patched
	(cd $(NTP_DIR); rm -rf config.cache; \
		ac_cv_lib_md5_MD5Init=no \
		$(AUTO_CONFIGURE_TARGET) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		$(DISABLE_NLS) \
		$(DISABLE_IPV6) \
		--with-shared \
		--program-transform-name=s,,, \
		--without-crypto \
		--disable-tickadj \
	)
	touch $@

$(NTP_DIR)/$(NTP_BINARY): $(NTP_DIR)/.configured
	$(MAKE) -C $(NTP_DIR)
	touch -c $@

$(TARGET_DIR)/$(NTP_TARGET_BINARY): $(NTP_DIR)/$(NTP_BINARY)
	install -D -m 755 $(NTP_DIR)/ntpd/ntpd $(TARGET_DIR)/usr/sbin/ntpd
	install -D -m 755 $(NTP_DIR)/$(NTP_BINARY) $(TARGET_DIR)/$(NTP_TARGET_BINARY)
ifeq ($(BR2_PACKAGE_NTP_SNTP),y)
	install -D -m 755 $(NTP_DIR)/sntp/sntp $(TARGET_DIR)/usr/bin/sntp
endif
	install -D -m 755 package/ntp/ntp.sysvinit $(TARGET_DIR)/etc/init.d/S49ntp

ntp: uclibc $(TARGET_DIR)/$(NTP_TARGET_BINARY)

ntp-source: $(DL_DIR)/$(NTP_SOURCE)

ntp-clean:
	rm -f $(TARGET_DIR)/usr/sbin/ntpd $(TARGET_DIR)/usr/bin/sntp \
		$(TARGET_DIR)/etc/init.d/S49ntp \
		$(TARGET_DIR)/$(NTP_TARGET_BINARY)
	-$(MAKE) -C $(NTP_DIR) clean

ntp-dirclean:
	rm -rf $(NTP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_NTP),y)
TARGETS+=ntp
endif
