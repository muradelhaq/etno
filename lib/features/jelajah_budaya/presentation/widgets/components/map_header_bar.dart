import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import '../painters/indonesia_map_painter.dart';

class MapHeaderBar extends StatelessWidget {
  final MapViewMode viewMode;
  final ValueChanged<MapViewMode> onModeChanged;

  const MapHeaderBar({
    super.key,
    required this.viewMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.public_rounded,
                  color: AppColors.primaryGreen, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  viewMode == MapViewMode.indonesia
                      ? 'Peta Nusantara'
                      : 'Peta Fokus Jawa',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1E3A2B),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Toggle view mode buttons
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFC8E6C9)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleTab(
                label: 'Indonesia',
                icon: Icons.map_rounded,
                isSelected: viewMode == MapViewMode.indonesia,
                onTap: () => onModeChanged(MapViewMode.indonesia),
              ),
              _buildToggleTab(
                label: 'P. Jawa',
                icon: Icons.zoom_in_rounded,
                isSelected: viewMode == MapViewMode.pulauJawa,
                onTap: () => onModeChanged(MapViewMode.pulauJawa),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : const Color(0xFF2D6A4F),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2D6A4F),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapCompassRoseBadge extends StatelessWidget {
  const MapCompassRoseBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.navigation_rounded,
              size: 12, color: AppColors.warmTerracotta),
          SizedBox(width: 2),
          Text(
            'U',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A2B),
            ),
          ),
        ],
      ),
    );
  }
}

class MapGraticuleBadge extends StatelessWidget {
  final MapViewMode viewMode;

  const MapGraticuleBadge({super.key, required this.viewMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        viewMode == MapViewMode.indonesia
            ? '95°BT - 141°BT • 6°LU - 11°LS'
            : '105°BT - 115°BT • 5.5°LS - 9°LS',
        style: const TextStyle(
          fontSize: 9,
          color: Color(0xFF4A6B82),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
