import 'package:flutter/material.dart';

class AppColors {
  // Brand / Theme Colors
  static const Color primaryGreen = Color(0xFF2D6A4F);
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color primaryLight = Color(0xFF52B788);
  static const Color sageLight = Color(0xFFD8F3DC);
  static const Color sageBackground = Color(0xFFE8F5E9);

  // Warm Accents
  static const Color warmTerracotta = Color(0xFFBC6C25);
  static const Color terracottaDark = Color(0xFF99582A);
  static const Color goldenYellow = Color(0xFFDDA15E);
  static const Color warmCream = Color(0xFFFEFAE0);
  static const Color creamLight = Color(0xFFFFFDF5);

  // Neutral Colors
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9F9F4);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFCBD5E1);

  // Feedback Colors
  static const Color errorRed = Color(0xFFE63946);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color successGreen = Color(0xFF2A9D8F);
  static const Color successLight = Color(0xFFE0F2F1);
  static const Color warningOrange = Color(0xFFF4A261);
  static const Color infoBlue = Color(0xFF457B9D);
  static const Color infoLight = Color(0xFFE1F5FE);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [goldenYellow, warmTerracotta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, warmCream],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
