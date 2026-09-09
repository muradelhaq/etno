# Laporan Audit Kesiapan Google Play Store: E-Modul Etnosains

**Tanggal Audit:** 6 September 2026  
**Auditor:** Mobile Solutions Architect & Google Play Compliance Specialist  
**Aplikasi:** E-Modul Etnosains Makanan Tradisional Berbasis Fermentasi  
**Package ID:** `com.etnosains.e_modul_etnosains`  
**Versi Saat Ini:** `1.2.16+37`  
**Framework:** Flutter (Engine 3.44.8, Dart 3.12.2)

---

## 1. Ringkasan Eksekutif (Executive Summary)

| Kategori Evaluasi | Status Kesiapan | Catatan Utama |
| :--- | :---: | :--- |
| **Kepatuhan Kebijakan Google Play** | ❌ **TIDAK LAYAK (REJECT RISK)** | Ada 3 pelanggaran kebijakan kritis (Self-update, Kebijakan Privasi, Hapus Akun). |
| **Konfigurasi Teknis & Manifest** | ⚠️ **PERLU PERBAIKAN** | Izin berbahaya `REQUEST_INSTALL_PACKAGES`, label aplikasi sistem. |
| **Format Distribusi & Build** | ⚠️ **PERLU PENYESUAIAN** | Wajib menggunakan format **Android App Bundle (.aab)**, bukan `.apk`. |
| **Stabilitas & Fungsionalitas UI** | ✅ **LAYAK (READY)** | Responsif pada Portrait & Landscape, navigasi modul dan kuis berjalan lancar. |
| **Kelengkapan Aset Toko (Listing)** | ⚠️ **BELUM LENGKAP** | Memerlukan Banner Promosi 1024x500, App Icon 512x512, dan screenshot tablet. |

> [!CAUTION]
> **Keputusan Kesiapan:** **BELUM SIAP (NOT READY FOR SUBMISSION)**  
> Jika aplikasi di-submit ke Google Play Store dalam kondisi saat ini, aplikasi **pasti ditolak (Rejected)** pada tahap *Policy Review* otomatis maupun manual Google Play karena adanya fitur unduh APK internal (`REQUEST_INSTALL_PACKAGES`) dan ketiadaan URL Kebijakan Privasi serta mekanisme hapus data pengguna.

---

## 2. Temuan Kritis (Critical Blockers — Wajib Diperbaiki)

Berikut adalah 3 pemblokir utama yang menyebabkan aplikasi pasti ditolak oleh Google Play:

### 🚨 Blocker 1: Pelanggaran Kebijakan Pembaruan Aplikasi (*Device and Network Abuse*)
- **Lokasi Kode:**
  - `android/app/src/main/AndroidManifest.xml`: `<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>`
  - `lib/shared/services/app_update_service.dart`: Fitur download file `.apk` langsung dan eksekusi via `open_filex`.
- **Kebijakan Google Play:**
  Google Play Developer Policy secara ketat melarang aplikasi mengunduh, memasang, atau memperbarui kode biner aplikasi dari sumber luar Google Play (*Alternative Market / Self-Updating App*). Penggunaan izin `REQUEST_INSTALL_PACKAGES` tanpa justifikasi khusus (hanya untuk file manager / alternative store) akan memicu penolakan seketika (*Instant Rejection* atau penangguhan akun developer).
- **Solusi Rekomendasi:**
  1. Hapus `<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>` dari `AndroidManifest.xml`.
  2. Ubah alur `app_update_service.dart`: Ketika terdeteksi ada versi baru, jangan mengunduh file APK, melainkan buka link aplikasi di Google Play Store via `url_launcher`:
     ```dart
     // Contoh format URL Play Store
     https://play.google.com/store/apps/details?id=com.etnosains.e_modul_etnosains
     // atau market intent:
     market://details?id=com.etnosains.e_modul_etnosains
     ```

---

### 🚨 Blocker 2: Ketiadaan URL Kebijakan Privasi (*Privacy Policy & Data Safety*)
- **Lokasi Isu:** Konsol Google Play (*Data Safety Section*) & Dalam Aplikasi (*About/Settings*).
- **Kebijakan Google Play:**
  Aplikasi Anda menyimpan dan memproses data pengguna (Nama Siswa/Guru, Sekolah, NISN, nilai kuis/evaluasi, serta sinkronisasi ke Supabase Backend). Google Play mewajibkan:
  1. Tautan URL Kebijakan Privasi publik yang aktif dan dapat diakses publik tanpa login.
  2. Pengisian formulir *Data Safety* di Konsol Google Play yang merinci jenis data apa saja yang dikumpulkan, tujuan pengumpulan, enkripsi dalam transit (HTTPS), dan apakah data dibagikan ke pihak ketiga.
- **Solusi Rekomendasi:**
  1. Buat dokumen Kebijakan Privasi (dapat di-host gratis di GitHub Pages, Notion publik, atau Vercel).
  2. Cantumkan tautan Kebijakan Privasi tersebut pada menu aplikasi (Drawer/Profil).
  3. Masukkan URL tersebut pada tab *App Content > Privacy Policy* di Google Play Console.

---

### 🚨 Blocker 3: Kewajiban Fitur Penghapusan Akun (*Account Deletion Requirement*)
- **Lokasi Isu:** Menu Profil/Pengaturan Akun.
- **Kebijakan Google Play:**
  Sejak 2023, Google Play memberlakukan aturan bahwa jika aplikasi memungkinkan pengguna membuat akun/profil (misal: pendaftaran profil siswa dengan nama, sekolah, dan identitas lain yang tersimpan di server/Supabase), aplikasi **wajib** menyediakan:
  1. Opsi bagi pengguna untuk menghapus akun dan data riwayatnya langsung dari dalam aplikasi.
  2. Tautan formulir web publik di mana pengguna dapat mengajukan penghapusan data akun mereka tanpa harus menginstal ulang aplikasi.
- **Solusi Rekomendasi:**
  1. Tambahkan tombol **"Hapus Profil / Reset Data Pengguna"** di halaman pengaturan/profil aplikasi yang menghapus record pengguna di Supabase dan membersihkan `SharedPreferences`.
  2. Sediakan URL web formulir permintaan hapus data sederhana (Google Form atau web page).

---

## 3. Temuan Teknis & Konfigurasi Build (High & Medium Priority)

### ⚠️ Isu 1: Label Nama Aplikasi pada Android Manifest
- **Lokasi:** `android/app/src/main/AndroidManifest.xml` baris 5:
  ```xml
  android:label="e_modul_etnosains"
  ```
- **Masalah:** Nama yang tampil di home screen pengguna Android saat ini adalah snake_case teknis (`e_modul_etnosains`), bukan nama yang profesional.
- **Solusi:** Ganti menjadi:
  ```xml
  android:label="E-Modul Etnosains"
  ```

---

### ⚠️ Isu 2: Format Rilis Wajib Android App Bundle (.aab)
- **Kondisi Saat Ini:** Script panduan rilis sebelumnya masih menargetkan kompilasi `.apk` (`flutter build apk --release`).
- **Aturan Google Play:** Google Play tidak lagi menerima file `.apk` untuk upload rilis baru. Aplikasi baru wajib di-upload dalam format **Android App Bundle (.aab)**.
- **Perintah Kompilasi:**
  ```bash
  flutter build appbundle --release
  ```
  File luaran berada di: `build/app/outputs/bundle/release/app-release.aab`.

---

### ⚠️ Isu 3: Kelengkapan Adaptive Icon (Android 8.0+)
- **Kondisi:** Icon peluncur aplikasi sudah diperbarui di folder mipmap raster, namun perlu dipastikan ada resource `res/mipmap-anydpi-v26/ic_launcher.xml` yang memisahkan background dan foreground agar icon tampil rapi dan simetris (tidak terpotong atau gepeng) di berbagai launcher Android (Samsung One UI, Pixel Launcher, Xiaomi HyperOS).

---

### ⚠️ Isu 4: Kebijakan Keluarga & Usia Target (*Target Audience & Content Rating*)
- **Kondisi:** Aplikasi ini merupakan media pembelajaran sains sekolah (SMP/SMA) yang berpotensi digunakan oleh siswa di bawah usia 13 tahun atau 13–17 tahun.
- **Aturan Google Play:**
  - Jika memilih target usia mencakup anak di bawah 13 tahun, aplikasi akan masuk ke program **Designed for Families**, yang mewajibkan kepatuhan COPPA/GDPR-K dan larangan iklan/pelacakan ID non-esensial.
  - **Rekomendasi:** Di Google Play Console *Target Audience*, pilih rentang usia **13 tahun ke atas (13-15, 16-17, dan 18+)** sesuai jenjang siswa SMP/SMA agar terhindar dari audit regulasi anak di bawah umur yang sangat ketat, kecuali sekolah secara eksplisit menargetkan jenjang SD.

---

## 4. Checklist Aset Toko (Store Listing Requirements)

Sebelum mempublikasikan aplikasi, siapkan aset grafis dan teks berikut di Google Play Console:

| Aset Listing | Spesifikasi Google Play | Status Saat Ini |
| :--- | :--- | :---: |
| **App Title** | Maks. 30 karakter (`E-Modul Etnosains Fermentasi`) | Siap ditentukan |
| **Short Description** | Maks. 80 karakter (Penjelasan singkat modul belajar interaktif) | Perlu ditulis |
| **Full Description** | Maks. 4000 karakter (Fitur, materi tempe/oncom/tape, kuis, lab virtual) | Perlu disusun |
| **App Icon** | 512 x 512 px, format PNG 32-bit, maks 1 MB | Perlu export aset |
| **Feature Graphic (Banner)** | 1024 x 500 px, format JPG atau PNG, tanpa transparansi | Perlu dibuat |
| **Screenshot HP (Phone)** | Min. 2 screenshot (disarankan 4-8), rasio 16:9 atau 9:16 | Perlu capture UI |
| **Screenshot Tablet 7" & 10"** | Diperlukan jika aplikasi mendukung mode landscape tablet | Perlu capture UI |
| **URL Kebijakan Privasi** | Tautan web aktif protokol HTTPS | Belum ada |

---

## 5. Rencana Aksi & Task Backlog Perbaikan

Berikut adalah pembagian task terstruktur berdasarkan prioritas untuk persiapan rilis:

### Sprint 1: Critical Compliance (Wajib Sebelum Submit)
- [ ] **TASK-01 [P0 - Blocker]**: Hapus izin `REQUEST_INSTALL_PACKAGES` dari `AndroidManifest.xml`.
- [ ] **TASK-02 [P0 - Blocker]**: Refactor `app_update_service.dart` agar mengarahkan update ke Google Play Store via `url_launcher`, bukan mendownload dan menginstall APK secara mandiri.
- [x] **TASK-03 [P0 - Blocker]**: Buat dan publikasikan halaman web **Kebijakan Privasi (Privacy Policy)** publik (`PRIVACY_POLICY.md` & tautan in-app) (Selesai).
- [x] **TASK-04 [P0 - Blocker]**: Tambahkan fitur **"Hapus Profil / Reset Data Pengguna"** di dalam aplikasi untuk mematuhi kebijakan penghapusan akun Google Play (Selesai).
- [x] **TASK-05 [P1 - Branding]**: Ubah `android:label` di `AndroidManifest.xml` dari `e_modul_etnosains` menjadi `E-Modul Etnosains` (Selesai).

### Sprint 2: Build & Store Assets (Persiapan Upload)
- [ ] **TASK-06 [P1 - Build]**: Validasi `key.properties` dan keystore release, lalu lakukan uji build Android App Bundle:
  ```bash
  flutter build appbundle --release
  ```
- [ ] **TASK-07 [P1 - Assets]**: Siapkan Aset Grafis:
  - App Icon 512x512 PNG.
  - Feature Graphic Banner 1024x500 JPG/PNG.
  - 4–6 screenshot portrait & landscape resolusi tinggi.
- [x] **TASK-08 [P2 - Listing]**: Susun draf teks *Title*, *Short Description*, dan *Full Description* untuk Google Play Console (Selesai di `docs/playstore/STORE_LISTING.md`).
- [ ] **TASK-09 [P2 - Safety]**: Lengkapi kuesioner *Data Safety* dan *Content Rating* di Google Play Console.

---

## 6. Prosedur Build Rilis Final (Play Store Ready)

Setelah Sprint 1 diselesaikan, lakukan build dengan langkah berikut:

1. **Pastikan Versi Naik di `pubspec.yaml`**:
   ```yaml
   version: 1.3.0+36
   ```
2. **Jalankan Test dan Linter**:
   ```bash
   flutter analyze
   flutter test
   ```
3. **Kompilasi AAB (Android App Bundle)**:
   ```bash
   flutter build appbundle --release
   ```
4. **Verifikasi File Output**:
   File `.aab` siap diunggah ke Google Play Console pada menu **Production** atau **Internal Testing**:
   `build/app/outputs/bundle/release/app-release.aab`

