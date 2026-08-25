import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';

enum MapViewMode {
  indonesia,
  pulauJawa,
}

class IndonesiaMapPainter extends CustomPainter {
  final MapViewMode viewMode;

  IndonesiaMapPainter({required this.viewMode});

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
      _drawIndonesiaArchipelago(
          canvas, size, islandShadow, islandFill, coastlineStroke);
    } else {
      _drawJavaIslandDetail(
          canvas, size, islandShadow, islandFill, coastlineStroke);
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

    // 1. SUMATERA
    final sumatra = Path()
      ..moveTo(w * 0.07, h * 0.26)
      ..lineTo(w * 0.12, h * 0.24)
      ..lineTo(w * 0.16, h * 0.35)
      ..lineTo(w * 0.21, h * 0.48)
      ..lineTo(w * 0.25, h * 0.58)
      ..lineTo(w * 0.28, h * 0.68)
      ..lineTo(w * 0.26, h * 0.70)
      ..lineTo(w * 0.22, h * 0.62)
      ..lineTo(w * 0.16, h * 0.48)
      ..lineTo(w * 0.10, h * 0.36)
      ..close();

    // 2. JAWA & MADURA
    final java = Path()
      ..moveTo(w * 0.265, h * 0.72)
      ..lineTo(w * 0.30, h * 0.71)
      ..lineTo(w * 0.34, h * 0.72)
      ..lineTo(w * 0.39, h * 0.73)
      ..lineTo(w * 0.44, h * 0.74)
      ..lineTo(w * 0.48, h * 0.77)
      ..lineTo(w * 0.47, h * 0.81)
      ..lineTo(w * 0.41, h * 0.80)
      ..lineTo(w * 0.36, h * 0.79)
      ..lineTo(w * 0.30, h * 0.77)
      ..close();

    final madura = Path()
      ..addOval(Rect.fromLTWH(w * 0.42, h * 0.70, w * 0.05, h * 0.035));

    // 3. KALIMANTAN
    final kalimantan = Path()
      ..moveTo(w * 0.33, h * 0.34)
      ..lineTo(w * 0.39, h * 0.26)
      ..lineTo(w * 0.45, h * 0.28)
      ..lineTo(w * 0.47, h * 0.38)
      ..lineTo(w * 0.46, h * 0.48)
      ..lineTo(w * 0.44, h * 0.58)
      ..lineTo(w * 0.37, h * 0.58)
      ..lineTo(w * 0.32, h * 0.52)
      ..lineTo(w * 0.31, h * 0.42)
      ..close();

    // 4. SULAWESI (4 Peninsulas)
    final sulawesi = Path()
      ..moveTo(w * 0.55, h * 0.26)
      ..lineTo(w * 0.60, h * 0.22)
      ..lineTo(w * 0.60, h * 0.28)
      ..lineTo(w * 0.56, h * 0.34)
      ..lineTo(w * 0.62, h * 0.40)
      ..lineTo(w * 0.59, h * 0.44)
      ..lineTo(w * 0.60, h * 0.54)
      ..lineTo(w * 0.57, h * 0.56)
      ..lineTo(w * 0.55, h * 0.48)
      ..lineTo(w * 0.54, h * 0.62)
      ..lineTo(w * 0.51, h * 0.58)
      ..lineTo(w * 0.52, h * 0.42)
      ..close();

    // 5. NUSA TENGGARA
    final bali = Path()
      ..addOval(Rect.fromLTWH(w * 0.49, h * 0.77, w * 0.024, h * 0.025));
    final lombok = Path()
      ..addOval(Rect.fromLTWH(w * 0.52, h * 0.77, w * 0.022, h * 0.025));
    final sumbawa = Path()
      ..addOval(Rect.fromLTWH(w * 0.55, h * 0.76, w * 0.045, h * 0.025));
    final flores = Path()
      ..addOval(Rect.fromLTWH(w * 0.61, h * 0.75, w * 0.055, h * 0.025));
    final sumba = Path()
      ..addOval(Rect.fromLTWH(w * 0.59, h * 0.81, w * 0.04, h * 0.025));
    final timor = Path()
      ..addOval(Rect.fromLTWH(w * 0.68, h * 0.78, w * 0.05, h * 0.03));

    // 6. MALUKU
    final halmahera = Path()
      ..moveTo(w * 0.65, h * 0.28)
      ..lineTo(w * 0.68, h * 0.24)
      ..lineTo(w * 0.69, h * 0.35)
      ..lineTo(w * 0.65, h * 0.34)
      ..close();
    final seram = Path()
      ..addOval(Rect.fromLTWH(w * 0.66, h * 0.48, w * 0.06, h * 0.025));

    // 7. PAPUA
    final papua = Path()
      ..moveTo(w * 0.74, h * 0.38)
      ..lineTo(w * 0.78, h * 0.34)
      ..lineTo(w * 0.86, h * 0.39)
      ..lineTo(w * 0.86, h * 0.64)
      ..lineTo(w * 0.81, h * 0.62)
      ..lineTo(w * 0.78, h * 0.50)
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

    for (final p in allPaths) {
      canvas.drawPath(p, shadowPaint);
    }
    for (final p in allPaths) {
      canvas.drawPath(p, fillPaint);
    }
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

    final javaDetail = Path()
      ..moveTo(w * 0.04, h * 0.44)
      ..lineTo(w * 0.12, h * 0.32)
      ..lineTo(w * 0.22, h * 0.34)
      ..lineTo(w * 0.34, h * 0.38)
      ..lineTo(w * 0.46, h * 0.40)
      ..lineTo(w * 0.58, h * 0.36)
      ..lineTo(w * 0.70, h * 0.42)
      ..lineTo(w * 0.84, h * 0.46)
      ..lineTo(w * 0.94, h * 0.54)
      ..lineTo(w * 0.90, h * 0.72)
      ..lineTo(w * 0.76, h * 0.68)
      ..lineTo(w * 0.60, h * 0.66)
      ..lineTo(w * 0.48, h * 0.64)
      ..lineTo(w * 0.34, h * 0.66)
      ..lineTo(w * 0.20, h * 0.64)
      ..lineTo(w * 0.08, h * 0.58)
      ..close();

    final maduraDetail = Path()
      ..addOval(Rect.fromLTWH(w * 0.74, h * 0.32, w * 0.18, h * 0.14));

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
    canvas.drawCircle(Offset(w * 0.26, h * 0.48), w * 0.15, pasundanHighlight);

    for (final p in paths) {
      canvas.drawPath(p, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant IndonesiaMapPainter oldDelegate) {
    return oldDelegate.viewMode != viewMode;
  }
}
