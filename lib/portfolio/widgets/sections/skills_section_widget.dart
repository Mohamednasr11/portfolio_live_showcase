import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import '../../../widgets/common/reveal_on_scroll.dart';
import '../../profile_data.dart';
import '../common/chip_widget.dart';
import '../common/portfolio_card_widget.dart';
import '../common/section_frame_widget.dart';

class SkillsSectionWidget extends StatelessWidget {
  const SkillsSectionWidget({
    super.key,
    required this.width,
    required this.isArabic,
    required this.isDark,
  });

  final double width;
  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final columns = width >= 1080 ? 3 : (width >= 720 ? 2 : 1);

    return SectionFrameWidget(
      label: isArabic ? 'المهارات التقنية' : 'Skills & expertise',
      title: isArabic
          ? 'ما تخصصت في بنائه وإتقانه'
          : 'Technologies I work with daily',
      intro: isArabic
          ? 'مقسمة حسب المجالات، مع توضيح المشاريع التي تم استخدامها فيها.'
          : 'Grouped by domain, with direct evidence from my projects.',
      isDark: isDark,
      child: PortfolioGrid(
        columns: columns,
        children: [
          for (var i = 0; i < Profile.skills.length; i++)
            RevealOnScroll(
              delay: Duration(milliseconds: 100 * i),
              child: PortfolioCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? Profile.skills[i].titleAr
                          : Profile.skills[i].title,
                      style: ShowType.heading.copyWith(
                        color: Show.getText(isDark),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ChipsWidget(Profile.skills[i].skills, isDark: isDark),
                    const SizedBox(height: 16),
                    Text(
                      isArabic
                          ? 'مستخدمة في: ${Profile.skills[i].evidenceAr}'
                          : 'Used in: ${Profile.skills[i].evidence}',
                      style: TextStyle(
                        fontFamily: isArabic ? 'Graphic' : Show.body,
                        color: Show.getMuted(isDark),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
