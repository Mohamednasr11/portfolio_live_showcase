import 'package:flutter/material.dart';

import '../core/localization/language_controller.dart';
import '../models/project.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_education_section.dart';
import '../sections/hero_section.dart';
import '../sections/motion_lab_section.dart';
import '../sections/projects_section.dart';
import '../sections/services_section.dart';
import '../sections/skills_section.dart';
import '../sections/stats_strip_section.dart';
import '../sections/web_projects_section.dart';
import '../widgets/navigation/footer_nav_bar.dart';
import '../widgets/navigation/header_nav_bar.dart';
import 'project_detail_dialog.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scrollController = ScrollController();
  bool _isScrolled = false;
  String _activeSection = 'Hero';

  final _sectionKeys = <String, GlobalKey>{
    'Hero': GlobalKey(),
    'Projects': GlobalKey(),
    'Skills': GlobalKey(),
    'Contact': GlobalKey(),
    'About': GlobalKey(),
    'Experience': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    final offset = _scrollController.offset;

    final isScrolledNow = offset > 40;
    if (isScrolledNow != _isScrolled) {
      setState(() {
        _isScrolled = isScrolledNow;
      });
    }

    // Scroll-Spy section tracking
    String current = 'Hero';
    for (final entry in _sectionKeys.entries) {
      final keyContext = entry.value.currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          if (position.dy <= 180) {
            current = entry.key;
          }
        }
      }
    }

    if (current != _activeSection) {
      setState(() {
        _activeSection = current;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _goTo(String name) {
    final key = _sectionKeys[name];
    final context = key?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
        alignment: 0.04,
      );
    }
  }

  Future<void> _openProject(Project project) async {
    await showDialog<void>(
      context: context,
      builder: (context) => ProjectDetailDialog(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final textDirection = LanguageController.instance.textDirection;

        return Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: SelectionArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        const SizedBox(height: 70), // Spacer for sticky navbar
                        HeroSection(
                          key: _sectionKeys['Hero'],
                          onNavigate: _goTo,
                        ),
                        const StatsStripSection(),
                        ProjectsSection(
                          key: _sectionKeys['Projects'],
                          onOpenProject: _openProject,
                        ),
                        SkillsSection(key: _sectionKeys['Skills']),
                        AboutSection(key: _sectionKeys['About']),
                        WebProjectsSection(onOpenProject: _openProject),
                        ExperienceEducationSection(
                          key: _sectionKeys['Experience'],
                        ),
                        const MotionLabSection(),
                        const ServicesSection(),
                        ContactSection(key: _sectionKeys['Contact']),
                        FooterNavBar(onNavigate: _goTo),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: HeaderNavBar(
                      onNavigate: _goTo,
                      activeSection: _activeSection,
                      isScrolled: _isScrolled,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
