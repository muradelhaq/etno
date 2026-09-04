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

    // 1. Draw subtle ocean graticule gridlines
    final gridPaint = Paint()
      ..color = const Color(0xFF64B5F6).withValues(alpha: 0.22)
      ..strokeWidth = 0.6;

    for (double x = 0; x < w; x += w / 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += h / 6) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // 2. Equator Line (Garis Khatulistiwa 0° - approx h * 0.44 on Indonesia map)
    if (viewMode == MapViewMode.indonesia) {
      final equatorPaint = Paint()
        ..color = const Color(0xFFE76F51).withValues(alpha: 0.4)
        ..strokeWidth = 0.9
        ..style = PaintingStyle.stroke;
      
      const dashWidth = 4.0;
      const dashSpace = 3.0;
      double startX = 0;
      final yEq = h * 0.44;
      while (startX < w) {
        canvas.drawLine(Offset(startX, yEq), Offset(startX + dashWidth, yEq), equatorPaint);
        startX += dashWidth + dashSpace;
      }
    }

    // 3. Island Paints
    final islandFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF52B788),
          Color(0xFF2D6A4F),
          Color(0xFF1B4332),
        ],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final coastalGlow = Paint()
      ..color = const Color(0xFF80CBC4).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeJoin = StrokeJoin.round;

    final coastlineStroke = Paint()
      ..color = const Color(0xFF081C15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeJoin = StrokeJoin.round;

    final islandShadow = Paint()
      ..color = const Color(0xFF081C15).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);

    final mountainRidgePaint = Paint()
      ..color = const Color(0xFF74C69D).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    if (viewMode == MapViewMode.indonesia) {
      _drawIndonesiaArchipelago(
        canvas,
        size,
        islandShadow,
        coastalGlow,
        islandFill,
        coastlineStroke,
        mountainRidgePaint,
      );
    } else {
      _drawJavaIslandDetail(
        canvas,
        size,
        islandShadow,
        coastalGlow,
        islandFill,
        coastlineStroke,
        mountainRidgePaint,
      );
    }
  }

  void _drawIndonesiaArchipelago(
    Canvas canvas,
    Size size,
    Paint shadowPaint,
    Paint coastalPaint,
    Paint fillPaint,
    Paint strokePaint,
    Paint ridgePaint,
  ) {
    final w = size.width;
    final h = size.height;

    // 1. SUMATERA (Smooth authentic curve from Aceh to Lampung)
    final sumatra = Path()
      ..moveTo(w * 0.065, h * 0.24) // Aceh tip (Banda Aceh)
      ..quadraticBezierTo(w * 0.09, h * 0.22, w * 0.11, h * 0.25)
      ..cubicTo(w * 0.14, h * 0.31, w * 0.18, h * 0.40, w * 0.21, h * 0.48) // East Coast (Medan to Riau)
      ..cubicTo(w * 0.23, h * 0.53, w * 0.26, h * 0.58, w * 0.275, h * 0.65) // Palembang to Lampung
      ..quadraticBezierTo(w * 0.27, h * 0.68, w * 0.255, h * 0.67) // Sunda Strait tip
      ..cubicTo(w * 0.23, h * 0.62, w * 0.19, h * 0.52, w * 0.15, h * 0.44) // Bengkulu - Padang West Coast
      ..cubicTo(w * 0.12, h * 0.37, w * 0.08, h * 0.30, w * 0.065, h * 0.24)
      ..close();

    // Bangka & Belitung
    final bangka = Path()
      ..addOval(Rect.fromLTWH(w * 0.265, h * 0.50, w * 0.016, h * 0.038));
    final belitung = Path()
      ..addOval(Rect.fromLTWH(w * 0.288, h * 0.53, w * 0.014, h * 0.022));
    final niasMentawai = Path()
      ..addOval(Rect.fromLTWH(w * 0.095, h * 0.37, w * 0.012, h * 0.024))
      ..addOval(Rect.fromLTWH(w * 0.125, h * 0.47, w * 0.014, h * 0.032));

    // 2. JAWA & MADURA (Elongated authentic curve)
    final java = Path()
      ..moveTo(w * 0.262, h * 0.70) // Ujung Kulon / Banten
      ..quadraticBezierTo(w * 0.285, h * 0.685, w * 0.31, h * 0.69) // Jakarta / Karawang Bay
      ..quadraticBezierTo(w * 0.35, h * 0.70, w * 0.38, h * 0.705) // Cirebon - Tegal
      ..quadraticBezierTo(w * 0.40, h * 0.69, w * 0.415, h * 0.70) // Muria Peninsula
      ..cubicTo(w * 0.44, h * 0.72, w * 0.47, h * 0.73, w * 0.485, h * 0.755) // Surabaya to Banyuwangi
      ..quadraticBezierTo(w * 0.475, h * 0.78, w * 0.45, h * 0.775) // South East Java
      ..cubicTo(w * 0.40, h * 0.765, w * 0.34, h * 0.755, w * 0.29, h * 0.745) // South Central & West Java
      ..quadraticBezierTo(w * 0.265, h * 0.735, w * 0.262, h * 0.70)
      ..close();

    final madura = Path()
      ..addOval(Rect.fromLTWH(w * 0.428, h * 0.685, w * 0.038, h * 0.018));

    // 3. KALIMANTAN (Heart-shaped Borneo)
    final kalimantan = Path()
      ..moveTo(w * 0.33, h * 0.36) // Pontianak West
      ..cubicTo(w * 0.34, h * 0.28, w * 0.38, h * 0.25, w * 0.42, h * 0.26) // Sarawak Border North
      ..cubicTo(w * 0.45, h * 0.26, w * 0.47, h * 0.28, w * 0.48, h * 0.33) // Nunukan / Tarakan
      ..cubicTo(w * 0.485, h * 0.38, w * 0.475, h * 0.44, w * 0.47, h * 0.48) // Balikpapan / East Coast
      ..cubicTo(w * 0.46, h * 0.54, w * 0.43, h * 0.57, w * 0.40, h * 0.56) // Banjarmasin South
      ..cubicTo(w * 0.36, h * 0.56, w * 0.33, h * 0.52, w * 0.32, h * 0.45) // Sampit / West Coast
      ..quadraticBezierTo(w * 0.32, h * 0.40, w * 0.33, h * 0.36)
      ..close();

    // 4. SULAWESI (Iconic 4-peninsula orchid shape)
    final sulawesi = Path()
      ..moveTo(w * 0.525, h * 0.39) // Central Hub
      ..quadraticBezierTo(w * 0.54, h * 0.30, w * 0.565, h * 0.22) // North Peninsula (Gorontalo)
      ..quadraticBezierTo(w * 0.585, h * 0.19, w * 0.595, h * 0.22) // Manado / Minahasa Tip
      ..quadraticBezierTo(w * 0.57, h * 0.28, w * 0.545, h * 0.35)
      ..cubicTo(w * 0.58, h * 0.36, w * 0.62, h * 0.38, w * 0.63, h * 0.41) // East Peninsula (Banggai)
      ..quadraticBezierTo(w * 0.60, h * 0.43, w * 0.555, h * 0.42) // Teluk Tolo
      ..cubicTo(w * 0.57, h * 0.48, w * 0.59, h * 0.53, w * 0.585, h * 0.58) // Southeast Peninsula (Kendari)
      ..quadraticBezierTo(w * 0.565, h * 0.57, w * 0.545, h * 0.48) // Teluk Bone
      ..cubicTo(w * 0.535, h * 0.54, w * 0.53, h * 0.60, w * 0.518, h * 0.62) // South Peninsula (Makassar)
      ..quadraticBezierTo(w * 0.505, h * 0.58, w * 0.515, h * 0.46) // Toraja
      ..quadraticBezierTo(w * 0.51, h * 0.42, w * 0.525, h * 0.39)
      ..close();

    // 5. BALI & KEPULAUAN NUSA TENGGARA
    final bali = Path()
      ..addOval(Rect.fromLTWH(w * 0.492, h * 0.755, w * 0.022, h * 0.018));
    final lombok = Path()
      ..addOval(Rect.fromLTWH(w * 0.520, h * 0.755, w * 0.020, h * 0.018));
    final sumbawa = Path()
      ..moveTo(w * 0.545, h * 0.75)
      ..lineTo(w * 0.585, h * 0.745)
      ..lineTo(w * 0.58, h * 0.765)
      ..lineTo(w * 0.545, h * 0.765)
      ..close();
    final flores = Path()
      ..moveTo(w * 0.595, h * 0.74)
      ..lineTo(w * 0.645, h * 0.735)
      ..lineTo(w * 0.64, h * 0.755)
      ..lineTo(w * 0.595, h * 0.755)
      ..close();
    final sumba = Path()
      ..addOval(Rect.fromLTWH(w * 0.585, h * 0.79, w * 0.034, h * 0.020));
    final timor = Path()
      ..moveTo(w * 0.665, h * 0.76)
      ..lineTo(w * 0.71, h * 0.745)
      ..lineTo(w * 0.705, h * 0.775)
      ..lineTo(w * 0.66, h * 0.78)
      ..close();

    // 6. KEPULAUAN MALUKU
    final halmahera = Path()
      ..moveTo(w * 0.655, h * 0.25)
      ..lineTo(w * 0.67, h * 0.21)
      ..lineTo(w * 0.675, h * 0.26)
      ..lineTo(w * 0.69, h * 0.28)
      ..lineTo(w * 0.67, h * 0.31)
      ..lineTo(w * 0.655, h * 0.33)
      ..close();
    final buru = Path()
      ..addOval(Rect.fromLTWH(w * 0.628, h * 0.445, w * 0.026, h * 0.022));
    final seram = Path()
      ..moveTo(w * 0.66, h * 0.44)
      ..lineTo(w * 0.71, h * 0.445)
      ..lineTo(w * 0.705, h * 0.47)
      ..lineTo(w * 0.655, h * 0.46)
      ..close();
    final aru = Path()
      ..addOval(Rect.fromLTWH(w * 0.735, h * 0.58, w * 0.022, h * 0.032));

    // 7. PAPUA (Kepala Burung & Main Landmass)
    final papua = Path()
      ..moveTo(w * 0.735, h * 0.35) // Vogelkop / Sorong
      ..quadraticBezierTo(w * 0.755, h * 0.31, w * 0.775, h * 0.34) // Manokwari
      ..quadraticBezierTo(w * 0.76, h * 0.41, w * 0.79, h * 0.41) // Cenderawasih Bay Neck
      ..cubicTo(w * 0.83, h * 0.40, w * 0.88, h * 0.41, w * 0.905, h * 0.43) // Jayapura North Coast
      ..lineTo(w * 0.905, h * 0.65) // PNG Border East
      ..cubicTo(w * 0.87, h * 0.66, w * 0.82, h * 0.64, w * 0.80, h * 0.58) // Merauke - Timika South
      ..quadraticBezierTo(w * 0.77, h * 0.53, w * 0.75, h * 0.45) // Bomberai Peninsula
      ..quadraticBezierTo(w * 0.725, h * 0.42, w * 0.735, h * 0.35)
      ..close();

    final allLandmasses = [
      sumatra,
      bangka,
      belitung,
      niasMentawai,
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
      buru,
      seram,
      aru,
      papua,
    ];

    // Layer A: Drop Shadow
    for (final p in allLandmasses) {
      canvas.drawPath(p, shadowPaint);
    }
    // Layer B: Coastal Turquoise Glow
    for (final p in allLandmasses) {
      canvas.drawPath(p, coastalPaint);
    }
    // Layer C: Lush Emerald Land Fill
    for (final p in allLandmasses) {
      canvas.drawPath(p, fillPaint);
    }

    // Layer D: Topographic Mountain Ridges
    // Bukit Barisan on Sumatra
    final sumatraRidge = Path()
      ..moveTo(w * 0.08, h * 0.27)
      ..lineTo(w * 0.14, h * 0.42)
      ..lineTo(w * 0.22, h * 0.58)
      ..lineTo(w * 0.26, h * 0.66);
    canvas.drawPath(sumatraRidge, ridgePaint);

    // Java Volcanic Spine
    final javaRidge = Path()
      ..moveTo(w * 0.28, h * 0.72)
      ..lineTo(w * 0.36, h * 0.735)
      ..lineTo(w * 0.44, h * 0.75);
    canvas.drawPath(javaRidge, ridgePaint);

    // Jayawijaya Range on Papua
    final papuaRidge = Path()
      ..moveTo(w * 0.79, h * 0.47)
      ..lineTo(w * 0.85, h * 0.49)
      ..lineTo(w * 0.89, h * 0.50);
    canvas.drawPath(papuaRidge, ridgePaint);

    // Layer E: Crisp Coastline Border Stroke
    for (final p in allLandmasses) {
      canvas.drawPath(p, strokePaint);
    }
  }

  void _drawJavaIslandDetail(
    Canvas canvas,
    Size size,
    Paint shadowPaint,
    Paint coastalPaint,
    Paint fillPaint,
    Paint strokePaint,
    Paint ridgePaint,
  ) {
    final w = size.width;
    final h = size.height;

    // Detailed Zoom of Pulau Jawa
    final javaDetail = Path()
      ..moveTo(w * 0.05, h * 0.48) // Ujung Kulon / Banten
      ..quadraticBezierTo(w * 0.12, h * 0.35, w * 0.22, h * 0.36) // Teluk Banten & Jakarta
      ..quadraticBezierTo(w * 0.32, h * 0.38, w * 0.42, h * 0.40) // Cirebon
      ..quadraticBezierTo(w * 0.52, h * 0.35, w * 0.58, h * 0.38) // Semenanjung Muria / Jepara
      ..cubicTo(w * 0.68, h * 0.42, w * 0.78, h * 0.44, w * 0.88, h * 0.52) // Surabaya / Pasuruan
      ..quadraticBezierTo(w * 0.94, h * 0.56, w * 0.95, h * 0.62) // Selat Bali / Banyuwangi
      ..quadraticBezierTo(w * 0.91, h * 0.70, w * 0.82, h * 0.68) // Blambangan South
      ..cubicTo(w * 0.70, h * 0.65, w * 0.58, h * 0.63, w * 0.46, h * 0.62) // South Central Java
      ..cubicTo(w * 0.34, h * 0.64, w * 0.22, h * 0.63, w * 0.12, h * 0.59) // Pelabuhan Ratu
      ..quadraticBezierTo(w * 0.06, h * 0.55, w * 0.05, h * 0.48)
      ..close();

    final maduraDetail = Path()
      ..moveTo(w * 0.72, h * 0.35)
      ..lineTo(w * 0.88, h * 0.37)
      ..lineTo(w * 0.87, h * 0.43)
      ..lineTo(w * 0.71, h * 0.41)
      ..close();

    final baliDetail = Path()
      ..addOval(Rect.fromLTWH(w * 0.95, h * 0.60, w * 0.045, h * 0.045));

    final paths = [javaDetail, maduraDetail, baliDetail];

    for (final p in paths) {
      canvas.drawPath(p, shadowPaint);
    }
    for (final p in paths) {
      canvas.drawPath(p, coastalPaint);
    }
    for (final p in paths) {
      canvas.drawPath(p, fillPaint);
    }

    // Pasundan & Banyumas Regional Glow Zone
    final westJavaGlow = Paint()
      ..color = AppColors.goldenYellow.withValues(alpha: 0.20)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.27, h * 0.50), w * 0.16, westJavaGlow);

    // Mountain Spine across Java (Salak, Gede, Tangkuban Perahu, Ciremai, Slamet, Merapi, Semeru)
    final javaSpine = Path()
      ..moveTo(w * 0.14, h * 0.52)
      ..lineTo(w * 0.26, h * 0.50)
      ..lineTo(w * 0.38, h * 0.52)
      ..lineTo(w * 0.52, h * 0.53)
      ..lineTo(w * 0.68, h * 0.55)
      ..lineTo(w * 0.84, h * 0.59);
    canvas.drawPath(javaSpine, ridgePaint..strokeWidth = 1.6);

    for (final p in paths) {
      canvas.drawPath(p, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant IndonesiaMapPainter oldDelegate) {
    return oldDelegate.viewMode != viewMode;
  }
}
