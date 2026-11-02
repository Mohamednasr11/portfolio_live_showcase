import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../showcase/kit.dart';

/// Build-Guard — the user's real app screens (D:\portfolio_flutter_ref\
/// assets\build_gaurd_assets) rebuilt as a live session. Every beat is
/// matched to a mockup:
///   home     → Home.png            (navy hero, "Your Home is Safe", quick actions)
///   scan     → Scan.png            (AI VISION header, orange frame, shutter row)
///   capture  → save_the_result.png (flash + "Name this Scan" sheet)
///   analyzing→ Analyzing _Image.png (lens + swirl, "Analyzing Image....")
///   result   → High_risk.jpg       (92/100 High Risk verdict)
///   analysis → Mediumrisk.png      (expanded defect breakdown card)
///   repair   → RepairSteps.png     (Repair Guide: tools + numbered process)
class BuildGuardDemo extends StatelessWidget {
  const BuildGuardDemo({super.key, required this.step});

  final int step;

  // Brand palette confirmed by the mockups.
  static const Color bg = Color(0xFFE9E9E7); // page gray behind every screen
  static const Color ink = Color(0xFF0A3350); // navy headers / primary buttons
  static const Color orange = Color(0xFFF5821F); // scan accents, active tab
  static const Color muted = Color(0xFF8A8A8E); // secondary gray text
  static const Color textBlack = Color(0xFF1F2226); // headings on gray pages
  static const Color stepInk = Color(0xFF55606B); // repair step copy

  // Risk language from Lowrisk / Mediumrisk / High_risk.
  static const Color high = Color(0xFFE2372C);
  static const Color highTint = Color(0xFFFBE4E1);
  static const Color med = Color(0xFFEF8A17);
  static const Color medTint = Color(0xFFFDEED8);
  static const Color low = Color(0xFF1FA75D);
  static const Color lowTint = Color(0xFFDCF3E5);
  static const Color pillGray = Color(0xFFF1F1EF);

  static const List<String> _screens = [
    'home',
    'scan',
    'capture',
    'analyzing',
    'result',
    'analysis',
    'repair',
  ];

  @override
  Widget build(BuildContext context) {
    final screen = _screens[step];
    // Home and the two verdict screens open on a full-bleed navy header that
    // runs behind the status bar; the rest sit on the gray page.
    final navyTop =
        screen == 'home' || screen == 'result' || screen == 'analysis';
    return AppScreen(
      background: bg,
      tone: navyTop ? DeviceScreenTone.dark : DeviceScreenTone.light,
      padding: EdgeInsets.fromLTRB(0, navyTop ? 0 : 44, 0, 0),
      child: LiveScreenStack(
        screenKey: screen,
        child: switch (screen) {
          'home' => const _Home(),
          'scan' => const _Scan(),
          'capture' => const _Capture(),
          'analyzing' => const _Analyzing(),
          'result' => const _Verdict(
              score: 92,
              level: 'High',
              tone: BuildGuardDemo.high,
              tint: BuildGuardDemo.highTint,
            ),
          'analysis' => const _Verdict(
              score: 68,
              level: 'Medium',
              tone: BuildGuardDemo.med,
              tint: BuildGuardDemo.medTint,
              expandedIndex: 0,
              stagger: true,
            ),
          _ => const _Repair(),
        },
      ),
    );
  }
}

/// Shared tab bar from Home.png / Scan.png: white pill, labelled tabs and a
/// floating scan FAB in the middle (orange while the camera is open).
class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, this.fabOrange = false});

  final int active; // 0 home · 1 providers · 2 FAB · 3 bookings · 4 profile
  final bool fabOrange;

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.engineering_rounded,
    Icons.camera_enhance_rounded,
    Icons.description_rounded,
    Icons.person_rounded,
  ];
  static const List<String> _labels = [
    'Home',
    'Providers',
    '',
    'Bookings',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final fab = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fabOrange ? BuildGuardDemo.orange : BuildGuardDemo.ink,
        boxShadow: [
          BoxShadow(
            color: (fabOrange ? BuildGuardDemo.orange : BuildGuardDemo.ink)
                .withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(Icons.camera_enhance_rounded,
          size: 26, color: Colors.white),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                for (var i = 0; i < _icons.length; i++)
                  if (i == 2)
                    const SizedBox(width: 52)
                  else
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _icons[i],
                            size: 21,
                            color: i == active
                                ? BuildGuardDemo.orange
                                : BuildGuardDemo.ink,
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            child: Txt(
                              _labels[i],
                              size: 10,
                              weight: FontWeight.w800,
                              maxLines: 1,
                              color: i == active
                                  ? BuildGuardDemo.orange
                                  : BuildGuardDemo.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, top: -16, child: Center(child: fab)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Beat 0 — Home.png
// ---------------------------------------------------------------------------

class _Home extends StatelessWidget {
  const _Home();

  static const double band = 132;
  static const double overlap = 42;

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: _Home.band,
                  color: BuildGuardDemo.ink,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Txt('Welcome back,',
                                size: 13, color: Color(0xFFBFD3E0)),
                            SizedBox(height: 2),
                            Txt('Ahmed',
                                size: 24,
                                weight: FontWeight.w800,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _Home.band - _Home.overlap),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.fromLTRB(18, 54, 18, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Txt('Your Home is Safe',
                          size: 19,
                          weight: FontWeight.w800,
                          color: BuildGuardDemo.textBlack,
                          align: TextAlign.center),
                      SizedBox(height: 8),
                      Txt('Last check: 2 days ago. No major risks detected.',
                          size: 12.5,
                          color: BuildGuardDemo.muted,
                          align: TextAlign.center,
                          height: 1.4),
                      SizedBox(height: 16),
                      Align(
                        child: _NavyChip('Check Now'),
                      ),
                    ],
                  ),
                ),
              ),
              // In Home.png the green shield straddles the card's top edge and
              // is centred over it, so it has to paint after the card.
              Positioned(
                top: _Home.band - _Home.overlap - 34,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 78,
                    height: 78,
                    child: Image(
                      image: AssetImage('assets/buildguard/shield_house.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 22, 16, 0),
            child: Txt('Quick Actions',
                size: 16.5,
                weight: FontWeight.w800,
                color: BuildGuardDemo.textBlack),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: _ActionCard(emoji: '☎️', label: 'Emergency')),
                SizedBox(width: 12),
                Expanded(
                    child: _ActionCard(emoji: '💡', label: 'Maintenance')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(
                    child:
                        _ActionCard(emoji: '📍', label: 'Nearby Hazards')),
                SizedBox(width: 12),
                Expanded(child: _ActionCard(emoji: '📖', label: 'Reports')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFA9BECB),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Txt('💡', size: 13),
                  SizedBox(width: 10),
                  Expanded(
                    child: Txt(
                      'Heat expands cracks. Check your walls monthly.',
                      size: 12,
                      weight: FontWeight.w600,
                      color: BuildGuardDemo.ink,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        footer: const _Tabs(active: 0),
      );
}

class _NavyChip extends StatelessWidget {
  const _NavyChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: BuildGuardDemo.ink,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Txt(label,
            size: 13, weight: FontWeight.w800, color: Colors.white),
      );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.emoji, required this.label});

  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Txt(emoji, size: 30),
            const SizedBox(height: 10),
            FittedBox(
              child: Txt(label,
                  size: 12.5,
                  weight: FontWeight.w800,
                  color: BuildGuardDemo.textBlack,
                  maxLines: 1),
            ),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// Beat 1 — Scan.png
// ---------------------------------------------------------------------------

class _Scan extends StatelessWidget {
  const _Scan();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Txt('AI VISION: ACTIVE',
                            size: 11,
                            weight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: BuildGuardDemo.muted,
                            maxLines: 1),
                      ),
                      SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Txt('LIGHTING: GOOD (85%)',
                            size: 11,
                            letterSpacing: 0.5,
                            color: BuildGuardDemo.muted,
                            maxLines: 1),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.flash_off_rounded,
                          size: 19, color: BuildGuardDemo.ink),
                    ),
                    SizedBox(height: 4),
                    Txt('Flash', size: 10, color: BuildGuardDemo.muted),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Txt('Align the crack within the orange frame',
                size: 14,
                weight: FontWeight.w800,
                color: BuildGuardDemo.ink,
                align: TextAlign.center),
          ),
          const SizedBox(height: 12),
          const Expanded(child: _Viewfinder()),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.image_outlined, size: 30, color: Colors.black87),
                _Shutter(),
                Icon(Icons.close, size: 30, color: Colors.black87),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const _Tabs(active: -1, fabOrange: true),
        ],
      );
}

class _Viewfinder extends StatefulWidget {
  const _Viewfinder();

  @override
  State<_Viewfinder> createState() => _ViewfinderState();
}

class _ViewfinderState extends State<_Viewfinder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, box) => Stack(
          fit: StackFit.expand,
          children: [
            const _Wall(),
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) => Positioned(
                left: 0,
                right: 0,
                top: _c.value * box.maxHeight,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: BuildGuardDemo.orange,
                    boxShadow: [
                      BoxShadow(
                        color: BuildGuardDemo.orange.withValues(alpha: 0.7),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const _Corner(color: BuildGuardDemo.orange),
            Positioned(
              top: 0,
              right: 0,
              child: Transform.rotate(
                angle: math.pi / 2,
                child: const _Corner(color: BuildGuardDemo.orange),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Transform.rotate(
                angle: -math.pi / 2,
                child: const _Corner(color: BuildGuardDemo.orange),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.rotate(
                angle: math.pi,
                child: const _Corner(color: BuildGuardDemo.orange),
              ),
            ),
          ],
        ),
      );
}

class _Corner extends StatelessWidget {
  const _Corner({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 34,
        height: 34,
        child: CustomPaint(painter: _CornerPainter(color)),
      );
}

class _CornerPainter extends CustomPainter {
  _CornerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.62)
        ..lineTo(0, 8)
        ..quadraticBezierTo(0, 0, 8, 0)
        ..lineTo(size.width * 0.62, 0),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) => old.color != color;
}

/// The wall from Scan.png, shipped as its own asset so the camera screen
/// and the verdict strip show the same real surface.
class _Wall extends StatelessWidget {
  const _Wall();

  @override
  Widget build(BuildContext context) => Image(
    image: const AssetImage('assets/buildguard/scan_crack.png'),
    fit: BoxFit.cover,
  );
}

class _Shutter extends StatefulWidget {
  const _Shutter();

  @override
  State<_Shutter> createState() => _ShutterState();
}

class _ShutterState extends State<_Shutter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BuildGuardDemo.orange,
            border: Border.all(
              color: Colors.white,
              width: 3 + 2 * _c.value,
            ),
            boxShadow: [
              BoxShadow(
                color: BuildGuardDemo.orange.withValues(alpha: 0.35 + 0.2 * _c.value),
                blurRadius: 22 + 10 * _c.value,
              ),
            ],
          ),
        ),
      );
}

// ---------------------------------------------------------------------------
// Beat 2 — shutter flash into save_the_result.png ("Name this Scan")
// ---------------------------------------------------------------------------

class _Capture extends StatelessWidget {
  const _Capture();

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, v, child) => Stack(
          fit: StackFit.expand,
          children: [
            child!,
            Positioned.fill(
              child: ColoredBox(
                color: Colors.white.withValues(alpha: (1 - v) * 0.85),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(0, (1 - v) * 280),
                child: const _NameScanSheet(),
              ),
            ),
          ],
        ),
        child: const _Viewfinder(),
      );
}

class _NameScanSheet extends StatelessWidget {
  const _NameScanSheet();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Txt('Name this Scan',
                size: 16,
                weight: FontWeight.w800,
                color: BuildGuardDemo.textBlack),
            const SizedBox(height: 26),
            const Txt('e.g., Living Room',
                size: 13, color: BuildGuardDemo.muted),
            const SizedBox(height: 10),
            Container(height: 1.2, color: const Color(0xFF9AA0A6)),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Txt('Cancel',
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: BuildGuardDemo.muted),
                SizedBox(width: 26),
                Txt('Save',
                    size: 13.5,
                    weight: FontWeight.w800,
                    color: BuildGuardDemo.ink),
              ],
            ),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// Beat 3 — Analyzing _Image.png
// ---------------------------------------------------------------------------

class _Analyzing extends StatefulWidget {
  const _Analyzing();

  @override
  State<_Analyzing> createState() => _AnalyzingState();
}

class _AnalyzingState extends State<_Analyzing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 176,
                height: 176,
                child: RotationTransition(
                  turns: _c,
                  child: CustomPaint(painter: _SwirlPainter()),
                ),
              ),
              const RingProgress(
                value: 0.82,
                size: 118,
                stroke: 7,
                color: BuildGuardDemo.orange,
                track: Color(0x140A3350),
              ),
              Container(
                width: 78,
                height: 78,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF144B70), BuildGuardDemo.ink],
                  ),
                ),
                child: const Icon(Icons.search_rounded,
                    size: 36, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Txt('Analyzing Image....',
              size: 17.5,
              weight: FontWeight.w800,
              color: BuildGuardDemo.textBlack),
        ],
      );
}

/// The teal + orange decorative arcs spinning around the lens.
class _SwirlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: size.width / 2 - 4),
      0.4,
      2.4,
      false,
      Paint()
        ..color = const Color(0xFF5BBFD9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: size.width / 2 - 12),
      3.4,
      1.9,
      false,
      Paint()
        ..color = BuildGuardDemo.orange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SwirlPainter old) => false;
}

// ---------------------------------------------------------------------------
// Beats 4 + 5 — High_risk.jpg / Mediumrisk.png verdict screens
// ---------------------------------------------------------------------------

class _Verdict extends StatelessWidget {
  static const double overlap = 54;

  const _Verdict({    required this.score,
    required this.level,
    required this.tone,
    required this.tint,
    this.expandedIndex = -1,
    this.stagger = false,
  });

  final int score;
  final String level;
  final Color tone;
  final Color tint;
  final int expandedIndex;
  final bool stagger;

  static const List<(String, String)> _defects = [
    ('Spalling', 'High'),
    ('Joint_tape', 'Low'),
    ('Rust', 'Medium'),
    ('Graffiti', 'Medium'),
    ('Cavity', 'Medium'),
  ];

  static Color _levelTone(String level) => switch (level) {
        'High' => BuildGuardDemo.high,
        'Low' => BuildGuardDemo.low,
        _ => BuildGuardDemo.med,
      };

  static Color _levelBg(String level) => switch (level) {
        'High' => BuildGuardDemo.highTint,
        'Low' => BuildGuardDemo.lowTint,
        _ => BuildGuardDemo.medTint,
      };

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          // Navy app bar: back · Analysis Result · download · share.
          Container(
            color: BuildGuardDemo.ink,
            padding: const EdgeInsets.fromLTRB(14, 40, 14, 14),
            child: const Row(
              children: [
                Icon(Icons.arrow_back_rounded, size: 20, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Txt('Analysis Result',
                      size: 15,
                      weight: FontWeight.w800,
                      color: Colors.white,
                      maxLines: 1),
                ),
                Icon(Icons.download_rounded, size: 18, color: Colors.white),
                SizedBox(width: 16),
                Icon(Icons.share_rounded, size: 17, color: Colors.white),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _DetectStrip(stagger: stagger),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: _DetectStrip._height - _Verdict.overlap),
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _Gauge(score: score),
                  Txt('$level Risk',
                      size: 19, weight: FontWeight.w800, color: tone),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: tint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified_user_rounded,
                            size: 17, color: tone),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Txt('Risk Level',
                              size: 12.5,
                              weight: FontWeight.w700,
                              color: tone,
                              maxLines: 1),
                        ),
                        const Spacer(),
                        Txt('$score /100',
                            size: 13.5,
                            weight: FontWeight.w800,
                            color: tone),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Expanded(child: _StatPill('Issues Found', '5')),
                      SizedBox(width: 10),
                      Expanded(child: _StatPill('Total Locations', '11')),
                    ],
                  ),
                ],
              ),
            ),
          ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 20, 18, 0),
            child: Txt('Advanced Analysis',
                size: 15,
                weight: FontWeight.w800,
                color: BuildGuardDemo.textBlack),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                for (var i = 0; i < _defects.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _DefectRow(
                      name: _defects[i].$1,
                      level: _defects[i].$2,
                      tone: _levelTone(_defects[i].$2),
                      chipBg: _levelBg(_defects[i].$2),
                      expanded: i == expandedIndex,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
        footer: const _SheetFooter(),
      );
}

/// Detection photo strip: concrete wall with model boxes on top.
class _DetectStrip extends StatefulWidget {
  const _DetectStrip({this.stagger = false});

  final bool stagger;

  static const double _height = 124;

  @override
  State<_DetectStrip> createState() => _DetectStripState();
}

class _DetectStripState extends State<_DetectStrip> {
  Timer? _timer;
  int _shown = 0;

  static const List<(double, double, double, double, String, Color)> _boxes = [
    (0.06, 0.10, 0.34, 0.30, 'Spalling 0.94', BuildGuardDemo.high),
    (0.55, 0.14, 0.36, 0.30, 'Rust 0.88', BuildGuardDemo.med),
    (0.12, 0.55, 0.30, 0.30, 'Crack 0.91', BuildGuardDemo.high),
    (0.58, 0.62, 0.32, 0.26, 'Cavity 0.79', BuildGuardDemo.med),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.stagger) {
      _timer = Timer.periodic(const Duration(milliseconds: 520), (_) {
        if (_shown < _boxes.length) setState(() => _shown++);
      });
    } else {
      _shown = _boxes.length;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _DetectStrip._height,
        child: LayoutBuilder(
          builder: (context, box) => Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: const _Wall(),
              ),
              for (var i = 0; i < _shown; i++)
                Positioned(
                  left: _boxes[i].$1 * box.maxWidth,
                  top: _boxes[i].$2 * _DetectStrip._height,
                  width: _boxes[i].$3 * box.maxWidth,
                  height: _boxes[i].$4 * _DetectStrip._height,
                  child: _Detect(label: _boxes[i].$5, color: _boxes[i].$6),
                ),
            ],
          ),
        ),
      );
}

class _Detect extends StatelessWidget {
  const _Detect({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 380),
        builder: (context, v, _) => Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _BoxPainter(color: color, t: v),
              ),
            ),
            Positioned(
              top: -1,
              left: 0,
              child: Opacity(
                opacity: v,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: color,
                  child: Txt(label,
                      size: 7.5,
                      weight: FontWeight.w800,
                      color: Colors.white,
                      maxLines: 1),
                ),
              ),
            ),
          ],
        ),
      );
}

class _BoxPainter extends CustomPainter {
  _BoxPainter({required this.color, required this.t});

  final Color color;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..color = color.withValues(alpha: 0.10 * t)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _BoxPainter old) => old.t != t;
}

/// Half-circle risk gauge with an animated needle.
class _Gauge extends StatefulWidget {
  const _Gauge({required this.score});

  final int score;

  @override
  State<_Gauge> createState() => _GaugeState();
}

class _GaugeState extends State<_Gauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 200,
        height: 112,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => CustomPaint(
            painter: _GaugePainter(
              t: Curves.easeOutCubic.transform(_c.value),
              score: widget.score,
            ),
          ),
        ),
      );
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.t, required this.score});

  final double t;
  final int score;

  static const _bands = [
    Color(0xFF6CC24A),
    Color(0xFFB5D334),
    Color(0xFFF7D000),
    Color(0xFFF79A00),
    Color(0xFFF26522),
    Color(0xFFED1C24),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 6;
    final r = size.width / 2 - 16;

    for (var i = 0; i < _bands.length; i++) {
      final start = math.pi + (i / _bands.length) * math.pi;
      final sweep = math.pi / _bands.length - 0.02;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..color = _bands[i],
      );
    }

    for (var i = 0; i <= 24; i++) {
      final a = math.pi + (i / 24) * math.pi;
      final outer = r + 10;
      final inner = outer - (i % 4 == 0 ? 6 : 3.5);
      canvas.drawLine(
        Offset(cx + math.cos(a) * inner, cy + math.sin(a) * inner),
        Offset(cx + math.cos(a) * outer, cy + math.sin(a) * outer),
        Paint()
          ..color = Colors.black87
          ..strokeWidth = 1.2,
      );
    }

    final angle = math.pi + (score / 100) * math.pi * t;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + math.cos(angle) * (r - 14), cy + math.sin(angle) * (r - 14)),
      Paint()
        ..color = const Color(0xFF17232B)
        ..strokeWidth = 3.4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      6,
      Paint()..color = const Color(0xFF17232B),
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) => old.t != t;
}

class _StatPill extends StatelessWidget {
  const _StatPill(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: BuildGuardDemo.pillGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                child: Txt(label,
                    size: 11.5,
                    weight: FontWeight.w600,
                    color: const Color(0xFF5A646E),
                    maxLines: 1),
              ),
            ),
            const SizedBox(width: 8),
            Txt(value,
                size: 13,
                weight: FontWeight.w800,
                color: BuildGuardDemo.textBlack),
          ],
        ),
      );
}

class _DefectRow extends StatelessWidget {
  const _DefectRow({
    required this.name,
    required this.level,
    required this.tone,
    required this.chipBg,
    required this.expanded,
  });

  final String name;
  final String level;
  final Color tone;
  final Color chipBg;
  final bool expanded;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Expanded(
                    child: Txt(name,
                        size: 13,
                        weight: FontWeight.w800,
                        color: BuildGuardDemo.textBlack),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Txt(level,
                        size: 11, weight: FontWeight.w700, color: tone),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 20,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
            if (expanded) ...[
              Container(height: 1, color: const Color(0xFFECECEC)),
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 14, 8, 14),
                child: Row(
                  children: [
                    _DetailCell(
                      icon: Icons.place_rounded,
                      bg: Color(0xFFE3F1FA),
                      fg: BuildGuardDemo.ink,
                      label: 'Found in',
                      value: '1 location',
                    ),
                    _CellDivider(),
                    _DetailCell(
                      icon: Icons.center_focus_weak_rounded,
                      bg: Color(0xFFEFEFEE),
                      fg: Color(0xFF666B70),
                      label: 'Damaged Area',
                      value: '3.8%',
                    ),
                    _CellDivider(),
                    _DetailCell(
                      icon: Icons.warning_amber_rounded,
                      bg: BuildGuardDemo.medTint,
                      fg: BuildGuardDemo.med,
                      label: 'Required Closure',
                      value: 'No',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
}

class _CellDivider extends StatelessWidget {
  const _CellDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 64, color: const Color(0xFFECECEC));
}

class _DetailCell extends StatelessWidget {
  const _DetailCell({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color bg;
  final Color fg;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: fg),
            ),
            const SizedBox(height: 6),
            Txt(label,
                size: 9.5,
                color: BuildGuardDemo.muted,
                align: TextAlign.center,
                maxLines: 2),
            const SizedBox(height: 2),
            Txt(value,
                size: 11,
                weight: FontWeight.w800,
                color: BuildGuardDemo.textBlack,
                align: TextAlign.center,
                maxLines: 1),
          ],
        ),
      );
}

/// Bottom sheet from the risk mockups: handle + filled + outlined buttons.
class _SheetFooter extends StatelessWidget {
  const _SheetFooter();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              child: SizedBox(
                width: 40,
                height: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFD4D4D4),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            _FillButton('Diy Repair Steps'),
            SizedBox(height: 8),
            _OutlineButton('Find Verified Engineers Near Me'),
          ],
        ),
      );
}

class _FillButton extends StatelessWidget {
  const _FillButton(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BuildGuardDemo.ink,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FittedBox(
          child: Txt(label,
              size: 13.5, weight: FontWeight.w800, color: Colors.white,
              maxLines: 1),
        ),
      );
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: BuildGuardDemo.ink.withValues(alpha: 0.45), width: 1.4),
        ),
        child: FittedBox(
          child: Txt(label,
              size: 13.5,
              weight: FontWeight.w800,
              color: BuildGuardDemo.ink,
              maxLines: 1),
        ),
      );
}

// ---------------------------------------------------------------------------
// Beat 6 — RepairSteps.png ("Repair Guide")
// ---------------------------------------------------------------------------

class _Repair extends StatelessWidget {
  const _Repair();

  static const List<(String, List<String>)> _groups = [
    (
      'Spalling',
      [
        'Complete removal of the damaged area',
        'additional reinforcement mesh',
        'recasting using C35 SCC concrete',
      ]
    ),
    (
      'Joint Tape',
      [
        'Redesign the joint connection',
        'install mesh tape',
        'apply fiberglass layer',
      ]
    ),
    (
      'Rust',
      [
        'Apply two alkyd epoxy coats',
        'zinc-rich primer',
        'SA2.5 sand blasting',
      ]
    ),
    (
      'Graffiti',
      [
        'Surface cleaning',
        'protective paint coating',
        'waterproof protective layer',
      ]
    ),
    (
      'Cavity',
      [
        'Access drilling',
        'Pressure injection with cementitious',
        'Epoxy mortar',
      ]
    ),
  ];

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_rounded, size: 22, color: Colors.black87),
                Expanded(
                  child: Txt('Repair Guide',
                      size: 17,
                      weight: FontWeight.w800,
                      color: BuildGuardDemo.textBlack,
                      align: TextAlign.center,
                      maxLines: 1),
                ),
                SizedBox(width: 22),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E7C9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 18, color: BuildGuardDemo.med),
                  SizedBox(width: 10),
                  Expanded(
                    child: Txt('Wear protective gear before starting',
                        size: 12,
                        weight: FontWeight.w600,
                        color: Color(0xFF7C6E52),
                        maxLines: 2),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Txt('Tools Needed',
                      size: 15,
                      weight: FontWeight.w800,
                      color: BuildGuardDemo.textBlack),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 20, color: Colors.black87),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: _ToolCard(emoji: '🔪', label: 'Putty Knife')),
                SizedBox(width: 8),
                Expanded(child: _ToolCard(emoji: '🖌️', label: 'Paint Brush')),
                SizedBox(width: 8),
                Expanded(child: _ToolCard(emoji: '🧤', label: 'Gloves')),
                SizedBox(width: 8),
                Expanded(child: _ToolCard(emoji: '🧴', label: 'Filler Paste')),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Txt('Repair Process',
                size: 15,
                weight: FontWeight.w800,
                color: BuildGuardDemo.textBlack),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var g = 0; g < _groups.length; g++)
                  _RepairGroup(
                    title: _groups[g].$1,
                    steps: _groups[g].$2,
                    delay: g,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        footer: Container(
          color: BuildGuardDemo.bg,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: const _FillButton('Mark as Fixed'),
        ),
      );
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.emoji, required this.label});

  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Txt(emoji, size: 24),
            const SizedBox(height: 6),
            FittedBox(
              child: Txt(label,
                  size: 10,
                  weight: FontWeight.w700,
                  color: BuildGuardDemo.textBlack,
                  maxLines: 1),
            ),
          ],
        ),
      );
}

class _RepairGroup extends StatelessWidget {
  const _RepairGroup({
    required this.title,
    required this.steps,
    required this.delay,
  });

  final String title;
  final List<String> steps;
  final int delay;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 340 + delay * 160),
          builder: (context, v, child) => Opacity(
            opacity: v.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(12 * (1 - v), 0),
              child: child,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Txt(title,
                  size: 13.5,
                  weight: FontWeight.w800,
                  color: BuildGuardDemo.textBlack),
              const SizedBox(height: 8),
              for (var i = 0; i < steps.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: BuildGuardDemo.ink,
                              shape: BoxShape.circle,
                            ),
                            child: Txt('${i + 1}',
                                size: 11,
                                weight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          if (i != steps.length - 1)
                            Container(
                              width: 2,
                              height: 26,
                              color: const Color(0xFFB9C6D0),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Txt(steps[i],
                              size: 12,
                              height: 1.35,
                              color: BuildGuardDemo.stepInk),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}
