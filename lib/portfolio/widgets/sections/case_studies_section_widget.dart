import 'package:flutter/material.dart';

import '../../../showcase/model.dart';
import '../../../showcase/theme.dart';
import '../../../widgets/common/hover_card.dart';
import '../../../widgets/common/reveal_on_scroll.dart';
import '../../profile_data.dart';
import '../common/link_button_widget.dart';
import '../common/live_phone_widget.dart';
import '../common/portfolio_card_widget.dart';
import '../common/portfolio_constants.dart';
import '../common/section_frame_widget.dart';

class CaseStudiesSectionWidget extends StatelessWidget {
  const CaseStudiesSectionWidget({
    super.key,
    required this.demos,
    required this.width,
    required this.isArabic,
    required this.isDark,
  });

  final List<DemoSpec> demos;
  final double width;
  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final columns = width >= 1080 ? 2 : 1;
    final previews = width >= 720;

    return SectionFrameWidget(
      label: isArabic ? 'دراسات الحالة التفاعلية' : 'Interactive case studies',
      title: isArabic
          ? 'أربعة تطبيقات متكاملة يمكنك تجربتها حية'
          : 'Four real-world apps you can play through',
      intro: isArabic
          ? 'تعرض كل دراسة حالة تدفق التطبيق خطوة بخطوة، مع توضيح القرارات الهندسية وراء كل واجهة.'
          : 'Each case study replays an application’s key flow step-by-step, highlighting the architectural choices behind every screen.',
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Show.accent2.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Show.accent2.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Show.accent2,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    isArabic
                        ? 'هذه نسخ تفاعلية مبنية بفلاتر تعمل مباشرة في متصفحك. البيانات وشبكات الاتصال ومساعد الذكاء الاصطناعي محاكاة احترافية، مع توفر كود متجرك مفتوح المصدر.'
                        : 'Data, network calls, AI responses and device features are simulated. Matjarkom’s real source code is public; the other three are UX case studies.',
                    style: ShowType.body.copyWith(
                      color: Show.getText(isDark),
                      fontSize: 14.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          PortfolioGrid(
            columns: columns,
            children: [
              for (var i = 0; i < Profile.caseStudies.length; i++)
                RevealOnScroll(
                  delay: Duration(milliseconds: 100 * i),
                  child: _CaseStudyCard(
                    demo: demos.firstWhere(
                      (d) => d.id == Profile.caseStudies[i].demoId,
                    ),
                    info: Profile.caseStudies[i],
                    preview: previews,
                    isArabic: isArabic,
                    isDark: isDark,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CaseStudyCard extends StatelessWidget {
  const _CaseStudyCard({
    required this.demo,
    required this.info,
    required this.preview,
    required this.isArabic,
    required this.isDark,
  });

  final DemoSpec demo;
  final CaseStudyInfo info;
  final bool preview;
  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(demo.category.toUpperCase(), style: ShowType.label),
        const SizedBox(height: 8),
        Text(
          demo.name,
          style: ShowType.heading.copyWith(
            color: Show.getText(isDark),
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          demo.subtitle,
          style: TextStyle(
            fontFamily: Show.body,
            color: Show.getText(isDark),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          demo.pitch,
          style: ShowType.body.copyWith(color: Show.getMuted(isDark)),
        ),
        const SizedBox(height: 12),
        Text(
          isArabic ? info.sourceAr : info.source,
          style: TextStyle(
            fontFamily: isArabic ? 'Graphic' : Show.body,
            color: Show.getMuted(isDark),
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => openShowcase(context, demo.id),
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text(isArabic ? 'تشغيل الدراسة' : 'Play case study'),
              style: FilledButton.styleFrom(
                backgroundColor: Show.accent,
                foregroundColor: Show.bg,
              ),
            ),
            for (final link in info.links)
              LinkButton(label: link.label, url: link.url),
          ],
        ),
      ],
    );

    return HoverCard(
      onTap: () => openShowcase(context, demo.id),
      semanticsLabel: 'Play case study for ${demo.name}',
      child: PortfolioCard(
        accent: demo.accent,
        isDark: isDark,
        child: preview
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: LivePhone(
                      demo: demo,
                      step: info.previewStep,
                      width: 140,
                    ),
                  ),
                  Expanded(child: text),
                ],
              )
            : text,
      ),
    );
  }
}
