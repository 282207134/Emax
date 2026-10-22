#!/bin/zsh
set -eu
cd "${0:A:h:h}"
DEVICE_ID="${1:-booted}"
if [[ "$DEVICE_ID" == "booted" ]]; then
  DEVICE_ID=$(xcrun simctl list devices booted -j | python3 -c 'import json,sys; print(next(v["udid"] for ds in json.load(sys.stdin)["devices"].values() for v in ds if v["state"] == "Booted"))')
fi
xcrun simctl status_bar "$DEVICE_ID" override --time '9:41' --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
flutter build ios --simulator --debug --target=test_driver/app.dart
xcrun simctl install "$DEVICE_ID" build/ios/iphonesimulator/Runner.app
APP_LAUNCH=$(xcrun simctl launch --terminate-running-process "$DEVICE_ID" com.emax.emax --start-paused --enable-dart-profiling)
APP_PID="${APP_LAUNCH##*: }"
VM_URL=''
# On newer iOS runtimes Flutter's VM URL is written to unified logs.
for attempt in {1..30}; do
  VM_URL=$(xcrun simctl spawn "$DEVICE_ID" log show --last 2m --style compact --predicate "processIdentifier == $APP_PID AND eventMessage CONTAINS 'Dart VM service'" 2>/dev/null | python3 -c 'import re,sys; m=re.search(r"Dart VM service is listening on (http://[^\s]+)",sys.stdin.read()); print(m[1] if m else "")')
  [[ -z "$VM_URL" ]] || break
  sleep 0.5
done
if [[ -z "$VM_URL" ]]; then
  print -u2 'Could not find the Dart VM service. Check that the simulator is running.'
  exit 1
fi
EMAX_SIMULATOR_ID="$DEVICE_ID" VM_SERVICE_URL="$VM_URL" dart test test_driver/screenshots_test.dart --reporter expanded
