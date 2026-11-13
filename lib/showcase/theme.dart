import 'package:flutter/material.dart';

/// The owner's own portfolio design language, transcribed from
/// D:\MyPortfolio-main\index.html (`:root` tokens, `.phone-frame`, `.hero-tag`,
/// `.section-title`, `.tag`, `.btn-primary`). Nothing here is invented.
class Show {
  const Show._();

  // :root (Original Dark theme tokens - kept static for backward compatibility)
  static const Color bg = Color(0xFF060810);
  static const Color surface = Color(0xFF0D1120);
  static const Color surfaceAlt = Color(0xFF111827);
  static const Color accent = Color(0xFF00D4FF);
  static const Color accent2 = Color(0xFF7B61FF);
  static const Color accent3 = Color(0xFF00FF88);
  static const Color text = Color(0xFFF0F4FF);
  static const Color muted = Color(0xFF6B7A9F);
  static const Color border = Color(0x1F00D4FF); // rgba(0,212,255,0.12)

  // .btn-primary:hover
  static const Color accentHot = Color(0xFF00E8FF);

  // Light mode color equivalents
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF1F5F9);
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightMuted = Color(0xFF475569);
  static const Color lightBorder = Color(0x260066CC);

  // Dynamic theme getters
  static Color getBg(bool isDark) => isDark ? bg : lightBg;
  static Color getSurface(bool isDark) => isDark ? surface : lightSurface;
  static Color getSurfaceAlt(bool isDark) => isDark ? surfaceAlt : lightSurfaceAlt;
  static Color getText(bool isDark) => isDark ? text : lightText;
  static Color getMuted(bool isDark) => isDark ? muted : lightMuted;
  static Color getBorder(bool isDark) => isDark ? border : lightBorder;

  // .phone-frame
  static const Color frameShell = Color(0xFF080808);
  static const Color frameRing = Color(0xFF222222); // 0 0 0 2px
  static const Color frameRingOuter = Color(0xFF0F0F0F); // 0 0 0 5px
  static const Color frameEdge = Color(0x0DFFFFFF); // 1px rgba(255,255,255,.05)
  static const Color screenEdge = Color(0x14FFFFFF); // .phone-screen border
  static const Color buttonStub = Color(0xFF1A1A1A); // side keys + notch pill
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
  static const List<String> arabicFallback = ['Cairo'];

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

  /// body — DM Sans 16/1.6.
  static const TextStyle body = TextStyle(
    fontFamily: Show.body,
    fontFamilyFallback: ShowType.arabicFallback,
    color: Show.muted,
    fontSize: 14,
    height: 1.6,
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
