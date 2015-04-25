include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-opkgconfig
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-opkgconfig
  SECTION:=config
  CATEGORY:=Freifunk Nordwest
  TITLE:=Set ipv6 mirrorlist for opkg
endef

define Package/ffnw-opkgconfig/description
  Set ipv6 mirrorlist for opkg
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-opkgconfig/install
  $(INSTALL_CONF) files/opkg.conf $(1)/etc/opkg.conf
endef

$(eval $(call BuildPackage,ffnw-opkgconfig))
