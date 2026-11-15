import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../core/utils/url_launcher_utils.dart';
import '../data/portfolio_data.dart';
import '../models/project.dart';
import '../widgets/common/buttons.dart';
import '../widgets/common/section_header.dart';
import '../widgets/common/tag_chip.dart';

class WebProjectsSection extends StatelessWidget {
  final ValueChanged<Project> onOpenProject;

  const WebProjectsSection({super.key, required this.onOpenProject});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;
        final webProjects = PortfolioData.webProjects;

        if (webProjects.isEmpty) return const SizedBox.shrink();

        return Container(
          color: const Color(0xFF091823),
          child: SectionWrapper(
            number: '03',
            eyebrow: isAr ? 'مشاريع الويب' : 'WEB DEVELOPMENT',
            title: isAr ? 'مشاريع الويب' : 'Web Projects',
            accent: isAr ? 'المستقلة عن فلاتر.' : 'Separate Stack.',
            description: isAr
                ? 'مشاريع تطوير الويب (Web Stack) المنفصلة تماماً عن تطوير تطبيقات فلاتر.'
                : 'Web engineering projects outside of Flutter development, showcasing full-stack web capabilities.',
            child: Column(
              children: webProjects
                  .map(
                    (project) => _WebProjectCard(
                      project: project,
                      onOpen: () => onOpenProject(project),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class _WebProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onOpen;

  const _WebProjectCard({required this.project, required this.onOpen});

  @override
  State<_WebProjectCard> createState() => _WebProjectCardState();
}

class _WebProjectCardState extends State<_WebProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isAr = LanguageController.instance.isArabic;
    final project = widget.project;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered
                ? AppColors.cyan
                : AppColors.withAlphaOpacity(AppColors.cyan, 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? AppColors.withAlphaOpacity(AppColors.cyan, 0.12)
                  : Colors.black26,
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: LayoutBuilder(
            builder: (context, box) {
              final info = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cyan,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAr
                              ? 'مشروع ويب (Web Project)'
                              : 'WEB DEVELOPMENT PROJECT',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TagChip(project.category(isAr)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    project.name(isAr),
                    style: const TextStyle(
                      color: AppColors.paper,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  if (project.headline(isAr) != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      project.headline(isAr)!,
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    project.description(isAr),
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.tags.map((t) => TagChip(t)).toList(),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      PrimaryButton(
                        label: isAr
                            ? 'عرض دراسة المشروع'
                            : 'View Web Case Study',
                        icon: Icons.launch_rounded,
                        onPressed: widget.onOpen,
                      ),
                      if (project.githubUrl != null)
                        QuietButton(
                          label: 'GitHub Repository',
                          icon: Icons.code_rounded,
                          onPressed: () =>
                              UrlLauncherUtils.launchURL(project.githubUrl!),
                        ),
                    ],
                  ),
                ],
              );

              return info;
            },
          ),
        ),
      ),
    );
  }
}
