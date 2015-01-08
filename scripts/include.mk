#
# Silent make rules
ifeq ($(strip $(V)),)
        E := @echo
        Q := @
else
        E := @\#
        Q :=
endif

export E Q

#
# Message helpers
define msg-gen
        $(E) "  GEN     " $(1)
endef

define msg-clean
        $(E) "  CLEAN   " $(1)
endef

define msg-cc
        $(E) "  CC      " $(1)
endef

define msg-dep
        $(E) "  DEP     " $(1)
endef

define msg-link
        $(E) "  LINK    " $(1)
endef

#
# Shorthand for simple directory built-in.o
# $(1) - directory name
define gen-build-dir
.PHONY: $(1)
$(1)/%::
	$$(Q) $$(MAKE) $$(build)=$(1) $$@
$(1):
	$$(Q) $$(MAKE) $$(build)=$(1) all
$(1)/built-in.o: $(1)
endef

#
# Shorthand for simple linked programs
# $(1) - directory name
# $(2) - executable name
define gen-build-exec
$$(eval $$(call gen-build-dir,$(1)))
$(2): $(1)/built-in.o
	$$(call msg-link, $$@)
	$$(Q) $$(CC) $$(CFLAGS) $$^ $$(LIBS) $$(LDFLAGS) -o $$@
endef

#
# If not defined yet -- fetch it out
ARCH ?= $(shell uname -m | sed          \
                -e s/i.86/i386/         \
                -e s/sun4u/sparc64/     \
                -e s/s390x/s390/        \
                -e s/parisc64/parisc/   \
                -e s/ppc.*/powerpc/     \
                -e s/mips.*/mips/       \
                -e s/sh[234].*/sh/)

ifndef ____msf_defined__tools
        include $(__msf_dir)tools.mk
endif

#
# Footer
____msf_defined__include := y
