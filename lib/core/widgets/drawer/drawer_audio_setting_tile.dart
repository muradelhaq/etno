import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/shared/services/app_audio_service.dart';

class DrawerAudioSettingTile extends ConsumerWidget {
  const DrawerAudioSettingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(backgroundAudioProvider);
    final isPlaying = audioState.isPlaying && !audioState.isMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6EE),
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPlaying ? Icons.music_note_rounded : Icons.music_off_rounded,
            color: isPlaying ? AppColors.primaryGreen : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Musik Latar (Backsound)',
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                ),
                Text(
                  isPlaying ? 'Sedang berputar • Tradisional' : 'Dinonaktifkan',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: isPlaying ? AppColors.primaryGreen : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isPlaying,
            activeTrackColor: AppColors.primaryGreen,
            onChanged: (val) {
              ref.read(backgroundAudioProvider.notifier).setMuted(!val);
            },
          ),
        ],
      ),
    );
  }
}
