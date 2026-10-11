#!/bin/bash
# Installs the latest Macbar into Applications and opens it:
#   curl -fsSL https://raw.githubusercontent.com/rahulornob/macbar-releases/main/install.sh | bash
#
# Files fetched with curl carry no "downloaded from the internet" mark, so macOS opens
# Macbar without the unidentified-developer prompt. The DMG and the app inside it are
# checked against Macbar's signing certificate first; anything else is refused.
# MACBAR_INSTALL_DIR and MACBAR_NO_OPEN=1 are for testing.
set -euo pipefail

REPO="rahulornob/macbar-releases"
CERT='certificate leaf = H"ebc1ea497538d8f2d9baad1ee5419be856aa91be"'

fail() { printf '\n✗ %s\n' "$1" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || fail "Macbar runs on macOS."
major="$(sw_vers -productVersion | cut -d. -f1)"
(( major >= 14 )) || fail "Macbar needs macOS 14 Sonoma or later."

echo "Finding the latest Macbar…"
URL="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep -o '"browser_download_url": *"[^"]*\.dmg"' | head -1 | sed -E 's/.*"(https[^"]+)"$/\1/')"
[[ -n "$URL" ]] || fail "Could not find a Macbar download. Check your connection and try again."

WORK="$(mktemp -d)"
MOUNT="$WORK/mount"
cleanup() {
    hdiutil detach "$MOUNT" -quiet 2>/dev/null || true
    rm -rf "$WORK"
}
trap cleanup EXIT

echo "Downloading ${URL##*/}…"
curl -fL --progress-bar -o "$WORK/Macbar.dmg" "$URL"

codesign -v --strict -R="$CERT" "$WORK/Macbar.dmg" 2>/dev/null \
    || fail "The download is not signed by Macbar. Nothing was installed."
mkdir -p "$MOUNT"
hdiutil attach "$WORK/Macbar.dmg" -nobrowse -readonly -quiet -mountpoint "$MOUNT" \
    || fail "Could not open the download."
codesign -v --deep --strict -R="identifier \"com.macbar.app\" and $CERT" "$MOUNT/Macbar.app" 2>/dev/null \
    || fail "The app is not signed by Macbar. Nothing was installed."

DEST="${MACBAR_INSTALL_DIR:-/Applications}"
if [[ ! -w "$DEST" ]]; then
    DEST="$HOME/Applications"
fi
mkdir -p "$DEST"

if pgrep -x Macbar >/dev/null 2>&1 && [[ -z "${MACBAR_INSTALL_DIR:-}" ]]; then
    echo "Closing the running Macbar…"
    osascript -e 'quit app id "com.macbar.app"' >/dev/null 2>&1 || pkill -x Macbar || true
    for _ in {1..50}; do pgrep -x Macbar >/dev/null 2>&1 || break; sleep 0.1; done
fi

echo "Installing into ${DEST}…"
rm -rf "$DEST/.Macbar.app.installing"
ditto "$MOUNT/Macbar.app" "$DEST/.Macbar.app.installing"
rm -rf "$DEST/Macbar.app"
mv "$DEST/.Macbar.app.installing" "$DEST/Macbar.app"
xattr -dr com.apple.quarantine "$DEST/Macbar.app" 2>/dev/null || true

if [[ "${MACBAR_NO_OPEN:-0}" != "1" ]]; then
    open "$DEST/Macbar.app"
fi
printf '\n✓ Macbar is installed in %s and running. Look at the top of your screen.\n' "$DEST"
