#
# Usage: option = $(call try-cc, source-to-build, cc-options)
try-cc := $(shell sh -c                                                                         \
                'TMP="$(OUTPUT)$(TMPOUT).$$$$";                                                 \
                 echo "$(1)" |                                                                  \
                 $(CC) $(DEFINES) -x c - $(2) $(3) -o "$$TMP" > /dev/null 2>&1 && echo y;       \
                 rm -f "$$TMP"')

#
# Remove duplicates
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

#
# Footer
____msf_defined__utils := y
