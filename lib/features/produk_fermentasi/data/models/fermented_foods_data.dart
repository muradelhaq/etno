import 'package:e_modul_etnosains/core/constants/app_assets.dart';
import '../../domain/entities/fermented_food_entity.dart';

class FermentedFoodsData {
  static const List<FermentedFoodEntity> allFoods = [
    // 1. TEMPE
    FermentedFoodEntity(
      id: 'tempe',
      name: 'Tempe Kedelai',
      localName: 'Tempe Mendoan / Orek Tempe',
      region: 'Banyumas (Jateng) & Seluruh Tatar Nusantara',
      rawMaterial: 'Biji Kedelai Kuning (Glycine max) + Ragi Tempe',
      heroImage: 'assets/images/panel_tempe_tauco_tape_hd.jpeg',
      microorganisms: [
        'Rhizopus oligosporus (Kapang utama penghasil miselium dan protease)',
        'Rhizopus oryzae (Membantu hidrolisis karbohidrat dan protein)',
      ],
      traditionalDishes: [
        'Tempe Mendoan (digoreng mendo / setengah matang gurih)',
        'Orek Tempe Basah & Kering (pengawetan tradisional dengan kecap)',
        'Sayur Lodeh Tempe Semangit (fermentasi lewat waktu kaya rasa umami)',
        'Keripik Tempe Renyah Gurih',
      ],
      processSteps: [
        StepProcessModel(
          stepNumber: 1,
          title: 'Pembersihan & Perendaman Kedelai',
          description:
              'Kedelai dicuci bersih dan direndam selama 12-24 jam. Terjadi fermentasi asam laktat spontan yang menurunkan pH kedelai menjadi 4,5–5,0.',
          biologicalContext:
              'Kondisi asam alami mencegah pertumbuhan bakteri pembusuk patogen sebelum ragi kapang diinokulasikan.',
          tip: 'Gunakan air bersih mengalir dan buang kedelai yang mengapung.',
        ),
        StepProcessModel(
          stepNumber: 2,
          title: 'Pengupasan Kulit & Perebusan',
          description:
              'Kulit ari kedelai dikupas dengan cara diremas, lalu kedelai direbus hingga matang empuk.',
          biologicalContext:
              'Perebusan mendegradasi senyawa antigizi (seperti antitripsin) dan melunakkan struktur biji agar mudah ditembus hifa kapang.',
        ),
        StepProcessModel(
          stepNumber: 3,
          title: 'Penirisan, Pendinginan & Inokulasi Ragi',
          description:
              'Kedelai dihamparkan hingga dingin dan kering permukaannya, lalu ditaburi ragi Rhizopus secara merata.',
          biologicalContext:
              'Spora Rhizopus peka terhadap suhu panas; penaburan harus pada suhu kamar (28-30°C).',
          tip:
              'Jangan menaburkan ragi saat kedelai masih panas agar spora kapang tidak mati.',
        ),
        StepProcessModel(
          stepNumber: 4,
          title: 'Pembungkusan & Fermentasi Ruang',
          description:
              'Kedelai dibungkus daun pisang atau plastik yang diberi lubang-lubang ventilasi mikro, lalu diperam selama 36–48 jam.',
          biologicalContext:
              'Kapang bersifat aerob obligat dan memerlukan pasokan oksigen mikro untuk menjalin miselium putih kompak.',
        ),
      ],
      localWisdom:
          'Masyarakat Sunda dan Jawa sejak dahulu membungkus tempe menggunakan daun pisang atau daun jati. Daun ini memiliki stomata alami yang menjaga kelembapan mikro dan sirkulasi udara optimal tanpa membuat tempe terlalu basah atau kepanasan.',
      ethnoscienceConcept:
          'Penggunaan daun pisang dan penempatan di ruang gelap merekonstruksi prinsip lingkungan mikroklimat aerob-terbatas: stomata daun menyediakan oksigen pasif, sementara suasana gelap dan hangat (30°C) merangsang enzim proteolitik Rhizopus bekerja maksimal tanpa paparan sinar UV yang dapat merusak hifa muda.',
      modernScienceValue:
          'Kapang Rhizopus menghasilkan enzim protease yang memecah protein kedelai menjadi asam amino bebas dan peptida sederhana sehingga daya cerna meningkat. Vitamin B12 yang kadang terdeteksi pada tempe terutama berkaitan dengan bakteri pendamping, bukan produksi langsung oleh Rhizopus.',
      caseStudy: CaseStudyModel(
        title: 'Pengaruh Suhu & Musim Hujan terhadap Laju Fermentasi Tempe',
        storyContext:
            'Seorang perajin tempe di Tasikmalaya menemukan bahwa pada musim hujan (suhu ruang turun ke 23°C), tempe membutuhkan waktu 56 jam untuk membentuk miselium putih padat, sedangkan pada musim kemarau (suhu 30°C) tempe sudah matang sempurna dalam 36 jam. Pada beberapa kemasan di musim hujan, tempe berbau asam dan berlendir.',
        researchQuestion:
            'Bagaimanakah pengaruh suhu lingkungan dan kelembapan terhadap waktu pemeraman serta kualitas miselium tempe?',
        manipulatedVariable: 'Suhu ruang pemeraman (23°C vs 30°C)',
        respondingVariable: 'Waktu pembentukan miselium padat (jam) & pH tempe',
        controlledVariables:
            'Jenis kedelai, konsentrasi ragi Rhizopus (2 g/kg), jenis pembungkus daun pisang.',
        hypothesisHint:
            'Suhu optimum Rhizopus oligosporus adalah 28–32°C. Pada suhu rendah laju metabolik enzim kapang melambat, memberi peluang bakteri pembusuk berkembang.',
        scientificExplanation:
            'Rhizopus oligosporus adalah kapang mesofilik dengan suhu optimal pertumbuhan sekitar 30–35°C. Ketika suhu turun, aktivitas enzim protease dan laju pemanjangan hifa menurun drastis sehingga waktu inkubasi lebih lambat. Kelembapan tinggi tanpa ventilasi memicu bakteri asam pembusuk.',
      ),
    ),

    // 2. TAPE SINGKONG & PEUYEUM
    FermentedFoodEntity(
      id: 'tape',
      name: 'Tape Singkong & Peuyeum',
      localName: 'Peuyeum Bandung / Colenak / Es Doger',
      region: 'Bandung, Garut & Priangan Barat',
      rawMaterial:
          'Singkong Kuning Mentega (Manihot esculenta) + Ragi Tape Tradisional',
      heroImage: AppAssets.tapeSingkong,
      microorganisms: [
        'Amylomyces rouxii (Menguraikan amilum pati menjadi glukosa manis pada tahap sakarifikasi)',
        'Saccharomyces cerevisiae (Khamir pengubah glukosa menjadi etanol & gas CO₂)',
        'Acetobacter aceti (Mengoksidasi sebagian etanol menjadi asam asetat bila fermentasi berlanjut)',
        'Bakteri Asam Laktat (Memberi sentuhan rasa asam segar)',
      ],
      traditionalDishes: [
        'Colenak (peuyeum bakar dicocol saus gula aren kelapa muda)',
        'Es Doger (campuran peuyeum, ketan hitam, kelapa, santan merah)',
        'Kolek Peuyeum (tape singkong berkuah santan gula aren)',
        'Es Goyobod Peuyeum (minuman segar penutup khas Priangan)',
      ],
      processSteps: [
        StepProcessModel(
          stepNumber: 1,
          title: 'Pengupasan & Pencucian Singkong',
          description:
              'Singkong dikupas, dikerik lendir kulit arinya, dipotong rapi, lalu dicuci berkali-kali hingga air jernih.',
          biologicalContext:
              'Pengerikan lendir menghilangkan getah dan kotoran mikroba liar di permukaan singkong.',
        ),
        StepProcessModel(
          stepNumber: 2,
          title: 'Pengukusan Singkong',
          description:
              'Singkong dikukus selama 30 menit hingga matang empuk (3/4 matang untuk peuyeum gantung agar tetap kokoh).',
          biologicalContext:
              'Proses gelatinisasi pati mempermudah enzim amilase kapang ragi memecah ikatan amilosa dan amilopektin.',
        ),
        StepProcessModel(
          stepNumber: 3,
          title: 'Pendinginan Total & Inokulasi Ragi',
          description:
              'Singkong ditata di tampah beralas daun pisang hingga benar-benar dingin, lalu ditaburi serbuk ragi halus (1% b/b).',
          biologicalContext:
              'Suhu panas di atas 40°C dapat mendenaturasi enzim dan membunuh khamir Saccharomyces.',
          tip:
              'Pantangan lokal: Tidak boleh menabur ragi saat singkong masih beruap panas.',
        ),
        StepProcessModel(
          stepNumber: 4,
          title: 'Pemeraman Tertutup (Fermentasi Anaerob)',
          description:
              'Wadah ditutup rapat beralas daun pisang dan disimpan di tempat tenang selama 2–3 hari.',
          biologicalContext:
              'Kondisi semi-anaerob memicu jalur fermentasi alkoholik oleh khamir, menghasilkan kadar glukosa puncak (51,61%) di hari ke-2.',
        ),
      ],
      localWisdom:
          'Dalam kearifan Sunda, perajin memiliki pantangan: wadah pemeraman tidak boleh sering dibuka, tempat pemeraman harus gelap dan tenang, serta tangan tidak boleh basah minyak. Pantangan ini secara ilmiah bertujuan menjaga kestabilan suhu, mencegah fluktuasi gas oksigen (yang dapat memicu pembusukan asam), dan mencegah kontaminasi.',
      ethnoscienceConcept:
          'Tradisi pantangan menabur ragi saat singkong panas merefleksikan pemahaman empiris atas batas termal mikroorganisme hayati. Penutupan rapat dengan daun pisang menghasilkan suasana mikroaerofilik-anaerobik yang mengarahkan metabolisme glikolisis khamir untuk memproduksi etanol aromatik dan gula.',
      modernScienceValue:
          'Terjadi reaksi dua tahap: (1) Sakarifikasi: Enzim amilase mengurai amilum menjadi glukosa; (2) Fermentasi Alkohol: Saccharomyces cerevisiae memetabolisme glukosa menjadi etanol + CO₂. Puncak kemanisan (glukosa 51,61%) terjadi pada konsentrasi ragi 1% di hari ke-2, lalu glukosa menurun di hari ke-3 karena terpakai sebagai substrat produksi alkohol.',
      caseStudy: CaseStudyModel(
        title: 'Optimasi Kadar Glukosa & Dinamika Fermentasi Tape Singkong',
        storyContext:
            'Seorang siswa Biologi menguji kadar glukosa tape pada berbagai konsentrasi ragi (0,5%, 1,0%, 1,5%) selama 1 hingga 3 hari. Data laboratorium menunjukkan kadar glukosa tertinggi dicapai pada ragi 1,0% hari ke-2 (51,61%), namun menurun menjadi 41,71% pada hari ke-3.',
        researchQuestion:
            'Mengapakah kadar glukosa tape singkong mengalami penurunan setelah fermentasi diperpanjang melebihi 2 hari?',
        manipulatedVariable:
            'Lama waktu fermentasi (1, 2, 3 hari) & konsentrasi ragi (0.5%, 1%, 1.5%)',
        respondingVariable: 'Kadar glukosa tape (%) & kadar alkohol',
        controlledVariables:
            'Varietas singkong kuning mentega (900 g), waktu pengukusan (30 menit), jenis wadah daun pisang.',
        hypothesisHint:
            'Pada hari ke-3, laju sakarifikasi amilum melambat karena substrat habis, sedangkan khamir terus mengonsumsi glukosa untuk fermentasi etanol.',
        scientificExplanation:
            'Reaksi glikolisis berlanjut: C6H12O6 -> 2 C2H5OH + 2 CO2. Glukosa yang terbentuk di hari ke-2 dimanfaatkan Saccharomyces cerevisiae sebagai sumber energi dan substrat untuk sintesis etanol dan ester volatil, sehingga kadar glukosa menurun sedangkan aroma alkohol meningkat tajam.',
      ),
    ),

    // 3. TAPE KETAN
    FermentedFoodEntity(
      id: 'tape-ketan',
      name: 'Tape Ketan Hijau / Hitam',
      localName: 'Tape Ketan Kuningan / Es Tape Ketan',
      region: 'Kuningan, Cirebon & Jawa Barat',
      rawMaterial:
          'Beras Ketan Putih/Hitam (Oryza sativa var. glutinosa) + Daun Katuk/Pandan + Ragi',
      heroImage: AppAssets.tapeKetan,
      microorganisms: [
        'Aspergillus oryzae & Amylomyces rouxii (Hidrolisis amilopektin ketan)',
        'Saccharomyces cerevisiae (Pembentukan aroma alkohol segar & cairan manis)',
        'Lactobacillus plantarum (Memberi keasaman khas menyegarkan)',
      ],
      traditionalDishes: [
        'Es Tape Ketan Segar (dengan sirup dan kelapa muda)',
        'Martabak Manis Isi Tape Ketan',
        'Tape Ketan Ember Bungkus Daun Jambu Air (Khas Kuningan)',
      ],
      processSteps: [
        StepProcessModel(
          stepNumber: 1,
          title: 'Perendaman & Pewarnaan Alami Beras Ketan',
          description:
              'Beras ketan direndam selama 4–6 jam bersama perasan daun katuk/pandan alami untuk menghasilkan warna hijau segar dan aroma harum.',
          biologicalContext:
              'Klorofil daun katuk bertindak sebagai pewarna alami dan antioksidan.',
        ),
        StepProcessModel(
          stepNumber: 2,
          title: 'Pengukusan Beras Ketan',
          description:
              'Ketan dikukus, disiram air panas mendidih (diaron), lalu dikukus kembali hingga pulen dan matang merata.',
          biologicalContext:
              'Gelatinisasi amilopektin rantai bercabang pada beras ketan mempermudah kerja enzim hidrolisis ragi.',
        ),
        StepProcessModel(
          stepNumber: 3,
          title: 'Penirisan, Penaburan Ragi & Gula',
          description:
              'Ketan didinginkan di tampah, lalu ditaburi ragi tape halus yang dicampur sedikit gula halus.',
          biologicalContext:
              'Gula awal memberikan energi permulaan (starter kick) bagi pertumbuhan khamir.',
        ),
        StepProcessModel(
          stepNumber: 4,
          title: 'Pemeraman dalam Daun Jambu Air / Wadah Tertutup',
          description:
              'Ketan dibungkus kecil-kecil dengan daun jambu air atau disimpan di ember tertutup selama 2–3 hari.',
          biologicalContext:
              'Daun jambu air memberikan tanin aromatik dan menjaga kelembapan mikroklimat.',
        ),
      ],
      localWisdom:
          'Penggunaan daun jambu air sebagai pembungkus tape ketan di Kuningan memberikan senyawa polifenol alami yang menghambat mikroba pembusuk dan memberikan aroma segar yang tidak didapatkan dari plastik.',
      ethnoscienceConcept:
          'Kandungan amilopektin tinggi (hampir 100%) pada beras ketan terhidrolisis menjadi cairan manis pekat (air tape/berem) yang melimpah, dipadukan dengan sifat antimikroba dari senyawa tanin daun jambu.',
      modernScienceValue:
          'Amilopektin yang memiliki struktur rantai bercabang alfa-1,6 dan alfa-1,4 dihidrolisis cepat oleh glukoamilase ragi menghasilkan cairan glukosa tinggi, gliserol, dan asam amino bebas yang memberi rasa manis legit.',
      caseStudy: CaseStudyModel(
        title:
            'Perbandingan Media Pembungkus Daun Jambu vs Plastik pada Tape Ketan',
        storyContext:
            'Sebuah UMKM tape ketan membandingkan kualitas tape yang dibungkus daun jambu air tradisional dengan kemasan mangkuk plastik tertutup. Hasilnya, tape kemasan daun jambu memiliki aroma lebih harum dan cairan tape tidak terlalu berbusa.',
        researchQuestion:
            'Bagaimanakah pengaruh jenis kemasan (daun jambu air vs wadah plastik) terhadap profil sensori dan keawetan tape ketan?',
        manipulatedVariable:
            'Jenis bahan pembungkus (daun jambu air vs cup plastik)',
        respondingVariable:
            'Skor aroma, tekstur kelunakan, dan volume cairan manis',
        controlledVariables:
            'Massa ketan (50 g per porsi), dosis ragi (1%), lama fermentasi (48 jam pada 28°C).',
        hypothesisHint:
            'Daun jambu air mengandung metabolit sekunder (tanin & flavonoid) yang menekan bakteri pembusuk.',
        scientificExplanation:
            'Senyawa fenolik pada daun jambu bertindak sebagai antimikroba selektif yang mencegah over-fermentasi asam asetat oleh bakteri liar, menghasilkan profil rasa manis legit seimbang.',
      ),
    ),

    // 4. TAUCO
    FermentedFoodEntity(
      id: 'tauco',
      name: 'Tauco Tradisional',
      localName: 'Tauco Cianjur / Sayur Ikan Tauco',
      region: 'Cianjur (Jawa Barat) & Wilayah Pesisir',
      rawMaterial:
          'Biji Kedelai Kuning (Glycine max) + Garam Laut (15-20%) + Ragi Koji',
      heroImage: 'assets/images/panel_tempe_tauco_tape.jpeg',
      microorganisms: [
        'Aspergillus oryzae / Aspergillus sojae (Fermentasi Koji: Enzim Protease, Lipase, Amilase)',
        'Tetragenococcus halophilus (Bakteri Halofilik: Fermentasi Moromi Larutan Garam)',
        'Zygosaccharomyces rouxii (Khamir tahan garam pembentuk aroma gurih volatil)',
      ],
      traditionalDishes: [
        'Sayur Ikan Tauco Kuah Santan Cianjur',
        'Tumis Kangkung Tauco Pedas',
        'Tahu Tempe Masak Tauco Gurih',
        'Ikan Bakar Bumbu Oles Tauco Tradisional',
      ],
      processSteps: [
        StepProcessModel(
          stepNumber: 1,
          title: 'Pembersihan, Perebusan & Pengupasan Kedelai',
          description:
              'Kedelai direbus hingga empuk, ditiriskan, dan dikupas kulit arinya agar mudah ditumbuhi kapang koji.',
          biologicalContext:
              'Protein kedelai terdenaturasi parsial sehingga lebih mudah diserang enzim hidrolitik kapang.',
        ),
        StepProcessModel(
          stepNumber: 2,
          title: 'Fermentasi Kapang (Tahap Koji)',
          description:
              'Kedelai dicampur tepung terigu/beras dan diinokulasi Aspergillus oryzae, lalu dihamparkan di tampah selama 3–5 hari.',
          biologicalContext:
              'Kapang memproduksi enzim ekstraseluler protease kuat yang akan memecah ikatan peptida.',
        ),
        StepProcessModel(
          stepNumber: 3,
          title: 'Perendaman Garam & Penjemuran Matahari (Tahap Moromi)',
          description:
              'Kedelai berkapang dimasukkan ke dalam tempayan tanah liat berisi larutan garam 15–20% dan dijemur di bawah terik matahari selama 2–8 minggu.',
          biologicalContext:
              'Konsentrasi garam tinggi menyeleksi mikroba halofilik Tetragenococcus dan khamir Zygosaccharomyces.',
        ),
        StepProcessModel(
          stepNumber: 4,
          title: 'Pemasakan dengan Gula Aren & Rempah',
          description:
              'Pasta tauco matang dimasak bersama gula kelapa, daun salam, lengkuas, dan serai hingga mengental harum.',
          biologicalContext:
              'Reaksi Maillard antara gula pereduksi dan asam amino menghasilkan warna cokelat gelap berkilau dan rasa umami kompleks.',
        ),
      ],
      localWisdom:
          'Perajin tauco Cianjur menjemur tempayan tanah liat di halaman terbuka hanya pada musim kemarau. Tempayan tanah liat berpori membantu pelepasan uap air berlebih secara perlahan sambil mempertahankan panas matahari untuk inkubasi mikroba garam.',
      ethnoscienceConcept:
          'Kearifan penjemuran matahari dan larutan garam tinggi merekonstruksi mekanisme seleksi osmotik biologis: garam 15–20% menghambat banyak mikroba pembusuk, sementara energi termal matahari membantu menjaga kondisi fermentasi bagi mikroba halotoleran penghasil asam glutamat.',
      modernScienceValue:
          'Enzim endopeptidase Aspergillus dan aktivitas Tetragenococcus halophilus memecah protein kedelai menjadi asam amino bebas berkonsentrasi tinggi, terutama asam glutamat, aspartat, dan alanin. Inilah molekul kimia alami penyumbang cita rasa gurih umami lezat.',
      caseStudy: CaseStudyModel(
        title: 'Penurunan Kualitas Tauco pada Periode Musim Hujan',
        storyContext:
            'Pada musim penghujan yang berkepanjangan, beberapa perajin tauco di Cianjur mengeluhkan produk mereka berwarna pucat, aromanya masam menyengat, dan berjamur hitam di permukaan tempayan. Sebagian warga menduga karena melanggar pantangan adat.',
        researchQuestion:
            'Bagaimanakah pengaruh intensitas sinar matahari dan kadar garam terhadap fermentasi moromi tauco?',
        manipulatedVariable:
            'Intensitas paparan sinar matahari & konsentrasi garam larutan moromi (10% vs 20%)',
        respondingVariable:
            'Tingkat keasaman (pH), kadar asam glutamat, dan keberadaan jamur kontaminan',
        controlledVariables:
            'Jenis kedelai, strain Aspergillus oryzae, jenis tempayan tanah liat.',
        hypothesisHint:
            'Kurangnya panas matahari menurunkan suhu moromi di bawah 30°C, sehingga laju proteolisis halofilik terhambat dan jamur liar tumbuh.',
        scientificExplanation:
            'Penjemuran sinar matahari berfungsi ganda: memberikan panas termal untuk aktivitas bakteri halofilik dan radiasi UV untuk mensterilkan permukaan atas tempayan. Tanpa matahari cukup, suhu rendah dan kelembapan tinggi memicu dominasi mikroba pembusuk dan penurunan degradasi protein.',
      ),
    ),
  ];
}
