import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolio_live_showcase/portfolio/widgets/navigations/desktop_nav_item_widget.dart';

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
    this.scrollProgress = 0.0,
  });

  final ValueChanged<PortfolioSection> onJump;
  final double width;
  final bool isArabic;
  final bool isDark;
  final VoidCallback onToggleLang;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenShowcase;
  final String name;
  final double scrollProgress;

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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: Show.getSurface(isDark)
                    .withValues(alpha: isDark ? 0.72 : 0.85),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Show.getBorder(isDark).withValues(alpha: 0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width < 720 ? 16 : 24,
                    ),
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
                                DesktopNavItemWidget(
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

                  // Liquid Glass Animated Scroll Progress Bar Slider
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOutCubic,
                        height: 2.5,
                        width:
                            MediaQuery.sizeOf(context).width *
                            scrollProgress.clamp(0.0, 1.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Show.accent,
                              Color(0xFF38BDF8),
                              Show.accent2,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Show.accent.withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
