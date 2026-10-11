# Diagnosis APK — Supabase lama, 12 Oktober 2026

Target aplikasi: `lumhlhxbmdtlqmlbcumc`. Tidak ada perubahan skema atau data aplikasi produksi pada pemeriksaan ini.

## Bukti

- REST/Auth tersedia dan Anonymous Sign-In aktif. Izin Internet sudah ada pada manifest Android release.
- Foto asli merespons HTTP 206 untuk permintaan range. Endpoint resize `/render/image/` merespons HTTP 403 `FeatureNotEnabled`. APK dari kode sebelumnya selalu memilih endpoint resize; perbaikan URL asli perlu dikirim lewat APK baru.
- Video pengantar merespons HTTP 206, berukuran 39.231.572 byte dan berdurasi sekitar 281 detik. Pemeriksaan ffprobe mengenali H.264 High, 1280×720, yuv420p, level 3.1, dengan audio AAC-LC. Ini membuktikan ketersediaan file dan formatnya, belum membuktikan pemutaran pada HP pengguna.
- Database lama masih berisi 18 profil dan 24 hasil kuis pada saat pemeriksaan. Uji penulisan sebagai role authenticated berhasil untuk profil, progres, kuis (termasuk replay idempotent), studi kasus, dan lab. Seluruh fixture berada dalam transaksi ROLLBACK; skripnya disimpan di `supabase/tests/student_sync.sql`.
- Test regresi membuktikan progres akun `local-*` tidak masuk antrean: jumlah operasi yang diharapkan 1, aktual 0. Pemanggil sebelumnya melewati layanan sinkronisasi ketika akun lokal atau Supabase belum siap.

## Perbaikan kode

- Foto memakai URL objek publik asli secara default, dengan transformasi sebagai opsi jika proyek mendukungnya.
- Progres dengan ID siswa tetap masuk layanan sinkronisasi saat offline; layanan menyimpannya ke antrean lokal yang persisten.
- Saat aplikasi dibuka lagi dan profil berhasil tersambung, progres tersimpan dikirim kembali, termasuk progres dari APK lama yang belum pernah masuk antrean.
- Kegagalan registrasi offline tidak mengganti ID siswa tersimpan dengan ID sementara baru.
- Update profil yang tidak menyentuh satu baris pun dianggap belum tersinkron dan tetap masuk antrean.
- Pengiriman ulang antrean dilakukan saat profil tersambung kembali melalui login/pembukaan aplikasi. Retry berkala ketika aplikasi tetap terbuka belum ditambahkan.

## Verifikasi dan batas

9 test terkait lulus setelah perbaikan; analisis enam file terkait tidak menemukan masalah. Test regresi offline gagal sebelum perubahan lalu lulus sesudahnya.

HP belum terhubung melalui ADB. Versi APK terpasang dan pesan kegagalan video belum diberikan, sehingga penyebab pemutaran video di perangkat serta hasil sinkronisasi menggunakan sesi pengguna belum terverifikasi. Jangan menghapus data aplikasi atau uninstall sebelum memastikan jawaban lokal tersalin/tersinkron.

Kandidat APK perbaikan dibangun dengan versi `1.2.17+38`, tanpa membuat tag atau memublikasikan rilis. Pengujian perangkat masih diperlukan sebelum menyatakan masalah pengguna selesai seluruhnya.
