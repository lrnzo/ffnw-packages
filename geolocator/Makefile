include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-nodewatcher
PKG_VERSION:=30
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-nodewatcher
  SECTION:=daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=Provides status data for netmon 
endef

define Package/ffnw-nodewatcher/description
	Provides status data for netmon
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-nodewatcher/install
	$(INSTALL_DIR) $(1)/lib/gluon/cron/
	$(INSTALL_DATA) files/lib/gluon/cron/nodewatcher $(1)/lib/gluon/cron/nodewatcher
	$(INSTALL_DIR) $(1)/lib/ffnw/nodewatcher/
	$(INSTALL_BIN) files/lib/ffnw/nodewatcher/nodewatcher.sh $(1)/lib/ffnw/nodewatcher/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) files/nodewatcher.config $(1)/etc/config/nodewatcher
endef

$(eval $(call BuildPackage,ffnw-nodewatcher))
