import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF10B981);
  static const Color accent = Color(0xFF8B5CF6);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textWhite = Colors.white;

  // Border and Divider Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Nepal flag colors
  static const Color nepalRed = Color(0xFFDC143C);
  static const Color nepalBlue = Color(0xFF003893);
  static const Color nepalBlueDark = Color(0xFF0D47A1);
  static const Color nepalBlueLight = Color(0xFF1976D2);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [nepalRed, nepalBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color appBarBackgroundColor = Color.fromARGB(255, 138, 149, 164);
  static const LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 55, 67, 84),
      Color.fromARGB(255, 138, 149, 164),
    ],
  );

  static LinearGradient get heroGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          nepalBlue.withAlpha((0.1 * 255).toInt()),
          nepalBlueDark.withAlpha((0.2 * 255).toInt()),
        ],
      );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  //membership gradient
  static LinearGradient membershipGradient = LinearGradient(
    colors: [Colors.purple.shade500, Colors.pink.shade600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
