#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luaparse
PKG_VERSION:=0.2.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/oxyc/luaparse.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=e4924cff95dbf02c9b09160638739df0552485b5
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

HOST_BUILD_DEPENDS:=node/host

HOST_BUILD_PARALLEL:=1
PKG_BUILD_PARALLEL:=1


PKG_MAINTAINER:=Jan Tarek Butt <tarek@ring0.de>
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Lua
  URL:=https://github.com/oxyc/luaparse
  TITLE:=A Lua parser written in JavaScript.
  DEPENDS:=+node
  MAINTAINER:=Jan-Tarek Butt <tarek@ring0.de>
endef

define Package/$(PKG_NAME)/description
  A Lua parser written in JavaScript.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/lib/node_modules/$(PKG_NAME)
	$(CP) $(PKG_BUILD_DIR)/* $(1)/lib/node_modules/$(PKG_NAME)/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/node_modules/$(PKG_NAME)
	$(CP) $(PKG_BUILD_DIR)/* $(1)/lib/node_modules/$(PKG_NAME)/
endef

define Host/Compile
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/lib/node_modules/$(PKG_NAME)
endef

define Host/Install
	$(CP) $(HOST_BUILD_DIR)/* $(STAGING_DIR_HOST)/lib/node_modules/$(PKG_NAME)/
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,$(PKG_NAME)))
