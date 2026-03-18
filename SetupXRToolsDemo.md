# Setup XR Tools Demo

## Overview

Set up or validate a Godot XR Tools demo project.

## Prerequisites

- `godot` is installed and available on PATH, or you know which Godot binary
  the project will use.
- `git` is available if you plan to clone the project.
- Internet access is available if you plan to download the project or a release
  archive.

## Instructions

Use the parts that match your workflow. The main decision is picking an XR Tools
release that matches the Godot version you actually plan to run.

### Check Godot Version

```bash
godot --version
```

If `godot` is not on PATH, use the version shown in the editor, your project
notes, or the specific binary you plan to launch.

### Pick a Compatible XR Tools Release

Use a Godot XR Tools release that matches the Godot version you are targeting.

| Godot XR Tools | Minimum Godot version |
| -------------- | --------------------- |
| 4.5.x          | 4.4                   |
| 4.4.x          | 4.2                   |
| 4.3.x          | 4.1                   |
| 4.2.x          | 4.1                   |
| 4.1.x          | 4.0                   |
| 4.0.x          | 4.0                   |

If more than one release fits, prefer the newest release in the compatible
series unless your project already depends on a specific older tag.

### Get the Demo Project

Use whichever source fits your workflow:

- Clone the repository at the tag or branch you want to work with.
- Download a release archive and unpack it locally.
- Reuse an existing checkout if it already matches the Godot version you are
  targeting.

The important end state is that you have a local project folder for the XR
Tools demo that matches your intended Godot version.

### Open the Project

You can import or open the project in the Godot editor, or launch it from the
CLI if that is how you usually work.

Editor path:
- Import the project folder in Godot if it is not already listed.
- Open the project and let Godot reimport assets if needed.

CLI path:

```bash
godot --path /path/to/xr-tools-demo
```

Replace `/path/to/xr-tools-demo` with the local project directory.

### What to Verify

Once the project is open, confirm that:

- the project imports without version or script-load errors
- scenes and assets finish importing cleanly
- the project uses the Godot version you intended
- any follow-up XR setup, such as the OpenXR Vendors addon, is handled
  separately if your target platform needs it
