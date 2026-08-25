import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';

class SplashProgressIndicator extends StatelessWidget {
  final AnimationController progressController;
  final String statusText;
  final int statusIndex;

  const SplashProgressIndicator({
    super.key,
    required this.progressController,
    required this.statusText,
    required this.statusIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressController,
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
                    width: 220 * progressController.value,
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
                          color:
                              AppColors.primaryLight.withValues(alpha: 0.6),
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
                statusText,
                key: ValueKey<int>(statusIndex),
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
    ).animate().fadeIn(delay: 650.ms, duration: 400.ms);
  }
}
