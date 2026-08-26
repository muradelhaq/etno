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

          Row(
            children: [
              Expanded(child: _buildDishCard(0)),
              const SizedBox(width: 10),
              Expanded(child: _buildDishCard(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDishCard(int index) {
    final tapeKetan = food.id == 'tape-ketan';
    final first = index == 0;
    final title = tapeKetan
        ? (first ? 'ES TAPE KETAN' : 'MARTABAK TAPE KETAN')
        : food.id == 'tempe'
            ? (first ? 'OREK TEMPE' : 'MENDOAN')
            : food.id == 'tape'
                ? (first ? 'COLENAK' : 'ES DOGER')
                : food.id == 'tauco'
                    ? (first ? 'SAYUR IKAN TAUCO' : 'TUMIS KANGKUNG')
                    : (first ? 'OLAHAN 1' : 'OLAHAN 2');
    final image = tapeKetan
        ? (first
            ? 'assets/images/es_tape.jpg'
            : 'assets/images/martabak_ketan.jpg')
        : food.id == 'tempe'
            ? (first
                ? 'assets/images/food_orek_tempe_slide.png'
                : 'assets/images/tempe-mendoan.jpg')
            : food.id == 'tape'
                ? (first
                    ? 'assets/images/food_tape_singkong.jpg'
                    : 'assets/images/es-goyobod.jpg')
                : food.id == 'tauco'
                    ? (first
                        ? 'assets/images/aset_sed/sayur-ikan-tauco.jpeg'
                        : 'assets/images/food_tauco.jpg')
                    : (first
                        ? 'assets/images/food_kecap.jpg'
                        : 'assets/images/food_oncom.jpg');
    final description = tapeKetan
        ? (first
            ? 'Tape ketan hijau atau hitam disajikan dingin dengan sirup dan kelapa muda.'
            : 'Martabak manis dengan isian tape ketan legit sebagai kudapan tradisional-modern.')
        : food.id == 'tempe'
            ? (first
                ? 'Potongan tempe yang ditumis gurih manis dengan kecap dan bumbu rempah aromatik Nusantara.'
                : 'Tempe tipis khas Banyumas dibalut adonan tepung beras berbumbu dan digoreng mendo.')
            : food.id == 'tape'
                ? (first
                    ? 'Peuyeum bakar yang dicocol dengan saus gula kelapa aren harum kelapa parut.'
                    : 'Minuman es serut segar khas Sunda dengan isian peuyeum tape singkong manis.')
                : food.id == 'tauco'
                    ? (first
                        ? 'Hidangan ikan berkuah santan gurih berpadu bumbu tauco Cianjur.'
                        : 'Tumis kangkung renyah dengan aksen tauco gurih aromatik.')
                    : 'Olahan kuliner warisan etnosains tradisional.';
    final science = tapeKetan
        ? (first
            ? 'Amilopektin ketan yang disakarifikasi menghasilkan cairan manis dan aroma fermentasi khas.'
            : 'Gula dan cairan fermentasi ketan memberi rasa manis-asam seimbang pada isian martabak.')
        : 'Perpaduan hasil fermentasi dan rempah lokal memperkaya rasa serta aroma hidangan.';
    return FoodProductCard(
      title: title,
      imageAsset: image,
      description: description,
      culinaryScience: science,
    );
  }
}
