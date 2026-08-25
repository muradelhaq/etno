import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/constants/app_strings.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_scaffold.dart';
import 'package:e_modul_etnosains/core/utils/slide_navigation_guard.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import '../widgets/cards/cover_identity_badge_card.dart';
import '../widgets/sections/cover_hero_poster.dart';
import '../widgets/buttons/cover_quick_action_buttons.dart';
import '../widgets/dialogs/learning_objectives_sheet.dart';

class CoverScreen extends ConsumerStatefulWidget {
  const CoverScreen({super.key});

  @override
  ConsumerState<CoverScreen> createState() => _CoverScreenState();
}

class _CoverScreenState extends ConsumerState<CoverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProgressProvider);
      if (!user.isRegistered) {
        context.go('/auth');
        return;
      }
      ref
          .read(userProgressProvider.notifier)
          .markModuleCompleted('cover', xpBonus: 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EthnoScaffold(
      title: AppStrings.appName,
      subtitle: 'Slide 1 / 12 • Beranda Utama',
      showBackButton: false,
      currentSlide: 1,
      nextRoute: '/apersepsi',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge Category
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.sageLight,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco_rounded,
                        color: AppColors.primaryGreen, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'E-MODUL INTERAKTIF BIOLOGI SMA',
                      style: AppTextStyles.tagText.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),

              const SizedBox(height: 12),

              // Student Identity & Switch Account Quick Card
              const CoverIdentityBadgeCard(),

              const SizedBox(height: 12),

              // Title
              Text(
                'ETNOSAINS:\nMAKANAN TRADISIONAL BERBASIS FERMENTASI',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 22,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 500.ms),

              const SizedBox(height: 10),

              // Subtitle
              Text(
                'Mengungkap Kearifan Lokal dan Konsep Sains di Balik Kelezatan Tempe, Tape, Tauco, Kecap, dan Oncom.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ).animate().fadeIn(delay: 250.ms, duration: 500.ms),

              const SizedBox(height: 20),

              // Hero Poster Image
              const CoverHeroPoster()
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 600.ms)
                  .scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 24),

              // Quick Action Media Buttons (Video, QR, Audio, Tujuan)
              const CoverQuickActionButtons()
                  .animate()
                  .fadeIn(delay: 450.ms, duration: 500.ms),

              const SizedBox(height: 28),

              // Main CTA: Mulai Belajar
              CustomButton(
                text: 'Mulai Belajar (Apersepsi)',
                icon: Icons.arrow_forward_rounded,
                isFullWidth: true,
                height: 56,
                backgroundColor: AppColors.primaryGreen,
                onPressed: () => navigateToNextSlide(
                  context,
                  ref,
                  currentSlide: 1,
                  route: '/apersepsi',
                ),
              ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              // Button: Capaian Pembelajaran Sheet
              OutlinedButton.icon(
                onPressed: () => LearningObjectivesSheet.show(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(
                      color: AppColors.primaryGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.assignment_outlined,
                    color: AppColors.primaryGreen, size: 20),
                label: Text(
                  'Lihat 5 Capaian Pembelajaran',
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.primaryGreen),
                ),
              ).animate().fadeIn(delay: 650.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
