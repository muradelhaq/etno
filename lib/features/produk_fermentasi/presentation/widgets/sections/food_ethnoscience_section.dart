import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/fermented_food_entity.dart';

class FoodEthnoscienceSection extends StatelessWidget {
  final FermentedFoodEntity food;

  const FoodEthnoscienceSection({super.key, required this.food});

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
                'KONSEP ETNOSAINS',
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

          // 2 Columns: Pengetahuan Lokal vs Konsep Sains
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1: Pengetahuan Lokal
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD6E8D0),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSubHeaderPill('Pengetahuan Lokal'),
                      const SizedBox(height: 8),
                      _buildBulletPoint(food.localWisdom.isNotEmpty
                          ? (food.id == 'tempe'
                              ? 'Tempe dibungkus daun agar tidak lembek dan sirkulasi udara baik.'
                              : food.localWisdom)
                          : 'Praktik tradisional warisan leluhur.'),
                      if (food.id == 'tempe') ...[
                        const SizedBox(height: 6),
                        _buildBulletPoint('Fermentasi 2 hari pada suhu ruang.'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Column 2: Konsep Sains
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD6E8D0),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSubHeaderPill('Konsep Sains'),
                      const SizedBox(height: 8),
                      _buildBulletPoint(food.ethnoscienceConcept.isNotEmpty
                          ? (food.id == 'tempe'
                              ? 'Kapang Rhizopus oligosporus tumbuh, membentuk miselium menyatukan biji kedelai.'
                              : food.ethnoscienceConcept)
                          : 'Rekonstruksi sains modern.'),
                      const SizedBox(height: 8),

                      // Microbe Circular Diagram from Infographic
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF3F8F2),
                                border: Border.all(
                                  color: const Color(0xFF2D5A3C),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: AppImage(
                                  'assets/images/tempe_rhizopus_diagram.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.biotech,
                                        color: AppColors.primaryGreen),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food.microorganisms.isNotEmpty
                                  ? food.microorganisms.first
                                      .split('(')
                                      .first
                                      .trim()
                                  : 'Rhizopus oligosporus',
                              style: const TextStyle(
                                color: Color(0xFF1E3A2B),
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeaderPill(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F0E0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2D5A3C),
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            color: Color(0xFF2D5A3C),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
