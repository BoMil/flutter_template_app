#!/usr/bin/env bash
set -e

# Triggers Codemagic builds for tenants defined in Firebase Firestore.
# Build FAILS if Firestore is unavailable.
#
# Usage:
#   # Build a single tenant for a specific environment:
#   ./scripts/trigger_builds.sh --env=development whitebank
#   ./scripts/trigger_builds.sh --env=staging whitebank blubank
#   ./scripts/trigger_builds.sh --env=production --all
#
#   # Default environment is production:
#   ./scripts/trigger_builds.sh whitebank
#
# Required environment variables:
#   CM_API_TOKEN           - Your Codemagic API token (Settings > Integrations)
#   CM_APP_ID              - Your Codemagic App ID (visible in the project URL)
#   FIREBASE_PROJECT_ID    - Your Firebase project ID
#
# Firestore tenant document structure:
#   Shared fields (top-level): APP_NAME, PACKAGE_NAME, PRIMARY_COLOR, ACCENT_COLOR, ERROR_COLOR
#   Per-environment (nested map): development.SERVER_ADDRESS, development.FIREBASE_*, staging.*, production.*
#   Feature flags (nested map): features.THEME_CHANGE, features.LANGUAGE, features.ACCOUNT_BALANCE,
#                                features.PAYMENTS, features.CARDS, features.ANALYTICS

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
# --- Parse --env= and --branch= arguments ---
ENV="production"
BRANCH="white-label"
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --env=*)
      ENV="${arg#--env=}"
      ;;
    --branch=*)
      BRANCH="${arg#--branch=}"
      ;;
    *)
      ARGS+=("$arg")
      ;;
  esac
done
set -- "${ARGS[@]}"

# Validate environment
case "$ENV" in
  development|staging|production) ;;
  *)
    echo "[ERROR] Invalid environment '$ENV'. Use: development, staging, or production"
    exit 1
    ;;
esac

WORKFLOW_ID="android-${ENV}"
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

# --- Helper: parse top-level Firestore field (shared branding) ---
parse_field() {
  local doc="$1"
  local field="$2"
  echo "$doc" | jq -r ".fields.${field}.stringValue // empty"
}

# --- Helper: parse environment-specific nested Firestore field ---
# Firestore structure: tenants/{id}.{env}.{field}
# e.g. tenants/whitebank.development.SERVER_ADDRESS
parse_env_field() {
  local doc="$1"
  local env="$2"
  local field="$3"
  echo "$doc" | jq -r ".fields.${env}.mapValue.fields.${field}.stringValue // empty"
}

# --- Helper: parse boolean feature flag from Firestore features map ---
# Returns "true" or "false". Defaults to "true" if field is missing.
# NOTE: jq's // operator treats false as falsy, so we use explicit null check instead.
parse_feature_flag() {
  local doc="$1"
  local flag="$2"
  echo "$doc" | jq -r "if .fields.features.mapValue.fields.${flag}.booleanValue == null then true else .fields.features.mapValue.fields.${flag}.booleanValue end"
}

# --- Determine which tenants to build ---
if [ "${1:-}" == "--all" ]; then
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
  echo "Usage: $0 [--env=development|staging|production] [--branch=white-label] <tenant_id> [tenant_id...] | --all"
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

  # Shared fields — same across all environments
  APP_NAME=$(parse_field "$TENANT_DOC" "APP_NAME")
  PACKAGE_NAME=$(parse_field "$TENANT_DOC" "PACKAGE_NAME")
  PRIMARY_COLOR=$(parse_field "$TENANT_DOC" "PRIMARY_COLOR")
  ACCENT_COLOR=$(parse_field "$TENANT_DOC" "ACCENT_COLOR")
  ERROR_COLOR=$(parse_field "$TENANT_DOC" "ERROR_COLOR")

  # Environment-specific fields — read from nested map
  SERVER_ADDRESS=$(parse_env_field "$TENANT_DOC" "$ENV" "SERVER_ADDRESS")
  FIREBASE_ANDROID_API_KEY=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_ANDROID_API_KEY")
  FIREBASE_ANDROID_APP_ID=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_ANDROID_APP_ID")
  FIREBASE_IOS_API_KEY=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_IOS_API_KEY")
  FIREBASE_IOS_APP_ID=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_IOS_APP_ID")
  FIREBASE_IOS_BUNDLE_ID=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_IOS_BUNDLE_ID")
  FIREBASE_MESSAGING_SENDER_ID=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_MESSAGING_SENDER_ID")
  FIREBASE_TENANT_PROJECT_ID=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_TENANT_PROJECT_ID")
  FIREBASE_STORAGE_BUCKET=$(parse_env_field "$TENANT_DOC" "$ENV" "FIREBASE_STORAGE_BUCKET")

  # Feature flags — read from features nested map (default: true)
  FEATURE_THEME_CHANGE=$(parse_feature_flag "$TENANT_DOC" "THEME_CHANGE")
  FEATURE_LANGUAGE=$(parse_feature_flag "$TENANT_DOC" "LANGUAGE")
  FEATURE_ACCOUNT_BALANCE=$(parse_feature_flag "$TENANT_DOC" "ACCOUNT_BALANCE")
  FEATURE_PAYMENTS=$(parse_feature_flag "$TENANT_DOC" "PAYMENTS")
  FEATURE_CARDS=$(parse_feature_flag "$TENANT_DOC" "CARDS")
  FEATURE_ANALYTICS=$(parse_feature_flag "$TENANT_DOC" "ANALYTICS")

  if [ -z "$APP_NAME" ] || [ -z "$PACKAGE_NAME" ]; then
    echo "[ERROR] Tenant '$TENANT_ID' is missing required shared fields (APP_NAME, PACKAGE_NAME) in Firestore."
    exit 1
  fi

  if [ -z "$SERVER_ADDRESS" ]; then
    echo "[WARN] Tenant '$TENANT_ID' has no SERVER_ADDRESS for '$ENV' environment in Firestore."
  fi

  echo "=== Triggering [$ENV] build for $APP_NAME ($PACKAGE_NAME) ==="

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
          \"ENVIRONMENT\": \"$ENV\",
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
          \"FIREBASE_STORAGE_BUCKET\": \"$FIREBASE_STORAGE_BUCKET\",
          \"FEATURE_THEME_CHANGE\": \"$FEATURE_THEME_CHANGE\",
          \"FEATURE_LANGUAGE\": \"$FEATURE_LANGUAGE\",
          \"FEATURE_ACCOUNT_BALANCE\": \"$FEATURE_ACCOUNT_BALANCE\",
          \"FEATURE_PAYMENTS\": \"$FEATURE_PAYMENTS\",
          \"FEATURE_CARDS\": \"$FEATURE_CARDS\",
          \"FEATURE_ANALYTICS\": \"$FEATURE_ANALYTICS\"
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
