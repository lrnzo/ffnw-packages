include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-banner
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-banner
  SECTION:=config
  CATEGORY:=Freifunk Nordwest
  TITLE:=Nordwest freifunk shell banner
endef

define Package/ffnw-banner/description
  Nordwest freifunk shell banner
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-banner/install
	$(INSTALL_DIR) $(1)/lib/gluon/cron/
	$(INSTALL_DATA) files/lib/gluon/cron/ffnw-banner $(1)/lib/gluon/cron/ffnw-banner
	$(INSTALL_DIR) $(1)/lib/ffnw/banner/
	$(INSTALL_BIN) files/lib/ffnw/banner/banner.sh $(1)/lib/ffnw/banner/
	$(INSTALL_CONF) files/lib/ffnw/banner/banner $(1)/lib/ffnw/banner/
endef

$(eval $(call BuildPackage,ffnw-banner))
