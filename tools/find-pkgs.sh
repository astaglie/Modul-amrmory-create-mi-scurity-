#!/usr/bin/env bash
# Pemakaian: tools/find-pkgs.sh dump/<tag> <regex>
set -euo pipefail
[ $# -eq 2 ] || { echo "pakai: $0 <dump_dir> <regex>"; exit 1; }
find "$1" \( -iname '*.apk' -o -iname '*.so' -o -iname '*.jar' -o -iname '*.rc' -o -iname '*.xml' \) \
  | grep -iE "$2" | sort
