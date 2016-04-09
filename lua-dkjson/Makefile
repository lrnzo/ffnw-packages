include $(TOPDIR)/rules.mk

PKG_NAME:=lua-dkjson
PKG_VERSION:=fdee2693613aa028
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://dkolf.de/src/dkjson-lua.fsl/tarball
PKG_SOURCE:=dkjson-$(PKG_VERSION).tar.gz
PKG_MD5SUM:=e4fb5b02a88870bdf08ed909a2f169bf
PKG_CAT:=zcat
PKG_BUILD_DIR := $(BUILD_DIR)/dkjson-$(PKG_VERSION)


include $(INCLUDE_DIR)/package.mk

define Package/lua-dkjson
  SECTION:=libs
  CATEGORY:=Freifunk Nordwest
  TITLE:=json-generator for lua
endef

define Package/lua-dkjson/description
	This contains a luamin-minimized version of the json-parser/-generator dkjson as a generating-only lua-library.
endef

define Build/Prepare
#ToDo Create workaround for lua minifier
	$(PKG_UNPACK)
endef


define Build/Configure
endef

define Build/Compile
endef

define Package/lua-dkjson/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/
	$(INSTALL_DATA) ./dkjson.lua $(1)/usr/lib/lua/dkjson.lua
endef

$(eval $(call BuildPackage,lua-dkjson))
