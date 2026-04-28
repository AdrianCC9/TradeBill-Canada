#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-TradeBillCanada.xcodeproj}"
SCHEME="${SCHEME:-TradeBillCanada}"
DEVICE_ID="${DEVICE_ID:-D8A49222-DD69-4A37-9259-732E7641476D}"
ARCH="${ARCH:-arm64}"
BUNDLE_ID="${BUNDLE_ID:-com.tradebillcanada.app}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-build/DerivedData/Smoke}"
SCREENSHOT_PATH="${SCREENSHOT_PATH:-build/Screenshots/smoke-ios-simulator.png}"
LAUNCH_WAIT_SECONDS="${LAUNCH_WAIT_SECONDS:-6}"

mkdir -p "$(dirname "$SCREENSHOT_PATH")"

xcrun simctl boot "$DEVICE_ID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$DEVICE_ID" -b

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,id=$DEVICE_ID,arch=$ARCH" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  -quiet \
  build

APP_PATH="$DERIVED_DATA_PATH/Build/Products/Debug-iphonesimulator/TradeBillCanada.app"

xcrun simctl uninstall "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl spawn "$DEVICE_ID" defaults delete "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl install "$DEVICE_ID" "$APP_PATH"
xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID"
sleep "$LAUNCH_WAIT_SECONDS"
xcrun simctl io "$DEVICE_ID" screenshot "$SCREENSHOT_PATH"

echo "Smoke screenshot saved to $SCREENSHOT_PATH"
