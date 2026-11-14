# Installer Magisk / KernelSU / APatch
SKIPUNZIP=0
MIN_API=37   # Android 17

[ "$API" -ge "$MIN_API" ] || abort "! Butuh Android 17 (API $MIN_API), device ini API $API"

ui_print "- Set permission"
set_perm_recursive "$MODPATH/system" 0 0 0755 0644
# Android 17: native lib yang di-load via System.load() harus read-only
find "$MODPATH/system" -name '*.so' -exec chmod 0444 {} \;
