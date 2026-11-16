import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../core/utils/url_launcher_utils.dart';
import '../data/portfolio_data.dart';
import '../models/project.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/hover_card.dart';
import '../widgets/common/reveal_on_scroll.dart';
import '../widgets/common/section_header.dart';
import '../widgets/common/tag_chip.dart';
import '../widgets/mockup/goldie_device_mockup.dart';

class ProjectsSection extends StatelessWidget {
  final ValueChanged<Project> onOpenProject;

  const ProjectsSection({super.key, required this.onOpenProject});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;
        final featured = PortfolioData.flutterProjects
            .where((p) => p.isFeatured)
            .toList();
        final secondary = PortfolioData.flutterProjects
            .where((p) => !p.isFeatured)
            .toList();

        return SectionWrapper(
          number: '01',
          eyebrow: isAr
              ? 'معرض الأعمال والخبرات'
              : 'CASE STUDIES & PRODUCTION WORK',
          title: isAr ? 'دراسات الحالة' : 'Case Studies',
          accent: isAr ? 'تطبيقات جوال حقيقية.' : '& Mobile Apps.',
          description: isAr
              ? 'تطبيقات جوال حقيقية تم بناؤها باستخدام Clean Architecture وBLoC/Cubit وFirebase وREST APIs.'
              : 'Production mobile applications engineered with Clean Architecture, BLoC/Cubit, Firebase, and robust APIs.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Featured Spotlight Projects (BuildGuard & TMDB Movie Application)
              ...featured.asMap().entries.map((entry) {
                final index = entry.key;
                final project = entry.value;

                return RevealOnScroll(
                  delay: Duration(milliseconds: index * 120),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: _FeaturedProjectCard(
                      project: project,
                      onOpen: () => onOpenProject(project),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),
              if (secondary.isNotEmpty) ...[
                RevealOnScroll(
                  child: Text(
                    isAr
                        ? 'مشاريع إضافية بـ Flutter'
                        : 'ADDITIONAL FLUTTER PROJECTS',
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.accent,
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 860 ? 2 : 1;
                    const gap = 24.0;
                    final cardWidth =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;

                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: secondary.asMap().entries.map((entry) {
                        final index = entry.key;
                        final project = entry.value;

                        return RevealOnScroll(
                          delay: Duration(milliseconds: 100 * index),
                          child: SizedBox(
                            width: cardWidth,
                            child: _StandardProjectCard(
                              project: project,
                              onTap: () => onOpenProject(project),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onOpen;

  const _FeaturedProjectCard({required this.project, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageController.instance.isArabic;

    return HoverCard(
      onTap: onOpen,
      semanticsLabel: 'Open case study for ${project.name(isAr)}',
      child: LayoutBuilder(
        builder: (context, box) {
          final compact = box.maxWidth < 800;

          final imageMockup = Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F172A), Color(0xFF070A12)],
              ),
            ),
            child: Center(
              child: SizedBox(
                width: compact ? 200 : 230,
                child: GoldieDeviceMockup(
                  imagePath: project.image,
                  width: compact ? 200 : 230,
                  height: compact ? 360 : 420,
                  enableHoverEffect: false,
                  headline: isAr ? 'مشروع رئيسي مميز' : 'FEATURED SHOWCASE',
                ),
              ),
            ),
          );

          final details = Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.background,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              isAr
                                  ? 'مشروع مميز (Featured)'
                                  : 'FEATURED CASE STUDY',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.background,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TagChip(project.category(isAr)),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  project.name(isAr),
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                if (project.headline(isAr) != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    project.headline(isAr)!,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  project.description(isAr),
                  style: const TextStyle(
                    color: AppColors.bodyText,
                    fontSize: 13,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.tags.map((t) => TagChip(t)).toList(),
                ),
                const SizedBox(height: 26),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    AppButton(
                      label: isAr ? 'عرض الدراسة التقنية' : 'View Case Study',
                      icon: Icons.article_outlined,
                      style: AppButtonStyle.primary,
                      onPressed: onOpen,
                    ),
                    if (project.githubUrl != null)
                      AppButton(
                        label: 'GitHub Repository',
                        icon: Icons.code_rounded,
                        style: AppButtonStyle.secondary,
                        onPressed: () =>
                            UrlLauncherUtils.launchURL(project.githubUrl!),
                      ),
                  ],
                ),
              ],
            ),
          );

          if (compact) {
            return Column(children: [imageMockup, details]);
          }

          return Row(
            children: [
              Expanded(flex: 5, child: imageMockup),
              Expanded(flex: 7, child: details),
            ],
          );
        },
      ),
    );
  }
}

class _StandardProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _StandardProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageController.instance.isArabic;

    return HoverCard(
      onTap: onTap,
      semanticsLabel: 'Open case study for ${project.name(isAr)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF070A12)],
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 190,
                child: GoldieDeviceMockup(
                  imagePath: project.image,
                  width: 190,
                  height: 340,
                  enableHoverEffect: false,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: TagChip(project.category(isAr))),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_outward_rounded,
                      color: AppColors.accent,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  project.name(isAr),
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  project.description(isAr),
                  style: const TextStyle(
                    color: AppColors.bodyText,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: project.tags.map((t) => TagChip(t)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
