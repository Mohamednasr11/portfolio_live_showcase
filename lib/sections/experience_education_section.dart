import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../data/portfolio_data.dart';
import '../widgets/common/section_header.dart';

class ExperienceEducationSection extends StatelessWidget {
  const ExperienceEducationSection({super.key});

  IconData _getIcon(String name) {
    switch (name) {
      case 'school':
        return Icons.school_rounded;
      case 'workspace_premium':
        return Icons.workspace_premium_rounded;
      case 'badge':
        return Icons.verified_user_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;
        final items = PortfolioData.educationAndTraining;

        return Container(
          color: const Color(0xFF091924),
          child: SectionWrapper(
            number: '05',
            eyebrow: isAr ? 'التعليم والتدريب التقني' : 'ACADEMIC & PROFESSIONAL TRAINING',
            title: isAr ? 'التعليم' : 'Education',
            accent: isAr ? 'والتدريب المعتمد.' : '& Specialized Training.',
            description: isAr
                ? 'خلفية أكاديمية في علوم الحاسب بجامعة المنصورة، مع تدريب عملي مكثف في معهد ITI والمعهد القومي للاتصالات NTI.'
                : 'Computer Science undergraduate education at Mansoura University alongside certified intensive training from ITI & NTI.',
            child: Column(
              children: items.map((item) {
                final type = isAr ? item['typeAr'] : item['typeEn'];
                final title = isAr ? item['titleAr'] : item['titleEn'];
                final subtitle = isAr ? item['subtitleAr'] : item['subtitleEn'];
                final description = isAr ? item['descriptionAr'] : item['descriptionEn'];
                final period = item['period'] as String;
                final iconName = item['icon'] as String;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _TimelineCard(
                    type: type,
                    title: title,
                    subtitle: subtitle,
                    description: description,
                    period: period,
                    icon: _getIcon(iconName),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _TimelineCard extends StatefulWidget {
  final String type;
  final String title;
  final String subtitle;
  final String description;
  final String period;
  final IconData icon;

  const _TimelineCard({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.period,
    required this.icon,
  });

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.lime
                : AppColors.withAlphaOpacity(AppColors.lime, 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? AppColors.withAlphaOpacity(AppColors.lime, 0.08)
                  : Colors.transparent,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 650;

            final mainContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.type,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF132F3D),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        widget.period,
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.paper,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: AppColors.lime,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
              ],
            );

            if (compact) return mainContent;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF122E3B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.lime, width: 1),
                  ),
                  child: Icon(widget.icon, color: AppColors.lime, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(child: mainContent),
              ],
            );
          },
        ),
      ),
    );
  }
}
