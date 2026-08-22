import 'pisa_question_model.dart';

class PisaQuestionsData {
  static const List<PisaQuestionModel> questions = [
    // SOAL 1
    PisaQuestionModel(
      id: 1,
      title: 'Soal 1: Perumusan Masalah Ilmiah Praktikum Tape',
      competency: PisaCompetency.identifyScientificIssues,
      competencyLabel: 'Mengidentifikasi Isu & Masalah Ilmiah',
      scenarioContext:
          'Seorang peneliti bioteknologi tradisional ingin mengetahui faktor penentu kualitas rasa manis tape singkong. Ia menguji 3 variasi konsentrasi ragi (0,5%; 1,0%; 1,5%) dengan waktu fermentasi selama 1, 2, dan 3 hari pada suhu ruang.',
      questionText:
          'Berdasarkan rancangan eksperimen tersebut, manakah rumusan masalah ilmiah yang paling tepat dan dapat diuji secara objektif di laboratorium?',
      options: [
        PisaQuestionOption(
          text: 'Mengapa masyarakat zaman dahulu lebih menyukai singkong kuning daripada singkong putih untuk membuat peuyeum?',
          isCorrect: false,
          justification: 'Ini adalah pertanyaan historis/preferensi, bukan menguji variabel konsentrasi ragi dan waktu fermentasi.',
        ),
        PisaQuestionOption(
          text: 'Bagaimanakah pengaruh konsentrasi ragi dan lama fermentasi terhadap kadar glukosa yang dihasilkan pada tape singkong?',
          isCorrect: true,
          justification: 'Tepat menghubungkan variabel bebas (konsentrasi ragi & lama hari) dengan variabel terikat terukur (kadar glukosa %).',
        ),
        PisaQuestionOption(
          text: 'Apakah semua jenis mikroorganisme pada ragi tape membutuhkan wadah daun pisang agar tidak mati?',
          isCorrect: false,
          justification: 'Terlalu sempit dan tidak menguji variabel konsentrasi ragi serta waktu fermentasi.',
        ),
        PisaQuestionOption(
          text: 'Apakah tape singkong lebih bergizi dibandingkan tempe kedelai dan oncom merah?',
          isCorrect: false,
          justification: 'Membandingkan jenis makanan lain di luar cakupan data penelitian.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Rumusan masalah ilmiah yang baik harus memuat hubungan yang jelas antara variabel bebas yang dimanipulasi (konsentrasi ragi dan durasi pemeraman) dengan variabel terikat yang diukur secara kuantitatif (persentase kadar glukosa tape).',
      hint: 'Cari pertanyaan yang mengaitkan variabel bebas (ragi & hari) dengan variabel terikat (glukosa).',
    ),

    // SOAL 2
    PisaQuestionModel(
      id: 2,
      title: 'Soal 2: Identifikasi Variabel Penelitian Eksperimen',
      competency: PisaCompetency.identifyScientificIssues,
      competencyLabel: 'Mengidentifikasi Variabel Ilmiah',
      scenarioContext:
          'Dalam prosedur praktikum: Singkong 900 g dikukus 30 menit, didinginkan ke suhu ruang, dibagi menjadi kelompok ragi 0,5% (4,5 g), 1,0% (9,0 g), dan 1,5% (13,5 g). Semua kelompok disimpan dalam wadah tertutup beralas daun pisang pada suhu ruang yang sama.',
      questionText:
          'Manakah kombinasi penentuan variabel penelitian yang paling tepat sesuai kaidah metode ilmiah?',
      options: [
        PisaQuestionOption(
          text: 'Variabel Bebas: Waktu pengukusan; Variabel Terikat: Berat ragi; Variabel Kontrol: Kadar glukosa.',
          isCorrect: false,
          justification: 'Terbalik; waktu pengukusan adalah variabel kontrol dan kadar glukosa adalah variabel terikat.',
        ),
        PisaQuestionOption(
          text: 'Variabel Bebas: Konsentrasi ragi & lama fermentasi; Variabel Terikat: Kadar glukosa tape; Variabel Kontrol: Massa singkong (900g), waktu kukus (30 menit), jenis daun pembungkus.',
          isCorrect: true,
          justification: 'Sempurna; memisahkan faktor yang diubah, faktor yang diukur, dan faktor yang dibuat konstan.',
        ),
        PisaQuestionOption(
          text: 'Variabel Bebas: Jenis daun pembungkus; Variabel Terikat: Rasa manis; Variabel Kontrol: Suhu inkubasi.',
          isCorrect: false,
          justification: 'Jenis daun dibuat sama (kontrol), bukan dimanipulasi.',
        ),
        PisaQuestionOption(
          text: 'Variabel Bebas: Kadar glukosa; Variabel Terikat: Konsentrasi ragi; Variabel Kontrol: Lama fermentasi.',
          isCorrect: false,
          justification: 'Variabel bebas dan terikat tertukar.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Variabel bebas adalah perlakuan yang sengaja divariasikan (konsentrasi ragi dan waktu inkubasi). Variabel terikat adalah respons terukur (kadar glukosa %). Variabel kontrol adalah parameter yang dijaga tetap sama agar hasil tidak bias (massa singkong 900 g, lama pengukusan 30 menit, wadah daun pisang, dan suhu lingkungan).',
      hint: 'Ingat: Variabel bebas adalah faktor yang diubah-ubah, variabel kontrol dijaga tetap sama.',
    ),

    // SOAL 3
    PisaQuestionModel(
      id: 3,
      title: 'Soal 3: Analisis Penurunan Kadar Glukosa di Hari ke-3',
      competency: PisaCompetency.explainPhenomenaScientifically,
      competencyLabel: 'Menjelaskan Fenomena secara Ilmiah',
      scenarioContext:
          'Data empiris menunjukkan: Pada konsentrasi ragi 1,0%, kadar glukosa tape mencapai puncaknya di hari ke-2 sebesar 51,61%. Namun ketika fermentasi dilanjutkan ke hari ke-3, kadar glukosanya turun menjadi 41,71%.',
      tableDataSummary: 'Ragi 1%: Hari 1 = 27,94% | Hari 2 = 51,61% | Hari 3 = 41,71%',
      questionText:
          'Mengapakah kadar glukosa mengalami penurunan yang signifikan setelah fermentasi berlangsung melebihi hari ke-2?',
      options: [
        PisaQuestionOption(
          text: 'Karena mikroorganisme ragi mengalami kematian serentak sehingga amilum kembali mengendap.',
          isCorrect: false,
          justification: 'Mikroorganisme ragi tidak mati serentak, melainkan tetap aktif bermetabolisme.',
        ),
        PisaQuestionOption(
          text: 'Karena glukosa yang terbentuk digunakan khamir (Saccharomyces cerevisiae) sebagai substrat untuk menghasilkan etanol, CO₂, dan energi.',
          isCorrect: true,
          justification: 'Penjelasan biokimia fermentasi alkohol: C6H12O6 -> 2 C2H5OH + 2 CO2 + ATP.',
        ),
        PisaQuestionOption(
          text: 'Karena uap air dari daun pisang mengencerkan konsentrasi gula di dalam singkong.',
          isCorrect: false,
          justification: 'Pengenceran fisik bukan penyebab utama penurunan biokimiawi gula pereduksi.',
        ),
        PisaQuestionOption(
          text: 'Karena enzim amilase mengubah glukosa kembali menjadi molekul amilum rantai panjang.',
          isCorrect: false,
          justification: 'Reaksi hidrolisis amilase bersifat searah dalam kondisi fermentasi.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Fermentasi tape melibatkan dua tahapan berkesinambungan: Sakarifikasi (pemecahan amilum menjadi glukosa oleh kapang amilolitik) dan Fermentasi Alkohol (pengubahan glukosa menjadi etanol dan gas CO₂ oleh khamir Saccharomyces cerevisiae). Di hari ke-3, laju konsumsi glukosa oleh khamir melampaui laju pembentukan glukosa baru, sehingga kadar glukosa bebas menurun seiring naiknya kadar alkohol.',
      hint: 'Pikirkan produk lanjutan yang dihasilkan oleh ragi khamir dari glukosa (fermentasi alkohol).',
    ),

    // SOAL 4
    PisaQuestionModel(
      id: 4,
      title: 'Soal 4: Pengaruh Konsentrasi Ragi Berlebih (1,5%)',
      competency: PisaCompetency.explainPhenomenaScientifically,
      competencyLabel: 'Menjelaskan Fenomena secara Ilmiah',
      scenarioContext:
          'Pada hari ke-2 pengujian: Konsentrasi ragi 1,0% menghasilkan kadar glukosa 51,61%, sedangkan konsentrasi ragi 1,5% hanya menghasilkan 41,81%.',
      questionText:
          'Mengapa penambahan ragi yang lebih banyak (1,5%) justru menghasilkan kadar glukosa yang lebih rendah pada hari ke-2 dibandingkan ragi 1,0%?',
      options: [
        PisaQuestionOption(
          text: 'Terlalu banyak ragi menyebabkan singkong menjadi terlalu kering sehingga enzim tidak dapat larut.',
          isCorrect: false,
          justification: 'Ragi tidak mengeringkan singkong secara fisik.',
        ),
        PisaQuestionOption(
          text: 'Populasi khamir yang terlalu padat mengonsumsi glukosa secara sangat cepat untuk respirasi dan pembentukan alkohol sebelum sempat terakumulasi.',
          isCorrect: true,
          justification: 'Kepadatan inokulum tinggi mempercepat habisnya substrat glukosa ke jalur fermentasi alkohol.',
        ),
        PisaQuestionOption(
          text: 'Ragi 1,5% mematikan seluruh kapang Aspergillus yang bertugas memecah amilum.',
          isCorrect: false,
          justification: 'Kapang tidak mati akibat dosis ragi, melainkan laju metabolisme khamir yang mendominasi.',
        ),
        PisaQuestionOption(
          text: 'Dosis ragi 1,5% mengubah pH menjadi basa kuat sehingga enzim amilase terdenaturasi.',
          isCorrect: false,
          justification: 'Fermentasi tape menghasilkan kondisi asam lemah, bukan basa kuat.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Inokulasi ragi 1,5% mengandung jumlah sel khamir Saccharomyces yang sangat padat. Tingginya populasi mikroba menyebabkan pemanfaatan glukosa berlangsung sangat cepat. Glukosa yang baru terbentuk dari amilum langsung dirombak menjadi etanol dan CO₂, sehingga kadar glukosa terukur menjadi lebih rendah dibandingkan dosis optimum 1,0%.',
      hint: 'Semakin banyak mikroba pemakan gula, semakin cepat gula diubah menjadi alkohol.',
    ),

    // SOAL 5
    PisaQuestionModel(
      id: 5,
      title: 'Soal 5: Perubahan Cita Rasa Tape Akibat Waktu Fermentasi',
      competency: PisaCompetency.explainPhenomenaScientifically,
      competencyLabel: 'Menjelaskan Fenomena secara Ilmiah',
      scenarioContext:
          'Seorang konsumen membeli tape singkong yang telah disimpan selama 4–5 hari. Saat dicicipi, rasa tape tidak lagi manis legit melainkan terasa tajam beralkohol dan sedikit menyengat di lidah.',
      questionText:
          'Berdasarkan jalur biokimia fermentasi, manakah penjelasan ilmiah yang paling tepat mengenai perubahan cita rasa tersebut?',
      options: [
        PisaQuestionOption(
          text: 'Pati singkong berubah menjadi senyawa racun sianida akibat penyimpanan lama.',
          isCorrect: false,
          justification: 'Proses perebusan singkong telah mendegradasi glukosida sianogenik secara tuntas.',
        ),
        PisaQuestionOption(
          text: 'Glukosa habis terfermentasi menjadi etanol dan asam organik volatil, sementara Acetobacter aceti mulai mengoksidasi etanol menjadi asam asetat.',
          isCorrect: true,
          justification: 'Penjelasan lengkap konversi alkohol dan asam asetat pada fermentasi lanjut.',
        ),
        PisaQuestionOption(
          text: 'Kandungan air menguap seluruhnya sehingga gula mengkristal dan kehilangan rasa manis.',
          isCorrect: false,
          justification: 'Tape lama justru bertambah basah dan berair, bukan mengering.',
        ),
        PisaQuestionOption(
          text: 'Bakteri pembusuk mengubah seluruh protein singkong menjadi gas metana.',
          isCorrect: false,
          justification: 'Bukan fermentasi metanogenik.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Ketika fermentasi diperpanjang melebihi batas optimum (2 hari), simpanan glukosa terhidrolisis habis dikonsumsi oleh Saccharomyces cerevisiae menjadi etanol (alkohol). Sebagian etanol juga mulai dioksidasi oleh bakteri Acetobacter aceti menjadi asam asetat (cuka), memberikan sensasi tajam beralkohol dan masam.',
      hint: 'Perhatikan pembentukan etanol dan asam cuka oleh bakteri lanjutan.',
    ),

    // SOAL 6
    PisaQuestionModel(
      id: 6,
      title: 'Soal 6: Komparasi Data Glukosa Hari ke-2',
      competency: PisaCompetency.useScientificEvidence,
      competencyLabel: 'Menggunakan & Menginterpretasikan Bukti Ilmiah',
      scenarioContext:
          'Perhatikan data hasil uji kadar glukosa tape pada Hari ke-2:\n- Ragi 0,5% : 41,25%\n- Ragi 1,0% : 51,61%\n- Ragi 1,5% : 41,81%',
      imageAsset: 'assets/images/pisa_question_6_ref.png',
      questionText:
          'Berdasarkan data penelitian di atas, perlakuan manakah yang menghasilkan kadar glukosa tertinggi dan bagaimanakah justifikasi datanya?',
      options: [
        PisaQuestionOption(
          text: 'Ragi 0,5% selama 2 hari, karena paling hemat ragi dan tidak terlalu asam.',
          isCorrect: false,
          justification: 'Nilai glukosanya hanya 41,25%, bukan yang tertinggi.',
        ),
        PisaQuestionOption(
          text: 'Ragi 1,5% selama 2 hari, karena dosis ragi lebih banyak selalu menghasilkan glukosa lebih banyak.',
          isCorrect: false,
          justification: 'Bertentangan dengan data: ragi 1,5% menghasilkan 41,81%.',
        ),
        PisaQuestionOption(
          text: 'Ragi 1,0% selama 2 hari, karena mencapai kadar glukosa 51,61% yang secara signifikan lebih tinggi dibanding 41,25% (0,5%) dan 41,81% (1,5%).',
          isCorrect: true,
          justification: 'Sesuai 100% dengan data empiris dan kunci acuan PISA.',
        ),
        PisaQuestionOption(
          text: 'Semua perlakuan menghasilkan kadar glukosa yang setara (berkisar 40%).',
          isCorrect: false,
          justification: 'Data 51,61% memiliki selisih hampir 10% di atas perlakuan lainnya.',
        ),
      ],
      correctOptionIndex: 2,
      scientificExplanation:
          'Berdasarkan data kuantitatif tabel uji laboratorium, kadar glukosa tertinggi pada hari ke-2 diraih oleh perlakuan ragi 1,0% yaitu sebesar 51,61%. Nilai ini melampaui standar mutu Badan Ketahanan Pangan Daerah Jawa Barat (>51,14%).',
      hint: 'Bandingkan angka persentase: 41,25% vs 51,61% vs 41,81%.',
    ),

    // SOAL 7
    PisaQuestionModel(
      id: 7,
      title: 'Soal 7: Uji Kebenaran Klaim Berdasarkan Data Empiris',
      competency: PisaCompetency.useScientificEvidence,
      competencyLabel: 'Menguji Bukti & Klaim Ilmiah',
      scenarioContext:
          'Seorang siswa membuat kesimpulan: "Semakin banyak ragi yang digunakan dalam pembuatan tape, maka kadar glukosa yang dihasilkan akan selalu semakin tinggi."',
      tableDataSummary: 'Hari 2: Ragi 0,5% = 41,25% | Ragi 1,0% = 51,61% | Ragi 1,5% = 41,81%',
      questionText:
          'Apakah kesimpulan siswa tersebut didukung oleh data hasil penelitian? Berikan argumen berbasis bukti ilmiah!',
      options: [
        PisaQuestionOption(
          text: 'Ya, kesimpulan didukung karena ragi 1,5% menghasilkan fermentasi yang paling cepat.',
          isCorrect: false,
          justification: 'Tidak didukung data karena kadar glukosa ragi 1,5% (41,81%) lebih rendah daripada ragi 1,0% (51,61%).',
        ),
        PisaQuestionOption(
          text: 'Tidak didukung data, karena pada konsentrasi ragi 1,5% kadar glukosa hari ke-2 (41,81%) terbukti lebih rendah dibanding ragi 1,0% (51,61%).',
          isCorrect: true,
          justification: 'Argumen ilmiah sahih yang menyangkal klaim linier tidak berbasis data.',
        ),
        PisaQuestionOption(
          text: 'Ya, karena penambahan ragi berbanding lurus dengan pembentukan alkohol.',
          isCorrect: false,
          justification: 'Pertanyaan menanyakan kadar glukosa, bukan kadar alkohol.',
        ),
        PisaQuestionOption(
          text: 'Tidak dapat ditentukan karena data penelitian belum lengkap.',
          isCorrect: false,
          justification: 'Data pada tabel sudah cukup jelas membuktikan penurunan.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Kesimpulan siswa TIDAK DIDUKUNG data penelitian. Hubungan antara dosis ragi dan kadar glukosa bukan garis lurus naik, melainkan kurva optimum. Konsentrasi 1,0% adalah titik optimum (51,61%), sedangkan konsentrasi 1,5% justru menyebabkan glukosa turun ke 41,81% karena perombakan cepat menjadi etanol.',
      hint: 'Lihat data ragi 1,5% (41,81%) apakah lebih tinggi atau lebih rendah dari ragi 1% (51,61%).',
    ),

    // SOAL 8
    PisaQuestionModel(
      id: 8,
      title: 'Soal 8: Rekomendasi Perlakuan Optimal Produksi Pangan',
      competency: PisaCompetency.useScientificEvidence,
      competencyLabel: 'Menggunakan Bukti Ilmiah untuk Solusi Praktis',
      scenarioContext:
          'Sebuah UMKM peuyeum di Bandung ingin memproduksi tape singkong dengan standar mutu terbaik (kadar glukosa > 51,14%) dan cita rasa paling manis legit untuk dipasarkan.',
      questionText:
          'Berdasarkan data penelitian, kombinasi perlakuan manakah yang paling direkomendasikan secara ilmiah dan ekonomis bagi perajin tersebut?',
      options: [
        PisaQuestionOption(
          text: 'Konsentrasi ragi 0,5% dengan lama fermentasi 1 hari.',
          isCorrect: false,
          justification: 'Kadar glukosa hanya 28,86%, tape masih tawar dan keras.',
        ),
        PisaQuestionOption(
          text: 'Konsentrasi ragi 1,0% dengan lama fermentasi 2 hari.',
          isCorrect: true,
          justification: 'Menghasilkan glukosa tertinggi (51,61%) dan memenuhi standar mutu pangan Jawa Barat.',
        ),
        PisaQuestionOption(
          text: 'Konsentrasi ragi 1,5% dengan lama fermentasi 3 hari.',
          isCorrect: false,
          justification: 'Kadar glukosa hanya 43,92% dan aroma alkohol terlalu pekat.',
        ),
        PisaQuestionOption(
          text: 'Konsentrasi ragi 0,5% dengan lama fermentasi 5 hari.',
          isCorrect: false,
          justification: 'Tape akan menjadi masam dan berair dengan glukosa rendah.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Perlakuan konsentrasi ragi 1,0% selama 2 hari adalah titik optimum yang menghasilkan glukosa 51,61%, tekstur kenyal-lunak sempurna, aroma harum aromatik, dan nilai organoleptik tertinggi (bintang 5), serta efisien dalam penggunaan bahan ragi.',
      hint: 'Pilih perlakuan yang menghasilkan puncak glukosa tertinggi 51,61%.',
    ),

    // SOAL 9
    PisaQuestionModel(
      id: 9,
      title: 'Soal 9: Prediksi Tren Kadar Glukosa Fermentasi Lanjutan',
      competency: PisaCompetency.explainPhenomenaScientifically,
      competencyLabel: 'Memprediksi Perubahan Ilmiah',
      scenarioContext:
          'Berdasarkan tren kurva penurunan glukosa dari hari ke-2 (51,61%) ke hari ke-3 (41,71%) pada kelompok ragi 1,0%:',
      questionText:
          'Prediksikan apa yang akan terjadi pada kadar glukosa dan sifat organoleptik tape jika fermentasi terus dibiarkan hingga hari ke-5 tanpa pendinginan!',
      options: [
        PisaQuestionOption(
          text: 'Kadar glukosa akan naik kembali melebihi 60% karena kapang menghasilkan gula cadangan.',
          isCorrect: false,
          justification: 'Tidak ada produksi gula baru karena amilum sudah habis terhidrolisis.',
        ),
        PisaQuestionOption(
          text: 'Kadar glukosa akan semakin menurun tajam (<25%), rasa manis hilang digantikan rasa masam dan aroma alkohol menusuk karena glukosa terus dimanfaatkan khamir dan bakteri asetat.',
          isCorrect: true,
          justification: 'Prediksi ilmiah akurat sesuai metabolisme anaerobik lanjut mikroba.',
        ),
        PisaQuestionOption(
          text: 'Kadar glukosa akan konstan di angka 41,71% selamanya karena fermentasi berhenti sendiri.',
          isCorrect: false,
          justification: 'Mikroorganisme terus aktif selama substrat dan kelembapan tersedia.',
        ),
        PisaQuestionOption(
          text: 'Tape akan mengering dan memadat menjadi adonan roti.',
          isCorrect: false,
          justification: 'Tape justru melunak dan mencair.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Jika fermentasi diteruskan hingga hari ke-5, kadar glukosa akan terus menurun drastis karena glukosa terpakai sebagai substrat respirasi anaerob oleh khamir untuk membentuk etanol, CO₂, dan energi. Selanjutnya, bakteri Acetobacter aceti mengubah etanol menjadi asam asetat sehingga tape menjadi masam berair.',
      hint: 'Ingat bahwa mikroorganisme tidak berhenti mengonsumsi gula selama masih hidup.',
    ),

    // SOAL 10
    PisaQuestionModel(
      id: 10,
      title: 'Soal 10 (HOTS Level PISA): Studi Kasus Keputusan Dua Produsen',
      competency: PisaCompetency.useScientificEvidence,
      competencyLabel: 'Interpretasi Data & Evaluasi Solusi Masalah Nyata',
      scenarioContext:
          'Dua produsen peuyeum memiliki metode produksi berbeda:\n- Produsen A: Menggunakan ragi 1% dengan pemeraman selama 2 hari.\n- Produsen B: Menggunakan ragi 1,5% dengan pemeraman selama 3 hari.\nKeduanya bersaing untuk menghasilkan tape dengan rasa paling manis.',
      imageAsset: 'assets/images/pisa_question_10_ref.png',
      questionText:
          'Berdasarkan data empiris penelitian, produsen manakah yang berhasil memproduksi tape dengan rasa paling manis? Jelaskan menggunakan bukti ilmiah!',
      options: [
        PisaQuestionOption(
          text: 'Produsen B, karena waktu 3 hari memberikan kesempatan lebih lama bagi ragi untuk bekerja.',
          isCorrect: false,
          justification: 'Kadar glukosa Produsen B hanya 43,92%, lebih rendah daripada Produsen A.',
        ),
        PisaQuestionOption(
          text: 'Produsen A, karena perlakuan Ragi 1% selama 2 hari menghasilkan kadar glukosa 51,61%, jauh lebih tinggi dibandingkan Produsen B (43,92%).',
          isCorrect: true,
          justification: 'Sesuai dengan data dan kunci acuan HOTS PISA resmi.',
        ),
        PisaQuestionOption(
          text: 'Keduanya menghasilkan tingkat kemanisan yang sama persis.',
          isCorrect: false,
          justification: 'Terdapat perbedaan kadar glukosa sebesar 7,69%.',
        ),
        PisaQuestionOption(
          text: 'Produsen B, karena biaya produksi ragi 1,5% lebih tinggi sehingga kualitas pasti lebih baik.',
          isCorrect: false,
          justification: 'Biaya tinggi bukan jaminan mutu biologis glukosa.',
        ),
      ],
      correctOptionIndex: 1,
      scientificExplanation:
          'Produsen A adalah pihak yang berhasil karena memilih titik puncak sakarifikasi (Ragi 1%, 2 hari) dengan kadar glukosa 51,61%. Sebaliknya, pada Produsen B (Ragi 1,5%, 3 hari), kadar glukosanya hanya 43,92% karena kelebihan dosis ragi dan waktu fermentasi yang terlalu lama menyebabkan sebagian besar glukosa telah diubah menjadi alkohol.',
      hint: 'Bandingkan data Glukosa Produsen A (51,61%) vs Produsen B (43,92%).',
    ),
  ];
}
