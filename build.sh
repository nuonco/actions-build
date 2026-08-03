#!/bin/bash

set -euo pipefail

OUTPUT_FILE=$(mktemp)
trap 'rm -f "$OUTPUT_FILE"' EXIT

nuon builds create \
  --app-id "$NUON_APP_ID" \
  --component-id "$COMPONENT_ID" \
  --output agent | tee "$OUTPUT_FILE"

BUILD_ID=$(jq -er '.data.id' "$OUTPUT_FILE")
echo "build_id=$BUILD_ID" >> "$GITHUB_OUTPUT"
