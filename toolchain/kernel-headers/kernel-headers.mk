#############################################################
#
# Setup the kernel headers. I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own. Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
#############################################################
DEFAULT_KERNEL_HEADERS:=$(strip $(subst ",, $(BR2_DEFAULT_KERNEL_HEADERS)))
#"))
LINUX_HEADERS_SITE:=127.0.0.1
LINUX_HEADERS_SOURCE:=unspecified-kernel-headers
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-null

KERNEL_ARCH:=$(shell $(CONFIG_SHELL) -c "echo \"$(ARCH)\" | sed -e \"s/-.*//\" \
	-e s/i.86/i386/ -e s/sun4u/sparc64/ \
	-e s/arm.*/arm/ -e s/sa110/arm/ \
	-e s/s390x/s390/ -e s/parisc64/parisc/ \
	-e s/powerpc64/powerpc/ -e s/bfin/blackfin/ \
	-e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
	-e s/sh[234].*/sh/")

# assume old manually sanitized kernel-headers
LINUX_HEADERS_IS_KERNEL:=n

ifeq ($(LINUX_HEADERS_VERSION),)
# parse linux version string
LNXVER:=$(subst ., ,$(strip $(DEFAULT_KERNEL_HEADERS)))
KERNEL_MAJORVERSION:=$(word 1,$(LNXVER))
KERNEL_PATCHLEVEL:=$(word 2,$(LNXVER))
KERNEL_SUBLEVEL:=$(word 3,$(LNXVER))
KERNEL_EXTRAVERSION:=$(word 4,$(LNXVER))
KERNEL_LOCALVERSION:=
KERNEL_EXTRAVERSION:=$(if $(KERNEL_EXTRAVERSION),.$(KERNEL_EXTRAVERSION),)
endif

include toolchain/kernel-headers/kernel-headers-old.makefile
include toolchain/kernel-headers/kernel-headers-new.makefile

$(DL_DIR)/$(LINUX_HEADERS_SOURCE):
	$(WGET) -P $(DL_DIR) $(LINUX_HEADERS_SITE)/$(LINUX_HEADERS_SOURCE)

kernel-headers: $(LINUX_HEADERS_DIR)/.configured

kernel-headers-source: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)

kernel-headers-clean: clean
	rm -rf $(LINUX_HEADERS_DIR)

kernel-headers-dirclean:
	rm -rf $(LINUX_HEADERS_DIR)
	rm -rf $(LINUX_HEADERS_UNPACK_DIR)

.PHONY: kernel-headers
