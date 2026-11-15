import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../core/utils/url_launcher_utils.dart';
import '../data/portfolio_data.dart';
import '../widgets/common/buttons.dart';
import '../widgets/common/max_width_container.dart';

class HeroSection extends StatelessWidget {
  final ValueChanged<String> onNavigate;

  const HeroSection({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        return MaxWidthContainer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 60, 28, 70),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 820;

                final textWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Eyebrow(
                      isAr
                          ? 'مطور تطبيقات فلاتر  ·  متاح للفرص والمشاريع'
                          : 'FLUTTER DEVELOPER  ·  MANSOURA UNIVERSITY CS',
                    ),
                    const SizedBox(height: 20),

                    // Name Header
                    Text(
                      PortfolioData.name,
                      style: TextStyle(
                        color: AppColors.lime,
                        fontSize: math.min(
                          48,
                          constraints.maxWidth * (stacked ? 0.08 : 0.05),
                        ),
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Headline Title
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: isAr
                                ? 'أبني تطبيقات جوال عالية الأداء '
                                : 'I build high-performance\nmobile apps with ',
                          ),
                          TextSpan(
                            text: isAr ? 'بمعمارية نظيفة.' : 'Clean Architecture.',
                            style: const TextStyle(color: AppColors.cyan),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        color: AppColors.paper,
                        fontSize: math.min(
                          56,
                          constraints.maxWidth * (stacked ? 0.09 : 0.065),
                        ),
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2.0,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Professional Summary
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 580),
                      child: Text(
                        isAr ? PortfolioData.heroIntroAr : PortfolioData.heroIntroEn,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 14,
                          height: 1.85,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Call to Action Buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        PrimaryButton(
                          label: isAr ? 'استكشف مشاريعي' : 'Explore Projects',
                          icon: Icons.arrow_outward_rounded,
                          onPressed: () => onNavigate('Projects'),
                        ),
                        QuietButton(
                          label: isAr ? 'تحميل السيرة الذاتية' : 'Download CV',
                          onPressed: () => UrlLauncherUtils.downloadCV(),
                        ),
                        QuietButton(
                          label: isAr ? 'تواصل معي' : 'Let’s talk',
                          onPressed: () => onNavigate('Contact'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Social Links
                    Wrap(
                      spacing: 16,
                      children: [
                        _SocialIconButton(
                          icon: Icons.code_rounded,
                          label: 'GitHub',
                          onTap: () => UrlLauncherUtils.launchURL(PortfolioData.githubUrl),
                        ),
                        _SocialIconButton(
                          icon: Icons.work_outline_rounded,
                          label: 'LinkedIn',
                          onTap: () => UrlLauncherUtils.launchURL(PortfolioData.linkedinUrl),
                        ),
                        _SocialIconButton(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          onTap: () => UrlLauncherUtils.openEmail(PortfolioData.email),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Key Badges / Stats
                    Wrap(
                      spacing: 28,
                      runSpacing: 16,
                      children: [
                        _HeroStat(
                          value: 'Clean Architecture',
                          label: isAr ? 'هيكلة برمجية نظيفة وقابلة للتوسع' : 'Data / Domain / Presentation Layers',
                        ),
                        _HeroStat(
                          value: 'BLoC / Cubit',
                          label: isAr ? 'إدارة حالة منظمة وفعالة' : 'Predictable & Testable State Management',
                        ),
                        _HeroStat(
                          value: 'REST & GraphQL',
                          label: isAr ? 'ربط واجهات البرمجة والخدمات' : 'Robust Dio & GraphQL API Integration',
                        ),
                      ],
                    ),
                  ],
                );

                const portraitWidget = _PortraitCard();

                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget,
                      const SizedBox(height: 44),
                      portraitWidget,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 12, child: textWidget),
                    const SizedBox(width: 36),
                    Expanded(flex: 8, child: portraitWidget),
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

class _Eyebrow extends StatelessWidget {
  final String text;
  const _Eyebrow(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.lime,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.lime, blurRadius: 9)],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
            color: AppColors.lime,
            fontSize: 18,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.lime, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.paper,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortraitCard extends StatelessWidget {
  const _PortraitCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.withAlphaOpacity(AppColors.lime, 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.withAlphaOpacity(AppColors.lime, 0.08),
                      blurRadius: 80,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
              Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.withAlphaOpacity(AppColors.cyan, 0.22),
                    width: 1.2,
                  ),
                ),
              ),
              Container(
                width: 230,
                height: 230,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.withAlphaOpacity(AppColors.lime, 0.68),
                    width: 2,
                  ),
                ),
                child: Image.asset(
                  'mee.jpg',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.2),
                  errorBuilder: (_, __, ___) => Image.asset(
                    'me.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const _FloatingChip(
                text: 'Flutter & Clean Arch',
                icon: Icons.code_rounded,
                top: 55,
                right: 0,
              ),
              const _FloatingChip(
                text: 'BLoC & Firebase',
                icon: Icons.layers_rounded,
                bottom: 60,
                left: 0,
              ),
              const Positioned(bottom: 20, right: 10, child: _LivePill()),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final double? top, right, bottom, left;

  const _FloatingChip({
    required this.text,
    required this.icon,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: AppColors.withAlphaOpacity(AppColors.lime, 0.3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.lime),
              const SizedBox(width: 6),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.paper,
                  fontSize: 11,
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

class _LivePill extends StatelessWidget {
  const _LivePill();

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageController.instance.isArabic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _PulseDot(),
          const SizedBox(width: 6),
          Text(
            isAr ? 'متاح للعمل فوراً' : 'Available for work',
            style: const TextStyle(color: AppColors.paper, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.35, end: 1.0).animate(_controller),
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AppColors.lime,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
