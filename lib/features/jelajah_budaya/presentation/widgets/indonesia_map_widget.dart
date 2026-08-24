import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/region_culture_model.dart';

enum MapViewMode {
  indonesia,
  pulauJawa,
}

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.public_rounded, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  _viewMode == MapViewMode.indonesia
                      ? 'Peta Nusantara (Indonesia)'
                      : 'Peta Fokus Pulau Jawa',
                  style: const TextStyle(
                    color: Color(0xFF1E3A2B),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),

            // Toggle view mode buttons
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: Row(
                children: [
                  _buildToggleTab(
                    label: 'Indonesia',
                    icon: Icons.map_rounded,
                    isSelected: _viewMode == MapViewMode.indonesia,
                    onTap: () => setState(() => _viewMode = MapViewMode.indonesia),
                  ),
                  _buildToggleTab(
                    label: 'P. Jawa',
                    icon: Icons.zoom_in_rounded,
                    isSelected: _viewMode == MapViewMode.pulauJawa,
                    onTap: () => setState(() => _viewMode = MapViewMode.pulauJawa),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Interactive Map Canvas Container
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFD0EAF5), // Nusantara ocean light blue
                Color(0xFFB8DEEF),
                Color(0xFFA2D2EB),
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
                    painter: _IndonesiaMapPainter(viewMode: _viewMode),
                  ),
                ),

                // Compass Rose (Top Right)
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.navigation_rounded, size: 12, color: AppColors.warmTerracotta),
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
                  ),
                ),

                // Graticule Coordinates Badge (Bottom Left)
                Positioned(
                  bottom: 8,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _viewMode == MapViewMode.indonesia
                          ? '95°BT - 141°BT • 6°LU - 11°LS'
                          : '105°BT - 115°BT • 5.5°LS - 9°LS',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF4A6B82),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Interactive Map Pins
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;

                    final regionsToRender = _viewMode == MapViewMode.indonesia
                        ? JelajahBudayaData.regions
                        : JelajahBudayaData.regions
                            .where((r) => r.id == 'banyumas' || r.id == 'tasikmalaya' || r.id == 'cianjur' || r.id == 'purwakarta' || r.id == 'bandung')
                            .toList();

                    return Stack(
                      children: regionsToRender.map((region) {
                        final pos = _getPinPosition(region.id, _viewMode, w, h);
                        final isSelected = region.id == widget.selectedRegionId;

                        return Positioned(
                          left: pos.dx - 18,
                          top: pos.dy - 28,
                          child: GestureDetector(
                            onTap: () => widget.onRegionSelected(region.id),
                            child: AnimatedBuilder(
                              animation: _pulseController,
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
                                            width: 28 + (6 * _pulseController.value),
                                            height: 28 + (6 * _pulseController.value),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.warmTerracotta
                                                  .withValues(alpha: 0.35 - (0.15 * _pulseController.value)),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
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

  Offset _getPinPosition(String regionId, MapViewMode mode, double w, double h) {
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
}

class _IndonesiaMapPainter extends CustomPainter {
  final MapViewMode viewMode;

  _IndonesiaMapPainter({required this.viewMode});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Draw subtle ocean gridlines
    final gridPaint = Paint()
      ..color = const Color(0xFF64B5F6).withValues(alpha: 0.25)
      ..strokeWidth = 0.6;

    for (double x = 0; x < w; x += w / 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += h / 6) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // 2. Island Paints (Lush Green with Coastline Shadow)
    final islandFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF52B788),
          Color(0xFF388E3C),
          Color(0xFF2E7D32),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final coastlineStroke = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeJoin = StrokeJoin.round;

    final islandShadow = Paint()
      ..color = const Color(0xFF1A3A2A).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    if (viewMode == MapViewMode.indonesia) {
      _drawIndonesiaArchipelago(canvas, size, islandShadow, islandFill, coastlineStroke);
    } else {
      _drawJavaIslandDetail(canvas, size, islandShadow, islandFill, coastlineStroke);
    }
  }

  void _drawIndonesiaArchipelago(
    Canvas canvas,
    Size size,
    Paint shadowPaint,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final w = size.width;
    final h = size.height;

    // --- 1. SUMATERA ---
    final sumatra = Path()
      ..moveTo(w * 0.07, h * 0.26) // Banda Aceh
      ..lineTo(w * 0.12, h * 0.24)
      ..lineTo(w * 0.16, h * 0.35) // Medan
      ..lineTo(w * 0.21, h * 0.48) // Riau
      ..lineTo(w * 0.25, h * 0.58) // Palembang
      ..lineTo(w * 0.28, h * 0.68) // Lampung
      ..lineTo(w * 0.26, h * 0.70)
      ..lineTo(w * 0.22, h * 0.62) // Bengkulu
      ..lineTo(w * 0.16, h * 0.48) // Padang / Minang
      ..lineTo(w * 0.10, h * 0.36)
      ..close();

    // --- 2. JAWA & MADURA ---
    final java = Path()
      ..moveTo(w * 0.265, h * 0.72) // Anyer / Banten
      ..lineTo(w * 0.30, h * 0.71) // Jakarta
      ..lineTo(w * 0.34, h * 0.72) // Cirebon
      ..lineTo(w * 0.39, h * 0.73) // Semarang
      ..lineTo(w * 0.44, h * 0.74) // Surabaya
      ..lineTo(w * 0.48, h * 0.77) // Banyuwangi
      ..lineTo(w * 0.47, h * 0.81) // South coast
      ..lineTo(w * 0.41, h * 0.80) // Yogyakarta
      ..lineTo(w * 0.36, h * 0.79) // Cilacap / Banyumas
      ..lineTo(w * 0.30, h * 0.77) // Pangandaran / Pelabuhan Ratu
      ..close();

    final madura = Path()
      ..addOval(Rect.fromLTWH(w * 0.42, h * 0.70, w * 0.05, h * 0.035));

    // --- 3. KALIMANTAN ---
    final kalimantan = Path()
      ..moveTo(w * 0.33, h * 0.34) // Sambas / Pontianak
      ..lineTo(w * 0.39, h * 0.26) // Sarawak border
      ..lineTo(w * 0.45, h * 0.28) // Nunukan
      ..lineTo(w * 0.47, h * 0.38) // Berau
      ..lineTo(w * 0.46, h * 0.48) // Balikpapan
      ..lineTo(w * 0.44, h * 0.58) // Banjarmasin
      ..lineTo(w * 0.37, h * 0.58) // Kumai
      ..lineTo(w * 0.32, h * 0.52)
      ..lineTo(w * 0.31, h * 0.42)
      ..close();

    // --- 4. SULAWESI (4 Peninsulas) ---
    final sulawesi = Path()
      ..moveTo(w * 0.55, h * 0.26)
      ..lineTo(w * 0.60, h * 0.22) // Manado
      ..lineTo(w * 0.60, h * 0.28)
      ..lineTo(w * 0.56, h * 0.34) // Palu hub
      ..lineTo(w * 0.62, h * 0.40) // Luwuk
      ..lineTo(w * 0.59, h * 0.44)
      ..lineTo(w * 0.60, h * 0.54) // Kendari
      ..lineTo(w * 0.57, h * 0.56)
      ..lineTo(w * 0.55, h * 0.48)
      ..lineTo(w * 0.54, h * 0.62) // South Sulawesi / Makassar
      ..lineTo(w * 0.51, h * 0.58)
      ..lineTo(w * 0.52, h * 0.42) // Mamuju
      ..close();

    // --- 5. NUSA TENGGARA (Bali, Lombok, Sumbawa, Flores, Timor) ---
    final bali = Path()..addOval(Rect.fromLTWH(w * 0.49, h * 0.77, w * 0.024, h * 0.025));
    final lombok = Path()..addOval(Rect.fromLTWH(w * 0.52, h * 0.77, w * 0.022, h * 0.025));
    final sumbawa = Path()..addOval(Rect.fromLTWH(w * 0.55, h * 0.76, w * 0.045, h * 0.025));
    final flores = Path()..addOval(Rect.fromLTWH(w * 0.61, h * 0.75, w * 0.055, h * 0.025));
    final sumba = Path()..addOval(Rect.fromLTWH(w * 0.59, h * 0.81, w * 0.04, h * 0.025));
    final timor = Path()..addOval(Rect.fromLTWH(w * 0.68, h * 0.78, w * 0.05, h * 0.03));

    // --- 6. MALUKU ---
    final halmahera = Path()
      ..moveTo(w * 0.65, h * 0.28)
      ..lineTo(w * 0.68, h * 0.24)
      ..lineTo(w * 0.69, h * 0.35)
      ..lineTo(w * 0.65, h * 0.34)
      ..close();
    final seram = Path()..addOval(Rect.fromLTWH(w * 0.66, h * 0.48, w * 0.06, h * 0.025));

    // --- 7. PAPUA ---
    final papua = Path()
      ..moveTo(w * 0.74, h * 0.38) // Sorong / Kepala Burung
      ..lineTo(w * 0.78, h * 0.34) // Teluk Cenderawasih
      ..lineTo(w * 0.86, h * 0.39) // Jayapura
      ..lineTo(w * 0.86, h * 0.64) // Merauke
      ..lineTo(w * 0.81, h * 0.62)
      ..lineTo(w * 0.78, h * 0.50) // Mimika
      ..lineTo(w * 0.74, h * 0.46)
      ..close();

    final allPaths = [
      sumatra,
      java,
      madura,
      kalimantan,
      sulawesi,
      bali,
      lombok,
      sumbawa,
      flores,
      sumba,
      timor,
      halmahera,
      seram,
      papua,
    ];

    // Draw Shadows
    for (final p in allPaths) {
      canvas.drawPath(p, shadowPaint);
    }
    // Draw Land Fills
    for (final p in allPaths) {
      canvas.drawPath(p, fillPaint);
    }
    // Draw Coastline Outlines
    for (final p in allPaths) {
      canvas.drawPath(p, strokePaint);
    }
  }

  void _drawJavaIslandDetail(
    Canvas canvas,
    Size size,
    Paint shadowPaint,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final w = size.width;
    final h = size.height;

    // Detailed Java Path with Tatar Pasundan prominent in the west
    final javaDetail = Path()
      ..moveTo(w * 0.04, h * 0.44) // Ujung Kulon
      ..lineTo(w * 0.12, h * 0.32) // Banten / Teluk Banten
      ..lineTo(w * 0.22, h * 0.34) // Teluk Jakarta & Karawang
      ..lineTo(w * 0.34, h * 0.38) // Cirebon
      ..lineTo(w * 0.46, h * 0.40) // Tegal / Pekalongan
      ..lineTo(w * 0.58, h * 0.36) // Semarang & Jepara
      ..lineTo(w * 0.70, h * 0.42) // Rembang / Tuban
      ..lineTo(w * 0.84, h * 0.46) // Surabaya / Gresik
      ..lineTo(w * 0.94, h * 0.54) // Banyuwangi / Baluran
      ..lineTo(w * 0.90, h * 0.72) // Grajagan / Jember Selatan
      ..lineTo(w * 0.76, h * 0.68) // Blitar / Pacitan
      ..lineTo(w * 0.60, h * 0.66) // Yogyakarta / Parangtritis
      ..lineTo(w * 0.48, h * 0.64) // Cilacap / Kebumen
      ..lineTo(w * 0.34, h * 0.66) // Pangandaran / Tasikmalaya Selatan
      ..lineTo(w * 0.20, h * 0.64) // Garut & Sukabumi Selatan
      ..lineTo(w * 0.08, h * 0.58) // Pelabuhan Ratu
      ..close();

    final maduraDetail = Path()
      ..addOval(Rect.fromLTWH(w * 0.74, h * 0.32, w * 0.18, h * 0.14));

    // Pasundan Region Highlight Shape (Western Java)
    final pasundanHighlight = Paint()
      ..color = AppColors.goldenYellow.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final paths = [javaDetail, maduraDetail];

    for (final p in paths) {
      canvas.drawPath(p, shadowPaint);
    }
    for (final p in paths) {
      canvas.drawPath(p, fillPaint);
    }
    // Draw Pasundan highlight overlay
    canvas.drawCircle(Offset(w * 0.26, h * 0.48), w * 0.15, pasundanHighlight);

    for (final p in paths) {
      canvas.drawPath(p, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _IndonesiaMapPainter oldDelegate) {
    return oldDelegate.viewMode != viewMode;
  }
}
