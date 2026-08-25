import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class SplashEmblemLogo extends StatelessWidget {
  const SplashEmblemLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated Logo Emblem
        Container(
          width: 110,
          height: 110,
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
              color: AppColors.goldenYellow.withValues(alpha: 0.8),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.goldenYellow.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.spa_rounded,
                size: 52,
                color: Color(0xFFFEFAE0),
              ),
              Positioned(
                bottom: 16,
                right: 18,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warmTerracotta,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.biotech_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
            .animate()
            .scale(duration: 800.ms, curve: Curves.easeOutBack)
            .fadeIn(duration: 600.ms),

        const SizedBox(height: 24),

        // Category Tag Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.goldenYellow.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.goldenYellow.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_stories_rounded,
                  color: AppColors.goldenYellow, size: 14),
              const SizedBox(width: 6),
              Text(
                'E-MODUL BIOLOGI SMA INTERAKTIF',
                style: AppTextStyles.tagText.copyWith(
                  color: AppColors.goldenYellow,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 250.ms, duration: 500.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 14),

        // Title
        Text(
          'E-MODUL ETNOSAINS',
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 350.ms, duration: 500.ms)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

        const SizedBox(height: 6),

        // Subtitle
        Text(
          'Makanan Tradisional Berbasis Fermentasi',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 14,
            color: const Color(0xFFD8F3DC),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ).animate().fadeIn(delay: 450.ms, duration: 500.ms),
      ],
    );
  }
}
