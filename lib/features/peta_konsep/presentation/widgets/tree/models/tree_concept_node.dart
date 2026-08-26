class TreeBranch {
  final String id;
  final String title;
  final String imageAsset;
  final String microbe;
  final String description;
  final String? route;
  final List<TreeChild> children;

  const TreeBranch({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.microbe,
    required this.description,
    this.route,
    required this.children,
  });
}

class TreeChild {
  final String id;
  final String title;
  final String imageAsset;
  final String parentProduct;
  final String description;
  final String? route;

  const TreeChild({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.parentProduct,
    required this.description,
    this.route,
  });
}

List<TreeBranch> getConceptTreeData() {
  return const [
    TreeBranch(
      id: 'tempe',
      title: 'Tempe',
      imageAsset: 'assets/images/food_tempe.jpg',
      microbe: 'Rhizopus oligosporus & R. oryzae',
      description:
          'Fermentasi biji kedelai oleh miselium kapang Rhizopus yang menghasilkan struktur padat, enzim protease, dan vitamin B12.',
      route: '/produk/tempe',
      children: [
        TreeChild(
          id: 'orek_tempe',
          title: 'Orek Tempe',
          imageAsset: 'assets/images/food_orek_tempe_slide.png',
          parentProduct: 'Tempe Kedelai (Rhizopus)',
          description:
              'Potongan tempe yang ditumis gurih manis dengan kecap dan bumbu rempah aromatik.',
          route: '/produk/tempe',
        ),
        TreeChild(
          id: 'mendoan',
          title: 'Mendoan',
          imageAsset: 'assets/images/tempe-mendoan.jpg',
          parentProduct: 'Tempe Kedelai (Rhizopus)',
          description:
              'Tempe tipis khas Banyumas dibalut adonan tepung berbumbu dan digoreng mendo (setengah matang).',
          route: '/produk/tempe',
        ),
      ],
    ),
    TreeBranch(
      id: 'tape_singkong',
      title: 'Tape Singkong',
      imageAsset: 'assets/images/food_tape_singkong.jpg',
      microbe: 'Saccharomyces cerevisiae & Aspergillus',
      description:
          'Fermentasi umbi singkong kukus dengan ragi yang mengubah pati menjadi glukosa manis beraroma alkohol lembut.',
      route: '/produk/tape',
      children: [
        TreeChild(
          id: 'goyobod',
          title: 'Goyobod',
          imageAsset: 'assets/images/es-goyobod.jpg',
          parentProduct: 'Tape Singkong / Peuyeum',
          description:
              'Minuman es tradisional khas Sunda Jawa Barat berisi potongan peuyeum legit, santan, dan serutan es segar.',
          route: '/produk/tape',
        ),
      ],
    ),
    TreeBranch(
      id: 'tape_ketan',
      title: 'Tape Ketan',
      imageAsset: 'assets/images/food_tape_ketan.jpg',
      microbe: 'Amylomyces rouxii & S. cerevisiae',
      description:
          'Fermentasi beras ketan putih atau hitam menghasilkan rasa manis berair yang khas kaya senyawa antioksidan antosianin.',
      route: '/produk/tape-ketan',
      children: [
        TreeChild(
          id: 'es_tape_ketan',
          title: 'Es Tape Ketan',
          imageAsset: 'assets/images/es_tape.jpg',
          parentProduct: 'Tape Ketan (Amylomyces)',
          description:
              'Sajian es pelepas dahaga dari paduan sari manis tape ketan hijau, santan, dan es serut.',
          route: '/produk/tape-ketan',
        ),
        TreeChild(
          id: 'martabak_ketan',
          title: 'Martabak Ketan',
          imageAsset: 'assets/images/martabak_ketan.jpg',
          parentProduct: 'Tape Ketan (Amylomyces)',
          description:
              'Martabak manis legit dengan isian tape ketan hitam/hijau yang lembut harum.',
          route: '/produk/tape-ketan',
        ),
      ],
    ),
    TreeBranch(
      id: 'tauco',
      title: 'Tauco',
      imageAsset: 'assets/images/food_tauco.jpg',
      microbe: 'Aspergillus oryzae & Tetragenococcus',
      description:
          'Bumbu fermentasi kedelai kuning khas Cianjur melalui dua tahap fermentasi: kapang (koji) dan larutan garam pekat.',
      route: '/produk/tauco',
      children: [
        TreeChild(
          id: 'sayur_tauco',
          title: 'Sayur Ikan Tauco',
          imageAsset: 'assets/images/sayur_tauco.jpg',
          parentProduct: 'Tauco Cianjur (A. oryzae)',
          description:
              'Olahan sayur kuah ikan gurih khas dengan aroma dan cita rasa tauco fermentasi kedelai yang khas.',
          route: '/produk/tauco',
        ),
      ],
    ),
  ];
}
