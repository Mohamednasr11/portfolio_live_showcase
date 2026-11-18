import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../core/utils/url_launcher_utils.dart';
import '../data/portfolio_data.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/max_width_container.dart';
import '../widgets/mockup/floating_phone.dart';

class HeroSection extends StatelessWidget {
  final ValueChanged<String> onNavigate;

  const HeroSection({super.key, required this.onNavigate});

  static const _heroScreens = [
    'assets/buildguard/shield_house.png',
    'assets/matjarkom/hero_watch.png',
    'assets/brewbloom/onboarding_cup.png',
  ];

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        return MaxWidthContainer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 60),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 900;

                Widget textContent = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Role Badge
                    _RoleBadge(
                      text: isAr
                          ? 'مطور تطبيقات فلاتر  ·  جامعة المنصورة'
                          : 'FLUTTER DEVELOPER  ·  MANSOURA UNIVERSITY CS',
                    ),
                    const SizedBox(height: 18),

                    // 2. Name Header
                    Text(
                      PortfolioData.name,
                      style: TextStyle(
                        fontFamily: 'Syne',
                        color: AppColors.accent,
                        fontSize: math.min(
                          44,
                          constraints.maxWidth * (stacked ? 0.08 : 0.045),
                        ),
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 3. Headline Title
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: isAr
                                ? 'أبني تطبيقات جوال تفاعلية '
                                : 'I build high-performance\nmobile apps with ',
                          ),
                          TextSpan(
                            text: isAr
                                ? 'بمعمارية نظيفة.'
                                : 'Clean Architecture.',
                            style: const TextStyle(color: AppColors.cyan),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontFamily: 'Syne',
                        color: AppColors.textPrimary,
                        fontSize: math.min(
                          52,
                          constraints.maxWidth * (stacked ? 0.09 : 0.058),
                        ),
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.8,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. Professional Summary (Selectable)
                    SelectionArea(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 580),
                        child: Text(
                          isAr
                              ? PortfolioData.heroIntroAr
                              : PortfolioData.heroIntroEn,
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            color: AppColors.bodyText,
                            fontSize: 14,
                            height: 1.85,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),

                    // 5. CTA Action Buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        AppButton(
                          label: isAr
                              ? 'استكشف دراسات الحالة'
                              : 'Explore Case Studies',
                          icon: Icons.arrow_downward_rounded,
                          style: AppButtonStyle.primary,
                          onPressed: () => onNavigate('Projects'),
                        ),
                        AppButton(
                          label: isAr ? 'تواصل معي' : 'Contact Me',
                          icon: Icons.mail_outline_rounded,
                          style: AppButtonStyle.quiet,
                          onPressed: () => onNavigate('Contact'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Quick Social Links
                    Wrap(
                      spacing: 16,
                      children: [
                        _SocialIconButton(
                          icon: Icons.code_rounded,
                          label: 'GitHub',
                          onTap: () => UrlLauncherUtils.launchURL(
                            PortfolioData.githubUrl,
                          ),
                        ),
                        _SocialIconButton(
                          icon: Icons.work_outline_rounded,
                          label: 'LinkedIn',
                          onTap: () => UrlLauncherUtils.launchURL(
                            PortfolioData.linkedinUrl,
                          ),
                        ),
                        _SocialIconButton(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          onTap: () =>
                              UrlLauncherUtils.openEmail(PortfolioData.email),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // 6. Key Architecture Pillars
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        _HeroStat(
                          value: 'Clean Architecture',
                          label: isAr
                              ? 'هيكلة برمجية نظيفة وقابلة للتوسع'
                              : 'Domain / Data / Presentation',
                        ),
                        _HeroStat(
                          value: 'BLoC / Cubit',
                          label: isAr
                              ? 'إدارة حالة منظمة وفعالة'
                              : 'Predictable State Management',
                        ),
                        _HeroStat(
                          value: 'REST & GraphQL',
                          label: isAr
                              ? 'ربط واجهات البرمجة والخدمات'
                              : 'Robust API Integrations',
                        ),
                      ],
                    ),
                  ],
                );

                // Animate text elements with staggered entrance if animations enabled
                if (!disableAnimations) {
                  textContent = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimateList(
                      interval: 120.ms,
                      effects: [
                        FadeEffect(
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
                        SlideEffect(
                          begin: const Offset(0, 0.15),
                          end: Offset.zero,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
                      ],
                      children: (textContent as Column).children,
                    ),
                  );
                }

                final phoneWidget = Center(
                  child: FloatingPhone(
                    screenImages: _heroScreens,
                    width: stacked ? 210 : 240,
                    height: stacked ? 420 : 480,
                  ),
                );

                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textContent,
                      const SizedBox(height: 48),
                      phoneWidget,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 12, child: textContent),
                    const SizedBox(width: 32),
                    Expanded(flex: 8, child: phoneWidget),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String text;
  const _RoleBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.accent, blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 16,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 10),
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Open $label link',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.accent, size: 15),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
