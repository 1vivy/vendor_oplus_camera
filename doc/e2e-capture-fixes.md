# OnePlus 15 (infiniti) — Camera e2e Capture Fixes

This note indexes the camera bring-up fixes that make OplusCamera capture and
save a JPEG end-to-end. Some fixes live in this repo (`vendor/oneplus/camera`)
as source patches; others edit the **odm HAL blobs/configs**, which this repo
deliberately leaves to the device tree (`vendor/oneplus/infiniti`) — see the
`# [HAL-owned-by-device-tree] odm/...` annotations in `proprietary-files.txt`.
This file is the cross-reference so the device-tree-side camera fixes are
discoverable from the camera repo.

## In this repo — `vendor/oneplus/camera`

- `patches/OplusCameraUnitSdk/0001-Stamp-Oplus-identity-for-system-camera-unlock-SAT-Fusion.patch`
  BaseMode self-stamps the Oplus identity so the SYSTEM camera unlocks the
  SAT-Fusion config path (otherwise gated into the non-Oplus graph → `-38`).
- `patches/OplusCamera/0001-Decode-smali-for-SystemProperties-wrapper-fix.patch`
  OplusCamera SystemProperties wrapper smali fix.

## Device tree — `vendor/oneplus/infiniti` (odm HAL blobs/configs)

These are camera fixes but live device-tree-side by the repo's HAL-ownership
convention:

- **(A) Disable deferred quick-jpeg for HDR stills** —
  `proprietary/odm/etc/camera/config/camera_unit_config`, in the
  `vendor_tag_type_values` section: `"com.oplus.quick.jpeg.support":"0"`.
  Rationale: the deferred quick-jpeg path holds the full-res capture buffers +
  borrowed metadata across the (slower-on-A16) deferred pipeline, overrunning
  the OEM's 20-image ImageReader / 20-frame metadata-cache windows →
  `ImageReader … more than maxImages` drop and the
  `APSMetadata::copyMetadata ← DeferJob::startCapture` use-after-free. Setting
  quick-jpeg off makes HDR capture synchronous (full JPEG still saves; only the
  fast preview-jpeg latency optimization is lost). Read path:
  OCS `CameraConfigHelper.getConfigValue` → `sVendorTagMap`
  (`JsonParser.parseVendorTagInfo` of `camera_unit_config vendor_tag_type_values`,
  checked **before** the encrypted `oplus_camera_config`). Value is a numeric
  string (`"0"` = false, per the `Byte.parseByte` config parser).
  NOTE: `ro.oplus.camera.defercap.support` is a config↔prop *consistency assert*,
  NOT a disable lever — leave it `=1`. `override_config_data` does NOT reach this
  key (that is the app-side `CameraConfig.f10007f`, a different object).
- **(B) libAlgoProcess p010 min() bounds patch** —
  `proprietary/odm/lib64/libAlgoProcess.so` (patched blob replaces the prebuilt).
  Fixes the IPE `p010LSB2MSBNeon` OOB on the HDR fusion path. (Supersedes the
  earlier interim patch.)
- libalogencrypt.so (`proprietary/odm/lib*`) — decrypts `oplus_camera_config`;
  required for the OCS in-process config read to succeed.

## Cross-reference

The app/SDK identity work (this repo's patches) and the device-tree odm fixes
(A)+(B) are co-required for e2e: identity unlocks the SAT-Fusion graph; (A)+(B)
let the HDR capture complete and save without the deferred-path UAF / buffer
exhaustion.
