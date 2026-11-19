import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../data/portfolio_data.dart';
import '../../../showcase/model.dart';
import '../../../showcase/shell.dart' show SiteBackdrop;
import '../../../showcase/theme.dart';
import '../../profile_data.dart';
import '../common/link_button_widget.dart';
import '../common/live_phone_widget.dart';
import '../common/portfolio_constants.dart';
import '../common/section_frame_widget.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({
    super.key,
    required this.demo,
    required this.narrow,
    required this.width,
    required this.isArabic,
    required this.isDark,
  });

  final DemoSpec demo;
  final bool narrow;
  final double width;
  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final side = width >= 980;

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );

    final disableAnimations =
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false) || isTest;

    final authorBadge = Row(
      children: [
        Container(
          width: narrow ? 260 : 240,
          height: narrow ? 260 : 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Show.accent, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Show.accent.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/ME/me.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Show.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Show.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      isArabic
                          ? Profile.roleAr.toUpperCase()
                          : Profile.role.toUpperCase(),
                      style: ShowType.label.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: Show.getMuted(isDark),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'جامعة المنصورة · مصر'
                          : 'Mansoura University · Egypt',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: isArabic ? 'Graphic' : Show.body,
                        color: Show.getMuted(isDark),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    Widget copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        authorBadge,
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(
            Profile.name,
            style: ShowType.display.copyWith(
              color: Show.getText(isDark),
              fontSize: narrow ? 36 : 52,
              letterSpacing: -1.2,
              height: 1.08,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Text(
            isArabic ? Profile.introAr : Profile.intro,
            style: ShowType.body.copyWith(
              color: Show.getMuted(isDark),
              fontSize: narrow ? 16 : 17.5,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => openShowcase(context),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                isArabic ? 'شاهد المعرض الحي' : 'Watch live case studies',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Show.accent,
                foregroundColor: Show.bg,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            LinkButton(
              label: 'WhatsApp',
              url: 'https://wa.me/${PortfolioData.phone}',
              icon: Icons.chat_bubble_outline_rounded,
            ),
            LinkButton(
              label: 'GitHub',
              url: Profile.githubUrl,
              icon: Icons.code_rounded,
            ),
            LinkButton(
              label: 'LinkedIn',
              url: Profile.linkedinUrl,
              icon: Icons.person_outline_rounded,
            ),
          ],
        ),
      ],
    );

    if (!disableAnimations) {
      copy = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimateList(
          interval: 120.ms,
          effects: [
            FadeEffect(duration: 500.ms, curve: Curves.easeOutCubic),
            SlideEffect(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
          ],
          children: (copy as Column).children,
        ),
      );
    }

    final phoneSection = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LivePhone(demo: demo, step: 2, width: narrow ? 250 : 290),
        const SizedBox(height: 14),
        Text(
          isArabic
              ? 'ويدجتس فلاتر حية وليست صورة. انقر للتجربة.'
              : 'Live Flutter widgets. Tap to play case study.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: isArabic ? 'Graphic' : Show.body,
            color: Show.getMuted(isDark),
            fontSize: 13,
          ),
        ),
      ],
    );

    return Stack(
      children: [
        Positioned.fill(child: SiteBackdrop()),
        Padding(
          padding: EdgeInsets.symmetric(vertical: narrow ? 44 : 80),
          child: WidthContainer(
            child: side
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 48),
                      phoneSection,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [copy, const SizedBox(height: 48), phoneSection],
                  ),
          ),
        ),
      ],
    );
  }
}
