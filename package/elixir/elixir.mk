#############################################################
#
# elixir
#
#############################################################

ELIXIR_VERSION = v0.12.5
ELIXIR_SITE = $(call github,elixir-lang,elixir,$(ELIXIR_VERSION))
ELIXIR_LICENSE = Apache-2.0
ELIXIR_LICENSE_FILES = LICENSE

# Technically we only depend on host-erlang to build the elixir
# compiler, but the files built by it only run if erlang is on
# the target.
HOST_ELIXIR_DEPENDENCIES = host-erlang erlang

define HOST_ELIXIR_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_ELIXIR_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(HOST_DIR) install
endef

$(eval $(host-generic-package))
