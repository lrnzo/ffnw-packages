include $(TOPDIR)/rules.mk

PKG_NAME:=lua-json-generator
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/lua-json-generator
  SECTION:=libs
  CATEGORY:=Freifunk Nordwest
  TITLE:=json-generator for lua
endef

define Package/lua-json-generator/description
	This contains a purified version of the json-parser/-generator dkjson as a generating-only lua-library. By removing its json parsing abilities its filesize was reduced massively.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/lua-json-generator/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,lua-json-generator))
