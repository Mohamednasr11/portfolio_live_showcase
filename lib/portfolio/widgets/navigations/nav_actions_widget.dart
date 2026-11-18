import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';

class NavActions extends StatelessWidget {
  const NavActions({
    super.key,
    required this.isArabic,
    required this.isDark,
    required this.compact,
    required this.onToggleLang,
    required this.onToggleTheme,
  });

  final bool isArabic;
  final bool isDark;
  final bool compact;
  final VoidCallback onToggleLang;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: isArabic ? 'Switch to English' : 'التبديل للعربية',
          onPressed: onToggleLang,
          visualDensity: VisualDensity.compact,
          icon: Text(
            isArabic ? 'EN' : 'AR',
            style: const TextStyle(
              color: Show.accent,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),

        IconButton(
          tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          onPressed: onToggleTheme,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: Show.getMuted(isDark),
            size: 19,
          ),
        ),
      ],
    );
  }
}
