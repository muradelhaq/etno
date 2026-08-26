import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/shared/models/user_progress_model.dart';

class DrawerUserHeader extends StatelessWidget {
  final UserProgressModel progress;

  const DrawerUserHeader({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.eco_rounded,
                    color: AppColors.warmCream, size: 28),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Admin Shortcut
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.admin_panel_settings_rounded,
                              size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Guru',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Ganti Profil
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/auth');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warmTerracotta,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_rounded,
                              size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Profil',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            progress.studentName,
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontSize: 17,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '📚 ${progress.studentClass}  •  🏫 ${progress.studentSchool}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.sageLight,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // XP and completion banner
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: AppColors.goldenYellow, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${progress.earnedXP} XP',
                        style: AppTextStyles.bodyBold.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.sageLight, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${progress.completedModules.length}/13 Modul',
                        style: AppTextStyles.bodyBold.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
