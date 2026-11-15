import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'max_width_container.dart';

class SectionWrapper extends StatelessWidget {
  final String number;
  final String eyebrow;
  final String title;
  final String accent;
  final String description;
  final Widget child;

  const SectionWrapper({
    super.key,
    required this.number,
    required this.eyebrow,
    required this.title,
    required this.accent,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaxWidthContainer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 94, 28, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: AppColors.lime,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 38,
                  height: 1,
                  color: AppColors.withAlphaOpacity(AppColors.muted, 0.5),
                ),
                const SizedBox(width: 10),
                Text(
                  eyebrow,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    letterSpacing: 1.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 680;
                final heading = Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '$title\n'),
                      TextSpan(
                        text: accent,
                        style: const TextStyle(color: AppColors.lime),
                      ),
                    ],
                  ),
                  style: const TextStyle(
                    color: AppColors.paper,
                    fontSize: 47,
                    height: 1.02,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2.2,
                  ),
                );
                final intro = Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.8,
                  ),
                );
                return narrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading,
                          const SizedBox(height: 14),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 440),
                            child: intro,
                          ),
                          const SizedBox(height: 34),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(child: heading),
                          const SizedBox(width: 35),
                          SizedBox(width: 300, child: intro),
                          const SizedBox(width: 5),
                        ],
                      );
              },
            ),
            if (MediaQuery.sizeOf(context).width >= 680)
              const SizedBox(height: 42),
            child,
          ],
        ),
      ),
    );
  }
}
