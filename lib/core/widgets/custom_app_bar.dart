import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../theme/text_styles.dart';
import '../../shared/services/app_audio_service.dart';
import '../../shared/services/local_storage_service.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.actions,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (subtitle != null ? 16.0 : 0.0) + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(userProgressProvider);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryDark, size: 20),
              onPressed: () => context.pop(),
            )
          : Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: AppColors.primaryDark, size: 24),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            Text(
              subtitle ?? '',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      actions: [
        // Music Toggle Button
        Consumer(
          builder: (context, ref, _) {
            final audioState = ref.watch(backgroundAudioProvider);
            final isPlaying = audioState.isPlaying && !audioState.isMuted;

            return InkWell(
              onTap: () {
                ref.read(backgroundAudioProvider.notifier).togglePlay();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isPlaying
                          ? '🔇 Musik latar (backsound) dijeda'
                          : '🎵 Musik latar (backsound) dinyalakan',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: isPlaying
                        ? AppColors.terracottaDark
                        : AppColors.primaryGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPlaying
                      ? AppColors.sageLight
                      : Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPlaying
                        ? AppColors.primaryGreen
                        : AppColors.borderSubtle,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPlaying
                          ? Icons.music_note_rounded
                          : Icons.music_off_rounded,
                      color: isPlaying
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      isPlaying ? 'Musik' : 'Mute',
                      style: AppTextStyles.tagText.copyWith(
                        color: isPlaying
                            ? AppColors.primaryGreen
                            : AppColors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // XP Badge
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warmCream,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.goldenYellow, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.warmTerracotta, size: 18),
              const SizedBox(width: 4),
              Text(
                '${progress.earnedXP} XP',
                style: AppTextStyles.tagText.copyWith(
                  color: AppColors.terracottaDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
      bottom: bottom,
    );
  }
}
