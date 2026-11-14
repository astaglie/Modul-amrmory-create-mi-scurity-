#!/system/bin/sh
MODDIR=${0%/*}
ID=${MODDIR##*/}
LOG=/data/local/tmp/$ID.log

until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
{
  echo "=== $(date) ==="
  echo "api=$(getprop ro.build.version.sdk) rom=$(getprop ro.build.display.id)"
  echo "--- paket terkait ---"
  pm list packages -s 2>/dev/null | grep -iE 'asus|rog|armour|armory'
} >> "$LOG" 2>&1

# kumpulkan SELinux denial 90 detik setelah boot buat bahan sepolicy.rule
(
  sleep 90
  echo "--- avc denied ---" >> "$LOG"
  logcat -d -b all 2>/dev/null | grep 'avc: denied' | sort -u >> "$LOG"
) &
