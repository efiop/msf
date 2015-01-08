__msf_dir=../scripts/
export __msf_dir

include $(__msf_dir)include.mk

MAKEFLAGS := -r -R --no-print-directory

.PHONY: all

all:
	$(call msg-gen, simple)
	$(Q) $(MAKE) -C simple
