import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/features/jelajah_budaya/data/models/region_culture_model.dart';
import '../painters/indonesia_map_painter.dart';

Offset getPinPosition(
    String regionId, MapViewMode mode, double w, double h) {
  if (mode == MapViewMode.indonesia) {
    switch (regionId) {
      case 'minangkabau':
        return Offset(w * 0.16, h * 0.48);
      case 'palembang':
        return Offset(w * 0.23, h * 0.58);
      case 'cianjur':
        return Offset(w * 0.28, h * 0.72);
      case 'purwakarta':
        return Offset(w * 0.30, h * 0.69);
      case 'bandung':
        return Offset(w * 0.31, h * 0.75);
      case 'tasikmalaya':
        return Offset(w * 0.34, h * 0.76);
      case 'banyumas':
        return Offset(w * 0.38, h * 0.77);
      case 'bali':
        return Offset(w * 0.50, h * 0.77);
      default:
        return Offset(w * 0.32, h * 0.74);
    }
  } else {
    // Pulau Jawa Zoom View
    switch (regionId) {
      case 'cianjur':
        return Offset(w * 0.20, h * 0.46);
      case 'purwakarta':
        return Offset(w * 0.24, h * 0.38);
      case 'bandung':
        return Offset(w * 0.28, h * 0.50);
      case 'tasikmalaya':
        return Offset(w * 0.34, h * 0.56);
      case 'banyumas':
        return Offset(w * 0.52, h * 0.58);
      default:
        return Offset(w * 0.28, h * 0.50);
    }
  }
}

class MapRegionPin extends StatelessWidget {
  final RegionalCultureItem region;
  final bool isSelected;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const MapRegionPin({
    super.key,
    required this.region,
    required this.isSelected,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                      width: 28 + (6 * pulseAnimation.value),
                      height: 28 + (6 * pulseAnimation.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warmTerracotta.withValues(
                            alpha: 0.35 - (0.15 * pulseAnimation.value)),
                      ),
                    ),
                  // Solid Pin Badge
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.warmTerracotta
                          : const Color(0xFF1B4332),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : AppColors.goldenYellow,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? Icons.location_on : Icons.restaurant_rounded,
                      size: isSelected ? 14 : 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Location Name Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.warmTerracotta
                      : Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.warmTerracotta
                        : const Color(0xFF2D6A4F).withValues(alpha: 0.5),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  region.regionName.split('&').first.trim(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1E3A2B),
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
