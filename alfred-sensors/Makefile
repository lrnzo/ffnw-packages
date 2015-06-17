include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-sensors
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-sensors
  SECTION:=sensors
  CATEGORY:=Freifunk Nordwest
  TITLE:=Provides sensor data for alfred
endef

define Package/ffnw-sensors/description
	Provides sensor data for alfred
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-sensors/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffnw-sensors))
