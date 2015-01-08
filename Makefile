__msf_dir=scripts/
export __msf_dir

include $(__msf_dir)include.mk

MAKEFLAGS := -r -R --no-print-directory

.PHONY: all help test docs clean install

help:
	@echo '    Targets:'
	@echo '      install dir=<dir>  - Install scripts into directory <dir>'
	@echo '      docs               - Build documentation'
	@echo '      clean              - Clean everything'

test:
	$(Q) $(MAKE) -C tests all

docs:
	$(Q) $(MAKE) -C Documentation all

install:
	@echo 'Copying scripts into $(dir)'

all:
	@true

clean:
	$(call msg-clean, "src")
	$(Q) $(MAKE) -C Documentation clean

.DEFAULT_GOAL := all
