import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'auth_cloud_status_badge.dart';

class AuthHeroBrandingColumn extends StatelessWidget {
  const AuthHeroBrandingColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emblem badge
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.biotech_rounded,
              size: 36,
              color: AppColors.goldenYellow,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'E-Modul Etnosains',
          style: AppTextStyles.h1.copyWith(
            fontSize: 32,
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rekonstruksi Kearifan Lokal & Literasi Sains HOTS PISA Berbasis Bioteknologi Tradisional.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // Feature Highlights
        _buildFeatureBadge(
          Icons.menu_book_rounded,
          '5 Modul Pangan Fermentasi',
          'Tempe, Tape, Tauco, Kecap, dan Oncom',
        ),
        const SizedBox(height: 12),
        _buildFeatureBadge(
          Icons.science_rounded,
          'Laboratorium Virtual',
          'Simulasi kadar glukosa & organoleptik empiris',
        ),
        const SizedBox(height: 12),
        _buildFeatureBadge(
          Icons.analytics_rounded,
          'Dashboard Guru & Real-time Sync',
          'Monitoring kemajuan belajar & ekspor rekap Excel',
        ),
        const SizedBox(height: 28),
        const AuthCloudStatusBadge(),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05);
  }

  Widget _buildFeatureBadge(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD6E6D6)),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1E3A2B),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
