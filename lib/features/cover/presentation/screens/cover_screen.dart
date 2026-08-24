import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_scaffold.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/services/app_audio_service.dart';
import '../../../../shared/services/app_update_service.dart';
import '../../../../shared/widgets/app_update_dialog.dart';

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
      ref.read(userProgressProvider.notifier).markModuleCompleted('cover', xpBonus: 20);
      _checkAutoUpdate();
    });
  }

  Future<void> _checkAutoUpdate() async {
    try {
      final updateService = ref.read(appUpdateServiceProvider);
      final updateInfo = await updateService.checkForUpdate();
      if (updateInfo != null && updateInfo.hasUpdate && mounted) {
        AppUpdateDialog.show(context, updateInfo);
      }
    } catch (e) {
      debugPrint('Error auto checking update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return EthnoScaffold(
      title: AppStrings.appName,
      subtitle: 'Slide 1 / 12 • Beranda Utama',
      showBackButton: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge Category
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.sageLight,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 16),
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

              const SizedBox(height: 16),

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

              // Hero Poster Image Container
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        AppAssets.posterLearningModules,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: AppColors.sageLight,
                          child: const Center(
                            child: Icon(Icons.menu_book_rounded, size: 64, color: AppColors.primaryGreen),
                          ),
                        ),
                      ),
                      // Gradient overlay at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.75),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '🌾 Kearifan Leluhur • 🔬 Bioteknologi Modern',
                            style: AppTextStyles.tagText.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 24),

              // Quick Action Media Buttons (Video, QR, Audio, Tujuan)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickActionBtn(
                    icon: Icons.play_circle_fill_rounded,
                    label: 'Video Intro',
                    color: AppColors.warmTerracotta,
                    onTap: () => _showVideoPengantarDialog(context),
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final audioState = ref.watch(backgroundAudioProvider);
                      final isPlaying = audioState.isPlaying && !audioState.isMuted;

                      return _buildQuickActionBtn(
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
                  _buildQuickActionBtn(
                    icon: Icons.qr_code_2_rounded,
                    label: 'QR Akses',
                    color: AppColors.infoBlue,
                    onTap: () => _showQrDialog(context),
                  ),
                  _buildQuickActionBtn(
                    icon: Icons.checklist_rounded,
                    label: 'Tujuan',
                    color: AppColors.goldenYellow,
                    onTap: () => _showLearningObjectivesSheet(context),
                  ),
                ],
              ).animate().fadeIn(delay: 450.ms, duration: 500.ms),

              const SizedBox(height: 28),

              // Main CTA: Mulai Belajar
              CustomButton(
                text: 'Mulai Belajar (Apersepsi)',
                icon: Icons.arrow_forward_rounded,
                isFullWidth: true,
                height: 56,
                backgroundColor: AppColors.primaryGreen,
                onPressed: () {
                  context.go('/apersepsi');
                },
              ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              // Button: Capaian Pembelajaran Sheet
              OutlinedButton.icon(
                onPressed: () => _showLearningObjectivesSheet(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.assignment_outlined, color: AppColors.primaryGreen, size: 20),
                label: Text(
                  'Lihat 5 Capaian Pembelajaran',
                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen),
                ),
              ).animate().fadeIn(delay: 650.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionBtn({
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

  void _showLearningObjectivesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (c, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.sageLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.school_rounded, color: AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tujuan Pembelajaran Etnosains',
                      style: AppTextStyles.h2.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kompetensi yang akan kamu kuasai setelah menyelesaikan modul:',
                style: AppTextStyles.bodySmall,
              ),
              const Divider(height: 24),
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  itemCount: AppStrings.learningObjectives.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 12),
                  itemBuilder: (c, i) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warmCream.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppStrings.learningObjectives[i],
                              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Mengerti & Lanjutkan Belajar',
                isFullWidth: true,
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go('/apersepsi');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoPengantarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.movie_filter_rounded, color: AppColors.warmTerracotta),
            const SizedBox(width: 10),
            Text('Pengantar E-Modul', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppAssets.flowchartFermentation,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(
                    color: Colors.black45,
                  ),
                  const Icon(Icons.play_circle_fill, color: Colors.white, size: 54),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Selamat Datang di E-Modul Etnosains Fermentasi!',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'Melalui media interaktif ini, kamu akan mengeksplorasi bagaimana kearifan nenek moyang dalam mengolah tempe, tape, tauco, kecap, dan oncom sebenarnya merupakan penerapan bioteknologi mikroba yang sangat canggih.',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/apersepsi');
            },
            child: const Text('Mulai Bab 1'),
          ),
        ],
      ),
    );
  }

  void _showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.qr_code_scanner_rounded, color: AppColors.primaryGreen),
            const SizedBox(width: 10),
            Text('Akses Cepat Modul', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(Icons.qr_code_2, size: 140, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 12),
            Text(
              'Scan QR Code ini untuk membuka e-modul di perangkat ponsel atau tablet teman sekelasmu.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
