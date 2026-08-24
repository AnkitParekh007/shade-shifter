#!/usr/bin/env bash
# Hydrates the native Android/iOS shells and applies Shade Shifter platform
# configuration (BLE permissions, identifiers, usage descriptions).
#
# The android/ and ios/ folders are NOT committed — Flutter regenerates them and
# committing them causes churn. This script recreates them deterministically and
# overlays our config, so both CI and a fresh clone build identically.
#
# Usage: tool/bootstrap_platforms.sh [android|ios|all]
set -euo pipefail

TARGET="${1:-all}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ORG="com.shadeshifter"
APP_ID="com.shadeshifter.app"
IOS_BUNDLE_ID="com.shadeshifter.app"

platforms=""
case "$TARGET" in
  android) platforms="android" ;;
  ios) platforms="ios" ;;
  all) platforms="android,ios" ;;
  *) echo "Unknown target: $TARGET" >&2; exit 1 ;;
esac

echo "==> Generating platform shells: $platforms"
flutter create --org "$ORG" --platforms "$platforms" .

# ---------------- Android ----------------
if [[ "$platforms" == *android* ]]; then
  echo "==> Applying Android configuration"
  MANIFEST="android/app/src/main/AndroidManifest.xml"
  cp "tool/platform/android/AndroidManifest.xml" "$MANIFEST"

  # Set applicationId (store identity) without touching the code namespace.
  for gradle in android/app/build.gradle android/app/build.gradle.kts; do
    if [[ -f "$gradle" ]]; then
      sed -i.bak -E 's/applicationId(\s*=?\s*)"[^"]*"/applicationId\1"'"$APP_ID"'"/' "$gradle" || true
      rm -f "$gradle.bak"
    fi
  done
  echo "    applicationId => $APP_ID"
fi

# ---------------- iOS ----------------
if [[ "$platforms" == *ios* ]]; then
  echo "==> Applying iOS configuration"
  PLIST="ios/Runner/Info.plist"
  PB="/usr/libexec/PlistBuddy"
  if [[ -x "$PB" ]]; then
    "$PB" -c "Add :NSBluetoothAlwaysUsageDescription string 'Shade Shifter uses Bluetooth to connect to and control your frame.'" "$PLIST" 2>/dev/null || \
    "$PB" -c "Set :NSBluetoothAlwaysUsageDescription 'Shade Shifter uses Bluetooth to connect to and control your frame.'" "$PLIST"
    "$PB" -c "Add :NSBluetoothPeripheralUsageDescription string 'Shade Shifter uses Bluetooth to connect to and control your frame.'" "$PLIST" 2>/dev/null || true
  else
    echo "    PlistBuddy unavailable (non-macOS) — skipping Info.plist patch"
  fi

  # Set bundle identifier (best-effort).
  if [[ -f "ios/Runner.xcodeproj/project.pbxproj" ]]; then
    sed -i.bak -E "s/PRODUCT_BUNDLE_IDENTIFIER = [^;]+;/PRODUCT_BUNDLE_IDENTIFIER = $IOS_BUNDLE_ID;/g" \
      "ios/Runner.xcodeproj/project.pbxproj" || true
    rm -f "ios/Runner.xcodeproj/project.pbxproj.bak"
    echo "    bundle id => $IOS_BUNDLE_ID"
  fi
fi

echo "==> Platform bootstrap complete."
