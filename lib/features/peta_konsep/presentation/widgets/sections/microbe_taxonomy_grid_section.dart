import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';
import '../microscope/microscopic_cellular_view.dart';
import '../dialogs/microorganism_detail_dialog.dart';

class MicrobeTaxonomyGridSection extends StatelessWidget {
  final String selectedMicrobeId;
  final void Function(String microbeId, String microbeName) onSelectInMicroscope;

  const MicrobeTaxonomyGridSection({
    super.key,
    required this.selectedMicrobeId,
    required this.onSelectInMicroscope,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book_rounded, color: AppColors.primaryGreen, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '3. Kartu Karakteristik Lengkap 6 Mikroba Utama',
                style: AppTextStyles.h2.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Pelajari taksonomi, peran biokimia, morfologi mikroskopik, dan produk pangan olahannya (Ketuk kartu/tombol untuk langsung mengamati di mikroskop):',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (ctx, constraints) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;
            final isWide = constraints.maxWidth > 580 || isLandscape;
            final columns = isWide ? 3 : 2;
            final spacing = isWide ? 12.0 : 10.0;
            final cardWidth =
                (constraints.maxWidth - ((columns - 1) * spacing)) / columns;
            final bannerHeight = isWide ? 110.0 : 95.0;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: MicroorganismData.microbes.map((microbe) {
                final isCurrentInSimulator = microbe.id == selectedMicrobeId;

                return SizedBox(
                  width: cardWidth,
                  child: InkWell(
                    onTap: () => MicroorganismDetailDialog.show(
                      context,
                      microbe: microbe,
                      isCurrentInSimulator: isCurrentInSimulator,
                      onSelectInMicroscope: onSelectInMicroscope,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrentInSimulator
                              ? AppColors.primaryGreen
                              : AppColors.borderSubtle,
                          width: isCurrentInSimulator ? 2.0 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isCurrentInSimulator
                                ? AppColors.primaryGreen.withValues(alpha: 0.16)
                                : Colors.black.withValues(alpha: 0.04),
                            blurRadius: isCurrentInSimulator ? 8 : 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Photo / Microscopic Banner
                            Stack(
                              children: [
                                Image.asset(
                                  microbe.imageUrl,
                                  height: bannerHeight,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: bannerHeight,
                                    color: const Color(0xFF10281E),
                                    child: Center(
                                      child: MicroscopicCellularView(
                                          microbe: microbe, zoom: 300),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: bannerHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.8),
                                      ],
                                      stops: const [0.3, 1.0],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.warmTerracotta,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      microbe.kingdomType.split(' ').first,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  left: 8,
                                  right: 8,
                                  child: Text(
                                    microbe.scientificName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      shadows: [
                                        Shadow(color: Colors.black, blurRadius: 4),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            // Text Content Body
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.fastfood_rounded,
                                          size: 13, color: AppColors.warmTerracotta),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          microbe.targetProduct,
                                          style: AppTextStyles.bodyBold.copyWith(
                                            fontSize: 11.0,
                                            color: AppColors.primaryDark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.science_rounded,
                                          size: 13, color: AppColors.primaryGreen),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          microbe.biochemicalRole,
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textPrimary,
                                            fontSize: 10.5,
                                            height: 1.3,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => onSelectInMicroscope(
                                        microbe.id,
                                        microbe.scientificName,
                                      ),
                                      icon: Icon(
                                        isCurrentInSimulator
                                            ? Icons.check_circle_rounded
                                            : Icons.visibility_rounded,
                                        size: 13,
                                        color: isCurrentInSimulator
                                            ? Colors.white
                                            : AppColors.primaryDark,
                                      ),
                                      label: Text(
                                        isCurrentInSimulator
                                            ? 'Sedang Diamati'
                                            : 'Amati di Mikroskop',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrentInSimulator
                                              ? Colors.white
                                              : AppColors.primaryDark,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isCurrentInSimulator
                                            ? AppColors.primaryGreen
                                            : const Color(0xFFFAF7EE),
                                        elevation: isCurrentInSimulator ? 1 : 0,
                                        side: BorderSide(
                                          color: isCurrentInSimulator
                                              ? AppColors.primaryGreen
                                              : AppColors.borderSubtle,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
