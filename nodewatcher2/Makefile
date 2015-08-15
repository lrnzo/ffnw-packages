include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-nodewatcher2
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-nodewatcher
  SECTION:=daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=Provides status data for netmon
endef

define Package/ffnw-nodewatcher2/description
	Provides an xml-File containing the most important
	informations about the router. Nodewatcher2 is meant to
	be more expandable for other export-formats in the future
	by internally seperating retrieving and outputting the router-data
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
	$(INSTALL_DATA) files/lib/gluon/cron/nodewatcher2 $(1)/lib/gluon/cron/nodewatcher2
	$(INSTALL_DIR) $(1)/lib/ffnw/nodewatcher2/
	$(INSTALL_BIN) files/lib/ffnw/nodewatcher2/nodewatcher.sh $(1)/lib/ffnw/nodewatcher2/
	$(INSTALL_DIR) $(1)/usr/lib/lua/
	$(INSTALL_DATA) files/usr/lib/lua/dkjson.lua $(1)/usr/lib/lua/
	$(INSTALL_DATA) files/etc/config/nodewatcher2 $(1)/etc/config/nodewatcher2
endef

$(eval $(call BuildPackage,ffnw-nodewatcher2))
