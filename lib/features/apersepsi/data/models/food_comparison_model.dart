class FoodItemModel {
  final String id;
  final String name;
  final String category; // 'Modern' or 'Tradisional'
  final String imageAsset;
  final String baseFermentationProduct;
  final String description;

  const FoodItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageAsset,
    required this.baseFermentationProduct,
    required this.description,
  });
}

class ApersepsiData {
  static const List<FoodItemModel> modernFoods = [
    FoodItemModel(
      id: 'burger',
      name: 'Burger',
      category: 'Modern',
      imageAsset: 'assets/images/food_burger.jpg',
      baseFermentationProduct: 'Ragi Roti (S. cerevisiae)',
      description:
          'Makanan cepat saji global dengan roti bun hasil fermentasi ragi.',
    ),
    FoodItemModel(
      id: 'pizza',
      name: 'Pizza',
      category: 'Modern',
      imageAsset: 'assets/images/food_pizza.jpg',
      baseFermentationProduct: 'Ragi Roti & Keju',
      description:
          'Adonan roti beragi dengan topping keju hasil fermentasi bakteri asam laktat.',
    ),
    FoodItemModel(
      id: 'kimchi',
      name: 'Kimchi',
      category: 'Modern',
      imageAsset: 'assets/images/food_kimchi.jpg',
      baseFermentationProduct: 'Bakteri Asam Laktat (Leuconostoc)',
      description: 'Sayuran fermentasi khas Korea dengan bakteri asam laktat.',
    ),
    FoodItemModel(
      id: 'yogurt',
      name: 'Yogurt',
      category: 'Modern',
      imageAsset: 'assets/images/food_yogurt.jpg',
      baseFermentationProduct: 'Lactobacillus bulgaricus',
      description:
          'Produk olahan susu fermentasi yang menyegarkan dan kaya probiotik.',
    ),
  ];

  static const List<FoodItemModel> traditionalFoods = [
    FoodItemModel(
      id: 'orek_tempe',
      name: 'Orek Tempe',
      category: 'Tradisional',
      imageAsset: 'assets/images/food_tempe.jpg',
      baseFermentationProduct: 'Tempe (Rhizopus)',
      description:
          'Olahan tempe bumbu kecap gurih untuk memperpanjang daya simpan.',
    ),
    FoodItemModel(
      id: 'mendoan',
      name: 'Tempe Mendoan',
      category: 'Tradisional',
      imageAsset: 'assets/images/tempe-mendoan.jpg',
      baseFermentationProduct: 'Tempe (Rhizopus)',
      description:
          'Tempe kedelai khas Banyumas digoreng setengah matang (mendo).',
    ),
    FoodItemModel(
      id: 'goyobod',
      name: 'Es Goyobod / Peuyeum',
      category: 'Tradisional',
      imageAsset: 'assets/images/es-goyobod.jpg',
      baseFermentationProduct: 'Tape Singkong',
      description:
          'Minuman dingin segar khas Jawa Barat dengan isian peuyeum singkong manis.',
    ),
    FoodItemModel(
      id: 'es_tape_ketan',
      name: 'Es Tape Ketan',
      category: 'Tradisional',
      imageAsset: 'assets/images/es_tape.jpg',
      baseFermentationProduct: 'Tape Ketan',
      description: 'Sajian manis asam khas fermentasi beras ketan hijau/hitam.',
    ),
    FoodItemModel(
      id: 'martabak_ketan',
      name: 'Martabak Ketan',
      category: 'Tradisional',
      imageAsset: 'assets/images/martabak_ketan.jpg',
      baseFermentationProduct: 'Tape Ketan',
      description: 'Martabak manis dengan isian tape ketan legit.',
    ),
    FoodItemModel(
      id: 'sayur_tauco',
      name: 'Sayur Ikan Tauco',
      category: 'Tradisional',
      imageAsset: 'assets/images/sayur_tauco.jpg',
      baseFermentationProduct: 'Tauco (Fermentasi Garam)',
      description:
          'Masakan ikan berkuah gurih dengan fermentasi kedelai garam Cianjur.',
    ),
    FoodItemModel(
      id: 'tutug_oncom',
      name: 'Nasi Tutug Oncom',
      category: 'Tradisional',
      imageAsset: 'assets/images/tutug_oncom.jpg',
      baseFermentationProduct: 'Oncom (Neurospora)',
      description:
          'Nasi hangat ditumbuk bersama oncom bakar bumbu kencur gurih.',
    ),
    FoodItemModel(
      id: 'combro',
      name: 'Combro (Oncom di Jero)',
      category: 'Tradisional',
      imageAsset: 'assets/images/combro_oncom.webp',
      baseFermentationProduct: 'Oncom (Neurospora)',
      description:
          'Gorengan parutan singkong berisi tumisan oncom pedas wangi.',
    ),
  ];
}
