#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libwlocate
PKG_VERSION:=1.5

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/libwlocate
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Shared library that can be used for location-based services
  URL:=http://sourceforge.net/projects/libwlocate/
  DEPENDS:=+libiw
endef

define Package/libwlocate/description
	libwlocate is a shared library that can be used for location-based services.
	It checks for WLAN-networks that are available near to a user and retrieves the
	current geographic position out of them.
	Thus no GPS is needed for positioning. This WLAN-based geolocation happens
	without using any of the commercial services that do the same but track the users
	position and data. libwlocate instead bases on the free OpenWLANMap project.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/libwlocate.h $(1)/usr/include/
	
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libwlocate.so $(1)/usr/lib/
endef

define Package/libwlocate/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libwlocate.so $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libwlocate))
