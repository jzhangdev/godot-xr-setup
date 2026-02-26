---
name: godot-xr-setup
description: Set up and verify a Godot XR development environment, including preparing an XR demo project and installing/enabling OpenXR Vendors addon support. Use when the user asks to configure XR/OpenXR in Godot, install vendor OpenXR plugins, validate XR prerequisites, or troubleshoot XR setup issues.
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
- If the helper script warns that the preferred plugin major is not available,
  continue with the fallback tag it selected.
- If you are not in the skill repository directory, run the helper script by
  absolute path.
- If the user is on macOS, include the `Privacy & Security` approval step for
  blocked plugin binaries.
