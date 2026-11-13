import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

import '../showcase/demos.dart';
import '../showcase/device_frame.dart';
import '../showcase/model.dart';
import '../showcase/shell.dart' show SiteBackdrop;
import '../showcase/theme.dart';
import 'profile_data.dart';

abstract final class P {
  static const body = Color(0xFFA9B4CF);
  static const card = Show.surface;
  static const maxWidth = 1120.0;
}

enum _Section { work, projects, skills, build, journey, contact }

extension on _Section {
  String title(bool ar) => switch (this) {
    _Section.work => ar ? 'دراسات الحالة' : 'Case studies',
    _Section.projects => ar ? 'المشاريع' : 'Projects',
    _Section.skills => ar ? 'المهارات' : 'Skills',
    _Section.build => ar ? 'هندسة الموقع' : 'Architecture',
    _Section.journey => ar ? 'الخبرة والتعليم' : 'Experience',
    _Section.contact => ar ? 'التواصل' : 'Contact',
  };
}

void openShowcase(BuildContext context, [String? demoId]) {
  Navigator.of(context)
      .pushNamed(demoId == null ? '/showcase' : '/showcase?demo=$demoId');
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _keys = {for (final s in _Section.values) s: GlobalKey()};
  late final List<DemoSpec> _demos = buildDemos();

  bool _isArabic = false;
  bool _isDark = true;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _jump(_Section s) {
    final ctx = _keys[s]!.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 720;
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Show.getBg(_isDark),
        body: Column(
          children: [
            _NavBar(
              onJump: _jump,
              compact: width < 980,
              width: width,
              isArabic: _isArabic,
              isDark: _isDark,
              onToggleLang: () => setState(() => _isArabic = !_isArabic),
              onToggleTheme: () => setState(() => _isDark = !_isDark),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scroll,
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Column(
                    children: [
                      _Hero(
                        demo: _demos.first,
                        narrow: narrow,
                        width: width,
                        isArabic: _isArabic,
                        isDark: _isDark,
                      ),
                      _CaseStudies(
                        key: _keys[_Section.work],
                        demos: _demos,
                        width: width,
                        isArabic: _isArabic,
                        isDark: _isDark,
                      ),
                      _CodeProjects(
                        key: _keys[_Section.projects],
                        width: width,
                        isArabic: _isArabic,
                        isDark: _isDark,
                      ),
                      _Skills(
                        key: _keys[_Section.skills],
                        width: width,
                        isArabic: _isArabic,
                        isDark: _isDark,
                      ),
                      _BuildNotes(
                        key: _keys[_Section.build],
                        width: width,
                        isArabic: _isArabic,
                        isDark: _isDark,
                      ),
                      _Journey(
                        key: _keys[_Section.journey],
                        width: width,
                        isArabic: _isArabic,
                        isDark: _isDark,
                      ),
                      _Contact(
                        key: _keys[_Section.contact],
                        narrow: narrow,
                        isArabic: _isArabic,
                        isDark: _isDark,
                      ),
                      _Footer(isArabic: _isArabic, isDark: _isDark),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────── chrome ─────────────────────────────

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.onJump,
    required this.compact,
    required this.width,
    required this.isArabic,
    required this.isDark,
    required this.onToggleLang,
    required this.onToggleTheme,
  });

  final ValueChanged<_Section> onJump;
  final bool compact;
  final double width;
  final bool isArabic;
  final bool isDark;
  final VoidCallback onToggleLang;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final veryNarrow = width < 450;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Show.getSurface(isDark).withValues(alpha: 0.92),
        border: Border(bottom: BorderSide(color: Show.getBorder(isDark))),
      ),
      child: _Width(
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Show.accent, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/ME/me.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (!veryNarrow) ...[
              Expanded(
                child: Text(
                  Profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: Show.display,
                    color: Show.getText(isDark),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
            ],
            if (!compact)
              for (final s in const [
                _Section.work,
                _Section.projects,
                _Section.skills,
                _Section.contact,
              ])
                TextButton(
                  onPressed: () => onJump(s),
                  style: TextButton.styleFrom(
                    foregroundColor: Show.getMuted(isDark),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 44),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: Text(s.title(isArabic)),
                ),
            const SizedBox(width: 4),
            IconButton(
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              onPressed: onToggleTheme,
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: Show.accent,
                size: 18,
              ),
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 4),
            OutlinedButton(
              onPressed: onToggleLang,
              style: OutlinedButton.styleFrom(
                foregroundColor: Show.accent,
                side: const BorderSide(color: Show.accent),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                minimumSize: const Size(34, 30),
              ),
              child: Text(
                isArabic ? 'EN' : 'AR',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 4),
            FilledButton(
              onPressed: () => openShowcase(context),
              style: FilledButton.styleFrom(
                backgroundColor: Show.accent,
                foregroundColor: Show.bg,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                isArabic ? 'المعرض' : (veryNarrow ? 'App' : 'Live showcase'),
              ),
            ),
            PopupMenuButton<_Section>(
              tooltip: isArabic ? 'الأقسام' : 'Sections',
              icon: Icon(
                Icons.menu_rounded,
                color: Show.getText(isDark),
                size: 22,
              ),
              color: Show.getSurfaceAlt(isDark),
              onSelected: onJump,
              itemBuilder: (_) => [
                for (final s in _Section.values)
                  PopupMenuItem(
                    value: s,
                    child: Text(
                      s.title(isArabic),
                      style: TextStyle(color: Show.getText(isDark)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Width extends StatelessWidget {
  const _Width({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 720;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: P.maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: narrow ? 16 : 32),
          child: child,
        ),
      ),
    );
  }
}

class _SectionFrame extends StatelessWidget {
  const _SectionFrame({
    required this.label,
    required this.title,
    this.intro,
    required this.child,
    required this.isDark,
  });

  final String label;
  final String title;
  final String? intro;
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 720;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: narrow ? 48 : 80),
      child: _Width(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: ShowType.label),
            const SizedBox(height: 10),
            Semantics(
              header: true,
              child: Text(
                title,
                style: ShowType.title.copyWith(
                  color: Show.getText(isDark),
                  fontSize: narrow ? 28 : 36,
                ),
              ),
            ),
            if (intro != null) ...[
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(
                  intro!,
                  style: ShowType.body.copyWith(
                    color: Show.getMuted(isDark),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
            ],
            SizedBox(height: narrow ? 28 : 40),
            child,
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.accent, required this.isDark});

  final Widget child;
  final Color? accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Show.getSurface(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Show.getBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (accent != null) Container(height: 3.5, color: accent),
          Padding(padding: const EdgeInsets.all(24), child: child),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const gap = 24.0;
    return LayoutBuilder(
      builder: (context, box) {
        final w = (box.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final c in children) SizedBox(width: w, child: c)],
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, {required this.isDark});

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Show.accent.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Show.getBorder(isDark)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: Show.body,
          color: Show.getText(isDark),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips(this.items, {required this.isDark});

  final List<String> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [for (final i in items) _Chip(i, isDark: isDark)],
  );
}

class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.label,
    required this.url,
    this.icon = Icons.north_east_rounded,
    this.primary = false,
  });

  final String label;
  final String url;
  final IconData icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(url);
    return Link(
      uri: uri,
      target: uri.scheme == 'mailto' ? LinkTarget.self : LinkTarget.blank,
      builder: (context, follow) => primary
          ? FilledButton.icon(
              onPressed: follow,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: FilledButton.styleFrom(
                backgroundColor: Show.accent,
                foregroundColor: Show.bg,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: follow,
              icon: Icon(icon, size: 16),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: Show.accent,
                side: const BorderSide(color: Show.accent),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
    );
  }
}

class LivePhone extends StatelessWidget {
  const LivePhone({
    super.key,
    required this.demo,
    required this.step,
    required this.width,
  });

  final DemoSpec demo;
  final int step;
  final double width;

  static const _frameWidth = 320.0;
  static const _frameHeight = (_frameWidth - 18) * 2.09 + 20;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Play the ${demo.name} case study',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => openShowcase(context, demo.id),
          child: AbsorbPointer(
            child: ExcludeSemantics(
              child: RepaintBoundary(
                child: SizedBox(
                  width: width,
                  height: width * _frameHeight / _frameWidth,
                  child: FittedBox(
                    child: DeviceFrame(
                      width: _frameWidth,
                      child: demo.builder(context, step),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── sections ─────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero({
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
              image: AssetImage('assets/ME/me.jpg'),
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
                        fontFamily: isArabic ? 'Cairo' : Show.body,
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

    final copy = Column(
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
            fontFamily: isArabic ? 'Cairo' : Show.body,
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
          child: _Width(
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

class _Notice extends StatelessWidget {
  const _Notice(this.text, {required this.isDark});

  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Show.accent2.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Show.accent2.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_rounded, color: Show.accent2, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: ShowType.body.copyWith(
                color: Show.getText(isDark),
                fontSize: 14.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaseStudies extends StatelessWidget {
  const _CaseStudies({
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
    return _SectionFrame(
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
          _Notice(
            isArabic
                ? 'هذه نسخ تفاعلية مبنية بفلاتر تعمل مباشرة في متصفحك. البيانات وشبكات الاتصال ومساعد الذكاء الاصطناعي محاكاة احترافية، مع توفر كود متجرك مفتوح المصدر.'
                : 'Data, network calls, AI responses and device features are simulated. Matjarkom’s real source code is public; the other three are UX case studies.',
            isDark: isDark,
          ),
          const SizedBox(height: 28),
          _Grid(
            columns: columns,
            children: [
              for (final info in Profile.caseStudies)
                _CaseStudyCard(
                  demo: demos.firstWhere((d) => d.id == info.demoId),
                  info: info,
                  preview: previews,
                  isArabic: isArabic,
                  isDark: isDark,
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
            fontFamily: isArabic ? 'Cairo' : Show.body,
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
            for (final l in info.links) LinkButton(label: l.label, url: l.url),
          ],
        ),
      ],
    );
    return _Card(
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
    );
  }
}

class _CodeProjects extends StatelessWidget {
  const _CodeProjects({
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
    return _SectionFrame(
      label: isArabic ? 'مشاريع برمجية مفتوحة المصدر' : 'Open-source code',
      title: isArabic
          ? 'مشاريع جاهزة للاستعراض والاستنساخ'
          : 'Production-grade repositories',
      intro: isArabic
          ? 'مشاريع حقيقية يمكنك استنساخها وقراءة الكود الخاص بها. التفاصيل مستمدة من ملفات الـ README لكل مشروع.'
          : 'Repositories you can explore, clone, and evaluate. Features and architecture adhere to professional standards.',
      isDark: isDark,
      child: _Grid(
        columns: columns,
        children: [
          for (final p in Profile.codeProjects)
            _Card(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: ShowType.heading.copyWith(
                      color: Show.getText(isDark),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? p.summaryAr : p.summary,
                    style: TextStyle(
                      fontFamily: isArabic ? 'Cairo' : Show.body,
                      color: Show.getText(isDark),
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final point in (isArabic ? p.pointsAr : p.points))
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
                  _Chips(p.stack, isDark: isDark),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final l in p.links)
                        LinkButton(label: l.label, url: l.url),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Skills extends StatelessWidget {
  const _Skills({
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
    return _SectionFrame(
      label: isArabic ? 'المهارات التقنية' : 'Skills & expertise',
      title: isArabic
          ? 'ما تخصصت في بنائه وإتقانه'
          : 'Technologies I work with daily',
      intro: isArabic
          ? 'مقسمة حسب المجالات، مع توضيح المشاريع التي تم استخدامها فيها.'
          : 'Grouped by domain, with direct evidence from my projects.',
      isDark: isDark,
      child: _Grid(
        columns: columns,
        children: [
          for (final g in Profile.skills)
            _Card(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? g.titleAr : g.title,
                    style: ShowType.heading.copyWith(
                      color: Show.getText(isDark),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _Chips(g.skills, isDark: isDark),
                  const SizedBox(height: 16),
                  Text(
                    isArabic
                        ? 'مستخدمة في: ${g.evidenceAr}'
                        : 'Used in: ${g.evidence}',
                    style: TextStyle(
                      fontFamily: isArabic ? 'Cairo' : Show.body,
                      color: Show.getMuted(isDark),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BuildNotes extends StatelessWidget {
  const _BuildNotes({
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
    return _SectionFrame(
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
          _Grid(
            columns: width >= 720 ? 2 : 1,
            children: [
              for (var i = 0; i < Profile.highlights.length; i++)
                _Card(
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

class _Journey extends StatelessWidget {
  const _Journey({
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
    Widget column(String heading, List<TimelineEntry> entries) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: ShowType.heading.copyWith(color: Show.accent, fontSize: 20),
        ),
        const SizedBox(height: 16),
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _Card(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isArabic ? e.periodAr : e.period, style: ShowType.label),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? e.titleAr : e.title,
                    style: ShowType.heading.copyWith(
                      color: Show.getText(isDark),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? e.placeAr : e.place,
                    style: TextStyle(
                      fontFamily: isArabic ? 'Cairo' : Show.body,
                      color: Show.getText(isDark),
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final p in (isArabic ? e.pointsAr : e.points))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        p,
                        style: ShowType.body.copyWith(
                          color: Show.getMuted(isDark),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );

    final experience = column(
      isArabic ? 'الخبرة المهنية' : 'Experience',
      Profile.experience,
    );
    final education = column(
      isArabic ? 'التعليم والتدريب' : 'Education & training',
      Profile.education,
    );

    return _SectionFrame(
      label: isArabic
          ? 'المسيرة المهنية والأكاديمية'
          : 'Experience & education',
      title: isArabic ? 'حيث عملت ودرست' : 'Where I’ve worked and studied',
      isDark: isDark,
      child: width >= 900
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: experience),
                const SizedBox(width: 24),
                Expanded(child: education),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [experience, const SizedBox(height: 16), education],
            ),
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({
    super.key,
    required this.narrow,
    required this.isArabic,
    required this.isDark,
  });

  final bool narrow;
  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      label: isArabic ? 'تواصل معي' : 'Contact',
      title: isArabic ? 'لنبدأ العمل معاً' : 'Get in touch',
      intro: isArabic
          ? 'البريد الإلكتروني هو أسرع طريقة للتواصل معي. يمكنك أيضاً زيارة حساباتي على لينكد إن و جيت هب.'
          : 'Email is the fastest way to reach me. You can also connect via LinkedIn or GitHub.',
      isDark: isDark,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          LinkButton(
            label: Profile.email,
            url: 'mailto:${Profile.email}',
            icon: Icons.mail_outline_rounded,
            primary: true,
          ),
          IconButton(
            tooltip: isArabic ? 'نسخ البريد الإلكتروني' : 'Copy email address',
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(text: Profile.email));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'تم نسخ البريد الإلكتروني'
                        : 'Email address copied',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, color: Show.accent),
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
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.isArabic, required this.isDark});

  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Show.getBorder(isDark))),
      ),
      child: _Width(
        child: Text(
          isArabic
              ? '© ${DateTime.now().year} ${Profile.name} · تم البناء باستخدام Flutter Web'
              : '© ${DateTime.now().year} ${Profile.name} · Built with Flutter Web',
          style: TextStyle(
            fontFamily: isArabic ? 'Cairo' : Show.body,
            color: Show.getMuted(isDark),
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
