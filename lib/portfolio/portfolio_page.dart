import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

import '../showcase/demos.dart';
import '../showcase/device_frame.dart';
import '../showcase/model.dart';
import '../showcase/shell.dart' show SiteBackdrop;
import '../showcase/theme.dart';
import 'profile_data.dart';

/// Colours the portfolio adds on top of [Show]. [Show.muted] is under 4.5:1 on
/// the card surface, so running text uses [P.body] instead.
abstract final class P {
  static const body = Color(0xFFA9B4CF);
  static const card = Show.surface;
  static const cardEdge = Color(0x2600D4FF);
  static const maxWidth = 1120.0;
}

abstract final class _T {
  static const label = TextStyle(
    fontFamily: Show.body,
    color: Show.accent,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.6,
  );
  static const h3 = TextStyle(
    fontFamily: Show.display,
    color: Show.text,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static const body = TextStyle(
    fontFamily: Show.body,
    fontFamilyFallback: ShowType.arabicFallback,
    color: P.body,
    fontSize: 15.5,
    height: 1.6,
  );
  static const small = TextStyle(
    fontFamily: Show.body,
    color: P.body,
    fontSize: 13.5,
    height: 1.5,
  );

  static TextStyle display(bool narrow) => TextStyle(
    fontFamily: Show.display,
    color: Show.text,
    fontSize: narrow ? 40 : 62,
    fontWeight: FontWeight.w800,
    height: 1.04,
    letterSpacing: -1,
  );

  static TextStyle h2(bool narrow) => TextStyle(
    fontFamily: Show.display,
    color: Show.text,
    fontSize: narrow ? 28 : 38,
    fontWeight: FontWeight.w800,
    height: 1.1,
  );
}

enum _Section { work, projects, skills, build, journey, contact }

extension on _Section {
  String get title => switch (this) {
    _Section.work => 'Case studies',
    _Section.projects => 'Projects',
    _Section.skills => 'Skills',
    _Section.build => 'How it’s built',
    _Section.journey => 'Experience',
    _Section.contact => 'Contact',
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
    return Scaffold(
      backgroundColor: Show.bg,
      body: Column(
        children: [
          _NavBar(onJump: _jump, compact: width < 980),
          Expanded(
            child: Scrollbar(
              controller: _scroll,
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  children: [
                    _Hero(demo: _demos.first, narrow: narrow, width: width),
                    _CaseStudies(
                      key: _keys[_Section.work],
                      demos: _demos,
                      width: width,
                    ),
                    _CodeProjects(key: _keys[_Section.projects], width: width),
                    _Skills(key: _keys[_Section.skills], width: width),
                    _BuildNotes(key: _keys[_Section.build], width: width),
                    _Journey(key: _keys[_Section.journey], width: width),
                    _Contact(key: _keys[_Section.contact], narrow: narrow),
                    const _Footer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────── chrome ─────────────────────────────

class _NavBar extends StatelessWidget {
  const _NavBar({required this.onJump, required this.compact});

  final ValueChanged<_Section> onJump;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xF2060810),
        border: Border(bottom: BorderSide(color: Show.border)),
      ),
      child: _Width(
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Show.accent, Show.accent2],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Text(
                'MN',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: Show.body,
                  color: Show.bg,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                Profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: Show.display,
                  color: Show.text,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
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
                    foregroundColor: P.body,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 44),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: Text(s.title),
                ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () => openShowcase(context),
              style: FilledButton.styleFrom(
                backgroundColor: Show.accent,
                foregroundColor: Show.bg,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(compact ? 'Showcase' : 'Live showcase'),
            ),
            PopupMenuButton<_Section>(
              tooltip: 'Sections',
              icon: const Icon(Icons.menu_rounded, color: Show.text),
              color: Show.surfaceAlt,
              onSelected: onJump,
              itemBuilder: (_) => [
                for (final s in _Section.values)
                  PopupMenuItem(
                    value: s,
                    child: Text(
                      s.title,
                      style: const TextStyle(color: Show.text),
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

/// Centres content in the page column with the page gutter.
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
          padding: EdgeInsets.symmetric(horizontal: narrow ? 20 : 32),
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
  });

  final String label;
  final String title;
  final String? intro;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 720;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: narrow ? 48 : 80),
      child: _Width(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: _T.label),
            const SizedBox(height: 10),
            Semantics(header: true, child: Text(title, style: _T.h2(narrow))),
            if (intro != null) ...[
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(intro!, style: _T.body),
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
  const _Card({required this.child, this.accent});

  final Widget child;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: P.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: P.cardEdge),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (accent != null) Container(height: 3, color: accent),
          Padding(padding: const EdgeInsets.all(22), child: child),
        ],
      ),
    );
  }
}

/// Lays children out in [columns] equal tracks that wrap.
class _Grid extends StatelessWidget {
  const _Grid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const gap = 20.0;
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
  const _Chip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x1400D4FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Show.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: Show.body,
          color: Show.text,
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips(this.items);

  final List<String> items;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [for (final i in items) _Chip(i)],
  );
}

/// External link rendered through url_launcher's [Link], which emits a real
/// anchor on the web so middle-click and "open in new tab" work.
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
              ),
            )
          : OutlinedButton.icon(
              onPressed: follow,
              icon: Icon(icon, size: 16),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: Show.text,
                side: const BorderSide(color: Color(0x5500D4FF)),
              ),
            ),
    );
  }
}

/// A demo rendered live inside the phone bezel, scaled to [width].
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
  const _Hero({required this.demo, required this.narrow, required this.width});

  final DemoSpec demo;
  final bool narrow;
  final double width;

  @override
  Widget build(BuildContext context) {
    final side = width >= 980;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Profile.role.toUpperCase(), style: _T.label),
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: Text(Profile.name, style: _T.display(narrow)),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            Profile.intro,
            style: _T.body.copyWith(fontSize: narrow ? 16 : 18),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => openShowcase(context),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Watch the live case studies'),
              style: FilledButton.styleFrom(
                backgroundColor: Show.accent,
                foregroundColor: Show.bg,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
            const LinkButton(
              label: 'GitHub',
              url: Profile.githubUrl,
              icon: Icons.code_rounded,
            ),
            const LinkButton(
              label: 'LinkedIn',
              url: Profile.linkedinUrl,
              icon: Icons.person_outline_rounded,
            ),
          ],
        ),
      ],
    );

    final phone = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          LivePhone(demo: demo, step: 2, width: narrow ? 250 : 300),
          const SizedBox(height: 14),
          const Text(
            'Live Flutter widgets, not a screenshot. Tap to play.',
            textAlign: TextAlign.center,
            style: _T.small,
          ),
        ],
      ),
    );

    return Stack(
      children: [
        const Positioned.fill(child: SiteBackdrop()),
        Padding(
          padding: EdgeInsets.symmetric(vertical: narrow ? 44 : 72),
          child: _Width(
            child: side
                ? Row(
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 40),
                      phone,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      copy,
                      const SizedBox(height: 44),
                      Center(child: phone),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x147B61FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x4D7B61FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Show.accent2, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: _T.small)),
        ],
      ),
    );
  }
}

class _CaseStudies extends StatelessWidget {
  const _CaseStudies({super.key, required this.demos, required this.width});

  final List<DemoSpec> demos;
  final double width;

  @override
  Widget build(BuildContext context) {
    final columns = width >= 1080 ? 2 : 1;
    final previews = width >= 720;
    return _SectionFrame(
      label: 'Interactive case studies',
      title: 'Four apps you can play through',
      intro:
          'Each case study replays an app’s key flow beat by beat, with '
          'notes on the engineering decision behind every screen.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Notice(
            'These are Flutter re-creations of each app’s screens running in '
            'your browser. Data, network calls, AI responses and device '
            'features are simulated. Matjarkom’s real source code is public; '
            'the other three are UX case studies.',
          ),
          const SizedBox(height: 24),
          _Grid(
            columns: columns,
            children: [
              for (final info in Profile.caseStudies)
                _CaseStudyCard(
                  demo: demos.firstWhere((d) => d.id == info.demoId),
                  info: info,
                  preview: previews,
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
  });

  final DemoSpec demo;
  final CaseStudyInfo info;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(demo.category, style: _T.label.copyWith(color: P.body)),
        const SizedBox(height: 8),
        Text(demo.name, style: _T.h3.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text(demo.subtitle, style: _T.small.copyWith(color: Show.text)),
        const SizedBox(height: 12),
        Text(demo.pitch, style: _T.small),
        const SizedBox(height: 12),
        Text(
          'Simulated flow · ${demo.steps.length} beats · ${info.source}',
          style: _T.small.copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => openShowcase(context, demo.id),
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Play case study'),
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
      child: preview
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 24),
                  child: LivePhone(
                    demo: demo,
                    step: info.previewStep,
                    width: 150,
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
  const _CodeProjects({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final columns = width >= 1080 ? 3 : (width >= 720 ? 2 : 1);
    return _SectionFrame(
      label: 'Code on GitHub',
      title: 'Projects with public source',
      intro:
          'Repositories you can clone and read. Descriptions follow each '
          'project’s README.',
      child: _Grid(
        columns: columns,
        children: [
          for (final p in Profile.codeProjects)
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: _T.h3),
                  const SizedBox(height: 8),
                  Text(p.summary, style: _T.small.copyWith(color: Show.text)),
                  const SizedBox(height: 12),
                  for (final point in p.points)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8, right: 10),
                            child: SizedBox(
                              width: 5,
                              height: 5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Show.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Text(point, style: _T.small)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  _Chips(p.stack),
                  const SizedBox(height: 18),
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
  const _Skills({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final columns = width >= 1080 ? 3 : (width >= 720 ? 2 : 1);
    return _SectionFrame(
      label: 'Skills',
      title: 'What I work with',
      intro: 'Grouped by area, each with the projects where it is used.',
      child: _Grid(
        columns: columns,
        children: [
          for (final g in Profile.skills)
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g.title, style: _T.h3.copyWith(fontSize: 18)),
                  const SizedBox(height: 14),
                  _Chips(g.skills),
                  const SizedBox(height: 14),
                  Text('Used in: ${g.evidence}', style: _T.small),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BuildNotes extends StatelessWidget {
  const _BuildNotes({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      label: 'Architecture',
      title: 'How this site is built',
      intro:
          'The portfolio is a Flutter web app. The source is public, so '
          'each point below can be checked in the repository.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Grid(
            columns: width >= 720 ? 2 : 1,
            children: [
              for (var i = 0; i < Profile.highlights.length; i++)
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (i + 1).toString().padLeft(2, '0'),
                        style: _T.label.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Text(Profile.highlights[i].title, style: _T.h3),
                      const SizedBox(height: 8),
                      Text(Profile.highlights[i].body, style: _T.small),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const LinkButton(
            label: 'Read the source',
            url: Profile.sourceUrl,
            icon: Icons.code_rounded,
          ),
        ],
      ),
    );
  }
}

class _Journey extends StatelessWidget {
  const _Journey({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    Widget column(String heading, List<TimelineEntry> entries) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: _T.h3.copyWith(color: Show.accent)),
        const SizedBox(height: 16),
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.period, style: _T.label.copyWith(color: P.body)),
                  const SizedBox(height: 8),
                  Text(e.title, style: _T.h3.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(e.place, style: _T.small.copyWith(color: Show.text)),
                  const SizedBox(height: 10),
                  for (final p in e.points)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(p, style: _T.small),
                    ),
                ],
              ),
            ),
          ),
      ],
    );

    final experience = column('Experience', Profile.experience);
    final education = column('Education & training', Profile.education);
    return _SectionFrame(
      label: 'Experience & education',
      title: 'Where I’ve worked and studied',
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
  const _Contact({super.key, required this.narrow});

  final bool narrow;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      label: 'Contact',
      title: 'Get in touch',
      intro:
          'Email is the fastest way to reach me. GitHub and LinkedIn are '
          'linked below.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const LinkButton(
            label: Profile.email,
            url: 'mailto:${Profile.email}',
            icon: Icons.mail_outline_rounded,
            primary: true,
          ),
          IconButton(
            tooltip: 'Copy email address',
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(text: Profile.email));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email address copied')),
              );
            },
            icon: const Icon(Icons.copy_rounded, color: P.body),
          ),
          const LinkButton(
            label: 'GitHub',
            url: Profile.githubUrl,
            icon: Icons.code_rounded,
          ),
          const LinkButton(
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
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Show.border)),
      ),
      child: _Width(
        child: Text(
          '© ${DateTime.now().year} ${Profile.name} · Built with Flutter web',
          style: _T.small,
        ),
      ),
    );
  }
}
