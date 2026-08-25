import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class PisaResultDialog {
  static void show({
    required BuildContext context,
    required int finalScore,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              finalScore >= 80
                  ? Icons.military_tech_rounded
                  : Icons.emoji_events_rounded,
              color: AppColors.goldenYellow,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text('Hasil Uji Literasi Sains', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Skor Akhir Kamu:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$finalScore / 100',
              style: AppTextStyles.scientificData.copyWith(
                fontSize: 44,
                color: finalScore >= 80
                    ? AppColors.primaryGreen
                    : AppColors.warmTerracotta,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              finalScore >= 80
                  ? 'Predikat: Master Bioteknologi Tradisional (Sangat Unggul)'
                  : 'Predikat: Terampil & Terus Belajar Etnosains',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyBold.copyWith(
                color: finalScore >= 80
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Kamu telah menyelesaikan seluruh 12 slide modul pembelajaran. E-Sertifikat Digital kelulusanmu telah siap diterbitkan!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Review Jawaban'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.workspace_premium_rounded, size: 18),
            label: const Text('Buka E-Sertifikat'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/sertifikat');
            },
          ),
        ],
      ),
    );
  }
}
