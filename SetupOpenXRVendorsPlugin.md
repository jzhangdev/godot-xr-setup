# Setup OpenXR Vendors Plugin

## Overview

Install and enable the OpenXR Vendors plugin in a Godot project.

## Prerequisites

- `godot` is installed and available on PATH (or provide `--godot-version`).
- `git`, `curl`, and `unzip` are available.
- You are in the root of the Godot project.
- Internet access is available for release download.

## Instructions

1. Check the Godot version used by the project.

   ```bash
   godot --version
   ```

2. Select a compatible plugin major version.

   | Plugin major | Minimum Godot version |
   | ------------ | --------------------- |
   | 2.x          | 4.2                   |
   | 3.x          | 4.3                   |
   | 4.x          | 4.4                   |
   | 5.x          | 4.6                   |

3. Download the matching plugin release file with the helper script.

   ```bash
   chmod +x scripts/download_openxr_vendors_addon.sh
   scripts/download_openxr_vendors_addon.sh --output-dir /tmp
   ```

   Optional:
   - Pass an explicit version if `godot` is not on PATH:
     `scripts/download_openxr_vendors_addon.sh --godot-version 4.4.1 --output-dir /tmp`
   - Print resolved URL without downloading:
     `scripts/download_openxr_vendors_addon.sh --godot-version 4.4.1 --print-url`
   - Manual fallback release page:
     `https://github.com/GodotVR/godot_openxr_vendors/releases`

4. Install the addon into the Godot project.

   ```bash
   PLUGIN_ZIP="$(ls -1t /tmp/godotopenxrvendorsaddon-*.zip 2>/dev/null | head -n1)"
   [ -n "$PLUGIN_ZIP" ] || { echo "No downloaded addon zip found in /tmp"; exit 1; }
   TMP_DIR="$(mktemp -d)"
   trap 'rm -rf "$TMP_DIR"' EXIT
   unzip "$PLUGIN_ZIP" -d "$TMP_DIR"
   mkdir -p addons
   cp -R "$TMP_DIR/godotopenxrvendors" addons/
   ```

5. Enable OpenXR in Godot.

   In the Godot UI:
   - `Project -> Project Settings -> XR -> OpenXR -> Enabled`

   If you prefer file-based setup for OpenXR, ensure `project.godot` includes:

   ```ini
   [xr]
   openxr/enabled=true
   ```

6. Reload the project and handle the macOS security prompt if shown.

   On macOS, go to `System Settings -> Privacy & Security` and allow the blocked
   `libgodotopenxrvendors.macos` binary, then restart Godot.

7. Install the Android Build Template.

   In the Godot UI:
   - `Project -> Install Android Build Template`

## Verification

- OpenXR appears as enabled in `Project Settings -> XR -> OpenXR`.
- No plugin load errors appear in the Godot Output panel.
- `addons/godotopenxrvendors` exists in the project.

## Troubleshooting

- If the plugin does not appear, confirm the folder exists at:
  `addons/godotopenxrvendors`.
- If step 4 fails, verify at least one file exists at:
  `/tmp/godotopenxrvendorsaddon-*.zip`.
- If OpenXR does not initialize, confirm `openxr/enabled=true` in `project.godot`.
- If load fails, re-check plugin/Godot version compatibility.
- On macOS, if blocked again after update, re-allow the new binary in
  `Privacy & Security`.
