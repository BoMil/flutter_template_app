#!/usr/bin/env bash
set -e

# Triggers Codemagic builds for tenants defined in Firebase Firestore.
# Falls back to local tenants.json if Firestore is unavailable.
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
#   CM_API_TOKEN           - Your Codemagic API token (Settings > Integrations)
#   CM_APP_ID              - Your Codemagic App ID (visible in the project URL)
#   FIREBASE_PROJECT_ID    - Your Firebase project ID

CM_API_TOKEN="${CM_API_TOKEN:?Set CM_API_TOKEN environment variable (Codemagic > Settings > Integrations)}"
CM_APP_ID="${CM_APP_ID:?Set CM_APP_ID environment variable (from your Codemagic project URL)}"
FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-white-label-financeapp-b274a}"
BRANCH="${BRANCH:-white-label}"
WORKFLOW_ID="${WORKFLOW_ID:-android-workflow}"

FIRESTORE_BASE="https://firestore.googleapis.com/v1/projects/$FIREBASE_PROJECT_ID/databases/(default)/documents"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TENANTS_FILE="$SCRIPT_DIR/../tenants.json"

# --- Helper: fetch tenant config from Firestore ---
fetch_tenant_from_firestore() {
  local tenant_id="$1"
  local response
  response=$(curl -s --max-time 10 "$FIRESTORE_BASE/tenants/$tenant_id")

  # Check if response has fields (valid Firestore document)
  if echo "$response" | jq -e '.fields' > /dev/null 2>&1; then
    echo "$response"
    return 0
  else
    return 1
  fi
}

# --- Helper: parse Firestore document field ---
parse_field() {
  local doc="$1"
  local field="$2"
  echo "$doc" | jq -r ".fields.${field}.stringValue // empty"
}

# --- Helper: fetch tenant from local tenants.json fallback ---
fetch_tenant_from_local() {
  local tenant_id="$1"
  if [ -f "$TENANTS_FILE" ]; then
    jq -r --arg id "$tenant_id" '.[$id] // empty' "$TENANTS_FILE"
  fi
}

# --- Determine which tenants to build ---
if [ "$1" == "--all" ]; then
  # Try Firestore first: list all documents
  ALL_DOCS=$(curl -s --max-time 10 "$FIRESTORE_BASE/tenants")
  if echo "$ALL_DOCS" | jq -e '.documents' > /dev/null 2>&1; then
    TENANTS=$(echo "$ALL_DOCS" | jq -r '.documents[].name' | xargs -I{} basename {})
    echo "[INFO] Fetched tenant list from Firestore"
  elif [ -f "$TENANTS_FILE" ]; then
    TENANTS=$(jq -r 'keys[]' "$TENANTS_FILE")
    echo "[WARN] Firestore unavailable, using local tenants.json"
  else
    echo "[ERROR] Cannot fetch tenants from Firestore or tenants.json"
    exit 1
  fi
elif [ $# -gt 0 ]; then
  TENANTS="$@"
else
  echo "Usage: $0 <tenant_id> [tenant_id...] | --all"
  echo ""
  echo "Available tenants (from Firestore):"
  ALL_DOCS=$(curl -s --max-time 10 "$FIRESTORE_BASE/tenants")
  if echo "$ALL_DOCS" | jq -e '.documents' > /dev/null 2>&1; then
    echo "$ALL_DOCS" | jq -r '.documents[] | "  \(.name | split("/") | last) - \(.fields.APP_NAME.stringValue) (\(.fields.PACKAGE_NAME.stringValue))"'
  elif [ -f "$TENANTS_FILE" ]; then
    echo "  (Firestore unavailable, showing local tenants.json)"
    jq -r 'to_entries[] | "  \(.key) - \(.value.APP_NAME) (\(.value.PACKAGE_NAME))"' "$TENANTS_FILE"
  fi
  exit 0
fi

# --- Trigger a build for each tenant ---
for TENANT_ID in $TENANTS; do
  # Try Firestore first, fallback to local
  TENANT_DOC=$(fetch_tenant_from_firestore "$TENANT_ID" 2>/dev/null) && SOURCE="Firestore" || SOURCE=""

  if [ -n "$SOURCE" ]; then
    APP_NAME=$(parse_field "$TENANT_DOC" "APP_NAME")
    PACKAGE_NAME=$(parse_field "$TENANT_DOC" "PACKAGE_NAME")
    SERVER_ADDRESS=$(parse_field "$TENANT_DOC" "SERVER_ADDRESS")
    PRIMARY_COLOR=$(parse_field "$TENANT_DOC" "PRIMARY_COLOR")
    ACCENT_COLOR=$(parse_field "$TENANT_DOC" "ACCENT_COLOR")
    ERROR_COLOR=$(parse_field "$TENANT_DOC" "ERROR_COLOR")
  else
    # Fallback to tenants.json
    LOCAL_CONFIG=$(fetch_tenant_from_local "$TENANT_ID")
    if [ -z "$LOCAL_CONFIG" ]; then
      echo "[ERROR] Tenant '$TENANT_ID' not found in Firestore or tenants.json, skipping."
      continue
    fi
    SOURCE="tenants.json"
    APP_NAME=$(echo "$LOCAL_CONFIG" | jq -r '.APP_NAME')
    PACKAGE_NAME=$(echo "$LOCAL_CONFIG" | jq -r '.PACKAGE_NAME')
    SERVER_ADDRESS=$(echo "$LOCAL_CONFIG" | jq -r '.SERVER_ADDRESS')
    PRIMARY_COLOR=$(echo "$LOCAL_CONFIG" | jq -r '.PRIMARY_COLOR')
    ACCENT_COLOR=$(echo "$LOCAL_CONFIG" | jq -r '.ACCENT_COLOR')
    ERROR_COLOR=$(echo "$LOCAL_CONFIG" | jq -r '.ERROR_COLOR')
  fi

  echo "=== Triggering build for $APP_NAME ($PACKAGE_NAME) [source: $SOURCE] ==="

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
          \"ERROR_COLOR\": \"$ERROR_COLOR\",
          \"FIREBASE_PROJECT_ID\": \"$FIREBASE_PROJECT_ID\"
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
