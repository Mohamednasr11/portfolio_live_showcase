import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import '../../../widgets/common/reveal_on_scroll.dart';
import '../../profile_data.dart';
import '../common/portfolio_card_widget.dart';
import '../common/section_frame_widget.dart';

class JourneySectionWidget extends StatelessWidget {
  const JourneySectionWidget({
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
    Widget buildTimelineColumn(String heading, List<TimelineEntry> entries) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: ShowType.heading.copyWith(color: Show.accent, fontSize: 20),
          ),
          const SizedBox(height: 16),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RevealOnScroll(
                child: PortfolioCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? entry.periodAr : entry.period,
                        style: ShowType.label,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isArabic ? entry.titleAr : entry.title,
                        style: ShowType.heading.copyWith(
                          color: Show.getText(isDark),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isArabic ? entry.placeAr : entry.place,
                        style: TextStyle(
                          fontFamily: isArabic ? 'Graphic' : Show.body,
                          color: Show.getText(isDark),
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final point
                          in (isArabic ? entry.pointsAr : entry.points))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            point,
                            style: ShowType.body.copyWith(
                              color: Show.getMuted(isDark),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    }

    final experienceColumn = buildTimelineColumn(
      isArabic ? 'الخبرة المهنية' : 'Experience',
      Profile.experience,
    );

    final educationColumn = buildTimelineColumn(
      isArabic ? 'التعليم والتدريب' : 'Education & training',
      Profile.education,
    );

    return SectionFrameWidget(
      label: isArabic
          ? 'المسيرة المهنية والأكاديمية'
          : 'Experience & education',
      title: isArabic ? 'حيث عملت ودرست' : 'Where I’ve worked and studied',
      isDark: isDark,
      child: width >= 900
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: experienceColumn),
                const SizedBox(width: 24),
                Expanded(child: educationColumn),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                experienceColumn,
                const SizedBox(height: 16),
                educationColumn,
              ],
            ),
    );
  }
}
