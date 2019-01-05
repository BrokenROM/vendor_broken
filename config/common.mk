PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.debug.alloc=0

# Default sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/slim/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/slim/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/slim/prebuilt/common/bin/50-slim.sh:system/addon.d/50-slim.sh

# SLIM-specific init file
PRODUCT_COPY_FILES += \
    vendor/slim/prebuilt/common/etc/init.slim.rc:system/etc/init/init.slim.rc

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/slim/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/slim/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/slim/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# debug packages
ifneq ($(TARGET_BUILD_VARIENT),user)
PRODUCT_PACKAGES += \
    Development
endif

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/slim/config/twrp.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

#SnapdragonGallery
PRODUCT_PACKAGES += \
    SnapdragonGallery

# Extra Optional packages
PRODUCT_PACKAGES += \
    bootanimation.zip \
    SlimLauncher \
    SlimWallpaperResizer \
    SlimWallpapers \
    LatinIME \
    BluetoothExt \
    WallpaperPicker
#    SlimFileManager removed until updated

ifneq ($(DISABLE_SLIM_FRAMEWORK), true)
## Slim Framework
include frameworks/slim/slim_framework.mk
endif

## Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs

# exFAT tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/slim/overlay/common \
    vendor/slim/overlay/dictionaries

# Versioning System
# Slim version.
PRODUCT_VERSION_MAJOR = $(PLATFORM_VERSION)
PRODUCT_VERSION_MINOR = build
PRODUCT_VERSION_MAINTENANCE = 0.1
ifdef SLIM_BUILD_EXTRA
    SLIM_POSTFIX := -$(SLIM_BUILD_EXTRA)
endif
ifndef SLIM_BUILD_TYPE
    SLIM_BUILD_TYPE := UNOFFICIAL
endif

ifeq ($(SLIM_BUILD_TYPE),DM)
    SLIM_POSTFIX := -$(shell date +"%Y%m%d")
endif

ifndef SLIM_POSTFIX
    SLIM_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
SLIM_VERSION := 9.0
SLIM_MOD_VERSION := Slim-$(SLIM_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(SLIM_BUILD_TYPE)$(SLIM_POSTFIX)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    slim.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.slim.version=$(SLIM_VERSION) \
    ro.modversion=$(SLIM_MOD_VERSION) \
    ro.slim.buildtype=$(SLIM_BUILD_TYPE)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.slim.version=$(SLIM_VERSION) \

PRODUCT_COPY_FILES += \
    vendor/slim/config/permissions/privapp-permissions-slim.xml:system/etc/permissions/privapp-permissions-slim.xml

EXTENDED_POST_PROCESS_PROPS := vendor/slim/tools/slim_process_props.py

PRODUCT_EXTRA_RECOVERY_KEYS += \
  vendor/slim/build/target/product/security/slim

-include vendor/slim-priv/keys/keys.mk

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

$(call inherit-product-if-exists, vendor/extra/product.mk)
