__msf_dir=../../scripts/
export __msf_dir

include $(__msf_dir)include.mk

MAKEFLAGS := -r -R --no-print-directory
build := -r -R -f $(__msf_dir)main.mk makefile=Makefile obj

CFLAGS += -iquote include
export CFLAGS

PROGRAM += src/exec
PROGRAM += src/lib.so

$(eval $(call gen-build-dir,src))
$(eval $(call gen-build-so-link,src,src/lib.so))

src/exec: src/exec.built-in.o
	$(call msg-link, $@)
	$(Q) $(CC) $(CFLAGS) $^ $(LIBS) -ldl $(LDFLAGS) -o $@

clean:
	$(call msg-clean, $(PROGRAM))
	$(Q) $(RM) $(PROGRAM)
	$(Q) $(MAKE) $(build)=src $@

all: $(PROGRAM)
	@true

.DEFAULT_GOAL	:= all
