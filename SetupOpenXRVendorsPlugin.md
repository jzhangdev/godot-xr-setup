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

   Note: if the preferred major is not released yet, the helper script falls back
   to the latest available stable release and prints a warning.

3. Download the matching plugin release file with the helper script.

   ```bash
   SCRIPT_PATH="/path/to/godot-xr-setup/scripts/download_openxr_vendors_addon.sh"
   chmod +x "$SCRIPT_PATH"
   "$SCRIPT_PATH" --output-dir /tmp
   ```

   Optional:
   - Pass an explicit version if `godot` is not on PATH:
     `"$SCRIPT_PATH" --godot-version 4.4.1 --output-dir /tmp`
   - Print resolved URL without downloading:
     `"$SCRIPT_PATH" --godot-version 4.4.1 --print-url`
   - Manual fallback release page:
     `https://github.com/GodotVR/godot_openxr_vendors/releases`

4. Install the addon into the Godot project.

   ```bash
   PLUGIN_ZIP="$(ls -1t /tmp/godotopenxrvendorsaddon-*.zip 2>/dev/null | head -n1)"
   [ -n "$PLUGIN_ZIP" ] || { echo "No downloaded addon zip found in /tmp"; exit 1; }
   TMP_DIR="$(mktemp -d)"
   trap 'rm -rf "$TMP_DIR"' EXIT
   unzip "$PLUGIN_ZIP" -d "$TMP_DIR"
   ADDON_SRC="$TMP_DIR/godotopenxrvendors"
   [ -d "$ADDON_SRC" ] || ADDON_SRC="$TMP_DIR/asset/addons/godotopenxrvendors"
   [ -d "$ADDON_SRC" ] || { echo "Addon folder not found in archive layout"; exit 1; }
   mkdir -p addons
   cp -R "$ADDON_SRC" addons/
   ```

5. Enable OpenXR via Godot CLI (headless script mode).

   Create `enable_openxr.gd` in the project root:

   ```gdscript
   extends SceneTree

   func _init():
       ProjectSettings.set_setting("xr/openxr/enabled", true)
       ProjectSettings.set_setting("xr/openxr/auto_initialize", true)

       ProjectSettings.save()

       print("OpenXR enabled")
       quit()
   ```

   Run it:

   ```bash
   godot --headless --script enable_openxr.gd
   ```

   This updates `project.godot` safely without manual editing.
   After this step, remove the temporary helper script:

   ```bash
   rm -f enable_openxr.gd
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
- If OpenXR does not initialize, confirm both of these in `project.godot`:
  - `openxr/enabled=true`
  - `openxr/auto_initialize=true`
- If `godot --headless --script enable_openxr.gd` fails in a restricted
  environment, run it with normal user permissions, then verify `project.godot`.
- If load fails, re-check plugin/Godot version compatibility.
- On macOS, if blocked again after update, re-allow the new binary in
  `Privacy & Security`.
