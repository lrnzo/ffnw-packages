include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-geolocator
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-geolocator
  SECTION:=daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=Sed geoposition for alfred
endef

define Package/ffnw-geolocator/description
	Sed geoposition for alfred
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-geolocator/install
	$(INSTALL_DIR) $(1)/lib/gluon/cron/
	$(INSTALL_DATA) files/lib/gluon/cron/geolocator $(1)/lib/gluon/cron/geolocator
	$(INSTALL_DIR) $(1)/lib/ffnw/geolocator/
	$(INSTALL_BIN) files/lib/ffnw/geolocator/geolocator.sh $(1)/lib/ffnw/geolocator/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) files/geolocator.config $(1)/etc/config/geolocator
endef

$(eval $(call BuildPackage,ffnw-geolocator))
