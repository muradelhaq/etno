• ## Hasil akhir QA/QC

  Status aplikasi: lulus bersyarat, belum disarankan untuk rilis produksi baru.

  Fitur dasar siswa berjalan dan build web berhasil, tetapi ditemukan beberapa masalah penting
  pada realtime admin, konsistensi progres, duplikasi data siswa, sertifikat, dan urutan
  modul.

  ### Hasil pengujian teknis

   Pengujian                        Hasil
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Flutter analyzer                 ✅ Tidak ada error
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Automated test                   ✅ 15 test lulus
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Validasi perubahan kode          ✅ Tidak ada whitespace/error diff
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Build web release                ✅ Berhasil
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Web asset dan halaman utama      ✅ HTTP 200
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Build APK release terbaru        ⚠️ Gradle tidak selesai setelah ±25 menit dan dihentikan
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Pengujian perangkat Android      ⚠️ Belum dapat dilakukan karena perangkat/emulator tidak
                                    tersedia
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Pemeriksaan database Supabase    ✅ Selesai
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Pemeriksaan RLS dan keamanan     ✅ Selesai
  ───────────────────────────────  ───────────────────────────────────────────────────────────
   Pemeriksaan Storage gambar       ✅ Seluruh 28 file terdaftar tersedia

  File APK lama masih ada dengan ukuran sekitar 79 MB, tetapi itu bukan hasil build terbaru
  sehingga tidak dihitung sebagai validasi rilis saat ini.

  ## Temuan prioritas kritis/tinggi

  ### 1. Realtime admin sebenarnya belum aktif

  Kode admin berlangganan perubahan Supabase, tetapi tabel terkait belum dimasukkan ke
  publication Realtime.

  Dampaknya:

  - Notifikasi siswa baru tidak otomatis muncul.
  - Hasil kuis dan jawaban siswa tidak otomatis memperbarui dashboard.
  - Indikator “Real-time Live Connected” dapat tampil walaupun koneksi realtime belum
    berhasil.

  Perbaikan:

  - Aktifkan Realtime untuk users, quiz_results, dan case_study_answers.
  - Status UI harus mengikuti hasil subscribe, bukan hanya keberadaan objek channel.
  - Tambahkan tampilan reconnect dan error subscription.

  ### 2. Urutan modul produk fermentasi tidak konsisten

  Alur utama:

  Tempe → Tape → Tape Ketan → Tauco → Jelajah Budaya

  Tetapi drawer menampilkan:

  - Slide 6 sebagai Tauco.
  - Slide 7 sebagai Kecap & Oncom.
  - Tape Ketan tidak ditampilkan dengan benar.
  - Alur utama tidak pernah mengunjungi halaman Kecap.

  Ini dapat membuat siswa melewati materi atau membuka materi yang tidak sesuai dengan
  progresnya.

  ### 3. Progres admin tidak diperbarui secara langsung

  Progres cloud baru diperbarui secara penuh saat siswa menyelesaikan PISA. Perpindahan slide
  dan XP di tengah pembelajaran sebagian besar hanya berada di perangkat.

  Dampaknya:

  - Admin melihat slide dan XP lama.
  - Data dashboard tidak merepresentasikan aktivitas siswa saat ini.
  - Jika data perangkat hilang sebelum sinkronisasi terakhir, progres dapat hilang.

  ### 4. Sertifikat dapat dibuka sebelum pembelajaran selesai

  Route sertifikat tersedia dari drawer tanpa pemeriksaan kelulusan. Siswa dapat:

  - Membuka sertifikat sebelum menyelesaikan modul.
  - Mengganti nama pada sertifikat secara lokal.
  - Menghasilkan nama yang berbeda dengan data siswa di Supabase.

  Sertifikat seharusnya dibuka hanya setelah semua syarat kelulusan terpenuhi dan menggunakan
  identitas resmi siswa.

  ### 5. Duplikasi siswa belum sepenuhnya dicegah

  Penyimpanan sesi berhasil mencegah siswa mengetik ulang data pada perangkat yang sama. Namun
  pada perangkat berbeda atau setelah instalasi ulang, identitas yang sama masih bisa
  menghasilkan pengguna baru.

  Data saat audit:

  - 12 profil siswa.
  - 2 kelompok identitas duplikat.
  - 2 baris profil tambahan akibat duplikasi.
  - Tidak ada unique constraint identitas siswa.

  Diperlukan identitas siswa yang stabil, misalnya kode siswa/NIS yang dinormalisasi dan
  memiliki unique constraint di database.

  ### 6. Nilai XP dapat diberikan berulang

  Beberapa aksi belum idempotent:

  - Pengiriman ulang asesmen sikap dapat menambahkan 100 XP lagi.
  - Penyelesaian kuis berpotensi menambah XP kembali ketika dipanggil ulang.

  XP seharusnya diberikan satu kali berdasarkan kombinasi pengguna dan aktivitas.

  ## Data yang salah atau tidak konsisten

  ### Data progres

  - 3 pengguna mempunyai current_slide = 13.
  - Aplikasi sekarang menggunakan total 12 slide.
  - Ekspor admin masih menghitung progres dengan pembagi /13.

  Akibatnya persentase progres pada aplikasi dan CSV dapat berbeda.

  ### Data kuis dan jawaban

  - 20 hasil kuis.
  - 10 merupakan attempt tambahan pada kombinasi siswa/jenis kuis.
  - 29 jawaban studi kasus.
  - 17 merupakan respons tambahan pada kombinasi siswa/modul.

  Saat ini statistik admin menghitung baris attempt, bukan hasil terbaru per siswa. Siswa yang
  mengulang dapat memengaruhi rata-rata kelas secara tidak proporsional.

  ### Perhitungan N-Gain

  Kartu dashboard yang bernama N-Gain hanya menghitung selisih post-test dan pre-test. Itu
  bukan rumus normalized gain. CSV penuh memakai perhitungan berbeda.

  Label, rumus dashboard, dan ekspor harus disamakan.

  ### Pencocokan siswa berdasarkan nama

  Sebagian ekspor memiliki fallback pencocokan berdasarkan nama. Dua siswa dengan nama sama
  dapat tertukar, khususnya jika sekolah atau kelas berbeda. Relasi harus selalu memakai
  user_id.

  ## Masalah gambar dan konten

  - File saccharomyces_before_zoom.png identik dengan tempe_microscope_after_zoom.png. Jadi
    gambar “Saccharomyces sebelum zoom” saat ini merupakan duplikat gambar Rhizopus/tempe.

  - Tempoyak Palembang masih menggunakan gambar tauco.
  - Dadiah menggunakan gambar yoghurt generik, bukan gambar dadiah sebenarnya.
  - Seluruh 28 objek yang tercatat di module_assets tersedia di Supabase Storage; tidak
    ditemukan file hilang.

  Konten ilmiah yang perlu ditinjau ahli materi:

  - Produksi vitamin B12 diatribusikan langsung kepada Rhizopus. Klaim ini perlu dikoreksi
    atau diberi sumber karena B12 pada tempe umumnya berhubungan dengan bakteri pendamping.

  - “Aspergillus sp./Amylomyces” mencampurkan dua genus berbeda.
  - Klaim angka digestibilitas, kadar garam yang “membunuh” patogen, serta kondisi optimum
    perlu disertai referensi ilmiah.

  ## Temuan fitur siswa lainnya

  - Penguncian slide berdasarkan membaca sampai bawah dan menjawab pertanyaan wajib sudah
    lulus test.

  - Proyek tugas boleh dikosongkan, sesuai permintaan sebelumnya.
  - Proyek mengklaim hasil disimpan ke portofolio, tetapi jawaban masih hanya berada di state
    lokal dan tidak disimpan ke Supabase.

  - Membuka detail produk dapat langsung menandai modul selesai dan memberi XP sebelum
    aktivitas benar-benar diselesaikan.

  - Login yang gagal sinkronisasi Supabase diam-diam beralih ke akun lokal dan tetap
    menampilkan keberhasilan. Siswa seharusnya diberi informasi bahwa data belum tersinkron.

  - Pemeriksaan update saat splash dapat menahan pembukaan aplikasi sampai timeout jaringan
    selesai. Tombol “Lewati” hanya melewati animasi, bukan pemeriksaan jaringan.

  - Pembuatan PDF sertifikat kemungkinan memerlukan internet untuk font Google.
  - Backsound otomatis berpotensi diblokir oleh kebijakan autoplay browser.

  ## Temuan keamanan dan pemeliharaan

  - Akun admin@etnosains.com tersedia dan mempunyai role admin yang benar.
  - RLS aktif dan pola kepemilikan data siswa sudah diterapkan.
  - Supabase melaporkan perlindungan leaked-password belum aktif. Sebaiknya diaktifkan
    khususnya untuk akun admin. Panduan Supabase
    (https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection)

  - Dokumentasi admin masih menyebut login PIN seperti 123456, admin123, dan guruetno, padahal
    aplikasi sekarang menggunakan email/password. Dokumentasi tersebut sudah kedaluwarsa dan
    tidak aman.

  - Ada audio WAV sekitar 5,4 MB yang tampaknya tidak digunakan tetapi masih ikut dibundel.
  - GitHub release terbaru v1.1.7 memiliki APK sekitar 68,8 MB.
  - Flutter memberi peringatan bahwa plugin Kotlin lama dapat gagal pada versi Flutter
    mendatang.

  - Ada 24 dependency dengan versi lebih baru yang perlu dievaluasi bertahap.

  ## Urutan perbaikan yang disarankan

  1. Aktifkan dan verifikasi Supabase Realtime.
  2. Perbaiki urutan modul, route drawer, dan jumlah slide menjadi satu sumber konfigurasi.
  3. Tambahkan sinkronisasi progres setiap aktivitas penting.
  4. Cegah duplikasi siswa lintas perangkat dengan identitas unik.
  5. Buat pemberian XP dan penyimpanan jawaban idempotent.
  6. Kunci sertifikat berdasarkan syarat kelulusan dan identitas database.
  7. Perbaiki statistik admin, N-Gain, dan ekspor /12.
  8. Simpan proyek siswa ke database atau hilangkan klaim portofolio.
  9. Koreksi gambar Saccharomyces, Tempoyak, dan Dadiah.
  10. Lakukan validasi konten oleh ahli biologi/pangan.
  11. Perbaiki build APK yang macet dan lakukan uji instalasi/update pada perangkat nyata.
  12. Perbarui dokumentasi admin serta aktifkan leaked-password protection.