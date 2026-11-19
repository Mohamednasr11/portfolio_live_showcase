import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // ───────────── Dark theme: neutral surfaces ─────────────
  static const Color background = Color(0xFF0B0D12);
  static const Color ink = Color(0xFF0B0D12);
  static const Color panel = Color(0xFF12151C);
  static const Color panelLight = Color(0xFF181C26);
  static const Color border = Color(0xFF222733);
  static const Color cardBorder = Color(0xFF222733);

  // ───────────── Dark theme: text ─────────────
  static const Color textPrimary = Color(0xFFF2F4F8);
  static const Color paper = Color(0xFFF2F4F8);
  static const Color bodyText = Color(0xFFB4BCCB); // paragraphs
  static const Color muted = Color(0xFF7F8A9E); // captions / meta only

  // ───────────── Brand accent (CTA + labels only) ─────────────
  static const Color accent = Color(0xFF22D3EE);
  static const Color accentHot = Color(0xFF67E8F9); // hover
  static const Color accentSoft = Color(0x1F22D3EE); // chip background
  static const Color cyan = Color(0xFF22D3EE);
  static const Color lime = Color(0xFF22D3EE); // kept for old references

  // ───────────── Per-project colors (top bar + hover border) ─────────────
  static const Color projectMatjarkom = Color(0xFF6366F1);
  static const Color projectBuildGuard = Color(0xFFF97316);
  static const Color projectBrewBloom = Color(0xFFC98A5B);
  static const Color projectTrustSafe = Color(0xFF94A3B8);

  // ───────────── Light theme ─────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightPanel = Color(0xFFFFFFFF);
  static const Color lightPanelAlt = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightBodyText = Color(0xFF334155);
  static const Color lightMuted = Color(0xFF64748B);
  static const Color lightAccent = Color(0xFF0891B2); // darker for contrast
  static const Color lightAccentSoft = Color(0x1A0891B2);

  // ───────────── Mockup frame ─────────────
  static const Color mockupBezelOuter = Color(0xFF181C26);
  static const Color mockupBezelInner = Color(0xFF0B0D12);
  static const Color mockupCameraPin = Color(0xFF0B0D12);
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