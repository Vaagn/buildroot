#############################################################
#
# wget
#
#############################################################
WGET_VERSION:=1.10.2
WGET_SOURCE:=wget-$(WGET_VERSION).tar.gz
WGET_SITE:=$(BR2_GNU_MIRROR)/wget
WGET_DIR:=$(BUILD_DIR)/wget-$(WGET_VERSION)
WGET_CAT:=$(ZCAT)
WGET_BINARY:=src/wget
WGET_TARGET_BINARY:=bin/wget

$(DL_DIR)/$(WGET_SOURCE):
	$(WGET) -P $(DL_DIR) $(WGET_SITE)/$(WGET_SOURCE)

$(WGET_DIR)/.unpacked: $(DL_DIR)/$(WGET_SOURCE)
	$(WGET_CAT) $(DL_DIR)/$(WGET_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

# TODO: conditional ssl support
$(WGET_DIR)/.configured: $(WGET_DIR)/.unpacked
	(cd $(WGET_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/ \
		$(DISABLE_IPV6) \
		$(DISABLE_NLS) \
		--without-ssl \
	)
	touch $@

$(WGET_DIR)/$(WGET_BINARY): $(WGET_DIR)/.configured
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(WGET_DIR)

$(TARGET_DIR)/$(WGET_TARGET_BINARY): $(WGET_DIR)/$(WGET_BINARY)
	$(INSTALL) -D -m 0755 $(WGET_DIR)/$(WGET_BINARY) $(TARGET_DIR)/$(WGET_TARGET_BINARY)

wget: uclibc $(TARGET_DIR)/$(WGET_TARGET_BINARY)

wget-source: $(DL_DIR)/$(WGET_SOURCE)

wget-clean:
	rm -f $(TARGET_DIR)/$(WGET_TARGET_BINARY)
	-$(MAKE) -C $(WGET_DIR) clean

wget-dirclean:
	rm -rf $(WGET_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_WGET),y)
TARGETS+=wget
endif
