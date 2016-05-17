#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luamin
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/mathiasbynens/luamin.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=66ec0d4b5ab171a1c5fb57cbdf2fb1633a7b0ea6
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

HOST_BUILD_DEPENDS:=node/host
HOST_BUILD_DEPENDS:=luaparse/host

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
  URL:=https://github.com/mathiasbynens/luamin
  TITLE:=Luamin is a lua minifyer tool written in JS
  DEPENDS:=+node +luaparse
  MAINTAINER:=Jan-Tarek Butt <tarek@ring0.de>
endef

define Package/$(PKG_NAME)/description
  Luamin uses the excellent luaparse library to parse Lua code into an Abstract Syntax Tree.
  Based on that AST, luamin then generates a (hopefully) more compact yet semantically equivalent Lua program.
  luamin was inspired by the LuaMinify and Esmangle projects.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_DIR) $(1)/lib/node_modules/$(PKG_NAME)
	$(CP) $(PKG_BUILD_DIR)/* $(1)/lib/node_modules/$(PKG_NAME)/
	$(LN) $(PKG_BUILD_DIR)/lib/node_modules/$(PKG_NAME)/bin/$(PKG_NAME) $(1)/bin/$(PKG_NAME)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/usr/lib/node_modules/$(PKG_NAME)
	$(CP) $(PKG_BUILD_DIR)/* $(1)/lib/node_modules/$(PKG_NAME)/
	$(LN) $(1)/lib/node_modules/$(PKG_NAME)/bin/$(PKG_NAME) $(1)/usr/sbin/$(PKG_NAME)
endef

define Host/Compile
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin/
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/lib/node_modules/$(PKG_NAME)
endef

define Host/Install
	$(CP) $(HOST_BUILD_DIR)/* $(STAGING_DIR_HOST)/lib/node_modules/$(PKG_NAME)/
	$(LN) $(STAGING_DIR_HOST)/lib/node_modules/$(PKG_NAME)/bin/$(PKG_NAME) $(STAGING_DIR_HOST)/bin/$(PKG_NAME)
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,$(PKG_NAME)))
