import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../data/portfolio_data.dart';
import '../widgets/common/section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'phone':
        return Icons.phone_iphone_rounded;
      case 'architecture':
        return Icons.account_tree_rounded;
      case 'cloud':
        return Icons.cloud_outlined;
      case 'storage':
        return Icons.data_object_rounded;
      default:
        return Icons.code_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;
        final categories = PortfolioData.skillCategories;

        return SectionWrapper(
          number: '04',
          eyebrow: isAr ? 'الخبرات والمهارات التقنية' : 'TECHNICAL EXPERTISE',
          title: isAr ? 'المهارات' : 'Engineering',
          accent: isAr ? 'والتقنيات المتبعة.' : 'Stack & Tools.',
          description: isAr
              ? 'تخصص تقني عميق في تطوير تطبيقات الجوال باستخدام فلاتر مع الالتزام بأفضل الممارسات والمعمارية النظيفة.'
              : 'Focused technical stack specializing in Flutter mobile app engineering, clean software design, and backend APIs.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 880 ? 2 : 1;
              const gap = 20.0;
              final width = (constraints.maxWidth - gap * (cols - 1)) / cols;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: categories.map((cat) {
                  final title = isAr ? cat['titleAr'] : cat['titleEn'];
                  final iconName = cat['icon'] as String;
                  final skills = cat['skills'] as List<String>;

                  return SizedBox(
                    width: width,
                    child: _SkillCategoryCard(
                      title: title,
                      icon: _getCategoryIcon(iconName),
                      skills: skills,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}

class _SkillCategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<String> skills;

  const _SkillCategoryCard({
    required this.title,
    required this.icon,
    required this.skills,
  });

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.lime
                : AppColors.withAlphaOpacity(AppColors.lime, 0.2),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132F3D),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lime, width: 0.8),
                  ),
                  child: Icon(widget.icon, color: AppColors.lime, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.paper,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.skills.map((skill) => _SkillChip(skill: skill)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String skill;

  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF091924),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.lime,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            skill,
            style: const TextStyle(
              color: AppColors.paper,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
