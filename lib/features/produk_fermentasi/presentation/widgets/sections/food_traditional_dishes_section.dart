import 'package:flutter/material.dart';
import '../../../domain/entities/fermented_food_entity.dart';
import '../cards/food_product_card.dart';

class FoodTraditionalDishesSection extends StatelessWidget {
  final FermentedFoodEntity food;

  const FoodTraditionalDishesSection({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD6E8D0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'MAKANAN TRADISIONAL',
                style: TextStyle(
                  color: Color(0xFF1E3A2B),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 2 Traditional Food Cards
          Row(
            children: [
              // Card 1
              Expanded(
                child: FoodProductCard(
                  title: food.id == 'tempe'
                      ? 'OREK TEMPE'
                      : (food.id == 'tape'
                          ? 'COLENAK'
                          : (food.id == 'tauco' ? 'SAYUR IKAN TAUCO' : 'OLAHAN 1')),
                  imageAsset: food.id == 'tempe'
                      ? 'assets/images/food_orek_tempe_slide.png'
                      : (food.id == 'tape'
                          ? 'assets/images/food_tape_singkong.jpg'
                          : (food.id == 'tauco'
                              ? 'assets/images/aset_sed/sayur-ikan-tauco.jpeg'
                              : 'assets/images/food_kecap.jpg')),
                  description: food.id == 'tempe'
                      ? 'Potongan tempe yang ditumis gurih manis dengan kecap dan bumbu rempah aromatik Nusantara.'
                      : (food.id == 'tape'
                          ? 'Peuyeum bakar yang dicocol dengan saus gula kelapa aren harum kelapa parut.'
                          : (food.id == 'tauco'
                              ? 'Hidangan ikan berkuah santan gurih berpadu bumbu tauco Cianjur yang khas.'
                              : 'Olahan kuliner warisan etnosains tradisional.')),
                  culinaryScience: food.id == 'tempe'
                      ? 'Proses karamelisasi gula kecap dan asam amino hasil fermentasi tempe menciptakan rasa gurih umami yang kaya.'
                      : (food.id == 'tape'
                          ? 'Pemanasan membangkitkan senyawa karamelisasi gula sederhana hasil sakarifikasi ragi.'
                          : (food.id == 'tauco'
                              ? 'Asam glutamat bebas pada tauco bertindak sebagai penguat cita rasa umami alami.'
                              : 'Perpaduan asam amino dan rempah lokal.')),
                ),
              ),
              const SizedBox(width: 10),

              // Card 2
              Expanded(
                child: FoodProductCard(
                  title: food.id == 'tempe'
                      ? 'MENDOAN'
                      : (food.id == 'tape'
                          ? 'ES DOGER'
                          : (food.id == 'tauco' ? 'TUMIS KANGKUNG' : 'OLAHAN 2')),
                  imageAsset: food.id == 'tempe'
                      ? 'assets/images/food_mendoan_slide.png'
                      : (food.id == 'tape'
                          ? 'assets/images/food_tape_singkong.jpg'
                          : (food.id == 'tauco'
                              ? 'assets/images/food_tauco.jpg'
                              : 'assets/images/food_oncom.jpg')),
                  description: food.id == 'tempe'
                      ? 'Tempe tipis khas Banyumas dibalut adonan tepung beras berbumbu dan digoreng mendo (setengah matang).'
                      : (food.id == 'tape'
                          ? 'Minuman es serut segar khas Sunda dengan isian peuyeum tape singkong manis.'
                          : (food.id == 'tauco'
                              ? 'Tumis kangkung renyah dengan aksen tauco gurih aromatik.'
                              : 'Sajian pendamping kaya cita rasa fermentasi.')),
                  culinaryScience: food.id == 'tempe'
                      ? 'Penggorengan singkat menjaga miselium tempe tetap lembut legit serta mempertahankan aroma khas kapang Rhizopus.'
                      : (food.id == 'tape'
                          ? 'Keseimbangan rasa manis asam alami tape berpadu santan gurih menyegarkan.'
                          : (food.id == 'tauco'
                              ? 'Kandungan garam dan asam glutamat menjaga tekstur dan warna sayuran.'
                              : 'Pengawetan dan peningkatan aroma masakan.')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
