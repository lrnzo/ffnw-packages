include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-autoupdater-mod
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-autoupdater-mod
  SECTION:=Daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=custom autoupdater special to split the testing from stable network
endef

define Package/ffnw-autoupdater-mod/description
  custom autoupdater special to split the testing from stable network
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-autoupdater-mod/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffnw-autoupdater-mod))
