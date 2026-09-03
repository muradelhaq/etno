import '../../../../core/constants/app_assets.dart';
import '../../domain/entities/fermented_food_entity.dart';

enum StepIconType {
  kedelai,
  perendaman,
  perebusan,
  ragi,
  pembungkusan,
  fermentasi,
  tempe,
}

class ProcessStepItem {
  final String title;
  final String? subtitle;
  final String? imageAsset;
  final StepIconType iconType;
  final String description;
  final String biologicalExplanation;

  const ProcessStepItem({
    required this.title,
    this.subtitle,
    this.imageAsset,
    required this.iconType,
    required this.description,
    required this.biologicalExplanation,
  });
}

class FoodProcessStepsProvider {
  static List<ProcessStepItem> getTempeSteps() {
    return const [
      ProcessStepItem(
        title: 'Biji Kedelai',
        imageAsset: AppAssets.tempeKedelai,
        iconType: StepIconType.kedelai,
        description:
            'Pemilihan biji kedelai kuning (Glycine max) berkualitas tinggi yang utuh dan bersih.',
        biologicalExplanation:
            'Biji kedelai kaya akan protein globulin (glisinin & konglisinin) dan lipid yang menjadi substrat utama kapang.',
      ),
      ProcessStepItem(
        title: 'Perendaman Kedelai',
        imageAsset: AppAssets.tempePerendaman,
        iconType: StepIconType.perendaman,
        description:
            'Kedelai direndam dalam air bersih selama 12–24 jam pada suhu ruang.',
        biologicalExplanation:
            'Terjadi hidrasi biji dan fermentasi asam laktat alami yang menurunkan pH kedelai ke 4.5–5.0, menghambat bakteri patogen pembusuk.',
      ),
      ProcessStepItem(
        title: 'Perebusan & Kupas Kulit',
        imageAsset: AppAssets.tempePerebusan,
        iconType: StepIconType.perebusan,
        description:
            'Kedelai direbus dalam air mendidih hingga melunak, lalu kulit ari dikupas.',
        biologicalExplanation:
            'Suhu tinggi mendenaturasi zat antigizi antitripsin dan menginaktivasi enzim lipoksigenase penyebab bau langu.',
      ),
      ProcessStepItem(
        title: 'Pemberian Ragi',
        subtitle: '(Rhizopus oligosporus)',
        imageAsset: AppAssets.tempeRagi,
        iconType: StepIconType.ragi,
        description:
            'Kedelai ditiriskan hingga kering dan dingin (suhu ruang), lalu diinokulasi spora kapang tempe.',
        biologicalExplanation:
            'Inokulasi harus pada suhu kamar (<32°C) agar spora tidak rusak akibat panas.',
      ),
      ProcessStepItem(
        title: 'Pembungkusan',
        subtitle: '(daun pisang/ plastik)',
        imageAsset: AppAssets.tempePembungkusan,
        iconType: StepIconType.pembungkusan,
        description:
            'Kedelai beragi dibungkus daun pisang atau plastik dengan lubang jarum ventilasi mikro.',
        biologicalExplanation:
            'Kapang Rhizopus bersifat aerob obligat; pori daun/lubang plastik menyediakan suplai oksigen mikro yang terkendali.',
      ),
      ProcessStepItem(
        title: 'Fermentasi 36-48 jam',
        imageAsset: AppAssets.tempeProsesFerm,
        iconType: StepIconType.fermentasi,
        description:
            'Paket tempe diperam di tempat hangat dan gelap pada suhu 28–32°C selama 36–48 jam.',
        biologicalExplanation:
            'Miselium kapang tumbuh lebat merajut kedelai menjadi satu kesatuan padat sambil menyekresikan enzim protease dan lipase.',
      ),
      ProcessStepItem(
        title: 'Tempe Matang',
        imageAsset: AppAssets.tempeJadi,
        iconType: StepIconType.tempe,
        description:
            'Tempe matang dengan miselium putih padat beraroma khas siap dikonsumsi atau diolah.',
        biologicalExplanation:
            'Protein kedelai telah terhidrolisis menjadi asam amino bebas sehingga daya cerna meningkat hingga >85% dan kaya vitamin B12.',
      ),
    ];
  }

  static List<ProcessStepItem> getTapeSteps() {
    return const [
      ProcessStepItem(
        title: 'Pengupasan & Pengerikan',
        imageAsset: AppAssets.tapeFase1,
        iconType: StepIconType.kedelai,
        description:
            'Singkong kuning mentega dikupas kulit luarnya dan dikerik lendir kulit arinya hingga bersih.',
        biologicalExplanation:
            'Pengerikan lendir menghilangkan getah dan mikroba liar tanah yang dapat memicu fermentasi asam tidak terkendali.',
      ),
      ProcessStepItem(
        title: 'Pencucian & Pembilasan',
        imageAsset: AppAssets.tapeFase2,
        iconType: StepIconType.perendaman,
        description:
            'Singkong dicuci bersih berkali-kali dengan air mengalir hingga lendir getah hilang total.',
        biologicalExplanation:
            'Meminimalkan populasi bakteri kontaminan alami pada permukaan umbi singkong.',
      ),
      ProcessStepItem(
        title: 'Pengukusan (Gelatinisasi)',
        imageAsset: AppAssets.tapeFase3,
        iconType: StepIconType.perebusan,
        description:
            'Singkong dikukus selama 25–30 menit hingga matang empuk (3/4 matang untuk peuyeum gantung).',
        biologicalExplanation:
            'Gelatinisasi pati amilosa & amilopektin melonggarkan ikatan polisakarida agar mudah dihidrolisis enzim amilase ragi.',
      ),
      ProcessStepItem(
        title: 'Pendinginan & Inokulasi Ragi',
        subtitle: '(Amylomyces & Saccharomyces)',
        imageAsset: AppAssets.tapeFase4,
        iconType: StepIconType.ragi,
        description:
            'Singkong dihamparkan di tampah beralas daun pisang hingga dingin sempurna, lalu ditaburi serbuk ragi tape (1% b/b).',
        biologicalExplanation:
            'Suhu di atas 40°C dapat mematikan khamir Saccharomyces cerevisiae; penaburan wajib pada suhu kamar.',
      ),
      ProcessStepItem(
        title: 'Pemeraman Anaerob (2–3 Hari)',
        imageAsset: AppAssets.tapeFase5,
        iconType: StepIconType.fermentasi,
        description:
            'Singkong beragi ditutup rapat dengan daun pisang dan disimpan selama 2–3 hari.',
        biologicalExplanation:
            'Kondisi mikroaerofilik mengoptimalkan sintesis glukosa (puncak 51,61% hari ke-2) dan aroma etanol aromatik.',
      ),
      ProcessStepItem(
        title: 'Hasil Tape Singkong Manis',
        imageAsset: AppAssets.tapeSingkongFermentasi,
        iconType: StepIconType.tempe,
        description:
            'Tape singkong matang berair manis legit dengan aroma khas harum alkoholik menyegarkan.',
        biologicalExplanation:
            'Kandungan glukosa tinggi hasil hidrolisis pati amilum oleh enzim glukoamilase khamir.',
      ),
    ];
  }

  static List<ProcessStepItem> getTaucoSteps() {
    return const [
      ProcessStepItem(
        title: 'Perebusan & Pengupasan Kedelai',
        imageAsset: AppAssets.taucoFase1,
        iconType: StepIconType.perebusan,
        description:
            'Kedelai kuning direbus hingga empuk, ditiriskan, dan dikupas kulit arinya.',
        biologicalExplanation:
            'Denaturasi protein kedelai mempermudah penetrasi hifa kapang Aspergillus oryzae.',
      ),
      ProcessStepItem(
        title: 'Penirisan & Inokulasi Koji',
        subtitle: '(Aspergillus oryzae)',
        imageAsset: AppAssets.taucoFase2,
        iconType: StepIconType.ragi,
        description:
            'Kedelai dicampur tepung beras/terigu lalu diinokulasi spora kapang koji.',
        biologicalExplanation:
            'Tepung menyediakan sumber karbon awal untuk memicu pertumbuhan miselium kapang.',
      ),
      ProcessStepItem(
        title: 'Fermentasi Padat Koji (3–5 Hari)',
        imageAsset: AppAssets.taucoFase3,
        iconType: StepIconType.fermentasi,
        description:
            'Kedelai berkapang diinkubasi di tampah bambu hingga terbentuk miselium hijau keemasan.',
        biologicalExplanation:
            'Aspergillus oryzae memproduksi enzim hidrolase ekstraseluler (protease, peptidase, amilase).',
      ),
      ProcessStepItem(
        title: 'Fermentasi Moromi & Penjemuran',
        subtitle: '(Larutan Garam 15–20%)',
        imageAsset: AppAssets.taucoFase4a,
        iconType: StepIconType.perendaman,
        description:
            'Kedelai koji dimasukkan ke tempayan tanah liat berisi air garam 15–20% dan dijemur matahari selama 2–8 minggu.',
        biologicalExplanation:
            'Kadar garam tinggi membunuh bakteri patogen dan menyeleksi mikroba halofilik Tetragenococcus halophilus.',
      ),
      ProcessStepItem(
        title: 'Pemasakan dengan Gula Aren',
        imageAsset: AppAssets.taucoFase5a,
        iconType: StepIconType.tempe,
        description:
            'Pasta moromi dimasak bersama gula aren, daun salam, lengkuas, dan serai hingga harum kental berkilau.',
        biologicalExplanation:
            'Reaksi Maillard antara asam amino bebas (asam glutamat) dan gula kelapa menghasilkan rasa umami gurih alami.',
      ),
    ];
  }

  static List<ProcessStepItem> getTapeKetanSteps() {
    return const [
      ProcessStepItem(
        title: 'Perendaman & Pewarnaan Alami Beras Ketan',
        imageAsset: AppAssets.tapeKetanFase1,
        iconType: StepIconType.perendaman,
        description:
            'Beras ketan direndam selama 4–6 jam bersama perasan daun katuk/pandan alami untuk menghasilkan warna hijau segar dan aroma harum.',
        biologicalExplanation:
            'Klorofil daun katuk bertindak sebagai pewarna alami dan antioksidan.',
      ),
      ProcessStepItem(
        title: 'Pengukusan Beras Ketan',
        subtitle: '(Gelatinisasi Amilopektin)',
        imageAsset: AppAssets.tapeKetanFase2,
        iconType: StepIconType.perebusan,
        description:
            'Ketan dikukus, disiram air panas mendidih (diaron), lalu dikukus kembali hingga pulen dan matang merata.',
        biologicalExplanation:
            'Gelatinisasi amilopektin rantai bercabang pada beras ketan mempermudah kerja enzim hidrolisis ragi.',
      ),
      ProcessStepItem(
        title: 'Penirisan, Pendinginan & Penaburan Ragi',
        subtitle: '(Amylomyces & Saccharomyces)',
        imageAsset: AppAssets.tapeKetanFase3,
        iconType: StepIconType.ragi,
        description:
            'Ketan didinginkan di tampah bambu, lalu ditaburi ragi tape halus yang dicampur sedikit gula halus.',
        biologicalExplanation:
            'Gula awal memberikan energi permulaan (starter kick) bagi pertumbuhan khamir.',
      ),
      ProcessStepItem(
        title: 'Pemeraman dalam Daun Jambu Air / Wadah',
        subtitle: '(Fermentasi 2–3 Hari)',
        imageAsset: AppAssets.tapeKetanFase4,
        iconType: StepIconType.fermentasi,
        description:
            'Ketan dibungkus kecil-kecil dengan daun jambu air atau disimpan di ember tertutup selama 2–3 hari.',
        biologicalExplanation:
            'Daun jambu air memberikan tanin aromatik dan menjaga kelembapan mikroklimat.',
      ),
    ];
  }

  static List<ProcessStepItem> getGenericSteps(FermentedFoodEntity food) {
    return food.processSteps.map((s) {
      return ProcessStepItem(
        title: s.title,
        iconType: s.stepNumber == 1
            ? StepIconType.kedelai
            : (s.stepNumber == 2
                ? StepIconType.perebusan
                : (s.stepNumber == 3 ? StepIconType.ragi : StepIconType.tempe)),
        description: s.description,
        biologicalExplanation: s.biologicalContext,
      );
    }).toList();
  }

  static List<ProcessStepItem> getStepsForFood(FermentedFoodEntity food) {
    if (food.id == 'tempe') return getTempeSteps();
    if (food.id == 'tape') return getTapeSteps();
    if (food.id == 'tape-ketan') return getTapeKetanSteps();
    if (food.id == 'tauco') return getTaucoSteps();
    return getGenericSteps(food);
  }
}
