include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-node-info
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_DEPENDS := respondd

include $(GLUONDIR)/include/package.mk

define Package/ffnw-node-info
  SECTION:=daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=Add /etc/config/gluon-node-info to uci
  DEPENDS:=+lwtrace +libwlocate +gluon-core +libgluonutil
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/ffnw-node-info/install
	$(CP) ./files/* $(1)/

	$(INSTALL_DIR) $(1)/lib/gluon/respondd
	$(CP) $(PKG_BUILD_DIR)/respondd.so $(1)/lib/gluon/respondd/node-info.so
endef

define Package/ffnw-node-info/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
endef

$(eval $(call BuildPackage,ffnw-node-info))
