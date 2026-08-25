import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import 'package:e_modul_etnosains/shared/services/app_update_service.dart';
import 'package:e_modul_etnosains/shared/widgets/app_update_dialog.dart';
import '../widgets/splash_ambient_background.dart';
import '../widgets/splash_emblem_logo.dart';
import '../widgets/splash_pillars_wrap.dart';
import '../widgets/splash_progress_indicator.dart';
import '../widgets/splash_version_footer.dart';

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
  bool _animationFinished = false;
  bool _updateCheckFinished = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUpdateOnStartup();
    });

    // Navigation waits for both the splash animation and update check.
    Future.delayed(const Duration(milliseconds: 2700), () {
      _animationFinished = true;
      _continueToApp();
    });
  }

  Future<void> _checkUpdateOnStartup() async {
    try {
      final updateInfo =
          await ref.read(appUpdateServiceProvider).checkForUpdate();
      if (mounted && updateInfo != null && updateInfo.hasUpdate) {
        await AppUpdateDialog.show(context, updateInfo);
      }
    } catch (error) {
      debugPrint('Startup update check failed: $error');
    } finally {
      _updateCheckFinished = true;
      _continueToApp();
    }
  }

  void _skipAnimation() {
    _animationFinished = true;
    _progressController.forward(from: _progressController.value);
    _continueToApp();
  }

  void _continueToApp() {
    if (_navigated ||
        !mounted ||
        !_animationFinished ||
        !_updateCheckFinished) {
      return;
    }
    _navigated = true;
    final user = ref.read(userProgressProvider);
    if (!user.isRegistered) {
      context.go('/auth');
    } else {
      context.go('/');
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
        onTap: _skipAnimation,
        child: SplashAmbientBackground(
          child: Stack(
            children: [
              // Skip button top right
              Positioned(
                top: 40,
                right: 20,
                child: SafeArea(
                  child: TextButton.icon(
                    onPressed: _skipAnimation,
                    icon: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white70, size: 16),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.2)),
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
                      const SplashEmblemLogo(),
                      const SizedBox(height: 20),
                      const SplashPillarsWrap(),
                      const SizedBox(height: 36),
                      SplashProgressIndicator(
                        progressController: _progressController,
                        statusText: _loadingSteps[_statusIndex],
                        statusIndex: _statusIndex,
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Footer
              const Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: SafeArea(
                  child: SplashVersionFooter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
