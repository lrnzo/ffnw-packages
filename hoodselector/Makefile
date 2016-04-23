include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-hoodselector
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=networke
  CATEGORY:=Freifunk Nordwest
  TITLE:=Select the hoods depending on the geo coordinate
  DEPENDS:=+lwtrace +libwlocate +ffnw-hoods +dkjson
endef

define Package/$(PKG_NAME)/description
	Select the hoods depending on the geo coordinates
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	sed '/[--].*/d' ./files/usr/sbin/hoodselector >> ./files/usr/sbin/hoodselector
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
