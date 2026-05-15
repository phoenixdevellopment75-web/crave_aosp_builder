# PixelOS 15 for Pixel 3 XL

This repository prepares a **GitHub Actions based PixelOS 15 build pipeline** for the **Google Pixel 3 XL (`crosshatch`)**.

It uses:

- official PixelOS manifest branch `fifteen`
- LineageOS Android 15 `crosshatch` device and kernel sources
- TheMuppets proprietary vendor blobs
- LineageOS `vendor/lineage` support for the `lineage_crosshatch` product

## Important reality check

This is a serious build setup, but it is not magic:

- GitHub-hosted runners are resource-constrained for full Android builds
- first builds can fail from disk, RAM, or upstream integration issues
- a successful build still needs real-device testing on Pixel 3 XL

So this repo is designed to give you the **best realistic chance** of building on GitHub servers, not a guaranteed one-click perfect ROM.

## Upstream sources

- PixelOS manifest: [PixelOS-AOSP/manifest `fifteen`](https://github.com/PixelOS-AOSP/manifest/tree/fifteen)
- LineageOS device tree: [LineageOS/android_device_google_crosshatch `lineage-22.2`](https://github.com/LineageOS/android_device_google_crosshatch/tree/lineage-22.2)
- LineageOS kernel: [LineageOS/android_kernel_google_msm-4.9 `lineage-22.2`](https://github.com/LineageOS/android_kernel_google_msm-4.9/tree/lineage-22.2)
- LineageOS vendor helpers: [LineageOS/android_vendor_lineage `lineage-22.2`](https://github.com/LineageOS/android_vendor_lineage/tree/lineage-22.2)
- Vendor blobs: [TheMuppets/proprietary_vendor_google_crosshatch `lineage-22.2`](https://github.com/TheMuppets/proprietary_vendor_google_crosshatch/tree/lineage-22.2)

## Build target

This setup currently builds:

- `lineage_crosshatch-userdebug`

That target comes from the Android 15 LineageOS crosshatch tree and is used here as the most practical device integration layer for PixelOS source.

## Workflow summary

The workflow:

1. Initializes PixelOS `fifteen`
2. Injects `crosshatch` local manifests
3. Syncs sources
4. Sets up `ccache`
5. Builds `lineage_crosshatch-userdebug`
6. Uploads produced artifacts

## Triggering the build

After pushing this repo to GitHub:

1. Open the repository `Actions` tab
2. Enable workflows if GitHub asks
3. Run `Build PixelOS 15 for Pixel 3 XL`

## Output

Expected outputs are usually under:

- `out/target/product/crosshatch/`

The workflow collects `.zip`, `.img`, `.txt`, and checksum-style artifacts from there when present.

