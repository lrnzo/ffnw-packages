include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-banner
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-banner
  SECTION:=config
  CATEGORY:=Freifunk Nordwest
  TITLE:=Nordwest freifunk shell banner
endef

define Package/ffnw-banner/description
  Nordwest freifunk shell banner
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-banner/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffnw-banner))
