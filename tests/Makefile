__msf_dir=../scripts/
export __msf_dir

include $(__msf_dir)include.mk

MAKEFLAGS := -r -R --no-print-directory

.PHONY: all clean

all:
	$(call msg-gen, simple)
	$(Q) $(MAKE) -C simple
	$(call msg-gen, mult)
	$(Q) $(MAKE) -C mult
	$(call msg-gen, lib)
	$(Q) $(MAKE) -C lib

clean:
	$(Q) $(MAKE) -C simple clean
	$(Q) $(MAKE) -C mult clean
	$(Q) $(MAKE) -C lib clean

.DEFAULT_GOAL	:= all
