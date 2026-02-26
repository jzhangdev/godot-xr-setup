---
name: godot-xr-setup
description: Set up a Godot XR development environment.
---

# Godot XR Setup

## Overview

Use this skill to set up a Godot XR project for local development.
It covers:
- creating or preparing an XR tools demo project
- installing and enabling the OpenXR Vendors addon

## When To Use

Use this skill when the user asks to:
- prepare a Godot XR starter/demo project
- install OpenXR vendor support in an existing Godot project
- verify XR/OpenXR setup for local development
- resolve setup issues related to Godot XR prerequisites

## Workflow

1. Set up or validate the XR tools demo project:
   - follow [SetupXRToolsDemo.md](./SetupXRToolsDemo.md)
2. Install and enable OpenXR Vendors addon support:
   - follow [SetupOpenXRVendorsPlugin.md](./SetupOpenXRVendorsPlugin.md)

## Notes

- Prefer the helper script for addon downloads:
  `scripts/download_openxr_vendors_addon.sh`
- Keep Godot version and addon major version compatibility aligned.
- If the user is on macOS, include the `Privacy & Security` approval step for
  blocked plugin binaries.
