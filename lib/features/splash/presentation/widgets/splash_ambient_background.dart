import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';

class SplashAmbientBackground extends StatelessWidget {
  final Widget child;

  const SplashAmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child,
        ],
      ),
    );
  }
}
