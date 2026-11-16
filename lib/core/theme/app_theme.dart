import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.cyan,
        surface: AppColors.panel,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'DM Sans',
      fontFamilyFallback: const ['Graphic', 'Cairo', 'sans-serif'],
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.accent,
        selectionColor: Color(0x5522D3EE),
      ),
    );
  }
}
