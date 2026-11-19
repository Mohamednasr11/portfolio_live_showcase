import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import '../../../widgets/common/reveal_on_scroll.dart';
import '../../profile_data.dart';
import '../common/link_button_widget.dart';
import '../common/portfolio_card_widget.dart';
import '../common/section_frame_widget.dart';

class BuildNotesSectionWidget extends StatelessWidget {
  const BuildNotesSectionWidget({
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
    return SectionFrameWidget(
      label: isArabic ? 'هندسة الموقع والتصميم' : 'Architecture & design',
      title: isArabic
          ? 'كيف تم بناء هذا الموقع؟'
          : 'How this portfolio is built',
      intro: isArabic
          ? 'هذا الموقع تطبيق فلاتر ويب حقيقي. الكود مصدر مفتوح ويمكن مراجعته بالكامل.'
          : 'This portfolio is a Flutter web application. Every architectural choice is verifiable in the repository.',
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PortfolioGrid(
            columns: width >= 720 ? 2 : 1,
            children: [
              for (var i = 0; i < Profile.highlights.length; i++)
                RevealOnScroll(
                  delay: Duration(milliseconds: 100 * i),
                  child: PortfolioCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (i + 1).toString().padLeft(2, '0'),
                          style: ShowType.label.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isArabic
                              ? Profile.highlights[i].titleAr
                              : Profile.highlights[i].title,
                          style: ShowType.heading.copyWith(
                            color: Show.getText(isDark),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic
                              ? Profile.highlights[i].bodyAr
                              : Profile.highlights[i].body,
                          style: ShowType.body.copyWith(
                            color: Show.getMuted(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 28),
          LinkButton(
            label: isArabic ? 'قراءة الكود المصدري' : 'Read the source code',
            url: Profile.sourceUrl,
            icon: Icons.code_rounded,
          ),
        ],
      ),
    );
  }
}
