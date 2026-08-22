# 🌾 E-Modul Etnosains: Makanan Tradisional Berbasis Fermentasi

Repositori ini berisi rancangan, materi, aset visual, dan spesifikasi arsitektur untuk pengembangan aplikasi media pembelajaran interaktif **E-Modul Etnosains** berbasis **Flutter**.

---

## 📌 Dokumen Utama

* 📄 **[FLUTTER_SPECIFICATION.md](file:///home/muradelhaq/Documents/GitHub/etno/FLUTTER_SPECIFICATION.md)**: Dokumen spesifikasi teknis lengkap, blueprint arsitektur (Clean Architecture + Feature-First), UI theme tokens, daftar dependencies `pubspec.yaml`, spesifikasi 13 modul layar, simulasi virtual lab, dan 10 soal literasi sains HOTS berstandar PISA.
* 📄 **[STORY BOAD E MODUL ETNOSAINS (1).docx](file:///home/muradelhaq/Documents/GitHub/etno/STORY%20BOAD%20E%20MODUL%20ETNOSAINS%20(1).docx)**: Berkas naskah asli storyboard e-modul.

---

## 🖼️ Direktori Aset Media Visual (`assets/images/`)

Semua aset gambar dan infografis yang diekstrak dari storyboard telah diorganisir di dalam folder [`assets/images/`](file:///home/muradelhaq/Documents/GitHub/etno/assets/images/) dengan nama semantik untuk mempermudah integrasi ke Flutter:

1. **`ui_mockup_12_slides.png`**: Desain wireframe & UI layout lengkap 12 slide interaktif.
2. **`poster_learning_modules.png`**: Infografis ringkasan modul pembelajaran etnosains terpadu.
3. **`flowchart_fermentation_processes.jpeg`**: Diagram alur foto langkah demi langkah pembuatan Tempe, Tape Singkong, Kecap, Tauco, dan Oncom.
4. **`panel_tempe_tauco_tape.jpeg`** & **`panel_tempe_tauco_tape_full.png`**: Infografis lengkap Tempe, Tauco, dan Tape Singkong.
5. **`panel_oncom_kecap.jpeg`** & **`panel_oncom_kecap_hd.jpeg`**: Infografis lengkap Oncom dan Kecap.
6. **`lab_tape_glucose_procedure.jpeg`**: Infografis 6 langkah prosedur praktikum uji kadar glukosa tape singkong.
7. **`chart_glucose_research_data.png`**: Grafik dan tabel data kuantitatif kadar glukosa hasil penelitian.
8. **`pisa_literacy_questions_worksheet.png`**: Poster 10 soal literasi sains berbasis data empiris standar PISA.
9. **`pisa_question_6_ref.png`** & **`pisa_question_10_ref.png`**: Referensi kunci dan analisis soal HOTS.

---

## 🎯 5 Produk Fermentasi yang Dipelajari

1. **Tempe** (*Rhizopus oligosporus* / *Rhizopus oryzae*)
2. **Tape Singkong** (*Aspergillus sp.*, *Saccharomyces cerevisiae*, *Acetobacter aceti*)
3. **Tauco** (*Aspergillus oryzae*, *Tetragenococcus halophilus*)
4. **Kecap** (*Aspergillus oryzae*, *Saccharomyces cerevisiae*, Bakteri Asam Laktat)
5. **Oncom** (*Neurospora intermedia* / *Neurospora sitophila*)

---

## 🚀 Fitur Unggulan Aplikasi

* 🗺️ **Peta Interaktif Kuliner Nusantara**: Eksplorasi asal daerah dan etimologi budaya (*mendoan*, *colenak*, *combro*, *nasi tutug oncom*, dll.).
* 🧪 **Virtual Lab Simulasi Glukosa Tape**: Simulasi slider interaktif konsentrasi ragi & durasi pemeraman yang memvisualisasikan grafik secara real-time.
* 📊 **Engine Soal PISA (10 Soal HOTS)**: Evaluasi 3 kompetensi literasi sains dengan penilaian dan feedback otomatis.
* 📜 **Generator E-Sertifikat**: Otomatisasi penerbitan sertifikat digital berdasar skor literasi sains dan kesadaran budaya.
