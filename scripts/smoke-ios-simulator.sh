#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-TradeBillCanada.xcodeproj}"
SCHEME="${SCHEME:-TradeBillCanada}"
DEVICE_NAME="${DEVICE_NAME:-}"
DEVICE_ID="${DEVICE_ID:-}"
ARCH="${ARCH:-arm64}"
BUNDLE_ID="${BUNDLE_ID:-com.tradebillcanada.app}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-build/DerivedData/Smoke}"
SCREENSHOT_PATH="${SCREENSHOT_PATH:-build/Screenshots/smoke-ios-simulator.png}"
LAUNCH_WAIT_SECONDS="${LAUNCH_WAIT_SECONDS:-6}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ios-simulator-selection.sh"

SCREENSHOT_DIR="$(dirname "$SCREENSHOT_PATH")"
SCREENSHOT_FILE="$(basename "$SCREENSHOT_PATH")"
mkdir -p "$SCREENSHOT_DIR"
SCREENSHOT_PATH="$(cd "$SCREENSHOT_DIR" && pwd)/$SCREENSHOT_FILE"

RESOLVED_DEVICE_ID="$(ios_resolve_simulator_id "$DEVICE_ID" "$DEVICE_NAME")"

echo "Using iOS simulator $RESOLVED_DEVICE_ID"

xcrun simctl boot "$RESOLVED_DEVICE_ID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$RESOLVED_DEVICE_ID" -b

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,id=$RESOLVED_DEVICE_ID,arch=$ARCH" \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  -quiet \
  build

APP_PATH="$DERIVED_DATA_PATH/Build/Products/Debug-iphonesimulator/TradeBillCanada.app"

xcrun simctl uninstall "$RESOLVED_DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl spawn "$RESOLVED_DEVICE_ID" defaults delete "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl install "$RESOLVED_DEVICE_ID" "$APP_PATH"
xcrun simctl launch "$RESOLVED_DEVICE_ID" "$BUNDLE_ID"
sleep "$LAUNCH_WAIT_SECONDS"
xcrun simctl io "$RESOLVED_DEVICE_ID" screenshot "$SCREENSHOT_PATH"

echo "Smoke screenshot saved to $SCREENSHOT_PATH"
