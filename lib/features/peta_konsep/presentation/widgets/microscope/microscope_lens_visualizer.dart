import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';

class MicroscopeLensVisualizer extends StatelessWidget {
  final MicroorganismModel activeMicrobe;
  final double zoom;
  final double lensSize;
  final bool isLandscape;

  const MicroscopeLensVisualizer({
    super.key,
    required this.activeMicrobe,
    required this.zoom,
    required this.lensSize,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    final t = ((zoom - 100.0) / 900.0).clamp(0.0, 1.0);
    final foodOpacity = (1.0 - t * 2.2).clamp(0.0, 1.0);
    final foodScale = 1.0 + t * 2.0;
    final microbeOpacity = (t * 2.0).clamp(0.0, 1.0);
    final microbeScale = 0.7 + t * 0.8;
    final beforeZoomImage = activeMicrobe.beforeZoomImage;
    final afterZoomImage = activeMicrobe.afterZoomImage;

    return Center(
      child: Container(
        width: lensSize,
        height: lensSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF10281E),
          border: Border.all(color: AppColors.primaryLight, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(color: const Color(0xFF0D1F17)),
              if (foodOpacity > 0.01)
                Opacity(
                  opacity: foodOpacity,
                  child: Transform.scale(
                    scale: foodScale,
                    child: AppImage(
                      beforeZoomImage,
                      width: lensSize,
                      height: lensSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF2C3E50),
                        child: const Center(
                          child: Icon(Icons.fastfood,
                              color: Colors.white54, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),
              if (microbeOpacity > 0.01)
                Opacity(
                  opacity: microbeOpacity,
                  child: Transform.scale(
                    scale: microbeScale,
                    child: AppImage(
                      afterZoomImage,
                      width: lensSize,
                      height: lensSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const Divider(color: Colors.white24, thickness: 1),
              const VerticalDivider(color: Colors.white24, thickness: 1),
              Positioned(
                top: isLandscape ? 6 : 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.goldenYellow, width: 0.9),
                  ),
                  child: Text(
                    zoom <= 200
                        ? '${zoom.toInt()}x • Preparat sebelum zoom'
                        : (zoom <= 500
                            ? '${zoom.toInt()}x • Transisi menuju mikroorganisme'
                            : '${zoom.toInt()}x • Sel ${activeMicrobe.scientificName.split(' ').first}'),
                    style: AppTextStyles.scientificFormula.copyWith(
                      color: AppColors.goldenYellow,
                      fontSize: isLandscape ? 8.0 : 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
