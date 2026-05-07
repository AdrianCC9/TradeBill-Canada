#!/usr/bin/env bash
set -euo pipefail

DEVICE_NAME="${DEVICE_NAME:-}"
DEVICE_ID="${DEVICE_ID:-}"
BOOTSTATUS_TIMEOUT_SECONDS="${BOOTSTATUS_TIMEOUT_SECONDS:-45}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ios-simulator-selection.sh"

run_with_timeout() {
  local seconds="$1"
  shift

  "$@" &
  local command_pid=$!

  (
    sleep "$seconds"
    if kill -0 "$command_pid" 2>/dev/null; then
      echo "Timed out after ${seconds}s: $*" >&2
      kill "$command_pid" 2>/dev/null || true
    fi
  ) &
  local watchdog_pid=$!

  set +e
  wait "$command_pid"
  local status=$?
  set -e

  kill "$watchdog_pid" 2>/dev/null || true
  wait "$watchdog_pid" 2>/dev/null || true

  return "$status"
}

echo "== Xcode =="
xcode-select -p
xcodebuild -version

echo
echo "== iOS simulator runtimes =="
xcrun simctl list runtimes available | sed -n '/iOS/p'

echo
echo "== Available devices =="
xcrun simctl list devices available

echo
echo "== Disk space =="
df -h "$HOME/Library/Developer/CoreSimulator" "/Library/Developer/CoreSimulator"

echo
echo "== Simulator-related processes =="
ps -axo pid,ppid,etime,pcpu,pmem,state,command |
  rg 'xcodebuild|simctl|CoreSimulator|Simulator|update_dyld|datamigrator|TradeBillCanada' |
  rg -v 'rg|diagnose-ios-simulator' || true

RESOLVED_DEVICE_ID="$(ios_resolve_simulator_id "$DEVICE_ID" "$DEVICE_NAME")"

echo
echo "== Boot status for simulator $RESOLVED_DEVICE_ID =="
run_with_timeout "$BOOTSTATUS_TIMEOUT_SECONDS" xcrun simctl bootstatus "$RESOLVED_DEVICE_ID"
