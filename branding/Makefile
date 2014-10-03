include $(TOPDIR)/rules.mk

PKG_NAME:=ffol-branding
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffol-branding
  SECTION:=misc
  CATEGORY:=Freifunk Nordwest
  TITLE:=Adds Freifunk Nordwest specific brandings 
endef

define Package/ffol-branding/description
	Adds Freifunk Nordwest specific brandings (banner etc.)
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffol-branding/install
	$(INSTALL_DATA) files/etc/banner $(1)/etc/banner
endef

$(eval $(call BuildPackage,ffol-branding))
