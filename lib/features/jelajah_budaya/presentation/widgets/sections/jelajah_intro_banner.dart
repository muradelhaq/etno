import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class JelajahIntroBanner extends StatelessWidget {
  const JelajahIntroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.explore_rounded,
              color: AppColors.goldenYellow, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peta Eksplorasi Daerah',
                  style: AppTextStyles.h3
                      .copyWith(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ketuk pin daerah di bawah untuk mempelajari etimologi nama dan tradisi kuliner fermentasinya:',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.sageLight),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
