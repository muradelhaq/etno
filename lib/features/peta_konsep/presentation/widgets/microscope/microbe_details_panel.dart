import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';

class MicrobeDetailsPanel extends StatelessWidget {
  final MicroorganismModel activeMicrobe;
  final bool isExpanded;
  final bool isLandscape;
  final VoidCallback onToggle;

  const MicrobeDetailsPanel({
    super.key,
    required this.activeMicrobe,
    required this.isExpanded,
    required this.isLandscape,
    required this.onToggle,
  });

  Color _getKingdomColor(String kingdomType) {
    if (kingdomType.toLowerCase().contains('bakteri') ||
        kingdomType.toLowerCase().contains('bacteria')) {
      return const Color(0xFF0284C7);
    }
    if (kingdomType.toLowerCase().contains('khamir')) {
      return AppColors.warmTerracotta;
    }
    return AppColors.primaryLight;
  }

  @override
  Widget build(BuildContext context) {
    final kingdomColor = _getKingdomColor(activeMicrobe.kingdomType);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: isExpanded ? 0.45 : 0.25),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isExpanded
                  ? AppColors.primaryLight.withValues(alpha: 0.5)
                  : Colors.white12,
              width: isExpanded ? 1.2 : 0.8,
            ),
            boxShadow: [
              if (isExpanded)
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: kingdomColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.biotech_rounded,
                      color: kingdomColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Scientific Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeMicrobe.scientificName,
                          style: TextStyle(
                            color: AppColors.warmCream,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: isLandscape ? 12.5 : 13.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activeMicrobe.kingdomType,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Kingdom Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: kingdomColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      activeMicrobe.kingdomType.split(' ').first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Expand/Collapse Chevron
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.goldenYellow,
                      size: 20,
                    ),
                  ),
                ],
              ),

              // Collapsed Teaser
              if (!isExpanded) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white38,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Target Pangan: ${activeMicrobe.targetProduct} (Ketuk untuk rincian)',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Expanded Details
              if (isExpanded) ...[
                const SizedBox(height: 10),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 10),

                // 1. Target Produk Fermentasi
                _buildInfoRow(
                  icon: Icons.restaurant_menu_rounded,
                  iconColor: AppColors.goldenYellow,
                  title: 'Produk Pangan',
                  content: activeMicrobe.targetProduct,
                  contentColor: AppColors.goldenYellow,
                  isBold: true,
                ),
                const SizedBox(height: 8),

                // 2. Peran Biokimia & Enzim
                _buildInfoRow(
                  icon: Icons.science_rounded,
                  iconColor: AppColors.primaryLight,
                  title: 'Peran Biokimia & Enzimatis',
                  content: activeMicrobe.primaryFunction,
                  contentColor: Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(height: 8),

                // 3. Karakter Morfologi Mikroskopik
                _buildInfoRow(
                  icon: Icons.grain_rounded,
                  iconColor: AppColors.sageLight,
                  title: 'Karakteristik Morfologi',
                  content: activeMicrobe.microscopicFeature,
                  contentColor: AppColors.sageLight,
                  isItalic: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    required Color contentColor,
    bool isBold = false,
    bool isItalic = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: iconColor),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              color: contentColor,
              fontSize: 11,
              height: 1.35,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
