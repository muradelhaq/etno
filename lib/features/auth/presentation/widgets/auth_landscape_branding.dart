import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'auth_cloud_status_badge.dart';

class AuthLandscapeBranding extends StatelessWidget {
  const AuthLandscapeBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Splash-style emblem badge
            Container(
              width: 52,
              height: 52,
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
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.spa_rounded,
                    size: 26,
                    color: Color(0xFFFEFAE0),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warmTerracotta,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: const Icon(
                        Icons.biotech_rounded,
                        size: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'E-MODUL ETNOSAINS',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 17,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Bioteknologi Fermentasi Nusantara',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Mini feature pills
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildMiniBadge(Icons.menu_book_rounded, '5 Modul Fermentasi'),
            _buildMiniBadge(Icons.science_rounded, 'Lab Virtual'),
            _buildMiniBadge(Icons.psychology_rounded, 'Literasi HOTS'),
          ],
        ),
        const SizedBox(height: 14),
        const AuthCloudStatusBadge(),
      ],
    ).animate().fadeIn(duration: 350.ms).slideX(begin: -0.04);
  }

  Widget _buildMiniBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD6E6D6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A2B).withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primaryGreen),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A2B),
            ),
          ),
        ],
      ),
    );
  }
}
