# Setup OpenXR Vendors Plugin

## Overview

Install and enable the OpenXR Vendors plugin in a Godot project.

## Prerequisites

- `godot` is installed and available on PATH (or provide `--godot-version`).
- `git`, `curl`, and `unzip` are available.
- You are in the root of the Godot project.
- Internet access is available for release download.

## Instructions

Use the parts that match your workflow. The helper script is the quickest way to
pick a compatible release, but manual download and manual project configuration
are both valid.

### Check Godot Version

```bash
godot --version
```

If `godot` is not on PATH, use the version from the editor, your project
documentation, or the specific binary you plan to run.

### Pick a Compatible Plugin Major

| Plugin major | Minimum Godot version |
| ------------ | --------------------- |
| 2.x          | 4.2                   |
| 3.x          | 4.3                   |
| 4.x          | 4.4                   |
| 5.x          | 4.6                   |

If you use the helper script and the preferred major is not released yet, it
falls back to the latest available stable release and prints a warning.

### Get the Addon Archive

Use whichever download path fits your workflow.

Helper script:

```bash
SCRIPT_PATH="/path/to/godot-xr-setup/scripts/download_openxr_vendors_addon.sh"
chmod +x "$SCRIPT_PATH"
"$SCRIPT_PATH" --output-dir /tmp
```

Useful variants:
- Pass an explicit version if `godot` is not on PATH:
  `"$SCRIPT_PATH" --godot-version 4.4.1 --output-dir /tmp`
- Print the resolved URL without downloading:
  `"$SCRIPT_PATH" --godot-version 4.4.1 --print-url`

Manual download:
`https://github.com/GodotVR/godot_openxr_vendors/releases`

### Install the Addon into the Project

The important end state is that `addons/godotopenxrvendors` exists in the
project root.

If you want a shell-based install flow, this works with the zip downloaded by
the helper script:

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

You can also unpack the archive with a file manager or other tooling, as long as
the addon ends up at `addons/godotopenxrvendors`.

### Enable OpenXR

Editor path:
- Open `Project Settings -> XR -> OpenXR`
- Turn on `Enabled`
- Turn on `Auto Initialize`

CLI path:
Use a temporary script if you prefer not to change the settings in the UI.

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

Then remove the temporary script if you do not want to keep it:

```bash
rm -f enable_openxr.gd
```

### Platform-Specific Follow-Up

On macOS, you may need to go to `System Settings -> Privacy & Security` and
allow the blocked `libgodotopenxrvendors.macos` binary, then restart Godot.

If you are targeting Android, install the Android build template from:
`Project -> Install Android Build Template`

## Verification

- OpenXR appears as enabled in `Project Settings -> XR -> OpenXR`.
- No plugin load errors appear in the Godot Output panel.
- `addons/godotopenxrvendors` exists in the project.

## Troubleshooting

- If the plugin does not appear, confirm the folder exists at:
  `addons/godotopenxrvendors`.
- If the shell-based install flow fails, verify at least one file exists at:
  `/tmp/godotopenxrvendorsaddon-*.zip`.
- If OpenXR does not initialize, confirm both of these in `project.godot`:
  - `openxr/enabled=true`
  - `openxr/auto_initialize=true`
- If `godot --headless --script enable_openxr.gd` fails in a restricted
  environment, run it with normal user permissions, then verify `project.godot`.
- If load fails, re-check plugin/Godot version compatibility.
- On macOS, if blocked again after update, re-allow the new binary in
  `Privacy & Security`.
