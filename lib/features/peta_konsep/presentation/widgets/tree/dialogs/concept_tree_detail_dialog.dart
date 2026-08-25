import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class ConceptTreeDialogs {
  static void showRootInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.account_tree_rounded, color: AppColors.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Produk Fermentasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Peta konsep ini merangkum 4 pilar produk fermentasi tradisional Indonesia (Tempe, Tape Singkong, Tape Ketan, dan Tauco) beserta ragam kuliner turunannya. Setiap produk memanfaatkan mikroorganisme spesifik yang mengubah cita rasa, tekstur, dan nilai gizi bahan pangan.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  static void showDetailDialog({
    required BuildContext context,
    required String title,
    required String category,
    required String microbe,
    required String imageAsset,
    required String description,
    required String? route,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppImage(
                  imageAsset,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    color: AppColors.warmCream,
                    child: const Center(
                      child: Icon(Icons.rice_bowl_rounded,
                          size: 40, color: AppColors.primaryGreen),
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
                            child: Text(title, style: AppTextStyles.h3),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.sageLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primaryGreen),
                            ),
                            child: Text(
                              category,
                              style: AppTextStyles.tagText.copyWith(
                                color: AppColors.primaryDark,
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Agens Mikroba / Basis:',
                        style: AppTextStyles.tagText.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        microbe,
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 12.5,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          if (route != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                context.go(route);
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('Buka Modul'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }
}
