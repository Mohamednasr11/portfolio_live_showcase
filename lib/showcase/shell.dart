import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';
import 'device_frame.dart';
import 'theme.dart';

class PresentationShell extends StatefulWidget {
  const PresentationShell({super.key, required this.controller});

  final PresentationController controller;

  @override
  State<PresentationShell> createState() => _PresentationShellState();
}

class _PresentationShellState extends State<PresentationShell> {
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode(debugLabel: 'presentation-keys');
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent &&
        !(event is KeyRepeatEvent &&
            event.physicalKey == PhysicalKeyboardKey.space)) {
      return KeyEventResult.ignored;
    }
    final c = widget.controller;
    final shift = HardwareKeyboard.instance.isShiftPressed;
    final key = event.physicalKey;

    if (key == PhysicalKeyboardKey.arrowRight ||
        key == PhysicalKeyboardKey.keyD) {
      if (shift) {
        c.nextDemo();
      } else {
        c.next();
      }
      return KeyEventResult.handled;
    }
    if (key == PhysicalKeyboardKey.arrowLeft ||
        key == PhysicalKeyboardKey.keyA) {
      if (shift) {
        c.prevDemo();
      } else {
        c.prev();
      }
      return KeyEventResult.handled;
    }
    if (key == PhysicalKeyboardKey.space) {
      c.togglePlay();
      return KeyEventResult.handled;
    }
    if (key == PhysicalKeyboardKey.keyN) {
      c.toggleNotes();
      return KeyEventResult.handled;
    }
    if (key == PhysicalKeyboardKey.keyM) {
      c.toggleAnnotations();
      return KeyEventResult.handled;
    }
    if (key == PhysicalKeyboardKey.keyS) {
      c.cycleSpeed();
      return KeyEventResult.handled;
    }
    if (key == PhysicalKeyboardKey.keyR) {
      c.restart();
      return KeyEventResult.handled;
    }
    if (key == PhysicalKeyboardKey.escape) {
      c.pause();
      return KeyEventResult.ignored;
    }
    final digits = <PhysicalKeyboardKey, int>{
      PhysicalKeyboardKey.digit1: 0,
      PhysicalKeyboardKey.digit2: 1,
      PhysicalKeyboardKey.digit3: 2,
      PhysicalKeyboardKey.digit4: 3,
      PhysicalKeyboardKey.numpad1: 0,
      PhysicalKeyboardKey.numpad2: 1,
      PhysicalKeyboardKey.numpad3: 2,
      PhysicalKeyboardKey.numpad4: 3,
    };
    final target = digits[key];
    if (target != null) {
      c.goToDemo(target);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // Depending on the scope is what rebuilds this subtree on every beat; the
    // const panels below rebuild through the same dependency.
    final c = context.watchController;
    final wide = MediaQuery.sizeOf(context).width > 1180;

    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Material(
        // A Text with no Material ancestor is painted with Flutter's "ugly"
        // fallback style (red text, yellow double underline); our explicit
        // styles override the colour but inherit the underline.
        type: MaterialType.canvas,
        color: Show.bg,
        child: Column(
          children: [
            const _TopBar(),
            // Without the rail, the strip is the only touch path between projects.
            if (!wide) const _ProjectStrip(),
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(child: SiteBackdrop()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (wide) const _DemoRail(),
                      Expanded(child: _Stage(wide: wide)),
                      if (c.showNotes && wide) const _NotesPanel(),
                    ],
                  ),
                ],
              ),
            ),
            _Hud(controller: c),
          ],
        ),
      ),
    );
  }
}

/// `.hero-bg` from the site: three coloured radial washes over an 80px grid
/// that fades out towards the edges.
class SiteBackdrop extends StatelessWidget {
  const SiteBackdrop({super.key});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _HeroBgPainter(), size: Size.infinite);
}

class _HeroBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    void wash(double cx, double cy, double rx, double ry, Color color) {
      final center = Offset(cx * size.width, cy * size.height);
      final paint = Paint()
        ..shader = RadialGradient(
          center: Alignment(
            (center.dx / size.width) * 2 - 1,
            (center.dy / size.height) * 2 - 1,
          ),
          radius: 1,
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0, .6],
        ).createShader(rect);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(rx, ry);
      canvas.translate(-center.dx, -center.dy);
      canvas.drawRect(rect, paint);
      canvas.restore();
    }

    wash(.70, .50, .60, .70, const Color(0x0F00D4FF));
    wash(.20, .80, .40, .50, const Color(0x147B61FF));
    wash(.80, .20, .30, .40, const Color(0x0A00FF88));

    // 80px grid, masked so it dissolves before the corners.
    final layer = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.saveLayer(layer, Paint());
    final line = Paint()
      ..color = const Color(0x0A00D4FF)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    canvas.drawRect(
      layer,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = const RadialGradient(
          colors: [Color(0xFF000000), Color(0xFF000000), Color(0x00000000)],
          stops: [.3, .3, .8],
        ).createShader(layer),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final c = context.watchController;
    final narrow = MediaQuery.sizeOf(context).width < 720;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: narrow ? 10 : 30,
        vertical: narrow ? 8 : 16,
      ),
      decoration: BoxDecoration(
        color: Show.bg.withValues(alpha: .7),
        border: const Border(bottom: BorderSide(color: Show.border)),
      ),
      child: Row(
        children: [
          _BackToPortfolio(compact: narrow),
          SizedBox(width: narrow ? 6 : 16),
          // .nav-logo — "MN." with the accent dot.
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'MN'),
                TextSpan(
                  text: '.',
                  style: TextStyle(color: Show.accent),
                ),
              ],
            ),
            style: TextStyle(
              fontFamily: Show.display,
              fontFamilyFallback: ShowType.arabicFallback,
              color: Show.text,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -.5,
            ),
          ),
          if (!narrow) ...[
            const SizedBox(width: 28),
            const Text(
              'LIVE UX SHOWCASE',
              style: TextStyle(
                fontFamily: Show.body,
                fontFamilyFallback: ShowType.arabicFallback,
                color: Show.muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: .24,
              ),
            ),
          ],
          const SizedBox(width: 12),
          // .hero-tag — the pulsing pill that names the project on stage.
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: narrow ? 12 : 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Show.accent.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Show.accent.withValues(alpha: .2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Show.accent3,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        narrow
                            ? c.demo.name.toUpperCase()
                            : '${c.demo.name.toUpperCase()} · ${c.demo.category.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: Show.body,
                          fontFamilyFallback: ShowType.arabicFallback,
                          color: Show.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .65,
                        ),
                      ),
                    ),
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

class _BackToPortfolio extends StatelessWidget {
  const _BackToPortfolio({required this.compact});

  final bool compact;

  void _leave(BuildContext context) {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      nav.pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back to portfolio',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => _leave(context),
          child: Container(
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0x1FFFFFFF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: Show.text,
                ),
                if (!compact) ...[
                  const SizedBox(width: 6),
                  Text(
                    'Portfolio',
                    style: ShowType.body.copyWith(
                      color: Show.text,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Touch-sized project switcher for layouts that have no side rail.
class _ProjectStrip extends StatelessWidget {
  const _ProjectStrip();

  @override
  Widget build(BuildContext context) {
    final c = context.watchController;
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Show.border)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        itemCount: c.demos.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final spec = c.demos[i];
          final selected = i == c.demoIndex;
          return Material(
            color: selected ? spec.accent.withValues(alpha: .18) : Show.surface,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => c.goToDemo(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: selected
                        ? spec.accent.withValues(alpha: .6)
                        : const Color(0x14FFFFFF),
                  ),
                ),
                child: Text(
                  spec.name,
                  style: TextStyle(
                    fontFamily: Show.display,
                    fontFamilyFallback: ShowType.arabicFallback,
                    color: selected ? Show.text : Show.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DemoRail extends StatelessWidget {
  const _DemoRail();

  @override
  Widget build(BuildContext context) {
    final c = context.watchController;
    return Container(
      width: 236,
      padding: const EdgeInsets.fromLTRB(16, 20, 12, 20),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Show.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 14),
            child: _SectionLabel(text: 'Featured Projects'),
          ),
          for (var i = 0; i < c.demos.length; i++)
            _RailTile(
              index: i,
              selected: i == c.demoIndex,
              progress: i == c.demoIndex ? c.demoProgress : 0,
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '${c.stepIndex + 1}/${c.demo.steps.length} beats',
              style: ShowType.mono.copyWith(color: Show.muted),
            ),
          ),
        ],
      ),
    );
  }
}

/// `.section-label` — uppercase accent text preceded by a 24px rule.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 24, height: 1, color: Show.accent),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          text.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ShowType.label,
        ),
      ),
    ],
  );
}

class _RailTile extends StatelessWidget {
  const _RailTile({
    required this.index,
    required this.selected,
    required this.progress,
  });

  final int index;
  final bool selected;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final c = context.watchController;
    final spec = c.demos[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Show.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => c.goToDemo(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? Show.accent.withValues(alpha: .2)
                    : const Color(0x0DFFFFFF),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selected ? Show.accent : Show.muted,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spec.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: Show.display,
                          fontFamilyFallback: ShowType.arabicFallback,
                          color: selected ? Show.text : Show.muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.3,
                        ),
                      ),
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: selected ? progress : 0,
                          minHeight: 3,
                          backgroundColor: Show.muted.withValues(alpha: .16),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            spec.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final c = context.watchController;
    return LayoutBuilder(
      builder: (context, box) {
        // Grow with the stage but never below the width the demo screens are
        // designed for; below that the stage scrolls instead of clipping.
        final byHeight = (box.maxHeight - 194) / 2.09 + 18;
        final deviceWidth = math
            .min(byHeight, box.maxWidth - 56)
            .clamp(320.0, 360.0);
        final frameHeight = (deviceWidth - 18) * 2.09 + 20;
        // Phones get the whole device in view by scaling the frame, never by
        // shrinking the layout width the demos were built against.
        final scale = wide
            ? 1.0
            : ((box.maxHeight - 32) / frameHeight).clamp(.7, 1.0);
        final panelWidth = math.min(deviceWidth + 70, box.maxWidth - 24);
        final device = DeviceFrame(
          width: deviceWidth,
          child: c.demo.builder(context, c.stepIndex),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: wide ? 0 : 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: wide ? box.maxHeight : box.maxHeight - 32,
            ),
            child: Center(
              child: Column(
                children: [
                  if (wide)
                    device
                  else
                    SizedBox(
                      width: deviceWidth * scale,
                      height: frameHeight * scale,
                      child: FittedBox(child: device),
                    ),
                  SizedBox(height: deviceWidth * 0.10),
                  if (c.showAnnotations)
                    _Annotation(
                      label: c.step.label,
                      note: c.step.annotation,
                      accent: c.demo.accent,
                      width: panelWidth,
                    ),
                  _SimulationNotice(width: panelWidth),
                  if (!wide && c.showNotes)
                    Container(
                      width: panelWidth,
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Show.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Show.border),
                      ),
                      child: const _NotesContent(),
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

class _SimulationNotice extends StatelessWidget {
  const _SimulationNotice({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: Show.muted,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Interactive Flutter re-creation of the app’s screens. Data, '
              'network calls and device features are simulated.',
              style: ShowType.body.copyWith(fontSize: 12, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _Annotation extends StatelessWidget {
  const _Annotation({
    required this.label,
    required this.note,
    required this.accent,
    required this.width,
  });

  final String label;
  final String note;
  final Color accent;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Show.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: .2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: ShowType.label.copyWith(color: accent, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Text(note, style: ShowType.body.copyWith(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _NotesPanel extends StatelessWidget {
  const _NotesPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 352,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      decoration: const BoxDecoration(
        color: Show.surface,
        border: Border(left: BorderSide(color: Show.border)),
      ),
      child: const SingleChildScrollView(child: _NotesContent()),
    );
  }
}

class _NotesContent extends StatelessWidget {
  const _NotesContent();

  @override
  Widget build(BuildContext context) {
    final c = context.watchController;
    final step = c.step;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(text: 'Project'),
        const SizedBox(height: 10),
        Text(
          c.demo.headline,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontFamily: Show.display,
            fontFamilyFallback: ShowType.arabicFallback,
            color: Show.text,
            fontSize: 17,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(c.demo.subtitle, style: ShowType.body.copyWith(fontSize: 13)),
        const SizedBox(height: 24),
        const _SectionLabel(text: 'What it proves'),
        const SizedBox(height: 10),
        Text(
          step.techNote,
          style: const TextStyle(
            fontFamily: Show.body,
            fontFamilyFallback: ShowType.arabicFallback,
            color: Show.text,
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        const _SectionLabel(text: 'Say this'),
        const SizedBox(height: 10),
        Text(
          step.speakerNote,
          style: ShowType.body.copyWith(color: Show.muted),
        ),
        const SizedBox(height: 24),
        const _SectionLabel(text: 'Stack'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < c.demo.stack.length; i++)
              _TagChip(
                text: c.demo.stack[i],
                tint: _tagTints[i % _tagTints.length],
              ),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionLabel(text: 'Flow'),
        const SizedBox(height: 12),
        for (var i = 0; i < c.demo.steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              children: [
                Icon(
                  i == c.stepIndex
                      ? Icons.play_arrow_rounded
                      : i < c.stepIndex
                      ? Icons.check_rounded
                      : Icons.circle_outlined,
                  size: 14,
                  color: i == c.stepIndex
                      ? Show.accent
                      : i < c.stepIndex
                      ? Show.accent3
                      : Show.muted.withValues(alpha: .5),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    c.demo.steps[i].label,
                    style: TextStyle(
                      fontFamily: Show.body,
                      fontFamilyFallback: ShowType.arabicFallback,
                      fontSize: 12.5,
                      color: i == c.stepIndex ? Show.text : Show.muted,
                      fontWeight: i == c.stepIndex
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// `.tag-flutter` / `.tag-dart` / `.tag-ui` / `.tag-firebase` from the site.
  static const List<Color> _tagTints = [
    Show.accent,
    Show.accent2,
    Show.accent3,
    Color(0xFFFFA726),
  ];
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text, required this.tint});

  final String text;
  final Color tint;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: tint.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: Show.body,
        fontFamilyFallback: ShowType.arabicFallback,
        color: tint,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: .44,
      ),
    ),
  );
}

class _Hud extends StatelessWidget {
  const _Hud({required this.controller});

  final PresentationController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;

    final transport = <Widget>[
      _HudButton(
        icon: c.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
        primary: true,
        onTap: c.togglePlay,
        tooltip: 'Play / pause  (Space)',
      ),
      const SizedBox(width: 8),
      _HudButton(
        icon: Icons.skip_previous_rounded,
        onTap: c.prev,
        tooltip: 'Previous beat  (←)',
      ),
      _HudButton(
        icon: Icons.skip_next_rounded,
        onTap: c.next,
        tooltip: 'Next beat  (→)',
      ),
      _HudButton(
        icon: Icons.restart_alt_rounded,
        onTap: c.restart,
        tooltip: 'Restart  (R)',
      ),
    ];
    final speed = _ChipLabel(
      label: '${c.speed}x',
      onTap: c.cycleSpeed,
      tooltip: 'Playback speed  (S)',
    );
    final notes = _ChipLabel(
      label: c.showNotes ? 'Notes' : 'Notes off',
      onTap: c.toggleNotes,
      tooltip: 'Speaker notes  (N)',
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 24,
        vertical: compact ? 8 : 14,
      ),
      decoration: BoxDecoration(
        color: Show.bg.withValues(alpha: .9),
        border: const Border(top: BorderSide(color: Show.border)),
      ),
      child: SafeArea(
        top: false,
        child: compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BeatTrack(controller: c),
                  const SizedBox(height: 6),
                  Row(children: [...transport, const Spacer(), speed, notes]),
                ],
              )
            : Row(
                children: [
                  ...transport,
                  const SizedBox(width: 14),
                  speed,
                  notes,
                  _ChipLabel(
                    label: c.showAnnotations ? 'Captions' : 'Captions off',
                    onTap: c.toggleAnnotations,
                    tooltip: 'On-stage captions  (M)',
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: _BeatTrack(controller: c)),
                  if (width >= 1400) ...[
                    const SizedBox(width: 14),
                    const _KeyHints(),
                  ],
                ],
              ),
      ),
    );
  }
}

class _BeatTrack extends StatelessWidget {
  const _BeatTrack({required this.controller});

  final PresentationController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final n = c.demo.steps.length;
    return Row(
      children: [
        for (var i = 0; i < n; i++)
          Expanded(
            child: Semantics(
              button: true,
              label: 'Beat ${i + 1}: ${c.demo.steps[i].label}',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => c.goToDemo(c.demoIndex, step: i),
                child: Padding(
                  // The bar is 4px; the padding is the finger-sized target.
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 8,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: i == c.stepIndex ? 7 : 4,
                    decoration: BoxDecoration(
                      color: i <= c.stepIndex
                          ? Show.accent
                          : Show.muted.withValues(alpha: .22),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _KeyHints extends StatelessWidget {
  const _KeyHints();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '← → beat   ⇧← → project   Space play   S speed   N notes   1-4 jump',
      style: TextStyle(
        fontFamily: Show.body,
        fontFamilyFallback: ShowType.arabicFallback,
        color: Show.muted,
        fontSize: 11,
      ),
    );
  }
}

class _HudButton extends StatelessWidget {
  const _HudButton({
    required this.icon,
    required this.onTap,
    this.primary = false,
    this.tooltip = '',
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        // .btn-primary vs .btn-secondary
        color: primary ? Show.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: primary ? 44 : 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: primary ? Show.accent : const Color(0x1FFFFFFF),
              ),
            ),
            child: Icon(
              icon,
              size: primary ? 22 : 18,
              color: primary ? Show.bg : Show.text,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({
    required this.label,
    required this.onTap,
    this.tooltip = '',
  });

  final String label;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Show.accent.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontFamily: Show.body,
                  fontFamilyFallback: ShowType.arabicFallback,
                  color: Show.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .44,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Local listener-free read helper: the shell rebuilds on every notify, so the
/// widgets below only need the controller instance from the tree.
extension WatchController on BuildContext {
  PresentationController get watchController =>
      _ControllerScope.of(this).controller;
}

class _ControllerScope extends InheritedWidget {
  const _ControllerScope({
    required this.controller,
    required this.tick,
    required super.child,
  });

  final PresentationController controller;

  /// Bumped on every controller notification so that descendants which called
  /// [BuildContext.watchController] — including `const` ones — rebuild.
  final int tick;

  static _ControllerScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ControllerScope>()!;

  @override
  bool updateShouldNotify(_ControllerScope oldWidget) =>
      controller != oldWidget.controller || tick != oldWidget.tick;
}

/// Wraps [PresentationShell] so descendants can read the controller.
class PresentationRoot extends StatefulWidget {
  const PresentationRoot({super.key, required this.controller});

  final PresentationController controller;

  @override
  State<PresentationRoot> createState() => _PresentationRootState();
}

class _PresentationRootState extends State<PresentationRoot> {
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onBeat);
  }

  void _onBeat() => setState(() => _tick++);

  @override
  void dispose() {
    widget.controller.removeListener(_onBeat);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ControllerScope(
      controller: widget.controller,
      tick: _tick,
      child: PresentationShell(controller: widget.controller),
    );
  }
}
