#!/usr/bin/env bash

set -euo pipefail

: "${APK_OUTPUT_DIR:?set APK_OUTPUT_DIR}"
: "${BUILD_TOOLS_DIR:?set BUILD_TOOLS_DIR}"
: "${STRIP_TOOL:?set STRIP_TOOL}"
: "${KEYSTORE_PATH:?set KEYSTORE_PATH}"
: "${KEY_ALIAS:?set KEY_ALIAS}"
: "${KEYSTORE_PASSWORD:?set KEYSTORE_PASSWORD}"
: "${KEY_PASSWORD:?set KEY_PASSWORD}"

run() {
    echo "\$ $*"
    "$@"
}

TMP_ROOT="$(mktemp -d /tmp/apk_fix_XXXXXX)"
echo "Working in: $TMP_ROOT"
echo

found_any=0

for src_apk in "$APK_OUTPUT_DIR"/app-*-release.apk; do
    [[ -f "$src_apk" ]] || continue
    apk_name="$(basename "$src_apk")"
    abi="${apk_name#app-}"
    abi="${abi%-release.apk}"
    found_any=1

    echo
    echo "=== Processing $abi ($apk_name) ==="
    work_dir="$TMP_ROOT/$abi"
    extracted_dir="$work_dir/extracted"
    mkdir -p "$extracted_dir"

    run 7z x "$(realpath "$src_apk")" -o"$extracted_dir"

    so_path="$extracted_dir/lib/$abi/libflutter.so"
    if [[ ! -f "$so_path" ]]; then
        echo "No libflutter.so found for $abi at $so_path, skipping strip."
    else
        before_size=$(stat -c%s "$so_path")
        run "$STRIP_TOOL" --strip-all "$so_path"
        after_size=$(stat -c%s "$so_path")
        before_mb=$(awk "BEGIN{printf \"%.1f\", $before_size/1e6}")
        after_mb=$(awk "BEGIN{printf \"%.1f\", $after_size/1e6}")
        echo "Stripped libflutter.so: ${before_mb}MB -> ${after_mb}MB"
    fi

    file_list="$work_dir/filelist.txt"
    (cd "$extracted_dir" && find . -type f | sed 's|^\./||') >"$file_list"

    repacked_apk="$work_dir/repacked.apk"
    (cd "$extracted_dir" && run 7z a -tzip "$repacked_apk" -mx=0 "@$file_list")

    aligned_apk="$work_dir/aligned.apk"
    run "$BUILD_TOOLS_DIR/zipalign" -p 4 "$repacked_apk" "$aligned_apk"

    signed_apk="$APK_OUTPUT_DIR/${apk_name%.apk}-stripped-signed.apk"
    run "$BUILD_TOOLS_DIR/apksigner" sign \
        --ks "$KEYSTORE_PATH" \
        --ks-key-alias "$KEY_ALIAS" \
        --ks-pass env:KEYSTORE_PASSWORD \
        --key-pass env:KEY_PASSWORD \
        --out "$signed_apk" \
        "$aligned_apk"

    run "$BUILD_TOOLS_DIR/apksigner" verify "$signed_apk"

    final_size=$(stat -c%s "$signed_apk")
    final_mb=$(awk "BEGIN{printf \"%.1f\", $final_size/1e6}")
    echo
    echo "✓ Done: $signed_apk (${final_mb}MB)"
done

if [[ "$found_any" -eq 0 ]]; then
    echo "No app-*-release.apk files found in $APK_OUTPUT_DIR — did the build step run first?" >&2
    exit 1
fi

echo
echo "All done. Signed APKs are in $APK_OUTPUT_DIR with \"-stripped-signed\" suffix."
