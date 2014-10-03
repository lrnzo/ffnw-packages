include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-fastdreg
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-fastdreg
  SECTION:=fastd
  CATEGORY:=Freifunk Nordwest
  TITLE:=Adds script which registers fastd-key
  DEPENDS:=+gluon-mesh-vpn-fastd
endef

define Package/ffnw-fastdreg/description
	Adds script which registers fastd-key
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-fastdreg/install
	$(INSTALL_DIR) $(1)/lib/gluon/cron/
	$(INSTALL_DATA) files/lib/gluon/cron/fastdreg $(1)/lib/gluon/cron/fastdreg
	$(INSTALL_DIR) $(1)/lib/ffnw/fastdreg/
	$(INSTALL_BIN) files/lib/ffnw/fastdreg/fastdreg.sh $(1)/lib/ffnw/fastdreg/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) files/fastdreg.config $(1)/etc/config/fastdreg
endef

$(eval $(call BuildPackage,ffnw-fastdreg))
