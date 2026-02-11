#!/usr/bin/env bash
set -e

# Triggers Codemagic builds for tenants defined in tenants.json.
#
# Usage:
#   # Build a single tenant:
#   ./scripts/trigger_builds.sh whitebank
#
#   # Build multiple tenants:
#   ./scripts/trigger_builds.sh whitebank blubank redbank
#
#   # Build ALL tenants:
#   ./scripts/trigger_builds.sh --all
#
# Required environment variables:
#   CM_API_TOKEN  - Your Codemagic API token (Settings > Integrations)
#   CM_APP_ID     - Your Codemagic App ID (visible in the project URL)

CM_API_TOKEN="${CM_API_TOKEN:?Set CM_API_TOKEN environment variable (Codemagic > Settings > Integrations)}"
CM_APP_ID="${CM_APP_ID:?Set CM_APP_ID environment variable (from your Codemagic project URL)}"
BRANCH="${BRANCH:-white-label}"
WORKFLOW_ID="${WORKFLOW_ID:-android-workflow}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TENANTS_FILE="$SCRIPT_DIR/../tenants.json"

if [ ! -f "$TENANTS_FILE" ]; then
  echo "ERROR: tenants.json not found at $TENANTS_FILE"
  exit 1
fi

# Determine which tenants to build
if [ "$1" == "--all" ]; then
  TENANTS=$(jq -r 'keys[]' "$TENANTS_FILE")
elif [ $# -gt 0 ]; then
  TENANTS="$@"
else
  echo "Usage: $0 <tenant_id> [tenant_id...] | --all"
  echo ""
  echo "Available tenants:"
  jq -r 'to_entries[] | "  \(.key) - \(.value.APP_NAME) (\(.value.PACKAGE_NAME))"' "$TENANTS_FILE"
  exit 0
fi

# Trigger a build for each tenant
for TENANT_ID in $TENANTS; do
  # Read tenant config from tenants.json
  TENANT_CONFIG=$(jq -r --arg id "$TENANT_ID" '.[$id] // empty' "$TENANTS_FILE")

  if [ -z "$TENANT_CONFIG" ]; then
    echo "[ERROR] Tenant '$TENANT_ID' not found in tenants.json, skipping."
    continue
  fi

  APP_NAME=$(echo "$TENANT_CONFIG" | jq -r '.APP_NAME')
  PACKAGE_NAME=$(echo "$TENANT_CONFIG" | jq -r '.PACKAGE_NAME')
  SERVER_ADDRESS=$(echo "$TENANT_CONFIG" | jq -r '.SERVER_ADDRESS')
  PRIMARY_COLOR=$(echo "$TENANT_CONFIG" | jq -r '.PRIMARY_COLOR')
  ACCENT_COLOR=$(echo "$TENANT_CONFIG" | jq -r '.ACCENT_COLOR')
  ERROR_COLOR=$(echo "$TENANT_CONFIG" | jq -r '.ERROR_COLOR')

  echo "=== Triggering build for $APP_NAME ($PACKAGE_NAME) ==="

  RESPONSE=$(curl -s -X POST "https://api.codemagic.io/builds" \
    -H "x-auth-token: $CM_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"appId\": \"$CM_APP_ID\",
      \"workflowId\": \"$WORKFLOW_ID\",
      \"branch\": \"$BRANCH\",
      \"environment\": {
        \"variables\": {
          \"TENANT_ID\": \"$TENANT_ID\",
          \"APP_NAME\": \"$APP_NAME\",
          \"PACKAGE_NAME\": \"$PACKAGE_NAME\",
          \"SERVER_ADDRESS\": \"$SERVER_ADDRESS\",
          \"PRIMARY_COLOR\": \"$PRIMARY_COLOR\",
          \"ACCENT_COLOR\": \"$ACCENT_COLOR\",
          \"ERROR_COLOR\": \"$ERROR_COLOR\"
        }
      }
    }")

  BUILD_ID=$(echo "$RESPONSE" | jq -r '.buildId // empty')

  if [ -n "$BUILD_ID" ]; then
    echo "  [OK] Build started: $BUILD_ID"
    echo "  URL: https://codemagic.io/app/$CM_APP_ID/build/$BUILD_ID"
  else
    echo "  [ERROR] Failed to trigger build:"
    echo "$RESPONSE" | jq .
  fi

  echo ""
done

echo "=== Done ==="
