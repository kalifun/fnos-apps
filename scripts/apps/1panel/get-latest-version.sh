#!/bin/bash
set -euo pipefail

INPUT_VERSION="${1:-}"

if [ -n "$INPUT_VERSION" ]; then
  VERSION="$INPUT_VERSION"
else
  # 1Panel v2.x split the binary into agent + core (incompatible with our build).
  # Pin to the last v1 LTS until we migrate the launcher/service-setup to v2.
  # CDN endpoint /stable/latest returns the latest v1 LTS tag (e.g. v1.10.34-lts).
  CDN_VERSION=$(curl -sL "https://resource.1panel.pro/stable/latest" 2>/dev/null)
  VERSION=$(echo "$CDN_VERSION" | sed 's/^v//')
fi

[ -z "$VERSION" ] || [ "$VERSION" = "null" ] && { echo "Failed to resolve version for 1panel" >&2; exit 1; }

echo "VERSION=$VERSION"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "version=$VERSION" >> "$GITHUB_OUTPUT"
fi
