#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-TradeBillCanada.xcodeproj}"
SCHEME="${SCHEME:-TradeBillCanada}"
DEVICE_NAME="${DEVICE_NAME:-}"
DEVICE_ID="${DEVICE_ID:-}"
ARCH="${ARCH:-arm64}"
RESULT_ROOT="${RESULT_ROOT:-build/TestResults}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
RESULT_BUNDLE_PATH="${RESULT_BUNDLE_PATH:-$RESULT_ROOT/TradeBillCanada-$TIMESTAMP.xcresult}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ios-simulator-selection.sh"

mkdir -p "$RESULT_ROOT"

RESOLVED_DEVICE_ID="$(ios_resolve_simulator_id "$DEVICE_ID" "$DEVICE_NAME")"
DESTINATION="platform=iOS Simulator,id=$RESOLVED_DEVICE_ID,arch=$ARCH"

echo "Using iOS simulator $RESOLVED_DEVICE_ID"

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -resultBundlePath "$RESULT_BUNDLE_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  test
