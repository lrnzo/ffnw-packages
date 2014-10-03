include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-configurator
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-configurator
  SECTION:=daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=Registers node on netmon
endef

define Package/ffnw-configurator/description
	Registers node on netmon
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-configurator/install
	$(INSTALL_DIR) $(1)/lib/gluon/cron/
	$(INSTALL_DATA) files/lib/gluon/cron/configurator $(1)/lib/gluon/cron/configurator
	$(INSTALL_DIR) $(1)/lib/ffnw/configurator/
	$(INSTALL_BIN) files/lib/ffnw/configurator/configurator.sh $(1)/lib/ffnw/configurator/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) files/configurator.config $(1)/etc/config/configurator
endef

$(eval $(call BuildPackage,ffnw-configurator))
