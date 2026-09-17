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

cat > "$APP_DIR/AppRun" <<EOF
#!/usr/bin/env bash
set -euo pipefail
HERE="\$(dirname "\$(readlink -f "\${0}")")"
APP_ID="${APP_ID}"
APP_NAME="${APP_NAME}"

install_app() {
    local appimage_path
    appimage_path="\$(readlink -f "\${APPIMAGE:-\$0}")"

    local data_home="\${XDG_DATA_HOME:-\$HOME/.local/share}"
    local bin_dir="\$HOME/.local/bin"
    local apps_dir="\$data_home/applications"
    local icons_dir="\$data_home/icons/hicolor/256x256/apps"

    mkdir -p "\$bin_dir" "\$apps_dir" "\$icons_dir"

    local installed_appimage="\$bin_dir/\$APP_NAME.AppImage"
    cp -f "\$appimage_path" "\$installed_appimage"
    chmod +x "\$installed_appimage"

    cp -f "\$HERE/\$APP_ID.png" "\$icons_dir/\$APP_ID.png"

    sed -e "s|^Exec=.*|Exec=\$installed_appimage %U|" \\
        -e "s|^Icon=.*|Icon=\$APP_ID|" \\
        "\$HERE/\$APP_ID.desktop" > "\$apps_dir/\$APP_ID.desktop"
    chmod +x "\$apps_dir/\$APP_ID.desktop"

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "\$apps_dir" >/dev/null 2>&1 || true
    fi
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache "\$data_home/icons/hicolor" >/dev/null 2>&1 || true
    fi

    echo "Installed \$APP_NAME:"
    echo "  binary:  \$installed_appimage"
    echo "  desktop: \$apps_dir/\$APP_ID.desktop"
    echo "  icon:    \$icons_dir/\$APP_ID.png"
    echo "Make sure \$bin_dir is on your PATH."
}

uninstall_app() {
    local data_home="\${XDG_DATA_HOME:-\$HOME/.local/share}"
    rm -f "\$HOME/.local/bin/\$APP_NAME.AppImage"
    rm -f "\$data_home/applications/\$APP_ID.desktop"
    rm -f "\$data_home/icons/hicolor/256x256/apps/\$APP_ID.png"

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "\$data_home/applications" >/dev/null 2>&1 || true
    fi
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache "\$data_home/icons/hicolor" >/dev/null 2>&1 || true
    fi

    echo "Uninstalled \$APP_NAME."
}

case "\${1:-}" in
    --appimage-install|install)
        install_app
        exit 0
        ;;
    --appimage-uninstall|uninstall)
        uninstall_app
        exit 0
        ;;
esac

cd "\$HERE/usr/bin"
exec "./\$APP_NAME" "\$@"
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
