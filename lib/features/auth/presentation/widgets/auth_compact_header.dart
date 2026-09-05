import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class AuthCompactHeader extends StatelessWidget {
  const AuthCompactHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF52B788),
                Color(0xFF2D6A4F),
                Color(0xFF1B4332),
              ],
            ),
            border: Border.all(
              color: AppColors.goldenYellow,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.spa_rounded,
                size: 34,
                color: Color(0xFFFEFAE0),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warmTerracotta,
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  child: const Icon(
                    Icons.biotech_rounded,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ).animate().scale(duration: 400.ms),
        const SizedBox(height: 12),
        Text(
          'E-MODUL ETNOSAINS',
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(
            fontSize: 20,
            color: AppColors.primaryDark,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bioteknologi Fermentasi Pangan Tradisional Nusantara',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}
