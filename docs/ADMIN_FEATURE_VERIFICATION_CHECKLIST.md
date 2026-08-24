# 📋 DAFTAR PERIKSA & PENGUJIAN FITUR DASHBOARD ADMIN (TODO CHECKLIST)
**Aplikasi E-Modul Etnosains Fermentasi Tradisional Nusantara (Versi 1.0.7+8)**

---

## 📌 Informasi Sesi Pengujian

- **Tanggal Dokumen**: 24 Agustus 2026
- **Versi Aplikasi**: `v1.0.7` (Build `1.0.7+8`)
- **Backend Database**: Supabase PostgreSQL (`https://lumhlhxbmdtlqmlbcumc.supabase.co`)
- **Akses Pengujian Web**: `http://localhost:8080`
- **PIN Akses Admin**: `123456` (atau `admin123` / `guruetno`)

---

## 🧭 Panduan Status Pengujian:
- [x] **[BERJALAN]**: Fitur sudah terimplementasi, teruji di lingkungan lokal & cloud, dan berfungsi 100%.
- [ ] **[BELUM DILAKUKAN]**: Pengujian manual oleh penguji/guru sebelum serah terima.

---

## 1. 🔐 Kategori 1: Autentikasi & Gerbang Masuk Admin

| No | Komponen / Skenario Uji | Deskripsi Tindakan & Hasil yang Diharapkan | Status Sistem | Verifikasi Manual |
| :---: | :--- | :--- | :---: | :---: |
| 1.1 | **Navigasi Rute `/auth`** | Buka URL `/auth`, `/login`, atau `/register` $\rightarrow$ Tampil Tab Masuk Siswa & Tab Akses Guru. | [x] **BERJALAN** | [ ] |
| 1.2 | **Shortcut dari Beranda** | Klik tombol *"Profil / Guru"* di atas cover (Slide 1) $\rightarrow$ Mengarahkan langsung ke `/auth`. | [x] **BERJALAN** | [ ] |
| 1.3 | **Shortcut dari App Drawer** | Buka menu samping (drawer), klik tombol *"Guru"* $\rightarrow$ Mengarahkan langsung ke `/admin`. | [x] **BERJALAN** | [ ] |
| 1.4 | **Validasi PIN Kosong** | Di Tab Guru, tekan tombol *"Buka Dashboard"* tanpa mengisi PIN $\rightarrow$ Muncul pesan validasi *"PIN Admin wajib diisi"*. | [x] **BERJALAN** | [ ] |
| 1.5 | **Validasi PIN Salah** | Masukkan PIN salah (misal: `000000`) $\rightarrow$ Muncul SnackBar merah *"PIN / Kata Sandi Guru Salah! (Coba: 123456)"*. | [x] **BERJALAN** | [ ] |
| 1.6 | **Validasi PIN Benar** | Masukkan PIN `123456` $\rightarrow$ Muncul notifikasi sukses dan langsung diarahkan ke `/admin`. | [x] **BERJALAN** | [ ] |
| 1.7 | **Fitur Lihat / Sembunyikan PIN** | Klik ikon mata pada field PIN $\rightarrow$ Karakter berganti antara sensor (*dots*) dan teks terlihat. | [x] **BERJALAN** | [ ] |

---

## 2. 🎛️ Kategori 2: Header & Navigasi Dashboard Admin (`/admin`)

| No | Komponen / Skenario Uji | Deskripsi Tindakan & Hasil yang Diharapkan | Status Sistem | Verifikasi Manual |
| :---: | :--- | :--- | :---: | :---: |
| 2.1 | **Indikator Koneksi Supabase** | Titik hijau menyala dengan teks *"Database Supabase Online • Real-time Monitoring"*. | [x] **BERJALAN** | [ ] |
| 2.2 | **Tombol Segarkan (Refresh)** | Klik ikon refresh (kuning) di AppBar $\rightarrow$ Muncul spinner dan data statistik ter-reload instan. | [x] **BERJALAN** | [ ] |
| 2.3 | **Tombol Ganti Akun / Logout** | Klik ikon logout di AppBar $\rightarrow$ Mengarahkan kembali ke halaman login `/auth`. | [x] **BERJALAN** | [ ] |
| 2.4 | **Tombol Kembali ke E-Modul** | Klik panah kiri (`leading`) $\rightarrow$ Mengarahkan kembali ke halaman Beranda E-Modul (`/`). | [x] **BERJALAN** | [ ] |
| 2.5 | **Perpindahan 3 Tab Utama** | TabBar responsif untuk beralih antara: *Statistik Kelas*, *Data Siswa*, dan *Koleksi Jawaban*. | [x] **BERJALAN** | [ ] |

---

## 3. 📊 Kategori 3: Tab 1 — Statistik & Ringkasan Kelas (*Class Analytics*)

| No | Komponen / Skenario Uji | Deskripsi Tindakan & Hasil yang Diharapkan | Status Sistem | Verifikasi Manual |
| :---: | :--- | :--- | :---: | :---: |
| 3.1 | **Kartu Total Siswa** | Menampilkan total jumlah siswa yang terdaftar di tabel `public.users`. | [x] **BERJALAN** | [ ] |
| 3.2 | **Kartu Rata-rata Pre-test** | Mengkalkulasi nilai rata-rata dari kuis bertipe *Pre-test* (skala 100). | [x] **BERJALAN** | [ ] |
| 3.3 | **Kartu Rata-rata Post-test** | Mengkalkulasi nilai rata-rata dari evaluasi literasi sains HOTS PISA (skala 100). | [x] **BERJALAN** | [ ] |
| 3.4 | **Kartu Kelulusan KKM** | Menampilkan persentase siswa yang memperoleh skor $\ge 75.0$. | [x] **BERJALAN** | [ ] |
| 3.5 | **Analisis Efektivitas N-Gain** | Menampilkan komparasi skor awal vs skor akhir serta nilai selisih peningkatan kompetensi. | [x] **BERJALAN** | [ ] |
| 3.6 | **Banner Partisipasi Inkuiri** | Menampilkan jumlah akumulasi seluruh respons studi kasus yang telah dikirim oleh siswa. | [x] **BERJALAN** | [ ] |

---

## 4. 👥 Kategori 4: Tab 2 — Direktori & Portofolio Siswa (*Student Directory*)

| No | Komponen / Skenario Uji | Deskripsi Tindakan & Hasil yang Diharapkan | Status Sistem | Verifikasi Manual |
| :---: | :--- | :--- | :---: | :---: |
| 4.1 | **Pencarian Nama Siswa** | Ketik nama siswa pada Search Bar $\rightarrow$ Daftar menyaring siswa sesuai nama secara *real-time*. | [x] **BERJALAN** | [ ] |
| 4.2 | **Pencarian Nama Sekolah** | Ketik nama sekolah pada Search Bar $\rightarrow$ Siswa dari sekolah terkait tersaring otomatis. | [x] **BERJALAN** | [ ] |
| 4.3 | **Filter Dropdown Kelas** | Pilih kelas tertentu (misal: *XII MIPA 1*) $\rightarrow$ Hanya menampilkan siswa dari kelas tersebut. | [x] **BERJALAN** | [ ] |
| 4.4 | **Kartu Identitas Siswa** | Menampilkan avatar inisial, nama, kelas, asal sekolah, total XP, dan badge nilai kuis. | [x] **BERJALAN** | [ ] |
| 4.5 | **Modal Detail Portofolio** | Klik panah kanan pada kartu siswa $\rightarrow$ Membuka dialog modal detail portofolio siswa. | [x] **BERJALAN** | [ ] |
| 4.6 | **Rincian Nilai Kuis Siswa** | Di dalam modal: Menampilkan skor, predikat kelulusan, dan jumlah butir soal yang dijawab benar. | [x] **BERJALAN** | [ ] |
| 4.7 | **Riwayat Opini Studi Kasus Siswa** | Di dalam modal: Menampilkan judul dan teks jawaban studi kasus yang pernah diinput oleh siswa tsb. | [x] **BERJALAN** | [ ] |

---

## 5. 💬 Kategori 5: Tab 3 — Koleksi Jawaban & Refleksi Seluruh Siswa (*Student Opinions Feed*)

| No | Komponen / Skenario Uji | Deskripsi Tindakan & Hasil yang Diharapkan | Status Sistem | Verifikasi Manual |
| :---: | :--- | :--- | :---: | :---: |
| 5.1 | **Filter Modul Pangan** | Dropdown filter: *Semua Modul*, *Tempe*, *Tape Singkong*, *Tauco*, *Kecap*, *Oncom*, *Jelajah Budaya*. | [x] **BERJALAN** | [ ] |
| 5.2 | **Pencarian Kata Kunci Jawaban** | Ketik istilah (misal: *daun pisang*, *enzim*, *ragi*) $\rightarrow$ Feed menyaring jawaban yang memuat kata kunci. | [x] **BERJALAN** | [ ] |
| 5.3 | **Tampilan Kartu Respons** | Menampilkan identitas pengirim (Nama, Kelas, Sekolah) dan cap waktu (*timestamp* pengiriman). | [x] **BERJALAN** | [ ] |
| 5.4 | **Teks Rumusan Masalah** | Menampilkan pertanyaan inkuiri ilmiah yang diajukan pada modul tersebut. | [x] **BERJALAN** | [ ] |
| 5.5 | **Teks Utuh Hipotesis & Pendapat** | Kotak berwarna kuning lembut yang menampilkan teks penalaran ilmiah lengkap yang diketik siswa. | [x] **BERJALAN** | [ ] |
| 5.6 | **Analisis Variabel Siswa** | Menampilkan variabel bebas (manipulasi) dan variabel terikat (respon) yang ditentukan siswa. | [x] **BERJALAN** | [ ] |

---

## 6. 🔄 Kategori 6: Uji Integrasi Aliran Data Dua Arah (End-to-End Integration)

| No | Komponen / Skenario Uji | Deskripsi Tindakan & Hasil yang Diharapkan | Status Sistem | Verifikasi Manual |
| :---: | :--- | :--- | :---: | :---: |
| 6.1 | **Registrasi Siswa Baru** | Buka `/auth`, isi nama *Budi Pratama*, kelas *XII MIPA 2*, sekolah *SMAN 3 Bandung*, klik Mulai $\rightarrow$ Data tersimpan di tabel `users`. | [x] **BERJALAN** | [ ] |
| 6.2 | **Refleksi Profil di Cover** | Setelah daftar, buka `/` $\rightarrow$ Banner atas menampilkan *Budi Pratama • XII MIPA 2 • SMAN 3 Bandung*. | [x] **BERJALAN** | [ ] |
| 6.3 | **Kirim Jawaban Studi Kasus** | Buka `/produk/tempe`, ketik analisis studi kasus, klik *"Kirim"* $\rightarrow$ Tersimpan ke `case_study_answers` & muncul di Tab 3 Admin. | [x] **BERJALAN** | [ ] |
| 6.4 | **Kirim Hasil Evaluasi PISA** | Buka `/literasi-sains-quiz`, jawab 10 soal HOTS, klik selesai $\rightarrow$ Skor dan detail pilihan tersimpan ke `quiz_results` & mengupdate statistik Tab 1 & Tab 2 Admin. | [x] **BERJALAN** | [ ] |
| 6.5 | **Dinamika Sertifikat & PDF** | Buka `/sertifikat` $\rightarrow$ Nama siswa, kelas, dan sekolah tercetak otomatis pada sertifikat digital dan dokumen PDF. | [x] **BERJALAN** | [ ] |

---

## 7. 📥 Kategori 7: Fitur Ekspor Excel / CSV & Supabase Realtime Live Alert

| No | Komponen / Skenario Uji | Deskripsi Tindakan & Hasil yang Diharapkan | Status Sistem | Verifikasi Manual |
| :---: | :--- | :--- | :---: | :---: |
| 7.1 | **Tombol Ekspor di AppBar** | Ikon file download kuning di AppBar $\rightarrow$ Muncul bottom sheet 3 pilihan format ekspor. | [x] **BERJALAN** | [ ] |
| 7.2 | **Ekspor Rekap Nilai Siswa** | Klik opsi 1 $\rightarrow$ File `.csv` terunduh/terbuka dengan tabel nilai pre/post-test, KKM, Gain, dan XP (ber-UTF-8 BOM). | [x] **BERJALAN** | [ ] |
| 7.3 | **Ekspor Transkrip Studi Kasus** | Klik opsi 2 $\rightarrow$ File `.csv` terunduh memuat seluruh rumusan masalah, hipotesis, dan opini inkuiri per modul. | [x] **BERJALAN** | [ ] |
| 7.4 | **Ekspor Laporan Lengkap Terpadu** | Klik opsi 3 $\rightarrow$ File `.csv` terunduh memuat ringkasan eksekutif kelas, tabel nilai siswa, dan transkrip studi kasus. | [x] **BERJALAN** | [ ] |
| 7.5 | **Indikator Realtime Live** | Titik hijau berdenyut (*pulse animation*) di AppBar dengan teks *"Live Connected"*. | [x] **BERJALAN** | [ ] |
| 7.6 | **Live Alert Evaluasi Masuk** | Saat siswa submit kuis evaluasi di tab/device lain $\rightarrow$ Muncul floating banner hijau notifikasi kuis masuk dan list terupdate instan. | [x] **BERJALAN** | [ ] |
| 7.7 | **Live Alert Studi Kasus Masuk** | Saat siswa mengirim studi kasus di tab/device lain $\rightarrow$ Muncul floating banner oranye notifikasi opini masuk dan list terupdate instan. | [x] **BERJALAN** | [ ] |

---

## 8. 🧪 Panduan Langkah Cepat Pengujian Mandiri

1. **Jalankan Aplikasi Web**:
   Buka browser dan akses **[http://localhost:8080](http://localhost:8080)**.
2. **Daftarkan Akun Siswa Penguji**:
   - Di halaman `/auth`, masukkan nama contoh (misal: *Dewi Sartika*), kelas (*XII MIPA 1*), sekolah (*SMAN 1 Bandung*).
   - Klik *"Mulai Belajar E-Modul"*.
3. **Kirimkan Jawaban Contoh**:
   - Masuk ke menu **Tempe** (`/produk/tempe`), buka bagian studi kasus di bawah, ketik jawaban analisis, klik **"Kirim"**.
   - Masuk ke menu **Evaluasi PISA** (`/literasi-sains-quiz`), kerjakan soal hingga selesai.
4. **Buka Portal Admin**:
   - Buka menu drawer samping, klik tombol **"Guru"** (atau buka URL `http://localhost:8080/#/admin`).
   - Masukkan PIN: **`123456`**.
5. **Verifikasi Fitur**:
   - Periksa apakah angka statistik bertambah di **Tab 1**.
   - Periksa apakah profil siswa dan skornya muncul di **Tab 2**.
   - Periksa apakah teks jawaban yang baru saja diketik terbaca utuh di **Tab 3**.
   - Klik ikon **Unduh (Ekspor)** di AppBar dan verifikasi file CSV terbuka rapi di Excel/Google Sheets.
   - Buka 2 tab browser berbeda untuk menguji **Live Alert Realtime** saat siswa submit kuis.

