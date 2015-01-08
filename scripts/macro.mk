#
# Helpers to include makefile only once
#
define include-once
        ifndef $(join ____msf_defined__,$(1:.mk=))
                $(join ____msf_defined__,$(1:.mk=)) := y
                include $(__msf_dir)$(1)
        endif
endef

#
# Footer
____msf_defined__macro = y
