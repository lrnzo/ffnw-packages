include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-config-mode-contact-info
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)


define Package/ffnw-config-mode-contact-info
  SECTION:=config-mode
  CATEGORY:=Freifunk Nordwest
  TITLE:=Set a custom string that will be distributed in the mesh.
  DEPENDS:=gluon-config-mode-core-virtual +ffnw-node-info
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,ffnw-config-mode-contact-info,i18n)
endef

define Package/ffnw-config-mode-contact-info/install
	$(CP) ./files/* $(1)/
	$(call GluonInstallI18N,ffnw-config-mode-contact-info,$(1))
endef

$(eval $(call BuildPackage,ffnw-config-mode-contact-info))
