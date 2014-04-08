#############################################################
#
# erlinit
#
#############################################################

ERLINIT_VERSION = f8d704fdef76c98c96ef7fd814401b8c7ebf4da0
ERLINIT_SITE = $(call github,nerves-project,erlinit,$(ERLINIT_VERSION))
ERLINIT_LICENSE = MIT

# Make sure erlinit gets installed after busybox init so that
# it gets called
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
ERLINIT_DEPENDENCIES += busybox
endif

define ERLINIT_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define ERLINIT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/erlinit $(TARGET_DIR)/sbin/init
endef

$(eval $(generic-package))
