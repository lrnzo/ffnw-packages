include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-node-info
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-node-info
  SECTION:=daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=Sed node infos for alfred
  DEPENDS:=+lwtrace
endef

define Package/ffnw-node-info/description
	Sed node infos for alfred
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-node-info/install
	$(CP) ./files/* $(1)/
endef

define Package/ffnw-node-info/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,ffnw-node-info))
