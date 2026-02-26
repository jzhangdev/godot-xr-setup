#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/GodotVR/godot_openxr_vendors.git"
RELEASE_BASE_URL="https://github.com/GodotVR/godot_openxr_vendors/releases/download"
ASSET_NAME="godotopenxrvendorsaddon.zip"

GODOT_VERSION=""
OUTPUT_DIR="."
PRINT_URL_ONLY="false"

usage() {
  cat <<'EOF'
Download the matching Godot OpenXR Vendors addon zip for a Godot 4.x version.

Usage:
  scripts/download_openxr_vendors_addon.sh [options]

Options:
  --godot-version <version>  Godot version (for example: 4.4.1). If omitted, uses `godot --version`.
  --output-dir <dir>         Directory to write the downloaded zip. Default: current directory.
  --print-url                Print resolved download URL and exit without downloading.
  -h, --help                 Show this help text.
EOF
}

extract_semver() {
  local raw="$1"
  printf '%s\n' "$raw" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1 || true
}

resolve_plugin_major() {
  local version="$1"
  local major minor

  IFS=. read -r major minor _rest <<< "$version"

  if [[ ! "$major" =~ ^[0-9]+$ || ! "$minor" =~ ^[0-9]+$ ]]; then
    echo "Unsupported Godot version format: $version" >&2
    return 1
  fi

  if (( major != 4 )); then
    echo "Unsupported Godot major version: $major (expected 4.x)." >&2
    return 1
  fi

  if (( minor >= 6 )); then
    echo 5
  elif (( minor >= 4 )); then
    echo 4
  elif (( minor >= 3 )); then
    echo 3
  elif (( minor >= 2 )); then
    echo 2
  else
    echo "No supported OpenXR Vendors plugin for Godot $version (requires >= 4.2)." >&2
    return 1
  fi
}

while (($# > 0)); do
  case "$1" in
    --godot-version)
      GODOT_VERSION="${2:-}"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="${2:-}"
      shift 2
      ;;
    --print-url)
      PRINT_URL_ONLY="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$GODOT_VERSION" ]]; then
  if ! command -v godot >/dev/null 2>&1; then
    echo "godot command not found. Pass --godot-version explicitly." >&2
    exit 1
  fi
  GODOT_VERSION="$(extract_semver "$(godot --version)")"
  if [[ -z "$GODOT_VERSION" ]]; then
    echo "Failed to parse version from `godot --version`." >&2
    exit 1
  fi
fi

PLUGIN_MAJOR="$(resolve_plugin_major "$GODOT_VERSION")"

if ! command -v git >/dev/null 2>&1; then
  echo "git command not found (required to query tags)." >&2
  exit 1
fi

mapfile -t TAGS < <(git ls-remote --tags --refs "$REPO_URL" | awk '{print $2}' | sed 's#refs/tags/##')
if ((${#TAGS[@]} == 0)); then
  echo "No release tags found for repository: $REPO_URL" >&2
  exit 1
fi

MATCHING_TAGS=()
for tag in "${TAGS[@]}"; do
  clean="${tag#v}"
  if [[ ! "$clean" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    continue
  fi
  tag_major="${clean%%.*}"
  if [[ "$tag_major" == "$PLUGIN_MAJOR" ]]; then
    MATCHING_TAGS+=("$tag")
  fi
done

if ((${#MATCHING_TAGS[@]} == 0)); then
  echo "No plugin tags found for major version $PLUGIN_MAJOR.x" >&2
  exit 1
fi

LATEST_CLEAN="$(printf '%s\n' "${MATCHING_TAGS[@]}" | sed 's/^v//' | sort -V | tail -n1)"
LATEST_TAG="$LATEST_CLEAN"
if printf '%s\n' "${MATCHING_TAGS[@]}" | grep -qx "v${LATEST_CLEAN}"; then
  LATEST_TAG="v${LATEST_CLEAN}"
fi

DOWNLOAD_URL="${RELEASE_BASE_URL}/${LATEST_TAG}/${ASSET_NAME}"

if [[ "$PRINT_URL_ONLY" == "true" ]]; then
  printf '%s\n' "$DOWNLOAD_URL"
  exit 0
fi

mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="${OUTPUT_DIR}/${ASSET_NAME%.zip}-${LATEST_CLEAN}.zip"

echo "Godot version: $GODOT_VERSION"
echo "Plugin major: ${PLUGIN_MAJOR}.x"
echo "Resolved tag: $LATEST_TAG"
echo "Downloading: $DOWNLOAD_URL"
echo "Output file: $OUTPUT_FILE"

curl -fL --retry 3 --retry-all-errors -o "$OUTPUT_FILE" "$DOWNLOAD_URL"

echo "Download completed."
echo "Downloaded addon zip: $OUTPUT_FILE"
