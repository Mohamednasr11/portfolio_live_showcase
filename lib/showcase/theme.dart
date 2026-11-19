import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class Show {
  const Show._();

  // Dark theme tokens (all values come from AppColors, single source of truth)
  static const Color bg = AppColors.background;
  static const Color surface = AppColors.panel;
  static const Color surfaceAlt = AppColors.panelLight;
  static const Color accent = AppColors.accent;
  static const Color accent2 = AppColors.projectMatjarkom; // indigo, for gradients only
  static const Color accent3 = Color(0xFF34D399); // success / positive
  static const Color text = AppColors.textPrimary;
  static const Color bodyText = AppColors.bodyText;
  static const Color muted = AppColors.muted;
  static const Color border = AppColors.border;

  // .btn-primary:hover
  static const Color accentHot = AppColors.accentHot;

  // Light mode equivalents
  static const Color lightBg = AppColors.lightBackground;
  static const Color lightSurface = AppColors.lightPanel;
  static const Color lightSurfaceAlt = AppColors.lightPanelAlt;
  static const Color lightText = AppColors.lightTextPrimary;
  static const Color lightBodyText = AppColors.lightBodyText;
  static const Color lightMuted = AppColors.lightMuted;
  static const Color lightBorder = AppColors.lightBorder;
  static const Color lightAccent = AppColors.lightAccent;

  // Dynamic theme getters
  static Color getBg(bool isDark) => isDark ? bg : lightBg;
  static Color getSurface(bool isDark) => isDark ? surface : lightSurface;
  static Color getSurfaceAlt(bool isDark) =>
      isDark ? surfaceAlt : lightSurfaceAlt;
  static Color getText(bool isDark) => isDark ? text : lightText;
  static Color getBodyText(bool isDark) => isDark ? bodyText : lightBodyText;
  static Color getMuted(bool isDark) => isDark ? muted : lightMuted;
  static Color getBorder(bool isDark) => isDark ? border : lightBorder;
  static Color getAccent(bool isDark) => isDark ? accent : lightAccent;

  // .phone-frame
  static const Color frameShell = Color(0xFF080808);
  static const Color frameRing = Color(0xFF222222);
  static const Color frameRingOuter = Color(0xFF0F0F0F);
  static const Color frameEdge = Color(0x0DFFFFFF);
  static const Color screenEdge = Color(0x14FFFFFF);
  static const Color buttonStub = Color(0xFF1A1A1A);
  static const Color screenBlack = Color(0xFF000000);

  // Fonts the site loads from Google.
  static const String display = 'Syne';
  static const String body = 'DM Sans';
}

Color alpha(Color color, double opacity) =>
    color.withValues(alpha: opacity.clamp(0.0, 1.0));

/// Sizes and weights straight from the site's typographic rules.
class ShowType {
  const ShowType._();

  /// Arabic resolves through this face; Latin stays on the brand font.
  static const List<String> arabicFallback = ['Graphic', 'Cairo'];

  /// .hero-name — Syne 800, line-height 1.05, letter-spacing -2px.
  static const TextStyle display = TextStyle(
    fontFamily: Show.display,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.text,
    fontSize: 58,
    height: 1.05,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
  );

  /// .section-title — Syne 800, line-height 1.1, letter-spacing -1.5px.
  static const TextStyle title = TextStyle(
    fontFamily: Show.display,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.text,
    fontSize: 34,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
  );

  /// .stat-num / .project-title — Syne, heavy, tight.
  static const TextStyle heading = TextStyle(
    fontFamily: Show.display,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.text,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  /// .section-label — DM Sans 600, 12px, +0.1em, uppercase, accent.
  static const TextStyle label = TextStyle(
    fontFamily: Show.body,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.accent,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  /// body — DM Sans 14/1.6, lighter than before for readability.
  static const TextStyle body = TextStyle(
    fontFamily: Show.body,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.bodyText,
    fontSize: 14,
    height: 1.6,
  );

  /// Captions and small notes (the dimmest text level).
  static const TextStyle caption = TextStyle(
    fontFamily: Show.body,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.muted,
    fontSize: 12,
    height: 1.5,
  );

  /// Mono style for meta lines.
  static const TextStyle mono = TextStyle(
    fontFamily: Show.body,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.accent,
    fontSize: 12,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w600,
  );
}