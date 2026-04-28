#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-TradeBillCanada.xcodeproj}"
SCHEME="${SCHEME:-TradeBillCanada}"
DEVICE_NAME="${DEVICE_NAME:-iPhone 16}"
DEVICE_ID="${DEVICE_ID:-}"
ARCH="${ARCH:-arm64}"
RESULT_ROOT="${RESULT_ROOT:-build/TestResults}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
RESULT_BUNDLE_PATH="${RESULT_BUNDLE_PATH:-$RESULT_ROOT/TradeBillCanada-$TIMESTAMP.xcresult}"

mkdir -p "$RESULT_ROOT"

if [[ -n "$DEVICE_ID" ]]; then
  DESTINATION="platform=iOS Simulator,id=$DEVICE_ID,arch=$ARCH"
else
  DESTINATION="platform=iOS Simulator,name=$DEVICE_NAME,arch=$ARCH"
fi

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -resultBundlePath "$RESULT_BUNDLE_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  test
