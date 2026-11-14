# rom-dumps (private)

Port ke ROM Android 17 (EvoX) sebagai modul root (Magisk / KernelSU / APatch):

| Modul | Sumber dump | Tag dump |
|---|---|---|
| xiaomi-security-a17 | HyperOS 3.3 (Android 17) Xiaomi 17 | hyperos-a17-pudding |
| armoury-crate-port | ASUS ROG Phone (terbaru: Android 16) | rog9-a16 |
| game-genie-port | ASUS ROG Phone (terbaru: Android 16) | rog9-a16 |

## Alur
1. Actions -> rom-port -> action=dump, isi rom_url + tag.
2. Cari paket: `tools/find-pkgs.sh dump/<tag> <regex>`.
3. Isi `modules/<id>/sources.txt` dengan path hasil dump (relatif ke dump/<tag>/).
4. `tools/fill.sh <id> dump/<tag>` menyalin file ke `modules/<id>/system/`.
5. Actions -> rom-port -> action=build, ambil zip dari Artifacts.
6. Flash zip di Magisk/KSU/APatch, baca logcat, perbaiki.

## Blocker yang sudah diketahui
- **Signature / sharedUserId**: app yang pakai `android.uid.system` ditandatangani kunci platform Xiaomi/ASUS.
  ROM lain menolaknya kecuali tanda tangan dicek lain atau app di-resign dengan kunci platform ROM.
- **privapp-permissions**: tiap priv-app butuh `system/etc/permissions/privapp-permissions-<nama>.xml`.
  Tanpa itu ROM bisa menolak app atau gagal boot (tergantung `ro.control_privapp_permissions`).
- **SELinux**: kumpulkan `avc: denied` dari `/data/local/tmp/<id>.log`, masukkan ke `sepolicy.rule`.
- **Android 17**: native library yang di-load lewat `System.load()` harus read-only (diurus `customize.sh`).
- **Tumpang tindih**: Game Turbo, Armoury Crate dan Game Genie sama-sama overlay game. Jangan pasang bareng dulu.
