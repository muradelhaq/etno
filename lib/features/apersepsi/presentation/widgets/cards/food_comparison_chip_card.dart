import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/features/apersepsi/data/models/food_comparison_model.dart';
import '../dialogs/food_comparison_detail_dialog.dart';

class FoodComparisonChipCard extends StatelessWidget {
  final FoodItemModel item;
  final bool isModern;
  final bool isLandscape;

  const FoodComparisonChipCard({
    super.key,
    required this.item,
    required this.isModern,
    this.isLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    return EthnoCard(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      borderColor: isModern
          ? AppColors.warmTerracotta.withValues(alpha: 0.3)
          : AppColors.primaryGreen.withValues(alpha: 0.3),
      onTap: () => FoodComparisonDetailDialog.show(context, item, isModern),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed Image
            AppImage(
              item.imageAsset,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.warmCream,
                child: Center(
                  child: Icon(
                    isModern ? Icons.fastfood_rounded : Icons.rice_bowl_rounded,
                    size: isLandscape ? 36 : 28,
                    color: isModern
                        ? AppColors.warmTerracotta
                        : AppColors.primaryGreen,
                  ),
                ),
              ),
            ),

            // Gradient shade overlay for contrast
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.70),
                    ],
                    stops: const [0.25, 0.55, 1.0],
                  ),
                ),
              ),
            ),

            // Semi-transparent badge for text
            Positioned(
              left: isLandscape ? 6 : 4,
              right: isLandscape ? 6 : 4,
              bottom: isLandscape ? 6 : 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLandscape ? 7 : 5,
                      vertical: isLandscape ? 5 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.60),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 0.7,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isLandscape ? 12 : 9.5,
                            height: 1.15,
                            shadows: const [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          softWrap: true,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.baseFermentationProduct,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: isLandscape ? 9.5 : 8.0,
                            fontWeight: FontWeight.w400,
                            height: 1.15,
                            shadows: const [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
