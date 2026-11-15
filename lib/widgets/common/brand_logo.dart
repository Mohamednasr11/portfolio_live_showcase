import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const Text(
            'م',
            style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Mohamed',
          style: TextStyle(color: AppColors.paper, fontWeight: FontWeight.w700),
        ),
        const Text(
          '.',
          style: TextStyle(
            color: AppColors.lime,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
