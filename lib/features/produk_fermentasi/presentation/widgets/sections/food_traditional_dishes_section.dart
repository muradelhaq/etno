import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_assets.dart';
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🍽️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                'Olahan Tradisional Etnosains',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A2B),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '2 Produk Unggulan',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E6F40),
                  ),
                ),
              ),
            ],
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
                ? (first ? 'COLENAK' : 'ES GOYOBOD / PEUYEUM')
                : food.id == 'tauco'
                    ? (first ? 'SAYUR IKAN TAUCO' : 'TUMIS KANGKUNG')
                    : (first ? 'OLAHAN 1' : 'OLAHAN 2');
    final image = tapeKetan
        ? (first
            ? AppAssets.tapeKetan
            : 'assets/images/martabak_ketan.jpg')
        : food.id == 'tempe'
            ? (first
                ? AppAssets.orekTempe
                : 'assets/images/tempe-mendoan.jpg')
            : food.id == 'tape'
                ? (first
                    ? AppAssets.colenak
                    : AppAssets.tapeSingkong)
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
