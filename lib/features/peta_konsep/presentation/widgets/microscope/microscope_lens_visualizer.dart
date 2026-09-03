import 'dart:math' as math;
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
  final bool showReticle;
  final bool isIlluminated;

  const MicroscopeLensVisualizer({
    super.key,
    required this.activeMicrobe,
    required this.zoom,
    required this.lensSize,
    required this.isLandscape,
    this.showReticle = true,
    this.isIlluminated = true,
  });

  String _getScaleText() {
    if (zoom <= 150) return '200 µm';
    if (zoom <= 300) return '100 µm';
    if (zoom <= 600) return '50 µm';
    if (zoom <= 850) return '20 µm';
    return '10 µm';
  }

  @override
  Widget build(BuildContext context) {
    final t = ((zoom - 100.0) / 900.0).clamp(0.0, 1.0);
    final foodOpacity = (1.0 - t * 2.2).clamp(0.0, 1.0);
    final foodScale = 1.0 + t * 1.8;
    final microbeOpacity = (t * 2.0).clamp(0.0, 1.0);
    final microbeScale = 0.75 + t * 0.75;
    final beforeZoomImage = activeMicrobe.beforeZoomImage;
    final afterZoomImage = activeMicrobe.afterZoomImage;

    final outerBezelSize = lensSize + (isLandscape ? 24.0 : 32.0);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Outer Mechanical Bezel & Knurled Rim
          Container(
            width: outerBezelSize,
            height: outerBezelSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFF2A3D33),
                  Color(0xFF1B2E24),
                  Color(0xFF0F1C15),
                  Color(0xFF08100C),
                ],
                stops: [0.70, 0.85, 0.95, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: isIlluminated
                      ? AppColors.primaryLight.withValues(alpha: 0.30)
                      : Colors.black54,
                  blurRadius: isIlluminated ? 22 : 12,
                  spreadRadius: isIlluminated ? 3 : 0,
                ),
                const BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: isIlluminated
                    ? AppColors.primaryLight.withValues(alpha: 0.6)
                    : const Color(0xFF2C3E35),
                width: 2.5,
              ),
            ),
            child: CustomPaint(
              painter: _BezelGraduationPainter(
                color: isIlluminated
                    ? AppColors.primaryLight.withValues(alpha: 0.35)
                    : Colors.white12,
              ),
            ),
          ),

          // 2. Optical Lens Viewport (Circular Crop)
          Container(
            width: lensSize,
            height: lensSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF183325),
                width: 2.0,
              ),
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  // Dark base layer
                  Container(color: const Color(0xFF07110C)),

                  // Specimen Before Zoom (Macro Food Sample)
                  if (foodOpacity > 0.01)
                    Opacity(
                      opacity: foodOpacity,
                      child: Transform.scale(
                        scale: foodScale,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            isIlluminated
                                ? Colors.transparent
                                : Colors.black.withValues(alpha: 0.45),
                            BlendMode.darken,
                          ),
                          child: AppImage(
                            beforeZoomImage,
                            width: lensSize,
                            height: lensSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF1E2D24),
                              child: const Center(
                                child: Icon(
                                  Icons.biotech_rounded,
                                  color: Colors.white38,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Specimen After Zoom (Microscopic Cellular Structure)
                  if (microbeOpacity > 0.01)
                    Opacity(
                      opacity: microbeOpacity,
                      child: Transform.scale(
                        scale: microbeScale,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            isIlluminated
                                ? Colors.transparent
                                : Colors.black.withValues(alpha: 0.45),
                            BlendMode.darken,
                          ),
                          child: AppImage(
                            afterZoomImage,
                            width: lensSize,
                            height: lensSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF14241B),
                              child: const Center(
                                child: Icon(
                                  Icons.scatter_plot_rounded,
                                  color: AppColors.primaryLight,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 3. Vignette Optical Shadow (Barrel Light Falloff)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.88,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.70),
                          ],
                          stops: const [0.65, 0.85, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // 4. Reticle & Measurement Scale (Toggleable)
                  if (showReticle)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MicroscopeReticlePainter(),
                      ),
                    ),

                  // 5. Specular Glare Reflection (Lens curvature sheen)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: const Alignment(-0.8, -0.9),
                            end: const Alignment(0.8, 0.9),
                            colors: [
                              Colors.white.withValues(alpha: 0.12),
                              Colors.white.withValues(alpha: 0.03),
                              Colors.transparent,
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.22, 0.40, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 6. Floating Specimen Stage & Zoom Pill (Top Center HUD)
                  Positioned(
                    top: isLandscape ? 8 : 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.80),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: zoom <= 250
                              ? AppColors.goldenYellow.withValues(alpha: 0.75)
                              : (zoom <= 700
                                  ? AppColors.warningOrange.withValues(alpha: 0.85)
                                  : AppColors.primaryLight.withValues(alpha: 0.85)),
                          width: 0.9,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            zoom <= 250
                                ? Icons.restaurant_rounded
                                : (zoom <= 700
                                    ? Icons.search_rounded
                                    : Icons.grain_rounded),
                            size: 11,
                            color: zoom <= 250
                                ? AppColors.goldenYellow
                                : (zoom <= 700
                                    ? AppColors.warningOrange
                                    : AppColors.primaryLight),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            zoom <= 250
                                ? 'Preparat Makro'
                                : (zoom <= 700
                                    ? 'Fase Transisi'
                                    : 'Morfologi Seluler'),
                            style: TextStyle(
                              color: zoom <= 250
                                  ? AppColors.goldenYellow
                                  : (zoom <= 700
                                      ? AppColors.warningOrange
                                      : AppColors.primaryLight),
                              fontSize: isLandscape ? 8.5 : 9.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 1,
                            height: 10,
                            color: Colors.white24,
                          ),
                          Text(
                            '${zoom.toInt()}x',
                            style: AppTextStyles.scientificFormula.copyWith(
                              color: AppColors.sageLight,
                              fontSize: isLandscape ? 8.5 : 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 7. Scale Bar Indicator (Bottom Center HUD)
                  if (showReticle)
                    Positioned(
                      bottom: isLandscape ? 8 : 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white24,
                            width: 0.6,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 14,
                              height: 1.5,
                              color: AppColors.goldenYellow,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _getScaleText(),
                              style: const TextStyle(
                                color: AppColors.goldenYellow,
                                fontSize: 8.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 14,
                              height: 1.5,
                              color: AppColors.goldenYellow,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for mechanical bezel graduation tick marks
class _BezelGraduationPainter extends CustomPainter {
  final Color color;

  _BezelGraduationPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const totalTicks = 36;
    for (int i = 0; i < totalTicks; i++) {
      final angle = (i * 2 * math.pi) / totalTicks;
      final isMajor = i % 3 == 0;
      final tickLength = isMajor ? 5.0 : 3.0;

      final startX = center.dx + (radius - 2) * math.cos(angle);
      final startY = center.dy + (radius - 2) * math.sin(angle);
      final endX = center.dx + (radius - 2 - tickLength) * math.cos(angle);
      final endY = center.dy + (radius - 2 - tickLength) * math.sin(angle);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BezelGraduationPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Custom painter for scientific microscope reticle crosshair and concentric calibration rings
class _MicroscopeReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final fineLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..strokeWidth = 0.7;

    // Center Crosshairs (with gap in the absolute center)
    const centerGap = 12.0;

    // Horizontal
    canvas.drawLine(
      Offset(15, center.dy),
      Offset(center.dx - centerGap, center.dy),
      fineLinePaint,
    );
    canvas.drawLine(
      Offset(center.dx + centerGap, center.dy),
      Offset(size.width - 15, center.dy),
      fineLinePaint,
    );

    // Vertical
    canvas.drawLine(
      Offset(center.dx, 15),
      Offset(center.dx, center.dy - centerGap),
      fineLinePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + centerGap),
      Offset(center.dx, size.height - 15),
      fineLinePaint,
    );

    // Concentric calibration rings
    canvas.drawCircle(center, radius * 0.35, ringPaint);
    canvas.drawCircle(center, radius * 0.70, ringPaint);
    canvas.drawCircle(center, 4.0, ringPaint..style = PaintingStyle.stroke);

    // Crosshair ticks
    for (double offset = 20; offset < radius - 20; offset += 15) {
      // Horizontal ticks
      canvas.drawLine(
        Offset(center.dx + offset, center.dy - 2.5),
        Offset(center.dx + offset, center.dy + 2.5),
        tickPaint,
      );
      canvas.drawLine(
        Offset(center.dx - offset, center.dy - 2.5),
        Offset(center.dx - offset, center.dy + 2.5),
        tickPaint,
      );

      // Vertical ticks
      canvas.drawLine(
        Offset(center.dx - 2.5, center.dy + offset),
        Offset(center.dx + 2.5, center.dy + offset),
        tickPaint,
      );
      canvas.drawLine(
        Offset(center.dx - 2.5, center.dy - offset),
        Offset(center.dx + 2.5, center.dy - offset),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
