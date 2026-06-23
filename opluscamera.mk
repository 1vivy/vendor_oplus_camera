# Blob dependencies
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V3-ndk.vendor \
    CameraThemedIcon

# Framework
# PRODUCT_BOOT_JARS += \
#    oplus-framework

# Init
#PRODUCT_PACKAGES += \
#    init.oplus.camera.rc

# Permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/oplus_google_lens_config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/oplus_google_lens_config.xml \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-oplus.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-oplus.xml \
    $(LOCAL_PATH)/configs/sysconfig/hiddenapi-package-oplus-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/hiddenapi-package-oplus-whitelist.xml \
    $(LOCAL_PATH)/configs/permissions/default-permissions-oneplus-gallery.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/default-permissions/default-permissions-oneplus-gallery.xml \
    $(LOCAL_PATH)/configs/compatconfig/oplus-gallery-receiver-compat-config.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/compatconfig/oplus-gallery-receiver-compat-config.xml \
    $(LOCAL_PATH)/configs/init/init.oplus.camera_rus.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.oplus.camera_rus.rc

# Properties
# v2.0 SDR-preview workaround (port of dirty-work af344d3, supersedes c45f452 smali form).
# The .201 app puts the preview on a BT2020_HLG SurfaceView w/ 5.0 HDR/SDR headroom
# (PreviewHDRControl); LOS's sRGB panel has no HLG->SDR tonemap path -> preview ~5x
# over-exposed (the JPEG is fine, tonemapped provider-side). Force the preview-HDR
# capability OFF so the SurfaceView stays sRGB (numHdrLayers->0). The override is honored
# ONLY when override_enable=true; override_enable is read solely by PreviewHDRControl, so
# no other side effects. NOTE: OOS's static config does NOT set this override prop (verified
# absent in dump300_full) — OOS leaves it default since it HAS the HDR display path. The prior
# "sync OOS 16.0.8.300 HDR props" (dd3ca87) introduced =1 with NO override_enable -> inert.
# The HDR *feature* props below (dolby_vision*/hdr_vision_app/localhdr_version/edrlistener/
# uhdr.support) ARE in the OOS baseline (dump300 build.prop) -> kept as-is. LOS adds this
# override to force the preview capability off (the one piece OOS doesn't need).
PRODUCT_PRODUCT_PROPERTIES += \
    persist.vendor.camera.privapp.list=com.oplus.camera \
    persist.camera.override_enable=true \
    persist.camera.override_preview_hdr_support=false \
    persist.sys.feature.dolby_vision=1 \
    persist.sys.feature.dolby_vision_app=1 \
    persist.sys.feature.hdr_vision_app=1 \
    persist.sys.feature.localhdr_version=2 \
    persist.sys.feature.support.edrlistener=true \
    persist.sys.feature.uhdr.support=true \
    persist.sys.camera.private.log.enable=debug,pre,mp \
    ro.build.version.module.sub_api=2 \
    ro.build.version.oplus.api=38 \
    ro.build.version.oplus.sub_api=47 \
    ro.build.version.oplusrom=V16.1.0 \
    ro.build.version.oplusrom.confidential=V16.1.0 \
    ro.build.version.oplusrom.display=16.0.8 \
    ro.com.google.lens.oem_camera_package=com.oplus.camera \
    ro.com.google.lens.oem_image_package=com.oneplus.gallery,com.oplus.screenshot \
    ro.oplus.fusionlight=true \
    ro.oplus.camera.defercap.support=1 \
    ro.oplus.system.gallery.name=com.oneplus.gallery \
    ro.oplus.system.camera.name=com.oplus.camera \
    ro.oplus.camera.defercap.all.quick.visible.support=1 \
    ro.vendor.oplus.hdr.uniform=1 \
    ro.vendor.oplus.vendorxml.enable=1 \
    vendor.oplus.hdr.uniform.debug=1 \
    oplus.software.camera.10bit=1 \
    vendor.camera.aux.packagelist=com.oplus.camera \
    ro.oplus.camera.facing.front.need.disable.nfc=1 \
    ro.oplus.camera.portrait.center.switch=oplus.switch.portrait.center \
    ro.oplus.camera.portrait_center.prefix=oplus.portrait.center. \
    ro.oplus.camera.video.beauty.switch=oplus.switch.video.beauty \
    ro.oplus.camera.video_beauty.prefix=oplus.video.beauty. \
    ro.oplus.camera.speechassist=true \
    ro.oplus.system.camera.flashlight=com.oplus.motor.flashlight \
    ro.camera.privileged.3rdpartyApp=com.mediatek.expert.mtkcamhelper;com.aiunit.aon; \

# Photo
$(call soong_config_set,camera,package_name,com.oplus.packageName)

# Video
$(call soong_config_set_bool,camera,override_format_from_reserved,true)

# SEpolicy
include vendor/oplus/camera/sepolicy/SEPolicy.mk

# Inherit from camera-vendor.mk
$(call inherit-product, vendor/oplus/camera/camera/camera-vendor.mk)
