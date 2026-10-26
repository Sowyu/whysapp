#!/bin/bash
# Build WhysApp.app from a GUI binary on macOS.
#
#   packaging/macos/bundle.sh <binary> <output.app> <version>
#
# Set CODESIGN_IDENTITY to use a Developer ID. Otherwise, use the ad-hoc
# signature required on arm64.
#
# Compile the Liquid Glass icon (ZapFast.icon, made in Icon Composer) with
# Xcode's actool, which also writes a flat .icns for macOS before 26.
# Info.plist is next to this script.
set -euo pipefail

binary="$1"
app="$2"
version="$3"
numeric_version="${version%%-*}"
here="$(cd "$(dirname "$0")" && pwd)"

rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

cp "$binary" "$app/Contents/MacOS/zapfast"
chmod 755 "$app/Contents/MacOS/zapfast"
sed "s/__VERSION__/$numeric_version/g" "$here/Info.plist" > "$app/Contents/Info.plist"

# Starting in the tray at login: a login item cannot pass --start-hidden, so
# SMAppService registers this agent from the bundle instead.
identifier=me.paolino.fastsapp
mkdir -p "$app/Contents/Library/LaunchAgents"
cp "$here/autostart.plist" "$app/Contents/Library/LaunchAgents/$identifier.autostart.plist"

icons="$(mktemp -d)"
xcrun actool "$here/ZapFast.icon" --compile "$app/Contents/Resources" \
    --app-icon ZapFast --platform macosx --target-device mac \
    --minimum-deployment-target 11.0 --enable-on-demand-resources NO \
    --output-partial-info-plist "$icons/partial.plist" >/dev/null
test -f "$app/Contents/Resources/Assets.car"
test -f "$app/Contents/Resources/ZapFast.icns"

# The notification plays ZapFast's built-in sounds from the bundle by name, so
# Do Not Disturb and Focus silence them (src/notify/macos.rs).
sounds="$here/../../assets/sounds"
cp "$sounds/receive.wav" "$app/Contents/Resources/zapfast-receive.wav"
cp "$sounds/alert.wav" "$app/Contents/Resources/zapfast-alert.wav"

# Attach the microphone entitlement before native-packages preserves it when
# replacing the ad-hoc signature with a hardened Developer ID signature.
if [ -n "${CODESIGN_IDENTITY:-}" ]; then
    codesign --force --timestamp --options runtime \
        --entitlements "$here/entitlements.plist" --sign "$CODESIGN_IDENTITY" "$app"
else
    codesign --force --entitlements "$here/entitlements.plist" --sign - "$app"
fi
codesign --verify --strict "$app"

echo "$app"
