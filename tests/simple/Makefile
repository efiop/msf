#
# A trivial example:
#  - source code lives in src/
#  - two files get compiled into src/built-in.o
#  - then linked into src/$(PROGRAM)

#
# Mandatory part to include msf itself
__msf_dir=../../scripts/
export __msf_dir

include $(__msf_dir)include.mk

MAKEFLAGS := -r -R --no-print-directory
build := -r -R -f $(__msf_dir)main.mk makefile=Makefile obj

PROGRAM := simple

$(eval $(call gen-build-exec,src,$(PROGRAM)))

clean:
	$(call msg-clean, $(PROGRAM))
	$(Q) $(RM) $(PROGRAM)
	$(Q) $(MAKE) $(build)=src $@

all: $(PROGRAM)
	@true

.DEFAULT_GOAL := all
