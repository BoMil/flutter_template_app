#!/usr/bin/env bash
set -e

# Called from codemagic.yaml with tenant env variables set.
# Patches native project files with tenant-specific branding.
# Downloads logo and app icons from Firebase Storage.

# All variables are passed via Codemagic API as environment variables.
TENANT_ID="${TENANT_ID:?TENANT_ID environment variable is required}"
APP_NAME="${APP_NAME:?APP_NAME environment variable is required}"
PACKAGE_NAME="${PACKAGE_NAME:?PACKAGE_NAME environment variable is required}"
FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-white-label-financeapp-b274a}"

FIREBASE_BUCKET="${FIREBASE_PROJECT_ID}.firebasestorage.app"
STORAGE_BASE="https://firebasestorage.googleapis.com/v0/b/$FIREBASE_BUCKET/o"

echo "=== Applying branding for tenant: $TENANT_ID ==="
echo "  App Name: $APP_NAME"
echo "  Package:  $PACKAGE_NAME"

# --- Helper: download file from Firebase Storage ---
download_from_storage() {
  local remote_path="$1"
  local local_path="$2"
  local encoded_path
  encoded_path=$(echo "$remote_path" | sed 's/\//%2F/g')

  mkdir -p "$(dirname "$local_path")"
  local http_code
  http_code=$(curl -s -o "$local_path" -w "%{http_code}" "$STORAGE_BASE/$encoded_path?alt=media")

  if [ "$http_code" == "200" ]; then
    return 0
  else
    rm -f "$local_path"
    return 1
  fi
}

# --- Download logo from Firebase Storage ---
LOGO_DIR="$CM_BUILD_DIR/assets/tenants/$TENANT_ID"
if download_from_storage "tenants/$TENANT_ID/logo.svg" "$LOGO_DIR/logo.svg"; then
  echo "  [OK] Logo downloaded from Firebase Storage"
else
  echo "  [WARN] Logo not found in Storage, using local if available"
fi

# --- Android: applicationId and namespace are read from PACKAGE_NAME env var in build.gradle ---
echo "  [OK] Android build.gradle reads PACKAGE_NAME from env"

# --- Android: Patch app label in AndroidManifest.xml ---
MANIFEST_FILE="$CM_BUILD_DIR/android/app/src/main/AndroidManifest.xml"
sed -i'' -e "s/android:label=\"[^\"]*\"/android:label=\"$APP_NAME\"/" "$MANIFEST_FILE"
echo "  [OK] Android AndroidManifest.xml patched"

# --- Android: Download app icons from Firebase Storage ---
ANDROID_RES="$CM_BUILD_DIR/android/app/src/main/res"
ANDROID_ICONS_FOUND=false
for density in mipmap-mdpi mipmap-hdpi mipmap-xhdpi mipmap-xxhdpi mipmap-xxxhdpi; do
  if download_from_storage "tenants/$TENANT_ID/app_icon/android/$density/ic_launcher.png" "$ANDROID_RES/$density/ic_launcher.png"; then
    ANDROID_ICONS_FOUND=true
  fi
done
if [ "$ANDROID_ICONS_FOUND" == "true" ]; then
  echo "  [OK] Android app icons downloaded from Firebase Storage"
else
  echo "  [WARN] No Android icons found in Storage (skipping)"
fi

# --- iOS: Patch bundle identifier in project.pbxproj ---
PBXPROJ="$CM_BUILD_DIR/ios/Runner.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ" ]; then
  sed -i'' -e "s/PRODUCT_BUNDLE_IDENTIFIER = com\.bokidev\.[^;]*/PRODUCT_BUNDLE_IDENTIFIER = $PACKAGE_NAME/g" "$PBXPROJ"
  echo "  [OK] iOS project.pbxproj patched"
fi

# --- iOS: Patch app display name in Info.plist ---
PLIST="$CM_BUILD_DIR/ios/Runner/Info.plist"
if [ -f "$PLIST" ]; then
  plutil -replace CFBundleDisplayName -string "$APP_NAME" "$PLIST"
  plutil -replace CFBundleName -string "$APP_NAME" "$PLIST"
  echo "  [OK] iOS Info.plist patched"
fi

# --- iOS: Download app icons from Firebase Storage (zip) ---
IOS_ICONS="$CM_BUILD_DIR/ios/Runner/Assets.xcassets/AppIcon.appiconset"
IOS_ZIP="/tmp/appiconset.zip"
if download_from_storage "tenants/$TENANT_ID/app_icon/ios/AppIcon.appiconset.zip" "$IOS_ZIP"; then
  unzip -o "$IOS_ZIP" -d "$IOS_ICONS/"
  rm -f "$IOS_ZIP"
  echo "  [OK] iOS app icons downloaded and extracted from Firebase Storage"
else
  echo "  [WARN] No iOS icon zip found in Storage (skipping)"
fi

echo "=== Branding applied successfully for $TENANT_ID ==="
