# godot-xr-setup (Agent Skill)

This repository defines a Codex agent skill for setting up a Godot XR development environment.

## Skill name

- `godot-xr-setup`

## What the skill does

- Guides setup/validation of an XR tools demo project.
- Installs and enables the OpenXR Vendors addon.
- Uses a helper script to resolve and download a compatible addon release for Godot 4.x.

## Repository layout

- [SKILL.md](./SKILL.md): skill definition and workflow entrypoint.
- [SetupXRToolsDemo.md](./SetupXRToolsDemo.md): XR tools demo setup notes.
- [SetupOpenXRVendorsPlugin.md](./SetupOpenXRVendorsPlugin.md): OpenXR Vendors plugin setup and verification.
- [scripts/download_openxr_vendors_addon.sh](./scripts/download_openxr_vendors_addon.sh): addon download helper.

## How to use this skill in Codex

Mention the skill or ask for Godot XR setup directly in your prompt.

Example prompts:

- `Use godot-xr-setup to prepare my project for XR development.`
- `Install OpenXR Vendors addon for my Godot project.`
- `Verify my Godot XR setup and fix missing prerequisites.`

## Maintainer notes

- Keep compatibility guidance in [SetupXRToolsDemo.md](./SetupXRToolsDemo.md) and [SetupOpenXRVendorsPlugin.md](./SetupOpenXRVendorsPlugin.md) in sync with the script logic.
- Script mapping currently supports Godot 4.x and selects plugin major version by Godot minor version.
- On macOS, keep the `Privacy & Security` approval step documented for blocked plugin binaries.
