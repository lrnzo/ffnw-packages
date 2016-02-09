include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-hoods
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=networke
  CATEGORY:=Freifunk Nordwest
  TITLE:=Hoodjson file
endef

define Package/$(PKG_NAME)/description
	Hoodjson file
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
