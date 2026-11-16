import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../widgets/common/max_width_container.dart';

class StatsStripSection extends StatelessWidget {
  const StatsStripSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        final metrics = [
          _StripMetric(
            value: 'Flutter & Dart',
            label: isAr ? 'منصات الجوال الأساسية' : 'PRIMARY MOBILE STACK',
          ),
          _StripMetric(
            value: 'Clean Architecture',
            label: isAr
                ? 'هيكلة كود نظيفة وقابلة للتوسع'
                : 'MODULAR CODEBASE PATTERN',
          ),
          _StripMetric(
            value: 'iOS & Android',
            label: isAr ? 'بناء وتصدير للمنصتين' : 'CROSS-PLATFORM DEPLOYMENT',
          ),
        ];

        final quote = Text(
          isAr
              ? '“الكود النظيف الجيد يسهل قراءته واختباره وتطويره بدون تعقيد.”'
              : '“Clean software design makes code readable, testable, and effortless to maintain.”',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            height: 1.6,
          ),
        );

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0A1B26),
            border: Border.symmetric(
              horizontal: BorderSide(color: Color(0x223F6269)),
            ),
          ),
          child: MaxWidthContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 780) {
                    return Wrap(
                      spacing: 24,
                      runSpacing: 18,
                      children: [
                        ...metrics,
                        SizedBox(width: double.infinity, child: quote),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: metrics[0]),
                      const SizedBox(width: 18),
                      Expanded(child: metrics[1]),
                      const SizedBox(width: 18),
                      Expanded(child: metrics[2]),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: quote),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StripMetric extends StatelessWidget {
  final String value, label;

  const _StripMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.lime,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 9,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
