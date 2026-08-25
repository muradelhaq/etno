import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';

class AuthSegmentedTabBar extends StatelessWidget {
  final TabController tabController;
  final ValueChanged<int> onTabChanged;

  const AuthSegmentedTabBar({
    super.key,
    required this.tabController,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isStudent = tabController.index == 0;

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE8DC)),
      ),
      child: Row(
        children: [
          // 1. Tab Masuk Siswa
          Expanded(
            child: InkWell(
              onTap: () => onTabChanged(0),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isStudent ? AppColors.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isStudent
                      ? [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school_rounded,
                        size: 16,
                        color: isStudent ? Colors.white : const Color(0xFF2D5A3C),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Masuk Siswa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: isStudent ? Colors.white : const Color(0xFF2D5A3C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // 2. Tab Akses Guru / Admin
          Expanded(
            child: InkWell(
              onTap: () => onTabChanged(1),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isStudent ? AppColors.primaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !isStudent
                      ? [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 16,
                        color: !isStudent ? Colors.white : const Color(0xFF2D5A3C),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Akses Guru / Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: !isStudent ? Colors.white : const Color(0xFF2D5A3C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
