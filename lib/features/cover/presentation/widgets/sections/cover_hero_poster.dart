import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/constants/app_assets.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class CoverHeroPoster extends StatelessWidget {
  const CoverHeroPoster({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: AppImage(
                    AppAssets.panelTempeTaucoTapeHd,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => _fallbackImage(),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: 2,
                  child: AppImage(
                    AppAssets.panelOncomKecapHd,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => _fallbackImage(),
                  ),
                ),
              ],
            ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: AppColors.sageLight,
      child: const Center(
        child: Icon(Icons.restaurant_rounded,
            size: 64, color: AppColors.primaryGreen),
      ),
    );
  }
}
