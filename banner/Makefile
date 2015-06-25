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
  MAINTAINER:=Freifunk Nordwest <tarek@ring0.de>
  URL:=https://git.nordwest.freifunk.net/ffnw/packages
  SOURCE:=git@git.nordwest.freifunk.net:ffnw/packages.git
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

define Package/ffnw-banner/preinst
  #!/bin/sh
  cd "$${IPKG_INSTROOT}/etc/"
  if [ -h "./banner" ] ; then
    /bin/rm "./banner"
  elif [ -f "./banner" ] ; then
    /bin/mv "./banner" "/tmp/banner.openwrt"
  fi
  /bin/ln -s "/tmp/banner.openwrt" "/etc/banner"
  exit 0
endef

define Package/ffnw-banner/postinst
  #!/bin/sh
  cd "$${IPKG_INSTROOT}/etc/"
  [ -h "./banner" ] && /bin/rm -f "./banner"
  /bin/mv "./banner.ffnw" "./banner"
  exit $$?
endef

define Package/ffnw-banner/prerm
  #!/bin/sh
  cd "$${IPKG_INSTROOT}/etc/"
  if [ -h "./banner" ] ; then
    [[ "$$(readlink -n ./banner)" == "./banner.ffnw" ]] && \
    /bin/rm -f "./banner" && \
    [ -f "/tmp/banner.openwrt" ] && \
    /bin/ln -s "./banner.openwrt" "./banner"
  fi
  exit 0
endef

define Package/ffnw-banner/install
  $(INSTALL_DIR) $(1)/etc/
  $(INSTALL_DATA) files/etc/banner.ffnw $(1)/etc/
endef

$(eval $(call BuildPackage,ffnw-banner))
