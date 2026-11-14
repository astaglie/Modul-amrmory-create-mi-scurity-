#!/usr/bin/env bash
# Pemakaian: tools/fill.sh <id-modul> <dump_dir>
# Baca modules/<id>/sources.txt (path relatif ke dump_dir) lalu salin ke modules/<id>/system/.
set -euo pipefail
[ $# -eq 2 ] || { echo "pakai: $0 <id-modul> <dump_dir>"; exit 1; }
mod="$1"; dump="$2"
list="modules/$mod/sources.txt"
[ -f "$list" ] || { echo "tidak ada $list"; exit 1; }
n=0
while IFS= read -r line || [ -n "$line" ]; do
  line="${line%%#*}"; line="$(echo "$line" | xargs)"
  [ -z "$line" ] && continue
  part="${line%%/*}"; rel="${line#*/}"
  case "$part" in
    system) dst="system/$rel" ;;
    system_ext|product|vendor|odm) dst="system/$part/$rel" ;;
    *) echo "LEWATI (partisi tidak dikenal): $line"; continue ;;
  esac
  src="$dump/$line"
  if [ ! -e "$src" ]; then echo "TIDAK ADA: $src"; continue; fi
  mkdir -p "modules/$mod/$(dirname "$dst")"
  cp -a "$src" "modules/$mod/$(dirname "$dst")/"
  echo "OK: $line -> modules/$mod/$dst"
  n=$((n+1))
done < "$list"
echo "$n entri disalin"
