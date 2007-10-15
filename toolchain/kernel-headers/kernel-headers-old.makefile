#############################################################
#
# Setup the kernel headers. I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own. Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
#############################################################
ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.25")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=4
KERNEL_SUBLEVEL:=25
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.25.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.25
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.27")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=4
KERNEL_SUBLEVEL:=27
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.27.tar.bz2
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.27
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.29")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=4
KERNEL_SUBLEVEL:=29
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.29.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.29
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.4.31")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=4
KERNEL_SUBLEVEL:=31
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://www.uclibc.org/downloads/toolchain
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.4.31.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.4.31
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.9")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=6
KERNEL_SUBLEVEL:=9
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.9.1.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.9.1
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.10")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=6
KERNEL_SUBLEVEL:=10
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.10.0.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.10.0
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.11")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=6
KERNEL_SUBLEVEL:=11
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.11.0.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.11.0
endif

ifeq ("$(DEFAULT_KERNEL_HEADERS)","2.6.12")
KERNEL_MAJORVERSION:=2
KERNEL_PATCHLEVEL:=6
KERNEL_SUBLEVEL:=12
LINUX_HEADERS_VERSION:=$(KERNEL_MAJORVERSION).$(KERNEL_PATCHLEVEL).$(KERNEL_SUBLEVEL)$(KERNEL_EXTRAVERSION)
LINUX_HEADERS_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_HEADERS_SOURCE:=linux-libc-headers-2.6.12.0.tar.bz2
LINUX_HEADERS_CAT:=$(BZCAT)
LINUX_HEADERS_DIR:=$(TOOL_BUILD_DIR)/linux
LINUX_HEADERS_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.12.0
endif


# the old sanitized kernel-headers
ifeq ($(LINUX_HEADERS_IS_KERNEL),n)

$(LINUX_HEADERS_UNPACK_DIR)/.unpacked: $(DL_DIR)/$(LINUX_HEADERS_SOURCE)
	@echo "Using old sanitized kernel-headers"
	rm -rf $(LINUX_HEADERS_DIR)
	$(LINUX_HEADERS_CAT) $(DL_DIR)/$(LINUX_HEADERS_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
ifneq ($(LINUX_HEADERS_UNPACK_DIR),$(LINUX_HEADERS_DIR))
	ln -fs $(LINUX_HEADERS_UNPACK_DIR) $(LINUX_HEADERS_DIR)
endif
	touch $(LINUX_HEADERS_UNPACK_DIR)/.unpacked

$(LINUX_HEADERS_DIR)/.patched: $(LINUX_HEADERS_UNPACK_DIR)/.unpacked
	toolchain/patch-kernel.sh $(LINUX_HEADERS_DIR) toolchain/kernel-headers \
		linux-libc-headers-$(LINUX_HEADERS_VERSION)\*.patch
ifeq ($(strip $(ARCH)),nios2)
	toolchain/patch-kernel.sh $(LINUX_HEADERS_DIR) toolchain/kernel-headers \
		linux-libc-headers-$(LINUX_HEADERS_VERSION)-nios2nommu.patch.conditional
endif
	touch $(LINUX_HEADERS_DIR)/.patched

$(LINUX_HEADERS_DIR)/.configured: $(LINUX_HEADERS_DIR)/.patched
	rm -f $(LINUX_HEADERS_DIR)/include/asm
	@if [ ! -f $(LINUX_HEADERS_DIR)/Makefile ] ; then \
	    /bin/echo -e "VERSION = $(KERNEL_MAJORVERSION)\nPATCHLEVEL = $(KERNEL_PATCHLEVEL)\n" > \
		    $(LINUX_HEADERS_DIR)/Makefile; \
	    /bin/echo -e "SUBLEVEL = $(KERNEL_SUBLEVEL)\nEXTRAVERSION =\n" >> \
		    $(LINUX_HEADERS_DIR)/Makefile; \
	    /bin/echo -e "KERNELRELEASE=\$$(VERSION).\$$(PATCHLEVEL).\$$(SUBLEVEL)\$$(EXTRAVERSION)" >> \
		    $(LINUX_HEADERS_DIR)/Makefile; \
	fi
	@if [ "$(ARCH)" = "powerpc" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-ppc$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mips" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mipsel" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "nios2" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-nios2nommu asm;) \
	elif [ "$(ARCH)" = "arm" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-arm$(NOMMU) asm; \
	     cd asm; \
	     if [ ! -L proc ] ; then \
	     ln -fs proc-armv proc; \
	     ln -fs arch-ebsa285 arch; fi); \
	elif [ "$(ARCH)" = "armeb" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-arm$(NOMMU) asm; \
	     cd asm; \
	     if [ ! -L proc ] ; then \
	     ln -fs proc-armv proc; \
	     ln -fs arch-ebsa285 arch; fi); \
	elif [ "$(ARCH)" = "cris" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-cris asm;) \
	elif [ "$(ARCH)" = "sh3" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh3 cpu) \
	elif [ "$(ARCH)" = "sh3eb" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh3 cpu) \
	elif [ "$(ARCH)" = "sh4" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh4 cpu) \
	elif [ "$(ARCH)" = "sh4eb" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-sh asm; \
	     cd asm; \
	     ln -s cpu-sh4 cpu) \
	elif [ "$(ARCH)" = "i386" -o "$(ARCH)" = "i486" -o "$(ARCH)" = "i586" -o "$(ARCH)" = "i686" ];then \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-i386$(NOMMU) asm;) \
	else \
	    (cd $(LINUX_HEADERS_DIR)/include; ln -fs asm-$(ARCH)$(NOMMU) asm;) \
	fi
	touch $(LINUX_HEADERS_DIR)/include/linux/autoconf.h
	touch $(LINUX_HEADERS_DIR)/.configured

endif
