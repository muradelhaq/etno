import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../peta_konsep/data/models/microorganism_model.dart';
import '../../../../peta_konsep/presentation/widgets/dialogs/microorganism_detail_dialog.dart';
import '../../../domain/entities/fermented_food_entity.dart';

class FoodEthnoscienceSection extends StatelessWidget {
  final FermentedFoodEntity food;

  const FoodEthnoscienceSection({super.key, required this.food});

  List<MicroorganismModel> _getFoodMicrobes(String foodId) {
    switch (foodId) {
      case 'tempe':
        return MicroorganismData.microbes
            .where((m) => m.id == 'rhizopus')
            .toList();
      case 'tape':
        return MicroorganismData.microbes
            .where((m) => m.id == 'saccharomyces' || m.id == 'aspergillus_sp')
            .toList();
      case 'tape-ketan':
        return MicroorganismData.microbes
            .where((m) => m.id == 'saccharomyces' || m.id == 'aspergillus_sp')
            .toList();
      case 'tauco':
        return MicroorganismData.microbes
            .where((m) =>
                m.id == 'aspergillus_oryzae' || m.id == 'tetragenococcus')
            .toList();
      default:
        return MicroorganismData.microbes
            .where((m) => m.id == 'rhizopus')
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final microbes = _getFoodMicrobes(food.id);

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
                      const SizedBox(height: 10),

                      // Microorganisms section with After Zoom Photos from Concept Map
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F8F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFD6E8D0),
                            width: 0.8,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('🔬', style: TextStyle(fontSize: 12)),
                                SizedBox(width: 4),
                                Text(
                                  'Mikroorganisme Utama',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D5A3C),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: microbes
                                  .map((m) => _buildMicrobeItem(context, m))
                                  .toList(),
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

  Widget _buildMicrobeItem(BuildContext context, MicroorganismModel microbe) {
    return InkWell(
      onTap: () {
        MicroorganismDetailDialog.show(
          context,
          microbe: microbe,
          isCurrentInSimulator: false,
          onSelectInMicroscope: (_, __) {},
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(maxWidth: 130),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2D5A3C),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipOval(
                child: AppImage(
                  microbe.afterZoomImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Color(0xFFE8F2E6),
                    child: Center(
                      child:
                          Icon(Icons.biotech, color: AppColors.primaryGreen),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              microbe.scientificName.split('(').first.trim(),
              style: const TextStyle(
                color: Color(0xFF1E3A2B),
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              microbe.id == 'rhizopus'
                  ? 'Kapang Tempe'
                  : microbe.id == 'saccharomyces'
                      ? 'Khamir Tape'
                      : microbe.id == 'aspergillus_sp'
                          ? 'Sakarifikasi'
                          : microbe.id == 'aspergillus_oryzae'
                              ? 'Kapang Koji'
                              : 'Bakteri Halofilik',
              style: const TextStyle(
                color: Color(0xFF5A7363),
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
