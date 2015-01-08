#
# Two source files get compiled into two
# executable programs but both lives in
# same directory.

#
# Mandatory part to include msf itself
__msf_dir=../../scripts/
export __msf_dir

include $(__msf_dir)include.mk

MAKEFLAGS := -r -R --no-print-directory
build := -r -R -f $(__msf_dir)main.mk makefile=Makefile obj

PROGRAMS += src/src-1
PROGRAMS += src/src-2

CFLAGS += -iquote ./include
export CFLAGS

.PHONY: src

src/%::
	$(Q) $(MAKE) $(build)=src $@
src:
	$(Q) $(MAKE) $(build)=src all

src/src-1: src/one.built-in.o
	$(call msg-link, $@)
	$(Q) $(CC) $(CGLAGS) -o $@ $^

src/src-2: src/two.built-in.o
	$(call msg-link, $@)
	$(Q) $(CC) $(CGLAGS) -o $@ $^

clean:
	$(call msg-clean, $(PROGRAMS))
	$(Q) $(RM) $(PROGRAMS)
	$(Q) $(MAKE) $(build)=src clean

all: $(PROGRAMS)
	@true

.DEFAULT_GOAL := all
