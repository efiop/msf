#
# Genaral inclusion statement

ifndef ____msf_defined__include
        include $(__msf_dir)include.mk
endif

ifndef ____msf_defined__macro
        include $(__msf_dir)macro.mk
endif

#
# Anything else might be included with
#
#       $(eval $(call include-once,<name.mk>))
#
# Note the order does matter!

$(eval $(call include-once,tools.mk))
$(eval $(call include-once,utils.mk))
$(eval $(call include-once,rules.mk))
$(eval $(call include-once,build.mk))

#
# Footer
____msf_defined__main := y
