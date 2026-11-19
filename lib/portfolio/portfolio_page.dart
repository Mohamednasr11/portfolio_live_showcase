import 'package:flutter/material.dart';

export 'widgets/common/link_button_widget.dart';
export 'widgets/common/portfolio_constants.dart';

import '../showcase/demos.dart';
import '../showcase/model.dart';
import '../showcase/theme.dart';
import 'profile_data.dart';
import 'widgets/common/portfolio_constants.dart';
import 'widgets/navigations/portfolio_nav_bar_widget.dart';
import 'widgets/sections/build_notes_section_widget.dart';
import 'widgets/sections/case_studies_section_widget.dart';
import 'widgets/sections/code_projects_section_widget.dart';
import 'widgets/sections/contact_section_widget.dart';
import 'widgets/sections/footer_section_widget.dart';
import 'widgets/sections/hero_section_widget.dart';
import 'widgets/sections/journey_section_widget.dart';
import 'widgets/sections/skills_section_widget.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();

  final Map<PortfolioSection, GlobalKey> _keys = {
    for (final section in PortfolioSection.values) section: GlobalKey(),
  };

  late final List<DemoSpec> _demos = buildDemos();

  bool _isArabic = false;
  bool _isDark = true;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    debugPrint('[PortfolioLog] PortfolioPage initState() executed.');
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final maxExtent = _scroll.position.maxScrollExtent;
    final progress = maxExtent > 0
        ? (_scroll.offset / maxExtent).clamp(0.0, 1.0)
        : 0.0;
    if ((progress - _scrollProgress).abs() > 0.005) {
      setState(() => _scrollProgress = progress);
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _jump(PortfolioSection section) {
    final ctx = _keys[section]?.currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 720;

    debugPrint('[PortfolioLog] PortfolioPage build() called (width: $width).');

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Show.getBg(_isDark),
        body: Scrollbar(
          controller: _scroll,
          child: SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    narrow ? 12 : 24,
                    16,
                    narrow ? 12 : 24,
                    0,
                  ),
                  child: PortfolioNavBar(
                    onJump: _jump,
                    width: width,
                    isArabic: _isArabic,
                    isDark: _isDark,
                    name: Profile.name,
                    scrollProgress: _scrollProgress,
                    onToggleLang: () => setState(() => _isArabic = !_isArabic),
                    onToggleTheme: () => setState(() => _isDark = !_isDark),
                    onOpenShowcase: () => openShowcase(context),
                  ),
                ),
                HeroSectionWidget(
                  demo: _demos.first,
                  narrow: narrow,
                  width: width,
                  isArabic: _isArabic,
                  isDark: _isDark,
                ),
                CaseStudiesSectionWidget(
                  key: _keys[PortfolioSection.work],
                  demos: _demos,
                  width: width,
                  isArabic: _isArabic,
                  isDark: _isDark,
                ),
                CodeProjectsSectionWidget(
                  key: _keys[PortfolioSection.projects],
                  width: width,
                  isArabic: _isArabic,
                  isDark: _isDark,
                ),
                SkillsSectionWidget(
                  key: _keys[PortfolioSection.skills],
                  width: width,
                  isArabic: _isArabic,
                  isDark: _isDark,
                ),
                BuildNotesSectionWidget(
                  key: _keys[PortfolioSection.build],
                  width: width,
                  isArabic: _isArabic,
                  isDark: _isDark,
                ),
                JourneySectionWidget(
                  key: _keys[PortfolioSection.journey],
                  width: width,
                  isArabic: _isArabic,
                  isDark: _isDark,
                ),
                ContactSectionWidget(
                  key: _keys[PortfolioSection.contact],
                  narrow: narrow,
                  isArabic: _isArabic,
                  isDark: _isDark,
                ),
                FooterSectionWidget(isArabic: _isArabic, isDark: _isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
