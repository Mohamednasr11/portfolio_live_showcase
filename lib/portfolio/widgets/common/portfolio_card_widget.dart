import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    super.key,
    required this.child,
    this.accent,
    required this.isDark,
  });

  final Widget child;
  final Color? accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Show.getSurface(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Show.getBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (accent != null) Container(height: 3.5, color: accent),
          Padding(padding: const EdgeInsets.all(24), child: child),
        ],
      ),
    );
  }
}

class PortfolioGrid extends StatelessWidget {
  const PortfolioGrid({
    super.key,
    required this.columns,
    required this.children,
  });

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const gap = 24.0;

    return LayoutBuilder(
      builder: (context, box) {
        final w = (box.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children) SizedBox(width: w, child: child),
          ],
        );
      },
    );
  }
}
