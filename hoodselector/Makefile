include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-hoodselector
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_BUILD_DEPENDS += lua/host luci-base/host

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-hoodselector
  SECTION:=networke
  CATEGORY:=Freifunk Nordwest
  TITLE:=Select the hoods depending on the geo coordinate
  DEPENDS:=+lwtrace +ffnw-hoods +dkjson gluon-mesh-batman-adv-15 +gluon-mesh-vpn-fastd
endef

define Package/ffnw-hoodselector/description
	Select the hoods depending on the geo coordinates
endef

define SrcDiet
	$(FIND) $(1) -type f | while read src; do \
		if $(STAGING_DIR_HOST)/bin/lua $(STAGING_DIR_HOST)/bin/LuaSrcDiet \
			--noopt-binequiv -o "$$$$src.o" "$$$$src"; \
			then mv "$$$$src.o" "$$$$src"; fi; \
	done
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc/* $(PKG_BUILD_DIR)/
	$(call SrcDiet,$(PKG_BUILD_DIR),$(PKG_BUILD_DIR))
	chmod +x -R $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-hoodselector/install
	$(CP) ./files/* $(1)/
	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) $(PKG_BUILD_DIR)/hoodselector $(1)/usr/sbin/hoodselector
endef

$(eval $(call BuildPackage,ffnw-hoodselector))
