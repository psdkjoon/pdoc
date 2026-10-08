#!/usr/bin/env bash
# Prints the app version: the VERSION file if present, else pubspec.yaml's
# `version:` without the +build suffix.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [[ -f VERSION ]]; then
    version="$(tr -d '[:space:]' < VERSION)"
else
    version="$(grep -m1 -E '^version:' pubspec.yaml | sed -E 's/^version:[[:space:]]*//; s/\+.*$//' | tr -d '[:space:]')"
fi

[[ -n "$version" ]] || { echo "could not determine version" >&2; exit 1; }
printf '%s\n' "$version"
