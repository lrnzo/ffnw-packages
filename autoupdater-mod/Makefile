include $(TOPDIR)/rules.mk

PKG_NAME:=ffnw-autoupdater-mod
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffnw-autoupdater-mod
  SECTION:=Daemon
  CATEGORY:=Freifunk Nordwest
  TITLE:=custom autoupdater special for batman upgrade
endef

define Package/ffnw-autoupdater-mod/description
  custom autoupdater special for batman upgrade
endef

define Build/Prepare
  mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffnw-autoupdater-mod/install
	$(INSTALL_DIR) $(1)/lib/gluon/cron/
	$(INSTALL_DATA) files/lib/gluon/cron/* $(1)/lib/gluon/cron/
	$(INSTALL_DIR) $(1)/lib/ffnw/autoupdater-mod/
	$(INSTALL_BIN) files/lib/ffnw/autoupdater-mod/* $(1)/lib/ffnw/autoupdater-mod/
endef

$(eval $(call BuildPackage,ffnw-autoupdater-mod))
