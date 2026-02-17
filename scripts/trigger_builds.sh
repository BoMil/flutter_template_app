#!/usr/bin/env bash
set -e

# Triggers Codemagic builds for tenants defined in Firebase Firestore.
# Build FAILS if Firestore is unavailable.
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

# Load local secrets if available
SCRIPT_DIR_INIT="$(cd "$(dirname "$0")" && pwd)"
ENV_LOCAL="$SCRIPT_DIR_INIT/../.env.local"
if [ -f "$ENV_LOCAL" ]; then
  set -a
  source "$ENV_LOCAL"
  set +a
fi

CM_API_TOKEN="${CM_API_TOKEN:?Set CM_API_TOKEN in .env.local or as environment variable}"
CM_APP_ID="${CM_APP_ID:?Set CM_APP_ID in .env.local or as environment variable}"
FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-white-label-financeapp-b274a}"
BRANCH="${BRANCH:-white-label}"
WORKFLOW_ID="${WORKFLOW_ID:-android-workflow}"

FIRESTORE_BASE="https://firestore.googleapis.com/v1/projects/$FIREBASE_PROJECT_ID/databases/(default)/documents"

# --- Helper: fetch tenant config from Firestore ---
fetch_tenant_from_firestore() {
  local tenant_id="$1"
  local response
  response=$(curl -s --max-time 10 "$FIRESTORE_BASE/tenants/$tenant_id")

  if echo "$response" | jq -e '.fields' > /dev/null 2>&1; then
    echo "$response"
    return 0
  else
    echo "[ERROR] Failed to fetch tenant '$tenant_id' from Firestore" >&2
    echo "[ERROR] Response: $response" >&2
    return 1
  fi
}

# --- Helper: parse Firestore document field ---
parse_field() {
  local doc="$1"
  local field="$2"
  echo "$doc" | jq -r ".fields.${field}.stringValue // empty"
}

# --- Determine which tenants to build ---
if [ "$1" == "--all" ]; then
  ALL_DOCS=$(curl -s --max-time 10 "$FIRESTORE_BASE/tenants")
  if echo "$ALL_DOCS" | jq -e '.documents' > /dev/null 2>&1; then
    TENANTS=$(echo "$ALL_DOCS" | jq -r '.documents[].name' | xargs -I{} basename {})
    echo "[INFO] Fetched tenant list from Firestore"
  else
    echo "[ERROR] Cannot fetch tenants from Firestore. Check FIREBASE_PROJECT_ID and Firestore rules."
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
  else
    echo "  [ERROR] Cannot fetch tenants from Firestore."
  fi
  exit 0
fi

# --- Trigger a build for each tenant ---
for TENANT_ID in $TENANTS; do
  TENANT_DOC=$(fetch_tenant_from_firestore "$TENANT_ID")

  APP_NAME=$(parse_field "$TENANT_DOC" "APP_NAME")
  PACKAGE_NAME=$(parse_field "$TENANT_DOC" "PACKAGE_NAME")
  SERVER_ADDRESS=$(parse_field "$TENANT_DOC" "SERVER_ADDRESS")
  PRIMARY_COLOR=$(parse_field "$TENANT_DOC" "PRIMARY_COLOR")
  ACCENT_COLOR=$(parse_field "$TENANT_DOC" "ACCENT_COLOR")
  ERROR_COLOR=$(parse_field "$TENANT_DOC" "ERROR_COLOR")
  # Firebase - platform-specific
  FIREBASE_ANDROID_API_KEY=$(parse_field "$TENANT_DOC" "FIREBASE_ANDROID_API_KEY")
  FIREBASE_ANDROID_APP_ID=$(parse_field "$TENANT_DOC" "FIREBASE_ANDROID_APP_ID")
  FIREBASE_IOS_API_KEY=$(parse_field "$TENANT_DOC" "FIREBASE_IOS_API_KEY")
  FIREBASE_IOS_APP_ID=$(parse_field "$TENANT_DOC" "FIREBASE_IOS_APP_ID")
  FIREBASE_IOS_BUNDLE_ID=$(parse_field "$TENANT_DOC" "FIREBASE_IOS_BUNDLE_ID")
  # Firebase - shared (project-level)
  FIREBASE_MESSAGING_SENDER_ID=$(parse_field "$TENANT_DOC" "FIREBASE_MESSAGING_SENDER_ID")
  FIREBASE_TENANT_PROJECT_ID=$(parse_field "$TENANT_DOC" "FIREBASE_TENANT_PROJECT_ID")
  FIREBASE_STORAGE_BUCKET=$(parse_field "$TENANT_DOC" "FIREBASE_STORAGE_BUCKET")

  if [ -z "$APP_NAME" ] || [ -z "$PACKAGE_NAME" ]; then
    echo "[ERROR] Tenant '$TENANT_ID' is missing required fields (APP_NAME, PACKAGE_NAME) in Firestore."
    exit 1
  fi

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
          \"ERROR_COLOR\": \"$ERROR_COLOR\",
          \"FIREBASE_PROJECT_ID\": \"$FIREBASE_PROJECT_ID\",
          \"FIREBASE_ANDROID_API_KEY\": \"$FIREBASE_ANDROID_API_KEY\",
          \"FIREBASE_ANDROID_APP_ID\": \"$FIREBASE_ANDROID_APP_ID\",
          \"FIREBASE_IOS_API_KEY\": \"$FIREBASE_IOS_API_KEY\",
          \"FIREBASE_IOS_APP_ID\": \"$FIREBASE_IOS_APP_ID\",
          \"FIREBASE_IOS_BUNDLE_ID\": \"$FIREBASE_IOS_BUNDLE_ID\",
          \"FIREBASE_MESSAGING_SENDER_ID\": \"$FIREBASE_MESSAGING_SENDER_ID\",
          \"FIREBASE_TENANT_PROJECT_ID\": \"$FIREBASE_TENANT_PROJECT_ID\",
          \"FIREBASE_STORAGE_BUCKET\": \"$FIREBASE_STORAGE_BUCKET\"
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
    exit 1
  fi

  echo ""
done

echo "=== Done ==="
