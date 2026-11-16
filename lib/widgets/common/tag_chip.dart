import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class TagChip extends StatelessWidget {
  final String label;

  const TagChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.withAlphaOpacity(Colors.black, 0.24),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(label, style: AppTextStyles.tag),
    );
  }
}
