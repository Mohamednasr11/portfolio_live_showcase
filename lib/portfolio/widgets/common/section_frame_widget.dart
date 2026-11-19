import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import 'portfolio_constants.dart';

class WidthContainer extends StatelessWidget {
  const WidthContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 720;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: P.maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: narrow ? 16 : 32),
          child: child,
        ),
      ),
    );
  }
}

class SectionFrameWidget extends StatelessWidget {
  const SectionFrameWidget({
    super.key,
    required this.label,
    required this.title,
    this.intro,
    required this.child,
    required this.isDark,
  });

  final String label;
  final String title;
  final String? intro;
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 720;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: narrow ? 48 : 80),
      child: WidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: ShowType.label),
            const SizedBox(height: 10),
            Semantics(
              header: true,
              child: Text(
                title,
                style: ShowType.title.copyWith(
                  color: Show.getText(isDark),
                  fontSize: narrow ? 28 : 36,
                ),
              ),
            ),
            if (intro != null) ...[
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  intro!,
                  style: ShowType.body.copyWith(
                    color: Show.getMuted(isDark),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
            ],
            SizedBox(height: narrow ? 28 : 40),
            child,
          ],
        ),
      ),
    );
  }
}
