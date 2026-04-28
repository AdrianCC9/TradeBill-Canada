#!/usr/bin/env bash
set -euo pipefail

DEVICE_NAME="${DEVICE_NAME:-iPhone 16}"
BOOTSTATUS_TIMEOUT_SECONDS="${BOOTSTATUS_TIMEOUT_SECONDS:-45}"

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

device_id_for_name() {
  xcrun simctl list devices available |
    awk -v name="$DEVICE_NAME" '$0 ~ name" \\(" { match($0, /\([A-F0-9-]+\)/); if (RSTART) { print substr($0, RSTART + 1, RLENGTH - 2); exit } }'
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

DEVICE_ID="$(device_id_for_name)"
if [[ -z "$DEVICE_ID" ]]; then
  echo
  echo "No available simulator found for DEVICE_NAME=$DEVICE_NAME" >&2
  exit 1
fi

echo
echo "== Boot status for $DEVICE_NAME ($DEVICE_ID) =="
run_with_timeout "$BOOTSTATUS_TIMEOUT_SECONDS" xcrun simctl bootstatus "$DEVICE_ID"
