#
# General helpers for simplified Makefiles.
#
MAKEFLAGS := -r -R --no-print-directory

_objs           :=
_deps           :=
_cleanups       :=
_targets        :=

ifneq ($(obj),)
        ifneq ($(makefile),)
                include $(obj)/$(makefile)
                #
                # Include predefined if requested
		# (note no $(obj)/ here it must be
		# prepared by the caller.
                _deps += $(dep-y)
                _cleanups += $(cleanup-y)
        endif
endif

#
# Generate a bundle of rules for C files
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-c-bundle
        $(eval $(call gen-rule-o-from-c-by-name,$(1),$(2),$(3)))
        $(eval $(call gen-rule-i-from-c-by-name,$(1),$(2),$(3)))
        $(eval $(call gen-rule-d-from-c-by-name,$(1),$(2),$(3)))
        $(eval $(call gen-rule-s-from-c-by-name,$(1),$(2),$(3)))
        _cleanups += $(2).o
        _cleanups += $(2).i
        _cleanups += $(2).d
        _cleanups += $(2).s
endef

#
# Generate a bundle of rules for S files
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-S-bundle
        $(eval $(call gen-rule-o-from-S-by-name,$(1),$(2),$(3)))
        $(eval $(call gen-rule-d-from-S-by-name,$(1),$(2),$(3)))
        $(eval $(call gen-rule-i-from-S-by-name,$(1),$(2),$(3)))
        _cleanups += $(2).o
        _cleanups += $(2).d
        _cleanups += $(2).i
endef

#
# Generate a bundle of rules for S files
# $(1) - helper to call
# $(2) - source file name (with prefix if needed)
# $(3) - additional flags
# $(4) - objects accumulator
# $(5) - deps accumulator
define gen-obj-rules
        $(foreach file, $(2),                                                                   \
                $(eval                                                                          \
                        $(call $(1),                                                            \
                                $(file:.o=),$(file:.o=),$(3))))
        $(4) += $(2)
        $(5) += $(2:.o=.d)
endef

#
# Generate a bundle of rules for C files
# $(1) - source file names (including prefix)
# $(2) - additional flags
# $(3) - objects accumulator
# $(4) - deps accumulator
define gen-obj-c-rules
        $(eval $(call gen-obj-rules,gen-rule-c-bundle,                                          \
                        $(1),,$(3),$(4)))
endef

#
# Generate a bundle of rules for C files
# $(1) - source file names (including prefix)
# $(2) - additional flags
# $(3) - objects accumulator
# $(4) - deps accumulator
define gen-obj-S-rules
        $(eval $(call gen-obj-rules,gen-rule-S-bundle,                                          \
                        $(1),,$(3),$(4)))
endef

#
# Default mode
ifneq ($(obj-y),)
        $(eval $(call gen-obj-c-rules,                                                          \
                        $(addprefix $(obj)/,$(obj-y)),,_objs,_deps))
endif

ifneq ($(obj-e),)
        $(eval $(call gen-obj-c-rules,                                                          \
                        $(obj-e),,_objs,_deps))
endif

ifneq ($(asm-y),)
        $(eval $(call gen-obj-S-rules,                                                          \
                        $(addprefix $(obj)/,$(asm-y)),,_objs,_deps))
endif

ifneq ($(asm-e),)
        $(eval $(call gen-obj-S-rules,                                                          \
                        $(asm-e),,_objs,_deps))
endif

ifneq ($(_objs),)
        _targets += $(obj)/built-in.o
        _cleanups += $(obj)/built-in.o
endif

#
# Target mode
define gen-target-rule
        ifneq ($($(1)-obj-y),)
                $(eval $(call gen-obj-c-rules,                                                  \
                                $(addprefix $(obj)/,$($(1)-obj-y)),,                            \
                                _$(1)-objs,_$(1)-deps))
        endif
        ifneq ($($(1)-obj-e),)
                $(eval $(call gen-obj-c-rules,                                                  \
                                $($(1)-obj-e),,                                                 \
                                _$(1)-objs,_$(1)-deps))
        endif
        ifneq ($($(1)-asm-y),)
                $(eval $(call gen-obj-S-rules,                                                  \
                                $(addprefix $(obj)/,$($(1)-asm-y)),,                            \
                                _$(1)-objs,_$(1)-deps))
        endif
        ifneq ($($(1)-asm-e),)
                $(eval $(call gen-obj-S-rules,                                                  \
                                $($(1)-asm-e),,                                                 \
                                _$(1)-objs,_$(1)-deps))
        endif
        _targets += $(obj)/$(1).built-in.o
        _cleanups += $(obj)/$(1).built-in.o
endef

$(foreach t, $(targets),                                                                        \
        $(eval $(call gen-target-rule,$(t))))

#
# Include deps when needed
define include-dep
        ifeq ($(1),$(obj)/built-in.o)
                $(eval -include $(_deps))
        else
                ifneq ($(filter-out %.d, $(1)),)
                        ifneq ($(filter-out %.built-in.o,$(1)),)
                                $(eval -include $(addsuffix .d,$(basename $(1))))
                        else
                                $(eval -include $(_$(patsubst %.built-in.o,%,$(1))-deps))
                        endif
                endif
        endif
endef

ifneq ($(MAKECMDGOALS),clean)
        ifeq ($(MAKECMDGOALS),all)
                -include $(_deps)
                ifneq ($(targets),)
                        $(foreach t, $(targets), $(eval -include $(_$(t)-deps)))
                endif
        else
                $(foreach t,$(MAKECMDGOALS),$(eval $(call include-dep,$(t))))
        endif
endif

#
# Link a target
# $(1) - target name
# $(2) - object files
# $(3) - cleanup accumulator
define gen-link-rule
ifneq ($(filter %.o,$(1)),)
$(1): $(2)
	$$(call msg-link, $$@)
	$$(Q) $$(LD) $$(LDFLAGS) $$(ldflags-y) -r -o $$@ $$^
endif
ifneq ($(filter %.so,$(1)),)
$(1): $(2)
	$$(call msg-link, $$@)
	$$(Q) $$(CC) -shared $$(cflags-so) $$(ldflags-so) $$(LDFLAGS) -o $$@ $$^
endif
$(3) += $(1)
endef

#
# Default built-in
ifneq ($(_objs),)
$(eval $(call gen-link-rule,$(obj)/built-in.o,$(_objs),_cleanups))
endif

#
# Per-target built-in
$(foreach t, $(targets),                                        \
        $(eval $(call gen-link-rule,                            \
                        $(obj)/$(t).built-in.o,                 \
                        $(_$(t)-objs) $(_objs),                 \
                        _cleanups)))

#
# Wildspread target
.PHONY: all
all: $(_targets)
	@true

#
# Clean everything needed
.PHONY: clean
_cleanups := $(call uniq, $(_cleanups) $(_objs) $(_deps))
clean:
	$(call msg-clean, $(obj))
	$(Q) $(RM) $(_cleanups)

#
# Footer
____msf_defined__build := y
