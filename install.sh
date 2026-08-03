#!/bin/bash

set -euo pipefail

if [ "${NUON_DEBUG:-}" = "true" ]; then
  set -x
fi

BASE_URL=https://nuon-artifacts.s3.us-west-2.amazonaws.com/cli
VERSION=0.19.1102
OS=$(uname -s | awk '{print tolower($0)}')

case "$(uname -m)" in
  x86_64 | amd64) ARCH=amd64 ;;
  arm64 | aarch64) ARCH=arm64 ;;
  *)
    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

ARTIFACT="nuon_${OS}_${ARCH}"
TEMP_DIR=$(mktemp -d)
INSTALL_DIR="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/nuon/bin"
trap 'rm -rf "$TEMP_DIR"' EXIT

curl --fail --location --retry 3 --silent --show-error \
  "$BASE_URL/$VERSION/checksums.txt" \
  --output "$TEMP_DIR/checksums.txt"
curl --fail --location --retry 3 --silent --show-error \
  "$BASE_URL/$VERSION/$ARTIFACT" \
  --output "$TEMP_DIR/$ARTIFACT"

EXPECTED=$(awk -v artifact="$ARTIFACT" '$2 == artifact { print $1 }' "$TEMP_DIR/checksums.txt")
if [ -z "$EXPECTED" ]; then
  echo "No checksum found for $ARTIFACT" >&2
  exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL=$(sha256sum "$TEMP_DIR/$ARTIFACT" | awk '{ print $1 }')
else
  ACTUAL=$(shasum -a 256 "$TEMP_DIR/$ARTIFACT" | awk '{ print $1 }')
fi

if [ "$ACTUAL" != "$EXPECTED" ]; then
  echo "Checksum verification failed for $ARTIFACT" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"
install -m 0755 "$TEMP_DIR/$ARTIFACT" "$INSTALL_DIR/nuon"
echo "$INSTALL_DIR" >> "$GITHUB_PATH"

echo "Installed Nuon CLI $VERSION"
