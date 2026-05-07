#!/usr/bin/env bash

ios_simulator_uuid_regex='[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}'

ios_simulator_id_for_name() {
  local device_name="$1"

  xcrun simctl list devices available |
    awk -v name="$device_name" -v uuid_regex="$ios_simulator_uuid_regex" '
      {
        line = $0
        sub(/^[[:space:]]+/, "", line)
        if (index(line, name " (") == 1 && match(line, uuid_regex)) {
          print substr(line, RSTART, RLENGTH)
          exit
        }
      }
    '
}

ios_default_simulator_id() {
  local booted_iphone
  booted_iphone="$(
    xcrun simctl list devices available |
      awk -v uuid_regex="$ios_simulator_uuid_regex" '
        /iPhone/ && /\(Booted\)/ && match($0, uuid_regex) {
          print substr($0, RSTART, RLENGTH)
          exit
        }
      '
  )"

  if [[ -n "$booted_iphone" ]]; then
    echo "$booted_iphone"
    return
  fi

  xcrun simctl list devices available |
    awk -v uuid_regex="$ios_simulator_uuid_regex" '
      /iPhone/ && match($0, uuid_regex) {
        print substr($0, RSTART, RLENGTH)
        exit
      }
    '
}

ios_resolve_simulator_id() {
  local requested_id="${1:-}"
  local requested_name="${2:-}"
  local resolved_id

  if [[ -n "$requested_id" ]]; then
    echo "$requested_id"
    return
  fi

  if [[ -n "$requested_name" ]]; then
    resolved_id="$(ios_simulator_id_for_name "$requested_name")"
    if [[ -n "$resolved_id" ]]; then
      echo "$resolved_id"
      return
    fi

    echo "No available simulator found for DEVICE_NAME=$requested_name" >&2
    echo "Available simulators:" >&2
    xcrun simctl list devices available >&2
    return 1
  fi

  resolved_id="$(ios_default_simulator_id)"
  if [[ -n "$resolved_id" ]]; then
    echo "$resolved_id"
    return
  fi

  echo "No available iPhone simulator found. Install an iOS simulator in Xcode first." >&2
  echo "Available simulators:" >&2
  xcrun simctl list devices available >&2
  return 1
}
