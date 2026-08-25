import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class PisaQuizHeader extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final int answeredCount;
  final String competencyLabel;

  const PisaQuizHeader({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.answeredCount,
    required this.competencyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Progress Bar & Stepper Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nomor ${currentIndex + 1} dari $totalQuestions',
              style:
                  AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.sageLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$answeredCount/$totalQuestions Terjawab',
                style: AppTextStyles.tagText.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        LinearProgressIndicator(
          value: (currentIndex + 1) / totalQuestions,
          backgroundColor: AppColors.borderSubtle,
          color: AppColors.primaryGreen,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),

        const SizedBox(height: 16),

        // Competency Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warmCream,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.goldenYellow),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.psychology_alt_rounded,
                  size: 14, color: AppColors.warmTerracotta),
              const SizedBox(width: 6),
              Text(
                'Kompetensi: $competencyLabel',
                style: AppTextStyles.tagText.copyWith(
                  color: AppColors.terracottaDark,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
