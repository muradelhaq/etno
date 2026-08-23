# 🚀 Panduan Rilis Pembaruan & In-App Auto-Updater (GitHub Releases)

Dokumen ini menjelaskan alur kerja sistem pembaruan otomatis (In-App Auto Updater) pada aplikasi **E-Modul Etnosains** serta langkah-langkah untuk merilis versi baru ke GitHub.

---

## 📌 Ringkasan Cara Kerja Sistem

1. **Pengecekan Versi Otomatis**:
   - Setiap kali pengguna membuka aplikasi (halaman Cover/Beranda), aplikasi otomatis memanggil API GitHub:
     ```
     https://api.github.com/repos/muradelhaq/etno/releases/latest
     ```
   - Aplikasi membandingkan versi yang terpasang di perangkat dengan Tag Release terbaru di GitHub.
2. **Pengecekan Manual**:
   - Pengguna juga dapat menekan tombol **"Cek Update"** pada bagian bawah menu Drawer navigasi kapan saja.
3. **Dialog Notifikasi & Catatan Rilis**:
   - Jika ada versi lebih baru, aplikasi menampilkan popup dialog berisi nomor versi baru (`v1.0.0 ➔ v1.0.1`) dan catatan rilis (changelog).
4. **In-App Downloader & Auto-Installer**:
   - Pengguna menekan tombol **"Update Sekarang"**.
   - File APK diunduh langsung di dalam aplikasi disertai progress bar (persentase & ukuran file).
   - Setelah unduhan selesai, aplikasi secara otomatis memicu layar pemasangan APK bawaan Android (*"Apakah Anda ingin memasang pembaruan untuk aplikasi ini?"*). Pengguna tidak perlu membuka browser atau mencari file di file manager.

---

## 🛠️ Tata Cara Push & Rilis Versi Pembaruan

Berikut adalah 3 langkah mudah setiap kali Anda melakukan perubahan kode/UI dan ingin merilis versi baru:

### Langkah 1: Naikkan Versi di `pubspec.yaml`
Buka file `pubspec.yaml`, lalu ubah nomor versinya:
```yaml
# Contoh: dari 1.0.0+1 menjadi 1.0.1+2
version: 1.0.1+2
```
* `1.0.1` adalah nama versi (*version name*).
* `2` adalah nomor build (*version code*).

---

### Langkah 2: Commit Perubahan Kode
Buka terminal dan lakukan commit seperti biasa:
```bash
git add .
git commit -m "feat: pembaruan materi dan perbaikan UI v1.0.1"
git push origin main
```

---

### Langkah 3: Buat & Push Git Tag
Buat tag baru sesuai nama versi (gunakan awalan huruf `v`, misal `v1.0.1`), lalu push tag ke GitHub:
```bash
# 1. Buat tag lokal
git tag v1.0.1

# 2. Push tag ke GitHub
git push origin v1.0.1
```

---

## 🤖 Otomasi GitHub Actions (CI/CD)

Setelah Anda menjalankan perintah `git push origin v1.0.1`:
1. GitHub Actions (file [`.github/workflows/release.yml`](.github/workflows/release.yml)) akan **otomatis berjalan**.
2. GitHub akan otomatis melakukan kompilasi file `app-release.apk`.
3. GitHub akan membuat entri Release baru dengan tag `v1.0.1` dan melampirkan file APK hasil kompilasi.
4. Pengguna yang membuka aplikasi akan langsung mendapatkan notifikasi update!

> 💡 **Tips Memantau:** Anda dapat melihat proses build di tab **Actions** pada repositori GitHub Anda: `https://github.com/muradelhaq/etno/actions`.

---

## 📦 Alternatif: Rilis Manual Melalui Halaman GitHub (Opsional)

Jika Anda tidak ingin menggunakan GitHub Actions atau ingin mengunggah file APK hasil build lokal Anda sendiri:

1. Kompilasi APK di komputer lokal Anda:
   ```bash
   flutter build apk --release
   ```
2. File APK akan berada di:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```
3. Buka halaman GitHub Release Anda:
   `https://github.com/muradelhaq/etno/releases/new`
4. Isi data rilis:
   - **Choose a tag**: Masukkan tag baru (misal `v1.0.1`) dan klik *Create new tag*.
   - **Release title**: Misal `Release v1.0.1 - Pembaruan Fitur`
   - **Describe this release**: Tuliskan catatan perubahan/fitur baru.
   - **Attach binaries by dropping them here...**: Seret & letakkan file `app-release.apk`.
5. Klik **Publish release**.

---

## ⚙️ Komponen & Kode yang Ditambahkan

| File | Deskripsi |
|---|---|
| [`lib/shared/services/app_update_service.dart`](lib/shared/services/app_update_service.dart) | Service pengecekan API GitHub, pembanding versi, dan downloader APK. |
| [`lib/shared/widgets/app_update_dialog.dart`](lib/shared/widgets/app_update_dialog.dart) | Dialog antarmuka pengguna untuk notifikasi update dan progress download. |
| [`lib/shared/models/app_update_info.dart`](lib/shared/models/app_update_info.dart) | Model data informasi rilis GitHub. |
| [`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml) | Izin Android `INTERNET` dan `REQUEST_INSTALL_PACKAGES`. |
| [`.github/workflows/release.yml`](.github/workflows/release.yml) | Workflow GitHub Actions untuk build & upload APK otomatis saat ada tag baru. |
