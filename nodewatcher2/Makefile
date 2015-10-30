include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-nodewatcher2
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-nodewatcher
  SECTION:=daemon
  CATEGORY:=Freifunk Nordwest
  DEPENDS:=+lua-json-generator
  TITLE:=Provides status data for netmon
endef

define Package/ffnw-nodewatcher2/description
	Provides various export-formats (json, xml, ...) the most important
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

define Package/ffnw-nodewatcher2/install
	$(CP) ./files/* $(1) /
endef

$(eval $(call BuildPackage,ffnw-nodewatcher2))
