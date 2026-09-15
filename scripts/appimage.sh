#!/usr/bin/env bash
set -euo pipefail

: "${BUNDLE_DIR:?set BUNDLE_DIR}"
: "${OUTPUT_DIR:?set OUTPUT_DIR}"

APP_ID="ir.psdkjoon.pdoc"
APP_NAME="pdoc"
DESKTOP_FILE="linux/packaging/${APP_ID}.desktop"
ICON_FILE="linux/icon.png"

run() {
    echo "\$ $*"
    "$@"
}

[[ -d "$BUNDLE_DIR" ]] || { echo "BUNDLE_DIR not found: $BUNDLE_DIR" >&2; exit 1; }
[[ -f "$DESKTOP_FILE" ]] || { echo "Desktop file not found: $DESKTOP_FILE" >&2; exit 1; }
[[ -f "$ICON_FILE" ]] || { echo "Icon not found: $ICON_FILE" >&2; exit 1; }

WORK_DIR="$(mktemp -d /tmp/appimage_build_XXXXXX)"
APP_DIR="$WORK_DIR/AppDir"
echo "Working in: $WORK_DIR"

mkdir -p "$APP_DIR/usr/bin"
run cp -r "$BUNDLE_DIR"/. "$APP_DIR/usr/bin/"

if [[ ! -x "$APP_DIR/usr/bin/$APP_NAME" ]]; then
    echo "Expected executable '$APP_NAME' not found in $BUNDLE_DIR" >&2
    exit 1
fi

run cp "$DESKTOP_FILE" "$APP_DIR/${APP_ID}.desktop"
run cp "$ICON_FILE" "$APP_DIR/${APP_ID}.png"
run ln -sf "${APP_ID}.png" "$APP_DIR/.DirIcon"

cat > "$APP_DIR/AppRun" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
HERE="$(dirname "$(readlink -f "${0}")")"
cd "$HERE/usr/bin"
exec "./pdoc" "$@"
EOF
chmod +x "$APP_DIR/AppRun"

APPIMAGETOOL="$WORK_DIR/appimagetool.AppImage"
run curl -fsSL -o "$APPIMAGETOOL" \
    "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod +x "$APPIMAGETOOL"

OUTPUT_FILE="$OUTPUT_DIR/${APP_NAME}-x86_64.AppImage"

run "$APPIMAGETOOL" --appimage-extract-and-run "$APP_DIR" "$OUTPUT_FILE"

echo
echo "✓ Done: $OUTPUT_FILE"
