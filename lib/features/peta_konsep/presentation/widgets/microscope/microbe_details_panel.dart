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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isExpanded ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded
                ? AppColors.primaryLight.withValues(alpha: 0.5)
                : Colors.white12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    activeMicrobe.scientificName,
                    style: TextStyle(
                      color: AppColors.warmCream,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: isLandscape ? 13 : 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warmTerracotta,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    activeMicrobe.kingdomType.split(' ').first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.goldenYellow,
                  size: 20,
                ),
              ],
            ),
            if (!isExpanded) ...[
              const SizedBox(height: 4),
              const Text(
                'Ketuk untuk melihat rincian produk target & morfologi',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (isExpanded) ...[
              const SizedBox(height: 8),
              Text(
                'Produk: ${activeMicrobe.targetProduct}',
                style: const TextStyle(
                  color: AppColors.goldenYellow,
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                activeMicrobe.primaryFunction,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Morfologi: ${activeMicrobe.microscopicFeature}',
                style: const TextStyle(
                  color: AppColors.sageLight,
                  fontSize: 10.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
