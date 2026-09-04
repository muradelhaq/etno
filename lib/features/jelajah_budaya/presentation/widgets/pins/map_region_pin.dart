import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/features/jelajah_budaya/data/models/region_culture_model.dart';
import '../painters/indonesia_map_painter.dart';

Offset getPinPosition(
    String regionId, MapViewMode mode, double w, double h) {
  if (mode == MapViewMode.indonesia) {
    switch (regionId) {
      case 'minangkabau':
        return Offset(w * 0.155, h * 0.44);
      case 'palembang':
        return Offset(w * 0.235, h * 0.56);
      case 'cianjur':
        return Offset(w * 0.285, h * 0.71);
      case 'purwakarta':
        return Offset(w * 0.315, h * 0.67);
      case 'bandung':
        return Offset(w * 0.320, h * 0.74);
      case 'tasikmalaya':
        return Offset(w * 0.355, h * 0.74);
      case 'banyumas':
        return Offset(w * 0.400, h * 0.75);
      case 'bali':
        return Offset(w * 0.505, h * 0.76);
      default:
        return Offset(w * 0.32, h * 0.74);
    }
  } else {
    // Pulau Jawa Zoom View
    switch (regionId) {
      case 'cianjur':
        return Offset(w * 0.18, h * 0.48);
      case 'purwakarta':
        return Offset(w * 0.24, h * 0.38);
      case 'bandung':
        return Offset(w * 0.29, h * 0.52);
      case 'tasikmalaya':
        return Offset(w * 0.36, h * 0.58);
      case 'banyumas':
        return Offset(w * 0.52, h * 0.56);
      default:
        return Offset(w * 0.28, h * 0.50);
    }
  }
}

class MapRegionPin extends StatelessWidget {
  final RegionalCultureItem region;
  final bool isSelected;
  final MapViewMode viewMode;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const MapRegionPin({
    super.key,
    required this.region,
    required this.isSelected,
    required this.viewMode,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDenseJavaRegionInIndonesiaView =
        viewMode == MapViewMode.indonesia &&
            (region.id == 'cianjur' ||
                region.id == 'purwakarta' ||
                region.id == 'bandung' ||
                region.id == 'tasikmalaya' ||
                region.id == 'banyumas');

    final showLabel = isSelected || !isDenseJavaRegionInIndonesiaView;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pin Head Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse glowing circle for active pin
                  if (isSelected)
                    Container(
                      width: 26 + (6 * pulseAnimation.value),
                      height: 26 + (6 * pulseAnimation.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warmTerracotta.withValues(
                            alpha: 0.40 - (0.20 * pulseAnimation.value)),
                      ),
                    ),
                  // Solid Pin Badge
                  Container(
                    padding: EdgeInsets.all(isSelected ? 4.5 : (isDenseJavaRegionInIndonesiaView ? 3.0 : 3.5)),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.warmTerracotta
                          : (isDenseJavaRegionInIndonesiaView
                              ? AppColors.primaryDark
                              : const Color(0xFF1B4332)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : AppColors.goldenYellow,
                        width: isSelected ? 1.8 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isSelected ? 0.35 : 0.2),
                          blurRadius: isSelected ? 5 : 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? Icons.location_on : Icons.restaurant_rounded,
                      size: isSelected ? 13 : (isDenseJavaRegionInIndonesiaView ? 9.5 : 10.5),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              if (showLabel) ...[
                const SizedBox(height: 2),
                // Location Name Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.warmTerracotta
                        : Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.warmTerracotta
                          : const Color(0xFF2D6A4F).withValues(alpha: 0.6),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isSelected ? 0.25 : 0.12),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    region.regionName.split('&').first.trim(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF1E3A2B),
                      fontSize: isSelected ? 9.0 : 8.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
