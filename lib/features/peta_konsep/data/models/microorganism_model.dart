class MicroorganismModel {
  final String id;
  final String scientificName;
  final String kingdomType; // 'Fungi (Kapang)', 'Fungi (Khamir)', 'Bacteria'
  final String targetProduct;
  final String primaryFunction;
  final String biochemicalRole;
  final String microscopicFeature;
  final String imageUrl;

  const MicroorganismModel({
    required this.id,
    required this.scientificName,
    required this.kingdomType,
    required this.targetProduct,
    required this.primaryFunction,
    required this.biochemicalRole,
    required this.microscopicFeature,
    required this.imageUrl,
  });
}

class MicroorganismData {
  static const List<MicroorganismModel> microbes = [
    MicroorganismModel(
      id: 'rhizopus',
      scientificName: 'Rhizopus oligosporus / oryzae',
      kingdomType: 'Fungi (Kapang / Zygomycota)',
      targetProduct: 'Tempe Kedelai',
      primaryFunction:
          'Menghasilkan enzim protease, lipase, dan amilase untuk menguraikan protein kompleks kedelai menjadi asam amino serta membentuk miselium putih padat.',
      biochemicalRole:
          'Meningkatkan daya cerna protein hingga 85%, menurunkan asam fitat, serta mensintesis vitamin B12 dan antioksidan isoflavon aglikon.',
      microscopicFeature:
          'Hifa tidak bersekat (senositik), sporangiofor tegak berkoloni, sporangium bulat berisi sporangiospora kehitaman.',
      imageUrl: 'assets/images/panel_tempe_tauco_tape_hd.jpeg',
    ),
    MicroorganismModel(
      id: 'saccharomyces',
      scientificName: 'Saccharomyces cerevisiae',
      kingdomType: 'Fungi (Khamir / Ascomycota)',
      targetProduct: 'Tape Singkong & Tape Ketan',
      primaryFunction:
          'Mengubah glukosa hasil hidrolisis amilum menjadi etanol, gas CO₂, dan senyawa ester aromatik melalui jalur glikolisis anaerob.',
      biochemicalRole:
          'C6H12O6 (Glukosa) -> 2 C2H5OH (Etanol) + 2 CO2 + Energi (2 ATP). Menghasilkan sensasi manis-segar beraroma khas pada tape.',
      microscopicFeature:
          'Sel uniseluler berbentuk oval/bulat telur, bereproduksi vegetatif dengan pertunasan (budding).',
      imageUrl: 'assets/images/panel_tempe_tauco_tape.jpeg',
    ),
    MicroorganismModel(
      id: 'aspergillus_sp',
      scientificName: 'Aspergillus sp. / amylomyces',
      kingdomType: 'Fungi (Kapang / Ascomycota)',
      targetProduct: 'Ragi Tape (Tahap Sakarifikasi)',
      primaryFunction:
          'Menghasilkan enzim alfa-amilase dan glukoamilase untuk menghidrolisis pati amilum singkong/ketan menjadi molekul glukosa sederhana.',
      biochemicalRole:
          'Pati (Amilum) + H2O -> Glukosa + Maltosa. Menyediakan substrat glukosa manis yang memicu pertumbuhan ragi khamir.',
      microscopicFeature:
          'Konidiofor tegak berujung vesikel bulat dengan rantai konidiospora radial.',
      imageUrl: 'assets/images/panel_tempe_tauco_tape_full.png',
    ),
    MicroorganismModel(
      id: 'aspergillus_oryzae',
      scientificName: 'Aspergillus oryzae',
      kingdomType: 'Fungi (Kapang Koji / Ascomycota)',
      targetProduct: 'Tauco & Kecap Manis Tradisional',
      primaryFunction:
          'Tahap Koji: Mengeluarkan enzim endoprotease kuat dan glutaminase yang memecah globulin kedelai menjadi asam glutamat.',
      biochemicalRole:
          'Menghasilkan asam glutamat bebas (sumber rasa gurih alami / umami) dan prekursor aroma pada fermentasi lanjutan.',
      microscopicFeature:
          'Miselium berwarna hijau zaitun kekuningan dengan konidia bersel satu berdinding halus/kasar.',
      imageUrl: 'assets/images/panel_oncom_kecap.jpeg',
    ),
    MicroorganismModel(
      id: 'tetragenococcus',
      scientificName: 'Tetragenococcus halophilus',
      kingdomType: 'Bacteria (Bakteri Halofilik Coccus)',
      targetProduct: 'Tauco & Moromi Kecap',
      primaryFunction:
          'Bertahan hidup pada konsentrasi garam tinggi (15-20%) dan memfermentasi gula menjadi asam laktat serta senyawa ester.',
      biochemicalRole:
          'Menurunkan pH, mencegah kontaminasi bakteri pembusuk patogen, dan mematangkan aroma gurih sedap selama penjemuran sinar matahari.',
      microscopicFeature:
          'Bakteri Gram-positif berpasangan atau berkelompok empat (tetrad), tidak berspora.',
      imageUrl: 'assets/images/panel_tempe_tauco_tape.jpeg',
    ),
    MicroorganismModel(
      id: 'neurospora',
      scientificName: 'Neurospora sitophila / intermedia',
      kingdomType: 'Fungi (Kapang Oncom / Ascomycota)',
      targetProduct: 'Oncom Merah Tradisional',
      primaryFunction:
          'Menguraikan protein dan serat selulosa pada ampas tahu / bungkil kacang serta memproduksi pigmen karotenoid jingga cerah.',
      biochemicalRole:
          'Meningkatkan nilai cerna ampas tahu, mendegradasi aflatoksin, dan memperkaya kandungan gizi vitamin B kompleks.',
      microscopicFeature:
          'Miselium cepat tumbuh berwarna jingga/oranye dengan rantai makrokonidia bersel satu oval.',
      imageUrl: 'assets/images/panel_oncom_kecap_hd.jpeg',
    ),
  ];
}
