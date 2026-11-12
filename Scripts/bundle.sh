#!/bin/sh
set -e
cd "$(dirname "$0")/.."

swift build

APP="$HOME/Applications/Atrium.app"
mkdir -p "$APP/Contents/MacOS"
cp .build/debug/atrium "$APP/Contents/MacOS/atrium"

cat > "$APP/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>Atrium</string>
    <key>CFBundleDisplayName</key><string>Atrium</string>
    <key>CFBundleIdentifier</key><string>dev.atrium.app</string>
    <key>CFBundleExecutable</key><string>atrium</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>0.1.0</string>
    <key>CFBundleVersion</key><string>1</string>
    <key>LSMinimumSystemVersion</key><string>14.0</string>
    <key>NSHighResolutionCapable</key><true/>
    <key>NSRemindersFullAccessUsageDescription</key>
    <string>Atrium shows your reminders alongside your calendar and mail.</string>
</dict>
</plist>
PLIST

codesign --force -s - "$APP"

if [ "$1" = "--open" ]; then
    pkill -x atrium 2>/dev/null || true
    sleep 1
    open "$APP"
fi

echo "bundled: $APP"