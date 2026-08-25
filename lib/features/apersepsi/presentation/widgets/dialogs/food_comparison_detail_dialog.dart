import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/features/apersepsi/data/models/food_comparison_model.dart';

class FoodComparisonDetailDialog extends StatelessWidget {
  final FoodItemModel item;
  final bool isModern;

  const FoodComparisonDetailDialog({
    super.key,
    required this.item,
    required this.isModern,
  });

  static void show(BuildContext context, FoodItemModel item, bool isModern) {
    showDialog(
      context: context,
      builder: (ctx) =>
          FoodComparisonDetailDialog(item: item, isModern: isModern),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final size = MediaQuery.of(context).size;

    if (isLandscape) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SizedBox(
          width: (size.width * 0.75).clamp(480.0, 650.0),
          height: (size.height * 0.85).clamp(240.0, 360.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: Full Photo
              Expanded(
                flex: 5,
                child: AppImage(
                  item.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.warmCream,
                    child: Center(
                      child: Icon(
                        isModern
                            ? Icons.fastfood_rounded
                            : Icons.rice_bowl_rounded,
                        size: 48,
                        color: isModern
                            ? AppColors.warmTerracotta
                            : AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ),
              ),

              // Right: Info & Description
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTextStyles.h3.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isModern
                                  ? AppColors.warmTerracotta
                                  : AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isModern ? 'Modern' : 'Tradisional',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Bahan Fermentasi: ${item.baseFermentationProduct}',
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 12,
                          color: isModern
                              ? AppColors.terracottaDark
                              : AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            item.description,
                            style: AppTextStyles.bodySmall
                                .copyWith(fontSize: 12, height: 1.4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImage(
                item.imageAsset,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: AppColors.warmCream,
                  child: Center(
                    child: Icon(
                      isModern
                          ? Icons.fastfood_rounded
                          : Icons.rice_bowl_rounded,
                      size: 48,
                      color: isModern
                          ? AppColors.warmTerracotta
                          : AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(item.name, style: AppTextStyles.h3),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isModern
                                ? AppColors.warmTerracotta
                                : AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isModern ? 'Modern' : 'Tradisional',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Bahan Fermentasi: ${item.baseFermentationProduct}',
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: 12,
                        color: isModern
                            ? AppColors.terracottaDark
                            : AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      );
    }
  }
}
