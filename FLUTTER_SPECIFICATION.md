# 📱 SPESIFIKASI PENGEMBANGAN APLIKASI FLUTTER
# E-MODUL ETNOSAINS: MAKANAN TRADISIONAL BERBASIS FERMENTASI

> **Dokumen Acuan Resmi Arsitektur, Desain UI/UX, dan Implementasi Teknis**  
> Diadaptasi dari Dokumen Storyboard & Desain Riset Pembelajaran Etnosains (Tempe, Tape Singkong, Tauco, Kecap, Oncom).

---

## 📑 DAFTAR ISI
1. [Ringkasan Proyek & Visi Produk](#1-ringkasan-proyek--visi-produk)
2. [Arsitektur Sistem & Rekomendasi Tech Stack](#2-arsitektur-sistem--rekomendasi-tech-stack)
3. [Design System & UI Tokens (Theme & Palette)](#3-design-system--ui-tokens)
4. [Struktur Direktori Proyek (Clean Architecture + Feature-First)](#4-struktur-direktori-proyek)
5. [Daftar Dependencies (pubspec.yaml)](#5-daftar-dependencies-pubspecyaml)
6. [Pemetaan Modul & Alur Layar (Screen-by-Screen Specs)](#6-pemetaan-modul--alur-layar)
   - [Screen 1: Cover, Intro & Capaian Pembelajaran](#screen-1-cover-intro--capaian-pembelajaran)
   - [Screen 2: Apersepsi & Brainstorming Interaktif](#screen-2-apersepsi--brainstorming-interaktif)
   - [Screen 3: Peta Jelajah Budaya Nusantara Interaktif](#screen-3-peta-jelajah-budaya-nusantara-interaktif)
   - [Screen 4: Peta Konsep & Taksonomi Mikroorganisme](#screen-4-peta-konsep--taksonomi-mikroorganisme)
   - [Screen 5–9: Modul Eksplorasi 5 Produk Fermentasi](#screen-59-modul-eksplorasi-5-produk-fermentasi)
   - [Screen 10: Virtual Lab Simulasi Uji Glukosa Tape](#screen-10-virtual-lab-simulasi-uji-glukosa-tape)
   - [Screen 11: Evaluasi Literasi Sains Berstandar PISA (10 Soal HOTS)](#screen-11-evaluasi-literasi-sains-berstandar-pisa)
   - [Screen 12: Galeri Inovasi Pangan Modern & Idea Pad](#screen-12-galeri-inovasi-pangan-modern--idea-pad)
   - [Screen 13: Project Challenge & Asesmen Kesadaran Budaya](#screen-13-project-challenge--asesmen-kesadaran-budaya)
7. [Skema Model Data (Entities & JSON Schema)](#7-skema-model-data-entities--json-schema)
8. [Fitur Gamifikasi, Progres Belajar & Sertifikat](#8-fitur-gamifikasi-progres-belajar--sertifikat)
9. [Panduan Implementasi & Checklist Rilis](#9-panduan-implementasi--checklist-rilis)

---

## 1. 🎯 Ringkasan Proyek & Visi Produk

### 1.1 Deskripsi Singkat
Aplikasi **E-Modul Etnosains Fermentasi** adalah media pembelajaran interaktif lintas platform (Android, iOS, Web, Tablet) yang bertujuan merekonstruksi pengetahuan asli masyarakat (*indigenous science / kearifan lokal*) menjadi sains ilmiah (*scientific biology / bioteknologi konvensional*).

### 1.2 Target Pengguna
* **Siswa SMA/MA/SMK** (Kelas X/XII - Materi Biologi: Bioteknologi, Metabolisme, Enzim, dan Keanekaragaman Hayati).
* **Guru Biologi / IPA** sebagai media instruksional berbasis *Problem-Based Learning* (PBL) dan *Ethno-STEM*.
* **Masyarakat & Penggiat Budaya Kuliner**.

### 1.3 Key Features
* 🗺️ **Peta Interaktif Budaya Nusantara** dengan eksplorasi asal-usul kuliner berbasis koordinat wilayah.
* 🔬 **Visual Mikroskop & Taksonomi Mikroorganisme** (*Rhizopus oligosporus*, *Aspergillus oryzae*, *Saccharomyces cerevisiae*, *Neurospora intermedia*, dsb.).
* 🧪 **Interactive Virtual Lab (Simulasi Kadar Glukosa)** dengan slider konsentrasi ragi, suhu, dan waktu pemeraman.
* 📊 **Engine Soal Literasi Sains PISA & HOTS** dengan grafik dinamis dan analisis data real-time.
* 💡 **Food Innovation Pad & Social Challenge Submission** (video promosi TikTok/Reels).
* 📜 **E-Sertifikat Kelulusan Otomatis** dengan export PDF / Image.

---

## 2. 🏗️ Arsitektur Sistem & Rekomendasi Tech Stack

Aplikasi dirancang menggunakan **Clean Architecture** dengan pendekatan **Feature-First**:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Screens, Widgets, StateNotifier/BLoC, UI States)    │
├────────────────────────────────────────────────────────┤
│                     Domain Layer                       │
│    (Entities, UseCases, Repositories Interfaces)       │
├────────────────────────────────────────────────────────┤
│                      Data Layer                        │
│   (DataSources [Local JSON/Isar/Hive], Models, Repos)  │
└────────────────────────────────────────────────────────┘
```

### Rekomendasi Stack:
* **Framework**: Flutter 3.24+ (Dart 3.5+)
* **State Management**: `flutter_riverpod` (v2.5+) atau `flutter_bloc` (v8.1+)
* **Local Storage / Persistence**: `isar` / `hive_flutter` / `shared_preferences`
* **Navigation / Routing**: `go_router` (v14.0+) dengan deep-linking support
* **Audio & Media**: `audioplayers`, `video_player`, `chewie`
* **Grafik & Visualisasi Data**: `fl_chart`
* **Animasi & Interaktivitas**: `lottie`, `flutter_animate`
* **Ekspor Dokumen**: `pdf`, `printing`, `screenshot`

---

## 3. 🎨 Design System & UI Tokens

Aplikasi mengusung tema **Warm Earthy & Botanical Science** (Kearifan Alam & Laboratorium Sains):

```
┌─────────────────┬───────────┬──────────────────────────────────────────┐
│ Token           │ Hex Code  │ Penggunaan                               │
├─────────────────┼───────────┼──────────────────────────────────────────┤
│ primaryGreen    │ #2D6A4F   │ Header, Tombol Utama, Aksen Etnosains    │
│ primaryDark     │ #1B4332   │ Teks Judul, Bottom Navigation Bar        │
│ sageLight       │ #D8F3DC   │ Card Background, Badge, Highlight Tip    │
│ warmTerracotta  │ #BC6C25   │ Aksen Fermentasi, Poin Kuis, Label Peringatan │
│ goldenYellow    │ #DDA15E   │ Bintang Rating, Trophy Gamifikasi        │
│ warmCream       │ #FEFAE0   │ Background Utama Aplikasi                │
│ surfaceWhite    │ #FFFFFF   │ Container Card, Dialog Modal             │
│ textPrimary     │ #1E293B   │ Teks Paragraf Utama                      │
│ textSecondary   │ #64748B   │ Subtitle, Keterangan, Label Variabel     │
│ errorRed        │ #E63946   │ Validasi Salah, Pantangan Fermentasi     │
│ successGreen    │ #2A9D8F   │ Jawaban Benar, Hasil Optimal             │
└─────────────────┴───────────┴──────────────────────────────────────────┘
```

### Tipografi (Google Fonts):
* **Heading (H1, H2, H3)**: `Plus Jakarta Sans` / `Poppins` (Bold/SemiBold, 700/600)
* **Body / Paragraf**: `Nunito` / `Inter` (Regular/Medium, 400/500)
* **Data / Angka / Laboratorium**: `JetBrains Mono` / `Roboto Mono`

---

## 4. 📂 Struktur Direktori Proyek

```
lib/
├── app.dart
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_assets.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── utils/
│   │   ├── audio_helper.dart
│   │   └── certificate_generator.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_app_bar.dart
│       ├── ethno_card.dart
│       └── audio_narration_player.dart
├── features/
│   ├── cover/
│   │   ├── presentation/
│   │   │   ├── screens/cover_screen.dart
│   │   │   └── widgets/learning_objectives_sheet.dart
│   │   └── controllers/cover_controller.dart
│   ├── apersepsi/
│   │   ├── data/models/food_comparison_model.dart
│   │   └── presentation/screens/apersepsi_screen.dart
│   ├── jelajah_budaya/
│   │   ├── data/models/region_culture_model.dart
│   │   └── presentation/
│   │       ├── screens/jelajah_budaya_screen.dart
│   │       └── widgets/interactive_indonesia_map.dart
│   ├── peta_konsep/
│   │   ├── data/models/microorganism_model.dart
│   │   └── presentation/screens/peta_konsep_screen.dart
│   ├── produk_fermentasi/
│   │   ├── domain/entities/fermented_food_entity.dart
│   │   ├── presentation/
│   │   │   ├── screens/food_detail_screen.dart
│   │   │   ├── tabs/olahan_tab.dart
│   │   │   ├── tabs/kearifan_lokal_tab.dart
│   │   │   ├── tabs/proses_fermentasi_tab.dart
│   │   │   ├── tabs/konsep_etnosains_tab.dart
│   │   │   ├── tabs/nilai_sains_tab.dart
│   │   │   └── tabs/studi_kasus_tab.dart
│   │   └── controllers/food_controller.dart
│   ├── virtual_lab/
│   │   ├── data/models/glucose_experiment_model.dart
│   │   └── presentation/
│   │       ├── screens/virtual_lab_screen.dart
│   │       ├── widgets/fermentation_simulator.dart
│   │       ├── widgets/digital_glucometer_widget.dart
│   │       └── widgets/glucose_chart_widget.dart
│   ├── literasi_sains/
│   │   ├── data/models/pisa_question_model.dart
│   │   ├── presentation/
│   │   │   ├── screens/pisa_quiz_screen.dart
│   │   │   └── widgets/pisa_question_card.dart
│   │   └── controllers/quiz_controller.dart
│   ├── inovasi_makanan/
│   │   ├── presentation/screens/food_innovation_screen.dart
│   │   └── controllers/user_ideas_controller.dart
│   ├── challenge_proyek/
│   │   └── presentation/screens/challenge_screen.dart
│   ├── evaluasi_kearifan/
│   │   ├── data/models/likert_question_model.dart
│   │   └── presentation/screens/cultural_assessment_screen.dart
│   └── sertifikat/
│       └── presentation/screens/certificate_view_screen.dart
└── shared/
    ├── models/user_progress_model.dart
    └── services/local_storage_service.dart
```

---

## 5. 📦 Daftar Dependencies (pubspec.yaml)

```yaml
name: e_modul_etnosains
description: "Aplikasi E-Modul Etnosains Makanan Tradisional Berbasis Fermentasi"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management & DI
  flutter_riverpod: ^2.5.1
  
  # Routing
  go_router: ^14.2.7
  
  # UI & Media
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1
  lottie: ^3.1.2
  flutter_animate: ^4.5.0
  cached_network_image: ^3.3.1
  audioplayers: ^6.0.0
  video_player: ^2.9.1
  chewie: ^1.8.5
  smooth_page_indicator: ^1.1.0
  flutter_staggered_animations: ^1.1.1
  
  # Data Visualizations & Charts
  fl_chart: ^0.68.0
  
  # Local Storage
  shared_preferences: ^2.3.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Exporting & Certificates
  pdf: ^3.11.1
  printing: ^5.13.2
  screenshot: ^3.0.0
  path_provider: ^2.1.4
  share_plus: ^10.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.11
  hive_generator: ^2.0.1
```

---

## 6. 📱 Pemetaan Modul & Alur Layar (Screen-by-Screen Specs)

### Screen 1: Cover, Intro & Capaian Pembelajaran
* **Rute**: `/`
* **Komponen UI**:
  * `HeroCoverIllustration`: Ilustrasi tempe mendoan, tape, daun pisang, dan ikon mikrobiologi.
  * `TitleHeader`: "E-Modul Etnosains: Makanan Tradisional Indonesia Berbasis Fermentasi".
  * `AudioIntroButton`: Memutar narasi suara pengantar selamat datang.
  * `VideoPengantarDialog`: Pop-up video singkat latar belakang kelezatan fermentasi tradisional.
  * `LearningObjectivesBottomSheet`: Menampilkan 5 butir Tujuan Pembelajaran dalam format checklist interaktif.
  * `CtaButton`: "Mulai Belajar" $\rightarrow$ Navigasi ke `/apersepsi`.

---

### Screen 2: Apersepsi & Brainstorming Interaktif
* **Rute**: `/apersepsi`
* **Tujuan**: Menghubungkan realitas kuliner modern vs tradisional untuk mengaktifkan skema awal siswa.
* **Komponen UI**:
  * `FoodComparisonGrid`: Grid 2 kolom menampilkan makanan Populer Modern (Burger, Pizza, Kimchi, Yogurt) vs Tradisional (Colenak, Combro, Nasi Tutug Oncom, Orek Tempe, Sayur Ikan Tauco, Tahu Gejrot).
  * `PromptQuestionCard`: *"Mengapa banyak remaja lebih mengenal Pizza & Kimchi dibandingkan Colenak & Oncom?"*
  * `InteractiveDragDropSection`: Siswa mencocokkan makanan dengan bahan baku fermentasinya.
  * `ReflectionInputCard`: `TextFormField` multiline untuk menuliskan opini siswa (disimpan otomatis ke Local Storage).

---

### Screen 3: Peta Jelajah Budaya Nusantara Interaktif
* **Rute**: `/jelajah-budaya`
* **Komponen UI**:
  * `InteractiveSvgMap`: Peta Indonesia (fokus Pulau Jawa & Priangan) dengan pin koordinat yang dapat diklik:
    * **Banyumas (Jateng)**: Tempe Mendoan (*mendo* = setengah matang/lembek).
    * **Tasikmalaya (Jabar)**: Nasi TO (*tutug* = ditumbuk), Combro (*oncom di jero*), Colenak (*dicocol enak*).
    * **Cianjur (Jabar)**: Sayur Ikan Tauco (tradisi fermentasi garam pesisir ratusan tahun).
    * **Purwakarta (Jabar)**: Sate Maranggi (daging dimarinasi bumbu kecap sebelum dibakar).
    * **Bandung/Priangan**: Es Doger (*dorong gerobak* + isian peuyeum), Kolek Peuyeum.
  * `CulturalDetailModal`: Membuka modal dengan foto makanan, audio pelafalan lokal, serta asal-usul istilah (*etimologi bahasa daerah*).

---

### Screen 4: Peta Konsep & Taksonomi Mikroorganisme
* **Rute**: `/peta-konsep`
* **Komponen UI**:
  * `ConceptGraphView`: Diagram pohon interaktif menghubungkan 5 produk fermentasi dengan produk turunannya.
  * `MicrobeCardGrid`: Kartu interaktif mikroba:
    1. **Tempe**: *Rhizopus oligosporus* & *Rhizopus oryzae* (Enzim Protease & Miselium putih).
    2. **Tape Singkong**: *Aspergillus sp.*, *Saccharomyces cerevisiae*, *Acetobacter aceti*.
    3. **Tauco**: *Aspergillus oryzae* + *Tetragenococcus halophilus* (Bakteri Halofilik).
    4. **Kecap**: *Aspergillus oryzae*, *Saccharomyces cerevisiae*, Bakteri Asam Laktat.
    5. **Oncom**: *Neurospora intermedia* / *Neurospora sitophila* (Pigmen karotenoid oranye & Enzim hidrolitik).
  * `MicroscopeSimulator`: Mode zoom visual miselium dan sel ragi di bawah mikroskop virtual.

---

### Screen 5–9: Modul Eksplorasi 5 Produk Fermentasi
* **Rute**: `/produk/:foodId` (`tempe`, `tape`, `tauco`, `kecap`, `oncom`)
* **Struktur Tampilan (Sliver AppBar + Bottom TabBar)**:
  1. **Tab 1: Olahan Tradisional**: Galeri foto hidangan turunan dan deskripsi rasa.
  2. **Tab 2: Jejak Kearifan Lokal**: Praktik tradisional masyarakat (penggunaan daun pisang/jati, tempayan tanah liat, penjemuran matahari, pantangan kebersihan saat menabur ragi).
  3. **Tab 3: Alur Fermentasi**: *Interactive Step-by-Step Horizontal Stepper* dengan foto asli dari `image6.jpeg`.
  4. **Tab 4: Konsep Etnosains**: Rekonstruksi sains asli masyarakat menjadi konsep sains modern (ekonomi sirkular ampas tahu, fungsi wadah gelap, seleksi garam).
  5. **Tab 5: Nilai Sains Biologis**: Penjelasan biokimia (pemecahan protein $\rightarrow$ asam amino glutamat / rasa umami, pembentukan vitamin B12, hidrolisis amilum $\rightarrow$ glukosa $\rightarrow$ etanol).
  6. **Tab 6: Studi Kasus (PBL)**: Studi kasus nyata di lapangan disertai kolom interaktif perumusan masalah, hipotesis, dan variabel ilmiah.

---

### Screen 10: Virtual Lab Simulasi Uji Glukosa Tape
* **Rute**: `/virtual-lab`
* **Komponen UI**:
  * `InputControlPanel`:
    * Slider Konsentrasi Ragi: `0.5%` (4.5g), `1.0%` (9.0g), `1.5%` (13.5g).
    * Slider Durasi Pemeraman: `1 Hari`, `2 Hari`, `3 Hari`, `4 Hari`, `5 Hari`.
    * Toggle Wadah: Daun Pisang vs Plastik Tertutup Rapat.
  * `DigitalGlucometerDisplay`: Tampilan animasi LED pengukur kadar glukosa digital (menampilkan data riil: 1% Hari ke-2 = **51,61%**; 1% Hari ke-3 = **41,71%**).
  * `DynamicLineBarChart`: Grafik fluktuasi glukosa menggunakan `fl_chart` yang diperbarui secara real-time berdasarkan kombinasi slider.
  * `ChemicalEquationBanner`:
    $$\text{Pati} \xrightarrow{\text{Amilase}} \text{Glukosa} \xrightarrow{\text{Khamir}} \text{Etanol} + \text{CO}_2 + \text{Energi}$$

---

### Screen 11: Evaluasi Literasi Sains Berstandar PISA
* **Rute**: `/literasi-sains-quiz`
* **Spesifikasi Engine 10 Soal HOTS**:
  * **Domain 1: Mengidentifikasi Masalah & Pertanyaan Ilmiah**
    * *Soal 1*: Merumuskan masalah ilmiah & 2 pertanyaan penelitian eksperimen tape.
    * *Soal 2*: Menentukan variabel bebas, variabel terikat, dan 3 variabel kontrol.
  * **Domain 2: Menjelaskan Fenomena secara Ilmiah**
    * *Soal 3*: Menganalisis alasan penurunan glukosa di hari ke-3 (glikolisis & fermentasi alkohol lanjutan).
    * *Soal 4*: Menganalisis mengapa ragi 1,5% tidak menghasilkan glukosa tertinggi (substrat exhaustion).
    * *Soal 5*: Menjelaskan mengapa tape yang terlalu lama berasa lebih beralkohol daripada manis.
  * **Domain 3: Menggunakan & Menginterpretasikan Bukti Ilmiah**
    * *Soal 6*: Analisis komparasi data glukosa hari ke-2 (Pilihan Ganda & Justifikasi).
    * *Soal 7*: Uji kebenaran klaim: *"Semakin banyak ragi, semakin tinggi glukosa"* berdasarkan data empiris.
    * *Soal 8*: Penentuan perlakuan optimal untuk produksi tape termanis (Ragi 1%, 2 Hari).
    * *Soal 9*: Prediksi tren kadar glukosa jika fermentasi dilanjutkan hingga hari ke-5.
    * *Soal 10 (HOTS PISA)*: Studi kasus pilihan proses produsen Tape A (1%, 2 hari) vs Tape B (1.5%, 3 hari).
  * **Fitur Penilaian**: Real-time scoring, umpan balik komprehensif, pembahasan ilmiah di tiap nomor.

---

### Screen 12: Galeri Inovasi Pangan Modern & Idea Pad
* **Rute**: `/inovasi-pangan`
* **Komponen UI**:
  * `InnovationCardCarousel`:
    * **Tempe**: Burger Tempe, Nugget Tempe, Tempe Krispi.
    * **Tape**: Es Krim Tape Singkong, Cheese Cake Tape, Smoothie Peuyeum.
    * **Oncom**: Pizza Oncom Saus Tomat, Pasta Oncom Carbonara, Keripik Oncom Gurih.
    * **Tauco**: Saus Glaze Tauco Modern, Ikan Bakar Marinade Tauco.
    * **Kecap**: Kecap Organik Rendah Natrium, Glaze Kecap Manis Alami.
  * `StudentIdeaSubmissionPad`: Formulir nama inovasi, bahan baku, konsep bioteknologi, dan upload sketsa produk.

---

### Screen 13: Project Challenge & Asesmen Kesadaran Budaya
* **Rute**: `/challenge-asesmen`
* **Komponen UI**:
  * `SocialMediaChallengeCard`: Panduan tugas pembuatan video promosi (TikTok / IG Reels 1–2 menit) dengan 6 kriteria wajib (Sejarah, Fermentasi, Manfaat Kesehatan, Nilai Budaya, Inovasi, Ajakan Melestarikan).
  * `LikertScaleAssessment`: Kuesioner Kesadaran Kearifan Lokal (5 Indikator, 30 Pernyataan, Skala 1–5: *Sangat Setuju* s/d *Sangat Tidak Setuju*).
  * `ResultRadarChart`: Grafik radar indeks kecintaan budaya lokal siswa.

---

## 7. 🧬 Skema Model Data (Entities & JSON Schema)

### 7.1 FermentedFoodModel
```dart
class FermentedFoodModel {
  final String id;
  final String name;
  final String localName;
  final String region;
  final String rawMaterial;
  final List<MicroorganismModel> microorganisms;
  final List<String> traditionalDishes;
  final List<StepProcessModel> processSteps;
  final String localWisdom;
  final String ethnoscienceConcept;
  final String modernScienceValue;
  final CaseStudyModel caseStudy;

  FermentedFoodModel({
    required this.id,
    required this.name,
    required this.localName,
    required this.region,
    required this.rawMaterial,
    required this.microorganisms,
    required this.traditionalDishes,
    required this.processSteps,
    required this.localWisdom,
    required this.ethnoscienceConcept,
    required this.modernScienceValue,
    required this.caseStudy,
  });
}
```

### 7.2 GlucoseExperimentResult
```dart
class GlucoseExperimentResult {
  final double yeastPercentage; // 0.5, 1.0, 1.5
  final int fermentationDays;   // 1, 2, 3, 4, 5
  final double glucoseLevel;    // %, contoh: 51.61
  final double alcoholLevel;    // perkiraan %
  final String tasteDescription;
  final String textureDescription;

  GlucoseExperimentResult({
    required this.yeastPercentage,
    required this.fermentationDays,
    required this.glucoseLevel,
    required this.alcoholLevel,
    required this.tasteDescription,
    required this.textureDescription,
  });
}
```

### 7.3 PisaQuestionModel
```dart
enum PisaCompetency {
  identifyScientificIssues,
  explainPhenomenaScientifically,
  useScientificEvidence,
}

class PisaQuestionModel {
  final int id;
  final String title;
  final PisaCompetency competency;
  final String questionText;
  final String? imageAsset;
  final List<String> options;
  final dynamic correctAnswer;
  final String explanation;
  final String hint;

  PisaQuestionModel({
    required this.id,
    required this.title,
    required this.competency,
    required this.questionText,
    this.imageAsset,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.hint,
  });
}
```

---

## 8. 🏆 Fitur Gamifikasi, Progres Belajar & Sertifikat

1. **XP Points & Badges**:
   * Menjelajahi 5 Peta Budaya: 🎖️ *Penjelajah Kuliner Nusantara* (+100 XP)
   * Menyelesaikan Virtual Lab Tape: 🧪 *Saintis Fermentasi Muda* (+150 XP)
   * Nilai Literasi Sains $\ge 80$: 🧠 *Master Bioteknologi Tradisional* (+250 XP)
2. **E-Sertifikat Digital Otomatis**:
   * Dibuat menggunakan package `pdf` dan `printing`.
   * Memuat Nama Siswa, Skor Literasi Sains, Tingkat Kesadaran Budaya, dan QR Code Verifikasi.
   * Tombol "Simpan Gambar" / "Bagikan Sertifikat (PDF)".

---

## 9. 🚀 Panduan Implementasi & Checklist Rilis

### Tahapan Pengerjaan (Sprint Plan):
- [ ] **Sprint 1**: Setup project Flutter, routing (`go_router`), theming, dan integrasi assets.
- [ ] **Sprint 2**: Implementasi Screen Cover, Apersepsi, Peta Jelajah Budaya SVG, dan Peta Konsep.
- [ ] **Sprint 3**: Implementasi Modul Detail 5 Produk Fermentasi (Tempe, Tape, Tauco, Kecap, Oncom).
- [ ] **Sprint 4**: Pembuatan Virtual Lab Uji Glukosa dengan `fl_chart` dan algoritma simulasi.
- [ ] **Sprint 5**: Engine Kuis Literasi Sains PISA (10 Soal HOTS) + Pembahasan Interaktif.
- [ ] **Sprint 6**: Food Innovation Pad, Angket Skala Likert, dan Generator Sertifikat PDF.
- [ ] **Sprint 7**: Testing responsivitas (Android, iOS, Web, Tablet) dan Quality Assurance.

---
*Dokumen ini dibuat secara otomatis sebagai panduan arsitektur pengembangan E-Modul Etnosains berbasis Flutter.*
