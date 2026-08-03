#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

cat > "$TEMP_DIR/nuon" <<'EOF'
#!/bin/bash
printf '%s\n' "$@" > "$NUON_TEST_ARGS"
echo '{"ok":true,"data":{"id":"bld_test123"}}'
EOF
chmod +x "$TEMP_DIR/nuon"

PATH="$TEMP_DIR:$PATH" \
  NUON_TEST_ARGS="$TEMP_DIR/args" \
  NUON_APP_ID=app_test \
  COMPONENT_ID=cmp_test \
  GITHUB_OUTPUT="$TEMP_DIR/github-output" \
  "$SCRIPT_DIR/build.sh"

diff -u \
  <(printf '%s\n' builds create --app-id app_test --component-id cmp_test --output agent) \
  "$TEMP_DIR/args"
grep -qx 'build_id=bld_test123' "$TEMP_DIR/github-output"
