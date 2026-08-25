import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/shared/services/app_audio_service.dart';
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
        Consumer(
          builder: (context, ref, _) {
            final audioState = ref.watch(backgroundAudioProvider);
            final isPlaying = audioState.isPlaying && !audioState.isMuted;

            return _buildActionBtn(
              icon: isPlaying
                  ? Icons.volume_up_rounded
                  : Icons.headphones_rounded,
              label: isPlaying ? 'Backsound On' : 'Audio Musik',
              color: AppColors.primaryGreen,
              onTap: () {
                ref.read(backgroundAudioProvider.notifier).togglePlay();
                final willPlay = !isPlaying;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      willPlay
                          ? '🎵 Memutar musik latar (backsound) etnosains...'
                          : '🔇 Musik latar (backsound) dijeda.',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: willPlay
                        ? AppColors.primaryGreen
                        : AppColors.terracottaDark,
                  ),
                );
              },
            );
          },
        ),
        _buildActionBtn(
          icon: Icons.qr_code_2_rounded,
          label: 'QR Akses',
          color: AppColors.infoBlue,
          onTap: () => CoverMediaDialogs.showQrDialog(context),
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
