class RegionalCultureItem {
  final String id;
  final String regionName;
  final String province;
  final double latitude;
  final double longitude;
  final String foodTitle;
  final String localTermOrigin; // Etimologi bahasa lokal
  final String funFact;
  final String ethnoscienceStory;
  final String imageAsset;
  final String audioNarrationText;

  const RegionalCultureItem({
    required this.id,
    required this.regionName,
    required this.province,
    required this.latitude,
    required this.longitude,
    required this.foodTitle,
    required this.localTermOrigin,
    required this.funFact,
    required this.ethnoscienceStory,
    required this.imageAsset,
    required this.audioNarrationText,
  });
}

class JelajahBudayaData {
  static const List<RegionalCultureItem> regions = [
    RegionalCultureItem(
      id: 'banyumas',
      regionName: 'Banyumas',
      province: 'Jawa Tengah',
      latitude: -7.5167,
      longitude: 109.2833,
      foodTitle: 'Tempe Mendoan',
      localTermOrigin:
          'Berasal dari bahasa Banyumasan "Mendo" yang berarti setengah matang atau lembek.',
      funFact:
          'Karena hanya digoreng sebentar dalam minyak panas, tempe mendoan tetap lembut di bagian dalam sehingga cita rasa kedelai dan miselium tempenya masih sangat terasa segar.',
      ethnoscienceStory:
          'Penggunaan daun pisang lebar untuk membungkus lembaran tipis tempe memungkinkan sirkulasi oksigen mikro yang sangat pas bagi pertumbuhan hifa Rhizopus oligosporus tanpa menimbulkan panas berlebih.',
      imageAsset: 'assets/images/tempe-mendoan.jpg',
      audioNarrationText:
          'Tempe Mendoan khas Banyumas digoreng setengah matang sehingga bagian dalamnya tetap lembut dan gurih.',
    ),
    RegionalCultureItem(
      id: 'tasikmalaya',
      regionName: 'Tasikmalaya',
      province: 'Jawa Barat (Priangan Timur)',
      latitude: -7.3274,
      longitude: 108.2207,
      foodTitle: 'Nasi Tutug Oncom & Combro',
      localTermOrigin:
          'Tutug = ditumbuk / diaduk rata; Combro = Oncom di Jero (oncom di bagian dalam); Colenak = Dicocol Enak.',
      funFact:
          'Dahulu Nasi TO merupakan bekal andalan para petani di Tatar Pasundan karena praktis, cepat disiapkan di saung sawah, mengenyangkan, dan kaya akan protein nabati hasil fermentasi kapang Neurospora.',
      ethnoscienceStory:
          'Masyarakat Sunda mendaur ulang ampas tahu menjadi oncom merah beraroma sedap dengan memanfaatkan kapang Neurospora sitophila yang kaya enzim pemecah protein & serat.',
      imageAsset: 'assets/images/tutug_oncom.jpg',
      audioNarrationText:
          'Nasi Tutug Oncom dan Combro membuktikan kearifan masyarakat Sunda dalam memanfaatkan ampas tahu menjadi santapan bergizi tinggi.',
    ),
    RegionalCultureItem(
      id: 'cianjur',
      regionName: 'Cianjur',
      province: 'Jawa Barat',
      latitude: -6.8173,
      longitude: 107.1394,
      foodTitle: 'Sayur Ikan Tauco Cianjur',
      localTermOrigin:
          'Tauco diperkenalkan melalui akulturasi kuliner Tionghoa-Sunda sejak abad ke-19.',
      funFact:
          'Aroma gurih nan khas dari tauco Cianjur berasal dari dua kali fermentasi: fermentasi kapang (koji) dan fermentasi garam (moromi) yang dijemur di bawah terik matahari selama berminggu-minggu.',
      ethnoscienceStory:
          'Pengrajin tauco menggunakan tempayan tanah liat tradisional yang berpori mikro, ditaruh di halaman terbuka agar terkena panas matahari untuk menyeleksi bakteri halofilik Tetragenococcus halophilus.',
      imageAsset: 'assets/images/sayur_tauco.jpg',
      audioNarrationText:
          'Tauco Cianjur menggunakan tempayan tanah liat yang dijemur matahari untuk fermentasi garam sempurna.',
    ),
    RegionalCultureItem(
      id: 'purwakarta',
      regionName: 'Purwakarta',
      province: 'Jawa Barat',
      latitude: -6.5569,
      longitude: 107.4433,
      foodTitle: 'Sate Maranggi Bumbu Kecap',
      localTermOrigin:
          'Dinamai dari Mak Ranggi, seorang peracik legendaris sate bumbu rempah di Purwakarta.',
      funFact:
          'Berbeda dengan sate biasa yang disiram kuah kacang setelah matang, daging Sate Maranggi direndam (dimarinasi) terlebih dahulu dengan racikan kecap manis, ketumbar, gula kelapa, dan jahe sebelum dibakar.',
      ethnoscienceStory:
          'Enzim protease pada kedelai fermentasi dalam kecap serta asam amino glutamat meresap ke serat daging sapi/kambing, menghasilkan rasa umami alami dan tekstur daging yang empuk.',
      imageAsset: 'assets/images/food_kecap.jpg',
      audioNarrationText:
          'Sate Maranggi Purwakarta dimarinasi dengan kecap fermentasi kedelai hitam sebelum dipanggang di atas arang.',
    ),
    RegionalCultureItem(
      id: 'bandung',
      regionName: 'Bandung & Priangan',
      province: 'Jawa Barat',
      latitude: -6.9175,
      longitude: 107.6191,
      foodTitle: 'Es Doger, Colenak & Kolek Peuyeum',
      localTermOrigin:
          'Doger = Dorong Gerobak; Colenak = Dicocol Enak; Peuyeum = Tape Singkong manis aromatik.',
      funFact:
          'Peuyeum Bandung terkenal bertekstur lebih kokoh di luar namun legit manis di dalam, sangat nikmat dibakar di atas arang lalu disiram saus kinca kelapa (Colenak).',
      ethnoscienceStory:
          'Penggunaan ragi tape dengan khamir Saccharomyces cerevisiae mengubah pati singkong menjadi glukosa manis dalam waktu 48 jam sebelum berubah menjadi aroma alkohol segar.',
      imageAsset: 'assets/images/es-goyobod.jpg',
      audioNarrationText:
          'Peuyeum Bandung dan Es Doger memadukan kesegaran manis alami hasil hidrolisis pati singkong oleh ragi tradisional.',
    ),
    RegionalCultureItem(
      id: 'minangkabau',
      regionName: 'Minangkabau',
      province: 'Sumatera Barat',
      latitude: -0.9471,
      longitude: 100.4172,
      foodTitle: 'Dadiah Susu Kerbau',
      localTermOrigin:
          'Dadiah adalah yogurt tradisional khas Minang dari fermentasi susu kerbau segar dalam ruas batang bambu.',
      funFact:
          'Batang bambu yang baru dipotong memiliki lapisan lilin dan mikroflora alami yang menyeleksi bakteri asam laktat tanpa perlu penambahan bibit starter buatan.',
      ethnoscienceStory:
          'Bakteri asam laktat alami (Lactobacillus & Lactococcus) memfermentasi laktosa menjadi asam laktat, menggumpalkan protein kasein menjadi dadih padat lembut berkhasiat probiotik.',
      imageAsset: 'assets/images/food_yogurt.jpg',
      audioNarrationText:
          'Dadiah Minangkabau memanfaatkan mikroflora tabung bambu untuk mengentalkan susu kerbau menjadi probiotik alami.',
    ),
    RegionalCultureItem(
      id: 'palembang',
      regionName: 'Palembang & Musi',
      province: 'Sumatera Selatan',
      latitude: -2.9761,
      longitude: 104.7754,
      foodTitle: 'Gulai Tempoyak Ikan Patin',
      localTermOrigin:
          'Tempoyak berasal dari teknik peram daging buah durian matang dengan sedikit garam dalam wadah tertutup.',
      funFact:
          'Kearifan lokal masyarakat Melayu dan Sumatera dalam mengawetkan surplus buah durian saat musim panen raya agar tidak terbuang sia-sia.',
      ethnoscienceStory:
          'Fermentasi asam laktat anaerob fakultatif oleh Fructobacillus & Lactobacillus menekan pH hingga <4.0, menciptakan rasa asam gurih yang berpadu sempurna dengan lemak ikan patin.',
      imageAsset: 'assets/images/food_tauco.jpg',
      audioNarrationText:
          'Tempoyak adalah wujud kearifan mengawetkan durian menjadi bumbu asam gurih kaya antioksidan dan probiotik.',
    ),
    RegionalCultureItem(
      id: 'bali',
      regionName: 'Bali & Gianyar',
      province: 'Bali',
      latitude: -8.4095,
      longitude: 115.1889,
      foodTitle: 'Brem Cair & Padat Bali',
      localTermOrigin:
          'Brem merupakan hasil perasan cairan fermentasi ketan hitam dan putih yang dimasak dan dikristalisasi.',
      funFact:
          'Dalam tradisi upacara adat Hindu Bali (Tabuh Rah), cairan fermentasi beras ketan telah digunakan selama berabad-abad sebagai simbol keharmonisan alam.',
      ethnoscienceStory:
          'Kombinasi kapang Amylomyces rouxii dan khamir Saccharomyces cerevisiae mengubah zat pati amilopektin ketan menjadi gula cair manis dengan aroma ester aromatik khas.',
      imageAsset: 'assets/images/food_tape_ketan.jpg',
      audioNarrationText:
          'Brem Bali memadukan hidrolisis pati ketan dan fermentasi khamir menghasilkan cita rasa manis asam khas tradisi dewata.',
    ),
  ];
}
