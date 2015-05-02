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
	$(INSTALL_DIR) $(1)/lib/gluon/cron/
	$(INSTALL_DATA) files/lib/gluon/cron/opkgconfig $(1)/lib/gluon/cron/opkgconfig
	$(INSTALL_DIR) $(1)/lib/ffnw/opkgconfig/
	$(INSTALL_BIN) files/lib/ffnw/opkgconfig/opkgconfig.sh $(1)/lib/ffnw/opkgconfig/
	$(INSTALL_CONF) files/lib/ffnw/opkgconfig/opkg.conf $(1)/lib/ffnw/opkgconfig/
endef

$(eval $(call BuildPackage,ffnw-opkgconfig))
