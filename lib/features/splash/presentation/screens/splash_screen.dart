import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../shared/services/local_storage_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  int _statusIndex = 0;
  Timer? _statusTimer;
  bool _navigated = false;

  final List<String> _loadingSteps = [
    'Menyiapkan modul etnosains biologi...',
    'Memuat materi 5 produk fermentasi tradisional...',
    'Menghubungkan sains ilmiah & kearifan lokal...',
    'Selamat datang di E-Modul Etnosains!',
  ];

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();

    _statusTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted && _statusIndex < _loadingSteps.length - 1) {
        setState(() {
          _statusIndex++;
        });
      }
    });

    // Navigate to cover page after animation finishes
    Future.delayed(const Duration(milliseconds: 2700), () {
      _goToCover();
    });
  }

  void _goToCover() {
    if (!_navigated && mounted) {
      _navigated = true;
      final user = ref.read(userProgressProvider);
      if (!user.isRegistered) {
        context.go('/auth');
      } else {
        context.go('/');
      }
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goToCover,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F2E22), // deep forest green
                Color(0xFF1B4332), // primaryDark
                Color(0xFF2D6A4F), // primaryGreen
                Color(0xFF081C15), // obsidian dark green
              ],
              stops: [0.0, 0.35, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Ambient Decorative Background Rings
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldenYellow.withValues(alpha: 0.08),
                  ),
                ).animate().scale(duration: 2000.ms, curve: Curves.easeInOut),
              ),
              Positioned(
                bottom: -100,
                left: -100,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight.withValues(alpha: 0.07),
                  ),
                ).animate().scale(duration: 2200.ms, curve: Curves.easeInOut),
              ),

              // Skip button top right
              Positioned(
                top: 40,
                right: 20,
                child: SafeArea(
                  child: TextButton.icon(
                    onPressed: _goToCover,
                    icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 16),
                    label: const Text(
                      'Lewati',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                ),
              ),

              // Central Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo Emblem
                      Container(
                        width: 110,
                        height: 110,
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
                            color: AppColors.goldenYellow.withValues(alpha: 0.8),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.goldenYellow.withValues(alpha: 0.35),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.spa_rounded,
                              size: 52,
                              color: Color(0xFFFEFAE0),
                            ),
                            Positioned(
                              bottom: 16,
                              right: 18,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.warmTerracotta,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                                child: const Icon(
                                  Icons.biotech_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.easeOutBack)
                          .fadeIn(duration: 600.ms),

                      const SizedBox(height: 24),

                      // Category Tag Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.goldenYellow.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.goldenYellow.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_stories_rounded, color: AppColors.goldenYellow, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'E-MODUL BIOLOGI SMA INTERAKTIF',
                              style: AppTextStyles.tagText.copyWith(
                                color: AppColors.goldenYellow,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 250.ms, duration: 500.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 14),

                      // Title
                      Text(
                        'E-MODUL ETNOSAINS',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 350.ms, duration: 500.ms)
                          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        'Makanan Tradisional Berbasis Fermentasi',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          color: const Color(0xFFD8F3DC),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 450.ms, duration: 500.ms),

                      const SizedBox(height: 20),

                      // Ethnoscience Pillars Pills
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildPill('🌿 Tempe Kedelai'),
                          _buildPill('🍚 Tape Singkong & Ketan'),
                          _buildPill('🫘 Tauco Manis'),
                          _buildPill('🫙 Kecap Tradisional'),
                          _buildPill('🍄 Oncom Merah'),
                        ],
                      ).animate().fadeIn(delay: 550.ms, duration: 500.ms),

                      const SizedBox(height: 36),

                      // Animated Loading Progress Bar
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 220,
                                  height: 6,
                                  color: Colors.white.withValues(alpha: 0.15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 220 * _progressController.value,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.goldenYellow,
                                            AppColors.primaryLight,
                                            Color(0xFF95D5B2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryLight.withValues(alpha: 0.6),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  _loadingSteps[_statusIndex],
                                  key: ValueKey<int>(_statusIndex),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 11.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).animate().fadeIn(delay: 650.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),

              // Bottom Footer
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.hasData
                          ? 'v${snapshot.data!.version}'
                          : 'v1.0.5';
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Kearifan Lokal Nusantara × Konsep Sains Terintegrasi',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 10.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$version • Etnobiologi Pendidikan',
                            style: TextStyle(
                              color: AppColors.goldenYellow.withValues(alpha: 0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ).animate().fadeIn(delay: 750.ms, duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFEFAE0),
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
