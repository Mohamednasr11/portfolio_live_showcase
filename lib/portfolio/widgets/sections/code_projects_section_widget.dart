import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import '../../../widgets/common/reveal_on_scroll.dart';
import '../../profile_data.dart';
import '../common/chip_widget.dart';
import '../common/link_button_widget.dart';
import '../common/portfolio_card_widget.dart';
import '../common/section_frame_widget.dart';

class CodeProjectsSectionWidget extends StatelessWidget {
  const CodeProjectsSectionWidget({
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
      label: isArabic ? 'مشاريع برمجية مفتوحة المصدر' : 'Open-source code',
      title: isArabic
          ? 'مشاريع جاهزة للاستعراض والاستنساخ'
          : 'Production-grade repositories',
      intro: isArabic
          ? 'مشاريع حقيقية يمكنك استنساخها وقراءة الكود الخاص بها. التفاصيل مستمدة من ملفات الـ README لكل مشروع.'
          : 'Repositories you can explore, clone, and evaluate. Features and architecture adhere to professional standards.',
      isDark: isDark,
      child: PortfolioGrid(
        columns: columns,
        children: [
          for (var i = 0; i < Profile.codeProjects.length; i++)
            RevealOnScroll(
              delay: Duration(milliseconds: 100 * i),
              child: PortfolioCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Profile.codeProjects[i].name,
                      style: ShowType.heading.copyWith(
                        color: Show.getText(isDark),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic
                          ? Profile.codeProjects[i].summaryAr
                          : Profile.codeProjects[i].summary,
                      style: TextStyle(
                        fontFamily: isArabic ? 'Graphic' : Show.body,
                        color: Show.getText(isDark),
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    for (final point
                        in (isArabic
                            ? Profile.codeProjects[i].pointsAr
                            : Profile.codeProjects[i].points))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                right: 10,
                                left: 4,
                              ),
                              child: SizedBox(
                                width: 6,
                                height: 6,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Show.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                point,
                                style: ShowType.body.copyWith(
                                  color: Show.getMuted(isDark),
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),
                    ChipsWidget(Profile.codeProjects[i].stack, isDark: isDark),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final link in Profile.codeProjects[i].links)
                          LinkButton(label: link.label, url: link.url),
                      ],
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
