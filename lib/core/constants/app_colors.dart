import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Dark Theme Palette
  static const Color background = Color(0xFF070A12);
  static const Color ink = Color(0xFF070A12);
  static const Color panel = Color(0xFF0A0F1B);
  static const Color panelLight = Color(0xFF0D1322);
  static const Color border = Color(0xFF232B44);
  static const Color cardBorder = Color(0xFF232B44);

  // Text
  static const Color textPrimary = Color(0xFFF4F7FB);
  static const Color paper = Color(0xFFF4F7FB);
  static const Color bodyText = Color(0xFFB8C2D6);
  static const Color muted = Color(0xFFB8C2D6);

  // Single Accent Cyan
  static const Color accent = Color(0xFF22D3EE);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color lime = Color(
    0xFF22D3EE,
  ); // Mapping lime references to primary accent cyan for design consistency

  // Mockup Frame Colors
  static const Color mockupBezelOuter = Color(0xFF131B2E);
  static const Color mockupBezelInner = Color(0xFF0A0F1B);
  static const Color mockupCameraPin = Color(0xFF070A12);
  static const Color mockupGlare = Color(0x18FFFFFF);

  /// Safe alpha color helper compatible across Flutter versions
  static Color withAlphaOpacity(Color color, double opacity) {
    return Color.fromARGB(
      (opacity * 255).round().clamp(0, 255).toInt(),
      // ignore: deprecated_member_use
      color.red,
      // ignore: deprecated_member_use
      color.green,
      // ignore: deprecated_member_use
      color.blue,
    );
  }
}
