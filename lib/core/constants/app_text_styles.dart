import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle heroHeading = TextStyle(
    color: AppColors.paper,
    height: 0.99,
    fontWeight: FontWeight.w800,
    letterSpacing: -4.3,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.paper,
    fontSize: 47,
    height: 1.02,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.2,
  );

  static const TextStyle eyebrow = TextStyle(
    color: AppColors.muted,
    fontSize: 10,
    letterSpacing: 1.3,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.muted,
    fontSize: 15,
    height: 1.85,
  );

  static const TextStyle cardTitle = TextStyle(
    color: AppColors.paper,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
  );

  static const TextStyle tag = TextStyle(
    color: Color(0xFFC1D0CA),
    fontSize: 9,
    letterSpacing: 0.3,
  );
}
