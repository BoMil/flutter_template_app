#!/usr/bin/env bash
set -e

# Called from codemagic.yaml with tenant env variables set.
# Patches native project files with tenant-specific branding.
# Downloads logo from Firebase Storage, copies app icons from repo.

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

# --- Download logo from Firebase Storage ---
LOGO_DIR="$CM_BUILD_DIR/assets/tenants/$TENANT_ID"
mkdir -p "$LOGO_DIR"
REMOTE_LOGO="tenants%2F${TENANT_ID}%2Flogo.svg"
HTTP_CODE=$(curl -s -o "$LOGO_DIR/logo.svg" -w "%{http_code}" "$STORAGE_BASE/$REMOTE_LOGO?alt=media")
if [ "$HTTP_CODE" == "200" ]; then
  echo "  [OK] Logo downloaded from Firebase Storage"
else
  echo "  [WARN] Logo not found in Storage (HTTP $HTTP_CODE), using local if available"
fi

# --- Android: applicationId and namespace are read from PACKAGE_NAME env var in build.gradle ---
echo "  [OK] Android build.gradle reads PACKAGE_NAME from env"

# --- Android: Patch app label in AndroidManifest.xml ---
MANIFEST_FILE="$CM_BUILD_DIR/android/app/src/main/AndroidManifest.xml"
sed -i'' -e "s/android:label=\"[^\"]*\"/android:label=\"$APP_NAME\"/" "$MANIFEST_FILE"
echo "  [OK] Android AndroidManifest.xml patched"

# --- Android: Copy tenant app icons (from repo) ---
TENANT_ANDROID_ICONS="$CM_BUILD_DIR/assets/tenants/$TENANT_ID/app_icon/android"
ANDROID_RES="$CM_BUILD_DIR/android/app/src/main/res"
if [ -d "$TENANT_ANDROID_ICONS" ]; then
  for density in mipmap-hdpi mipmap-mdpi mipmap-xhdpi mipmap-xxhdpi mipmap-xxxhdpi; do
    if [ -f "$TENANT_ANDROID_ICONS/$density/ic_launcher.png" ]; then
      cp "$TENANT_ANDROID_ICONS/$density/ic_launcher.png" "$ANDROID_RES/$density/ic_launcher.png"
    fi
  done
  echo "  [OK] Android app icons copied"
else
  echo "  [WARN] No Android icons found at $TENANT_ANDROID_ICONS (skipping)"
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

# --- iOS: Copy tenant app icons (from repo) ---
TENANT_IOS_ICONS="$CM_BUILD_DIR/assets/tenants/$TENANT_ID/app_icon/ios/AppIcon.appiconset"
IOS_ICONS="$CM_BUILD_DIR/ios/Runner/Assets.xcassets/AppIcon.appiconset"
if [ -d "$TENANT_IOS_ICONS" ]; then
  cp -R "$TENANT_IOS_ICONS/" "$IOS_ICONS/"
  echo "  [OK] iOS app icons copied"
else
  echo "  [WARN] No iOS icons found at $TENANT_IOS_ICONS (skipping)"
fi

echo "=== Branding applied successfully for $TENANT_ID ==="
