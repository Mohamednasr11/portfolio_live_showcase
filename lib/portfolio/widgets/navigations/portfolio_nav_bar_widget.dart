import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import 'mobile_nav_menu_widget.dart';
import 'nav_actions_widget.dart';
import 'nav_brand_widget.dart';

enum PortfolioSection { work, projects, skills, build, journey, contact }

extension PortfolioSectionTitle on PortfolioSection {
  String title(bool isArabic) => switch (this) {
    PortfolioSection.work => isArabic ? 'دراسات الحالة' : 'Case studies',
    PortfolioSection.projects => isArabic ? 'المشاريع' : 'Projects',
    PortfolioSection.skills => isArabic ? 'المهارات' : 'Skills',
    PortfolioSection.build => isArabic ? 'هندسة الموقع' : 'Architecture',
    PortfolioSection.journey => isArabic ? 'الخبرة والتعليم' : 'Experience',
    PortfolioSection.contact => isArabic ? 'التواصل' : 'Contact',
  };
}

class PortfolioNavBar extends StatelessWidget {
  const PortfolioNavBar({
    super.key,
    required this.onJump,
    required this.width,
    required this.isArabic,
    required this.isDark,
    required this.onToggleLang,
    required this.onToggleTheme,
    required this.onOpenShowcase,
    required this.name,
  });

  final ValueChanged<PortfolioSection> onJump;
  final double width;
  final bool isArabic;
  final bool isDark;
  final VoidCallback onToggleLang;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenShowcase;
  final String name;

  static const List<PortfolioSection> _sections = [
    PortfolioSection.work,
    PortfolioSection.projects,
    PortfolioSection.skills,
    PortfolioSection.journey,
    PortfolioSection.contact,
  ];

  @override
  Widget build(BuildContext context) {
    final compact = width < 980;

    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Show.getSurface(isDark).withValues(alpha: 0.96),
        border: Border(bottom: BorderSide(color: Show.getBorder(isDark))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.035),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width < 720 ? 16 : 32),
            child: Row(
              children: [
                NavBrand(
                  name: name,
                  isDark: isDark,
                  isArabic: isArabic,
                  compact: width < 520,
                ),

                if (!compact) ...[
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final section in _sections)
                        _DesktopNavItem(
                          title: section.title(isArabic),
                          isDark: isDark,
                          onTap: () => onJump(section),
                        ),
                    ],
                  ),
                  const Spacer(),
                ] else
                  const Spacer(),

                NavActions(
                  isArabic: isArabic,
                  isDark: isDark,
                  compact: width < 520,
                  onToggleLang: onToggleLang,
                  onToggleTheme: onToggleTheme,
                ),

                if (compact) ...[
                  const SizedBox(width: 6),
                  MobileNavMenu(
                    sections: PortfolioSection.values,
                    isArabic: isArabic,
                    isDark: isDark,
                    onJump: onJump,
                    onOpenShowcase: onOpenShowcase,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatefulWidget {
  const _DesktopNavItem({
    required this.title,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_DesktopNavItem> createState() => _DesktopNavItemState();
}

class _DesktopNavItemState extends State<_DesktopNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 1),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? Show.accent.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              color: _hovered ? Show.accent : Show.getMuted(widget.isDark),
              fontSize: 12.5,
              fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
