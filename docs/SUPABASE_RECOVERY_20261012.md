# Pemulihan Supabase — 12 Oktober 2026

## Status akhir: kembali ke proyek lama

Sesuai konfirmasi pemilik, aplikasi kembali memakai `lumhlhxbmdtlqmlbcumc`. URL database, public anon key, foto, video, dan skrip upload telah dikembalikan ke proyek tersebut. Pemeriksaan REST/Auth lulus, termasuk Anonymous Sign-In.

Berkas SQL dan test khusus proyek baru dipindahkan ke `supabase/recovery/tmwoffovaljcfdsshgyf/` sebagai arsip, terpisah dari migrasi aktif proyek lama. Tidak ada migrasi yang diterapkan ke database lama dalam pengalihan ini.

Catatan di bawah merupakan riwayat pemulihan proyek baru `tmwoffovaljcfdsshgyf`, bukan status backend aktif. Salinan aset dan data di proyek baru dipertahankan.

## Sudah diterapkan

Migrasi remote dan lokal `20261011171458_restore_flutter_backend_compatibility`:

- Membuat `users`, `case_study_answers`, `lab_records`, dan `module_assets` yang dibutuhkan Flutter.
- Memperluas `quiz_results` CMS dengan kolom payload Flutter, skor pecahan, default halaman/skor maksimum, dan tipe evaluasi PISA. Kolom serta tipe kuis CMS sebelumnya tetap tersedia.
- Menghilangkan lookup profil rekursif yang menyebabkan error REST `42P17`.
- Membatasi tabel siswa ke pemilik sesi dan admin dari `app_metadata.role`. Akses baca staf CMS pada kuis dipertahankan.
- Menambahkan empat tabel siswa ke publication `supabase_realtime`.
- Membuat bucket publik `aset-sed` dan `media-assets`; upload/update/delete dibatasi ke admin.

Migrasi ini khusus memperluas baseline CMS proyek baru. Riwayat migrasi lama dalam repositori berasal dari proyek sebelumnya dan bukan baseline yang bisa diputar ulang langsung ke database kosong. Jangan menjalankan seluruh riwayat dengan `db push` tanpa rekonsiliasi baseline.

## Verifikasi

- Uji SQL `supabase/recovery/tmwoffovaljcfdsshgyf/flutter_backend.sql` lulus sebelum dan sesudah penerapan. Seluruh fixture berada dalam transaksi `ROLLBACK`.
- Payload Flutter dan CMS lama, skor pecahan, idempotensi, larangan akses lintas siswa, penolakan pemindahan pemilik, akses admin, dan penghapusan data sendiri diuji.
- Lima tabel memiliki RLS aktif; empat tabel siswa terdaftar di Realtime.
- Jumlah akun Auth tetap empat; tidak ada akun uji tersisa.
- 20 test Flutter lulus.
- Endpoint siswa sekarang mengembalikan `401 / 42501` tanpa sesi, sesuai desain. Sebelumnya terjadi `404` tabel hilang dan `500 / 42P17` pada kuis. Jangan memberikan akses `anon` untuk menghilangkan respons 401 tersebut.

Jalankan pemeriksaan baca-saja dengan `python3 scripts/check_supabase_backend.py`. Exit code 1 berarti masih ada pemeriksaan yang gagal atau konfigurasi Auth belum selesai. Uji SQL menggunakan simulasi klaim JWT di database; belum membuktikan login Auth, koneksi WebSocket Realtime, atau alur aplikasi secara penuh.

## Belum selesai

1. **Anonymous Sign-In masih nonaktif.** Aktifkan di Authentication → Sign In / Providers → Anonymous Sign-Ins pada dashboard proyek. Ini diperlukan oleh `signInAnonymously()` di aplikasi. Setelah aktif, ulangi pemeriksaan dan uji registrasi siswa melalui aplikasi.
2. **Tidak ada akun dengan `app_metadata.role = admin`.** Pemilik perlu menentukan akun guru/admin yang benar sebelum role diberikan; jangan mengambil role dari `user_metadata`.
3. **Pemulihan aset sebagian sudah selesai:** 37 file di `aset-sed` dan 94 file di `media-assets` (131 file; 233.008.464 byte), serta 32 baris `module_assets`. Seluruh file cocok dengan SHA-256 sumber. Sumbernya 125 objek hasil pemulihan Git dan enam foto asli dari Downloads, bukan ekspor lengkap proyek lama. Masih ada sembilan referensi file yang belum ditemukan, termasuk video pengantar, sampul, dan tujuh gambar mikroskop. Daftar dan bukti sumber ada di `SUPABASE_ASSET_RECOVERY_20261012.json`.
4. Advisor tetap melaporkan temuan baseline CMS: fungsi `SECURITY DEFINER` dapat dieksekusi role API, serta leaked-password protection belum aktif. Temuan ini sudah ada sebelum migrasi dan belum diaudit menyeluruh dalam pemulihan kompatibilitas ini.

Tidak ada browser terhubung dalam sesi ini untuk mengubah konfigurasi Auth atau melakukan upload lewat dashboard.

## Pemulihan file lanjutan

- CLI menemukan proyek lama `lumhlhxbmdtlqmlbcumc` dengan status `INACTIVE`, bukan bukti proyek terhapus. Akun CLI hanya dapat mengakses proyek lama; konektor MCP mengakses proyek baru. Pemilik diminta melakukan Resume pada proyek lama agar file cloud dan data siswa dapat diekspor.
- Data siswa di proyek baru (`users`, `quiz_results`, `case_study_answers`, `lab_records`) masih kosong. Riwayat Git tidak memuat data siswa; data itu belum dipindahkan.
- `scripts/recover_storage_assets.py` merekonstruksi file yang pernah di-commit tanpa mengubah aset aplikasi. Salinan kerja pemulihan ada di `/tmp/etno-asset-recovery`; manifest permanen dan hash ada di dokumen JSON di atas. Enam file tambahan berasal dari folder Downloads dan dicatat terpisah di manifest.
- Transfer memakai fungsi sementara yang hanya menerima path, ukuran, dan SHA-256 yang telah ditentukan, token acak, serta batas waktu. Request tanpa autentikasi, path di luar manifest, dan file korup teruji ditolak. File lama tidak ditimpa. Setelah 131 file terverifikasi, fungsi `asset-recovery-20261012` diganti dengan handler tanpa kemampuan tulis yang selalu mengembalikan 410; verifikasi JWT gateway diaktifkan kembali dan token lokal dihapus. Entri fungsi yang sudah dipensiunkan masih terlihat di dashboard.
- Tidak ada metadata Storage palsu yang disisipkan melalui SQL. Semua file diunggah lewat API Storage, kemudian diunduh ulang di server untuk verifikasi hash. Enam file pertama juga sempat diverifikasi dengan unduhan lokal. Seluruh 32 metadata modul menunjuk ke objek yang tersedia.
- Endpoint `/render/image/` proyek baru mengembalikan `403 FeatureNotEnabled`. `AppImage.optimizedUrl` sekarang memakai URL objek asli secara default. Transformasi dapat diaktifkan kembali melalui `--dart-define=SUPABASE_IMAGE_TRANSFORMATIONS=true` setelah fitur tersedia. Tiga test gambar lulus pada kedua konfigurasi. Aplikasi perlu dijalankan ulang/dibangun ulang agar perubahan ini digunakan.

## Jalur pemulihan balik

Perubahan bersifat ekspansi dan tidak menghapus data CMS. Bila rilis Flutter perlu ditarik, pertahankan tabel/kolom tambahan agar data baru tidak hilang. Jangan mengembalikan policy rekursif, tipe skor integer (dapat membulatkan skor), atau menghapus bucket/tabel yang sudah berisi data. Pemulihan struktural penuh membutuhkan ekspor data baru, penghentian writer Flutter, dan migrasi kompensasi yang ditinjau terpisah; bukan menjalankan ulang migrasi ini.

Referensi: [RLS Supabase](https://supabase.com/docs/guides/database/postgres/row-level-security), [Anonymous Sign-Ins](https://supabase.com/docs/guides/auth/auth-anonymous).
