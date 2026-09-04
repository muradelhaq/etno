import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/features/jelajah_budaya/data/models/region_culture_model.dart';
import 'components/map_header_bar.dart';
import 'painters/indonesia_map_painter.dart';
import 'pins/map_region_pin.dart';

export 'painters/indonesia_map_painter.dart' show MapViewMode;

class IndonesiaMapWidget extends StatefulWidget {
  final String selectedRegionId;
  final ValueChanged<String> onRegionSelected;

  const IndonesiaMapWidget({
    super.key,
    required this.selectedRegionId,
    required this.onRegionSelected,
  });

  @override
  State<IndonesiaMapWidget> createState() => _IndonesiaMapWidgetState();
}

class _IndonesiaMapWidgetState extends State<IndonesiaMapWidget>
    with SingleTickerProviderStateMixin {
  MapViewMode _viewMode = MapViewMode.indonesia;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Map Top Bar: Title & View Mode Selector Switch
        MapHeaderBar(
          viewMode: _viewMode,
          onModeChanged: (mode) => setState(() => _viewMode = mode),
        ),

        const SizedBox(height: 10),

        // Interactive Map Canvas Container
        Container(
          height: 235,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFD4EDF8), // Nusantara ocean light blue
                Color(0xFFBCE3F5),
                Color(0xFFA5D7EE),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B4332).withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Custom Map Painter (Islands & Coastlines)
                Positioned.fill(
                  child: CustomPaint(
                    painter: IndonesiaMapPainter(viewMode: _viewMode),
                  ),
                ),

                // Compass Rose (Top Right)
                const Positioned(
                  top: 10,
                  right: 12,
                  child: MapCompassRoseBadge(),
                ),

                // Graticule Coordinates Badge (Bottom Left)
                Positioned(
                  bottom: 8,
                  left: 10,
                  child: MapGraticuleBadge(viewMode: _viewMode),
                ),

                // Interactive Map Pins
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;

                    final regionsToRender = _viewMode == MapViewMode.indonesia
                        ? JelajahBudayaData.regions
                        : JelajahBudayaData.regions
                            .where((r) =>
                                r.id == 'banyumas' ||
                                r.id == 'tasikmalaya' ||
                                r.id == 'cianjur' ||
                                r.id == 'purwakarta' ||
                                r.id == 'bandung')
                            .toList();

                    // Sort so selected pin is on top
                    final sortedRegions = List.of(regionsToRender)
                      ..sort((a, b) {
                        if (a.id == widget.selectedRegionId) return 1;
                        if (b.id == widget.selectedRegionId) return -1;
                        return 0;
                      });

                    return Stack(
                      children: sortedRegions.map((region) {
                        final pos = getPinPosition(region.id, _viewMode, w, h);
                        final isSelected = region.id == widget.selectedRegionId;

                        return Positioned(
                          left: pos.dx - 22,
                          top: pos.dy - 28,
                          child: MapRegionPin(
                            region: region,
                            isSelected: isSelected,
                            viewMode: _viewMode,
                            pulseAnimation: _pulseController,
                            onTap: () => widget.onRegionSelected(region.id),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
