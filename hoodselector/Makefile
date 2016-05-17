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
  DEPENDS:=+lwtrace +ffnw-hoods +dkjson gluon-mesh-batman-adv-15 +gluon-mesh-vpn-fastd
endef

define Package/$(PKG_NAME)/description
	Select the hoods depending on the geo coordinates
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc/* $(PKG_BUILD_DIR)/
	sed -e 's/--.*//' -e '/^$$$$/d' $(PKG_BUILD_DIR)/hoodselector > $(PKG_BUILD_DIR)/hoodselector-min
	chmod +x $(PKG_BUILD_DIR)/hoodselector-min
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/hoodselector-min $(1)/usr/sbin/hoodselector
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
