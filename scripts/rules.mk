#
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-o-from-c-by-name
$(2).o: $(1).c
	$$(call msg-cc, $$@)
	$$(Q) $$(CC) -c $$(CFLAGS) $$(cflags-y) $(3) $$< -o $$@
endef

#
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-i-from-c-by-name
$(2).i: $(1).c
	$$(call msg-cc, $$@)
	$$(Q) $$(CC) -E $$(CFLAGS) $$(cflags-y) $(3) $$< -o $$@
endef

#
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-s-from-c-by-name
$(2).s: $(1).c
	$$(call msg-cc, $$@)
	$$(Q) $$(CC) -S $$(CFLAGS) $$(cflags-y) $(3) -fverbose-asm $$< -o $$@
endef

#
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-o-from-S-by-name
$(2).o: $(1).S
	$$(call msg-cc, $$@)
	$$(Q) $$(CC) -c $$(CFLAGS) $$(cflags-y) $(3) $$(ASMFLAGS) $$(asmflags-y) $(4) $$< -o $$@
endef

#
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-d-from-c-by-name
$(2).d: $(1).c
	$$(call msg-dep, $$@)
	$$(Q) $$(CC) -M -MT $$@ -MT $$(patsubst %.d,%.o,$$@) $$(CFLAGS) $$(cflags-y) $(3) $$< -o $$@
endef

#
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-d-from-S-by-name
$(2).d: $(1).S
	$$(call msg-dep, $$@)
	$$(Q) $$(CC) -M -MT $$@ -MT $$(patsubst %.d,%.o,$$@) $$(CFLAGS) $$(cflags-y) $(3) $$< -o $$@
endef

#
# $(1) - source file name
# $(2) - destination file name
# $(3) - additional flags
define gen-rule-i-from-S-by-name
$(2).i: $(1).S
	$$(call msg-cc, $$@)
	$$(Q) $$(CC) -E $$(CFLAGS) $$(cflags-y) $(3) $$< -o $$@
endef

#
# Footer
____msf_defined__rules := y
