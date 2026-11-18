import 'package:flutter/material.dart';
import 'package:portfolio_live_showcase/portfolio/widgets/navigations/portfolio_nav_bar_widget.dart';

import '../../../showcase/theme.dart';

class MobileNavMenu extends StatelessWidget {
  const MobileNavMenu({
    super.key,
    required this.sections,
    required this.isArabic,
    required this.isDark,
    required this.onJump,
    required this.onOpenShowcase,
  });

  final List<PortfolioSection> sections;
  final bool isArabic;
  final bool isDark;
  final ValueChanged<PortfolioSection> onJump;
  final VoidCallback onOpenShowcase;

  IconData _icon(PortfolioSection section) {
    return switch (section) {
      PortfolioSection.work => Icons.work_outline_rounded,
      PortfolioSection.projects => Icons.grid_view_rounded,
      PortfolioSection.skills => Icons.code_rounded,
      PortfolioSection.build => Icons.architecture_rounded,
      PortfolioSection.journey => Icons.school_outlined,
      PortfolioSection.contact => Icons.mail_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Object>(
      tooltip: isArabic ? 'الأقسام' : 'Navigation',
      icon: Icon(Icons.menu_rounded, color: Show.getText(isDark), size: 24),
      color: Show.getSurfaceAlt(isDark),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (value) {
        if (value is PortfolioSection) {
          onJump(value);
        } else if (value == 'showcase') {
          onOpenShowcase();
        }
      },
      itemBuilder: (context) => [
        for (final section in sections)
          PopupMenuItem<Object>(
            value: section,
            child: Row(
              children: [
                Icon(_icon(section), size: 18, color: Show.accent),
                const SizedBox(width: 12),
                Text(
                  section.title(isArabic),
                  style: TextStyle(color: Show.getText(isDark), fontSize: 13),
                ),
              ],
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem<Object>(
          value: 'showcase',
          child: Row(
            children: [
              const Icon(
                Icons.play_circle_outline_rounded,
                size: 18,
                color: Show.accent,
              ),
              const SizedBox(width: 12),
              Text(
                isArabic ? 'المعرض الحي' : 'Live Showcase',
                style: TextStyle(color: Show.getText(isDark), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
