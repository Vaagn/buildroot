#############################################################
#
# openssl
#
#############################################################

# TARGETS
OPENSSL_VERSION:=0.9.8h
OPENSSL_SITE:=http://www.openssl.org/source
OPENSSL_SOURCE:=openssl-$(OPENSSL_VERSION).tar.gz
OPENSSL_CAT:=$(ZCAT)
OPENSSL_DIR:=$(BUILD_DIR)/openssl-$(OPENSSL_VERSION)

#Usage: Configure [no-<cipher> ...] [enable-<cipher> ...] [-Dxxx] [-lxxx] [-Lxxx] [-fxxx] [-Kxxx] [no-hw-xxx|no-hw] [[no-]threads] [[no-]shared] [[no-]zlib|zlib-dynamic] [enable-montasm] [no-asm] [no-dso] [no-krb5] [386] [--prefix=DIR] [--openssldir=OPENSSLDIR] [--with-xxx[=vvv]] [--test-sanity] os/compiler[:flags]

OPENSSL_TARGET_ARCH:=
ifeq ($(BR2_i386),y)
ifneq ($(ARCH),i386)
OPENSSL_TARGET_ARCH:=i386-$(ARCH)
OPENSSL_TARGET_ARCH:=generic32
endif
ifeq ($(ARCH),i686)
OPENSSL_TARGET_ARCH:=i386-i686/cmov
OPENSSL_TARGET_ARCH:=elf
endif
endif

ifeq ($(BR2_alpha),y)
OPENSSL_TARGET_ARCH:=linux-alpha-gcc
endif

ifeq ($(OPENSSL_TARGET_ARCH),)
OPENSSL_TARGET_ARCH:=$(ARCH)
endif

ifeq ($(BR2_PTHREADS_NONE),y)
OPENSSL_THREADS=no-threads
else
OPENSSL_THREADS=threads
endif

$(DL_DIR)/$(OPENSSL_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENSSL_SITE)/$(OPENSSL_SOURCE)

openssl-unpack: $(OPENSSL_DIR)/.unpacked
$(OPENSSL_DIR)/.unpacked: $(DL_DIR)/$(OPENSSL_SOURCE)
	$(OPENSSL_CAT) $(DL_DIR)/$(OPENSSL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(OPENSSL_DIR) package/openssl/ openssl-$(OPENSSL_VERSION)\*.patch
	# sigh... we have to resort to this just to set a gcc flag.
	# grumble.. and of course make sure to escape any '/' in CFLAGS
	$(SED) 's,/CFLAG=,/CFLAG= $(TARGET_SOFT_FLOAT) ,g' \
		$(OPENSSL_DIR)/Configure
	$(SED) '/CFLAG=/s,/;, $(shell echo '$(TARGET_CFLAGS)' | sed -e 's/\//\\\\\//g')/;,' \
		$(OPENSSL_DIR)/Configure
	touch $@

$(OPENSSL_DIR)/Makefile: $(OPENSSL_DIR)/.unpacked
	(cd $(OPENSSL_DIR); \
	CFLAGS="-DOPENSSL_NO_KRB5 -DOPENSSL_NO_IDEA -DOPENSSL_NO_MDC2 -DOPENSSL_NO_RC5 $(TARGET_CFLAGS)" \
	PATH=$(TARGET_PATH) \
	./Configure linux-$(OPENSSL_TARGET_ARCH) --prefix=/ \
		--openssldir=/lib/ssl -L$(STAGING_DIR)/lib -ldl \
		-I$(STAGING_DIR)/usr/include $(OPENSSL_OPTS) \
		$(OPENSSL_THREADS) \
		shared no-idea no-mdc2 no-rc5)

# --openssldir=/usr/lib/ssl results in files in /usr/usr/lib...

$(OPENSSL_DIR)/apps/openssl: $(OPENSSL_DIR)/Makefile
	$(MAKE1) CC=$(TARGET_CC) -C $(OPENSSL_DIR) all build-shared
	# Work around openssl build bug to link libssl.so with libcrypto.so.
	-rm $(OPENSSL_DIR)/libssl.so.*.*.*
	$(MAKE1) CC=$(TARGET_CC) -C $(OPENSSL_DIR) do_linux-shared

$(STAGING_DIR)/usr/lib/libcrypto.a: $(OPENSSL_DIR)/apps/openssl
	$(MAKE) CC=$(TARGET_CC) INSTALL_PREFIX=$(STAGING_DIR)/usr INSTALLTOP=$(STAGING_DIR)/usr/ -C $(OPENSSL_DIR) install
	cp -fa $(OPENSSL_DIR)/libcrypto.so* $(STAGING_DIR)/usr/lib/
	chmod a-x $(STAGING_DIR)/usr/lib/libcrypto.so.0.9.8
	(cd $(STAGING_DIR)/usr/lib; \
	 ln -fs libcrypto.so.0.9.8 libcrypto.so; \
	 ln -fs libcrypto.so.0.9.8 libcrypto.so.0; \
	)
	cp -fa $(OPENSSL_DIR)/libssl.so* $(STAGING_DIR)/usr/lib/
	chmod a-x $(STAGING_DIR)/usr/lib/libssl.so.0.9.8
	(cd $(STAGING_DIR)/usr/lib; \
	 ln -fs libssl.so.0.9.8 libssl.so; \
	 ln -fs libssl.so.0.9.8 libssl.so.0; \
	)
	touch -c $@

$(TARGET_DIR)/usr/lib/libcrypto.so.0.9.8: $(STAGING_DIR)/usr/lib/libcrypto.a
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -fa $(STAGING_DIR)/usr/lib/libcrypto.so* $(TARGET_DIR)/usr/lib/
	cp -fa $(STAGING_DIR)/usr/lib/libssl.so* $(TARGET_DIR)/usr/lib/
	#cp -fa $(STAGING_DIR)/bin/openssl $(TARGET_DIR)/bin/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libssl.so.0.9.8
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libcrypto.so.0.9.8

$(TARGET_DIR)/usr/lib/libssl.a: $(STAGING_DIR)/usr/lib/libcrypto.a
	mkdir -p $(TARGET_DIR)/usr/include
	cp -a $(STAGING_DIR)/usr/include/openssl $(TARGET_DIR)/usr/include/
	cp -dpf $(STAGING_DIR)/usr/lib/libssl.a $(TARGET_DIR)/usr/lib/
	cp -dpf $(STAGING_DIR)/usr/lib/libcrypto.a $(TARGET_DIR)/usr/lib/
	touch -c $@

openssl-headers: $(TARGET_DIR)/usr/lib/libssl.a

openssl: uclibc $(TARGET_DIR)/usr/lib/libcrypto.so.0.9.8

openssl-source: $(DL_DIR)/$(OPENSSL_SOURCE)

openssl-clean:
	-$(MAKE) -C $(OPENSSL_DIR) clean
	rm -f $(STAGING_DIR)/usr/bin/openssl $(TARGET_DIR)/usr/bin/openssl
	rm -f $(STAGING_DIR)/usr/lib/libcrypto.so* $(TARGET_DIR)/usr/lib/libcrypto.so*
	rm -f $(STAGING_DIR)/usr/lib/libssl.so* $(TARGET_DIR)/usr/lib/libssl.so*
	rm -rf $(STAGING_DIR)/usr/include/openssl $(TARGET_DIR)/usr/include/openssl

openssl-dirclean:
	rm -rf $(OPENSSL_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_OPENSSL),y)
TARGETS+=openssl
endif
ifeq ($(BR2_PACKAGE_OPENSSL_TARGET_HEADERS),y)
TARGETS+=openssl-headers
endif
