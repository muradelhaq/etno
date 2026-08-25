import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import '../dialogs/learning_objectives_sheet.dart';
import '../dialogs/cover_media_dialogs.dart';

class CoverQuickActionButtons extends StatelessWidget {
  const CoverQuickActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionBtn(
          icon: Icons.play_circle_fill_rounded,
          label: 'Video Intro',
          color: AppColors.warmTerracotta,
          onTap: () => CoverMediaDialogs.showVideoPengantarDialog(context),
        ),
        _buildActionBtn(
          icon: Icons.checklist_rounded,
          label: 'Tujuan',
          color: AppColors.goldenYellow,
          onTap: () => LearningObjectivesSheet.show(context),
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.tagText.copyWith(
                color: AppColors.primaryDark,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
