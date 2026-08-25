import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';

class SplashVersionFooter extends StatelessWidget {
  const SplashVersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version =
            snapshot.hasData ? 'v${snapshot.data!.version}' : 'v1.0.5';
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
    ).animate().fadeIn(delay: 750.ms, duration: 400.ms);
  }
}
