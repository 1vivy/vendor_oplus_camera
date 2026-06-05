# Blob dependencies
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V3-ndk.vendor

# Framework
# PRODUCT_BOOT_JARS += \
#    oplus-framework

# Init
#PRODUCT_PACKAGES += \
#    init.oplus.camera.rc

# Permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/init/init.oplus.camera_rus.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.oplus.camera_rus.rc \
    $(LOCAL_PATH)/configs/permissions/com.oplus.android-features.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.oplus.android-features.xml \
    $(LOCAL_PATH)/configs/permissions/oplus_google_lens_config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/oplus_google_lens_config.xml \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-oplus.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-oplus.xml \
    $(LOCAL_PATH)/configs/permissions/default-permissions-oneplus-gallery.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/default-permissions/default-permissions-oneplus-gallery.xml \
    $(LOCAL_PATH)/configs/compatconfig/oplus-gallery-receiver-compat-config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/compatconfig/oplus-gallery-receiver-compat-config.xml \
    $(LOCAL_PATH)/configs/sysconfig/hiddenapi-package-oplus-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/hiddenapi-package-oplus-whitelist.xml

# OPlus camera framework wrapper stubs (com.oplus.wrapper.*, OplusHeifWriter, etc.).
# Shipped as a regular system_ext/framework shared library (NOT a boot jar) and pulled
# into OplusCamera's classloader via <uses-library> (declared in privapp-permissions-oplus.xml,
# injected into the app manifest by the uses-library fixup in extract-files.py).
# Keeping it OFF PRODUCT_BOOT_JARS avoids baking app-only stubs into boot.art — a
# boot-image dex2oat/verification failure there fails zygote/system_server = bootloop —
# and scopes the wrapper classes to just the app that needs them.
PRODUCT_PACKAGES += \
    oplus-camera-stubs

# Defines the oplus/oppo *.COMPONENT_SAFE / *.safe.* permission family (normally from
# SecurityPermission.apk, which is android.uid.system and bootloops — see camera-vendor.mk).
# Without these defined, OplusCamera's launch-time bind to com.oneplus.gallery's
# OplusPreTileDecodeService (requires oppo.permission.OPPO_COMPONENT_SAFE) is a fatal
# SecurityException.
PRODUCT_PACKAGES += \
    OplusCameraSafePermissions

# libOplusSecurity, QNN runtime, CameraX extensions, and Gallery app-lib QNN
# duplicates are extraction-owned; see proprietary-files.txt. Do not commit
# them as root-level prebuilts or LFS payloads.
PRODUCT_PACKAGES += \
    libQnnHtp_gallery_app_lib \
    libQnnHtpPrepare_gallery_app_lib \
    libQnnHtpV81Stub_gallery_app_lib \
    libQnnHtpV81CalculatorStub_gallery_app_lib \
    libQnnSaver_gallery_app_lib \
    libQnnSystem_gallery_app_lib

# Properties
PRODUCT_PRODUCT_PROPERTIES += \
    persist.vendor.camera.privapp.list=com.oplus.camera \
    persist.sys.camera.private.log.enable=debug,pre,mp \
    ro.com.google.lens.oem_camera_package=com.oplus.camera \
    ro.com.google.lens.oem_image_package=com.oneplus.gallery,com.oplus.screenshot \
    ro.build.version.oplusrom=V16.0.0 \
    ro.build.version.oplusrom.display=16.0 \
    ro.build.version.oplusrom.confidential=V16.0.0 \
    ro.camerax.extensions.enabled=true \
    ro.oplus.camera.defercap.support=1 \
    ro.oplus.system.camera.name=com.oplus.camera \
    ro.oplus.camera.defercap.all.quick.visible.support=1 \
    ro.oplus.camera.livephoto.support=1 \
    ro.camera.disableHeicUltraHDR=1 \
    oplus.software.camera.10bit=1 \
    vendor.camera.aux.packagelist=* \
    ro.camera.notify_nfc=1 \
    ro.oplus.camera.facing.front.need.disable.nfc=1 \
    ro.oplus.camera.portrait.center.switch=oplus.switch.portrait.center \
    ro.oplus.camera.portrait_center.prefix=oplus.portrait.center. \
    ro.oplus.camera.video.beauty.switch=oplus.switch.video.beauty \
    ro.oplus.camera.video_beauty.prefix=oplus.video.beauty. \
    ro.oplus.camera.speechassist=true \
    ro.oplus.system.camera.flashlight=com.oplus.motor.flashlight \
    ro.camera.privileged.3rdpartyApp=com.mediatek.expert.mtkcamhelper;com.aiunit.aon; \
    persist.logd.log.load.camerahalserver.lower_limit=1000 \
    persist.logd.log.load.camerahalserver.threshold=800000 \
    persist.logd.log.load.camerahalserver.upper_limit=3000 \
    persist.logd.log.load.com.oplus.camera.lower_limit=1000 \
    persist.logd.log.load.com.oplus.camera.threshold=800000 \
    persist.logd.log.load.com.oplus.camera.upper_limit=3000 \
    persist.logd.log.load.vendor.qti.camera.provider-service_64.lower_limit=500 \
    persist.logd.log.load.vendor.qti.camera.provider-service_64.threshold=400000 \
    persist.logd.log.load.vendor.qti.camera.provider-service_64.upper_limit=1500 \
    persist.sys.feature.localhdr_version=2 \
    persist.sys.feature.hdr_vision_app=1 \
    persist.sys.feature.uhdr.support=true \
    persist.sys.feature.support.edrlistener=true \
    persist.sys.feature.dolby_vision=1 \
    persist.sys.feature.dolby_vision_app=1 \
    persist.camera.override_preview_hdr_support=1 \

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.oplus.hdr.uniform=1 \
    vendor.oplus.hdr.uniform.debug=1 \
    ro.oplus.fusionlight=true \
    ro.camera.enableCamera1MaxZsl=1 \
    ro.vendor.oplus.camera.backCamSize=50MP+50MP+50MP \
    ro.vendor.oplus.camera.frontCamSize=32MP

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.build.version.oplus.api=38 \
    ro.build.version.oplus.sub_api=28 \
    ro.vendor.oplus.vendorxml.enable=1 \
    ro.oplus.camera.defercap.support=1

# Photo
$(call soong_config_set,camera,package_name,com.oplus.packageName)

# Video
$(call soong_config_set_bool,camera,override_format_from_reserved,true)

# SEpolicy
include vendor/oneplus/camera/sepolicy/SEPolicy.mk

# Inherit from camera-vendor.mk
$(call inherit-product, vendor/oneplus/camera/camera/camera-vendor.mk)
