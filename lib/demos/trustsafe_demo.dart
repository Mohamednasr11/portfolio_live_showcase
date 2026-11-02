import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../showcase/kit.dart';

/// TrustSafe — secure document vault, rebuilt as a live session.
///
/// Every beat mirrors the real App-Store shots (`trustsafe_0..8`): warm
/// near-white screens, sienna buttons, white cards with hairline tan borders,
/// peach icon chips and bold sans headings throughout.
class TrustSafeDemo extends StatelessWidget {
  const TrustSafeDemo({super.key, required this.step});

  final int step;

  static const Color bg = Color(0xFFFFFBF5);
  static const Color card = Colors.white;
  static const Color ink = Color(0xFF211A14);
  static const Color accent = Color(0xFFA0562C);
  static const Color muted = Color(0xFF7C6E60);
  static const Color line = Color(0xFFEADFD2);
  static const Color chip = Color(0xFFF7E8D8);
  static const Color danger = Color(0xFFA94426);
  static const Color navy = Color(0xFF192E49);

  static const List<String> _screens = [
    'splash',
    'vault',
    'upload',
    'access',
    'unlock',
    'settings',
  ];

  @override
  Widget build(BuildContext context) {
    final screen = _screens[step];
    return AppScreen(
      background: bg,
      tone: DeviceScreenTone.light,
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 12),
      child: LiveScreenStack(
        screenKey: screen,
        child: switch (screen) {
          'splash' => const _Splash(),
          'vault' => const _Vault(),
          'upload' => const _Upload(),
          'access' => const _Access(),
          'unlock' => const _Unlock(),
          _ => const _Settings(),
        },
      ),
    );
  }
}

// ---------------------------------------------------------------- shared bits

/// Staged rise + fade used across beats (brand reveal, list rows, timeline).
class _Reveal extends StatelessWidget {
  const _Reveal({required this.index, required this.child, this.total = 1500});

  final int index;
  final Widget child;
  final int total;

  @override
  Widget build(BuildContext context) {
    final start = math.min(0.72, index * 0.16);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(start, math.min(1.0, start + 0.45),
          curve: Curves.easeOutCubic),
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, 12 * (1 - v)), child: child),
      ),
      child: child,
    );
  }
}

/// The sienna CTA from the mockups ("Login", "+ Add New Document", …).
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TrustSafeDemo.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 7),
            ],
            Flexible(
              child: Txt(label,
                  size: 12.5,
                  weight: FontWeight.w700,
                  color: Colors.white,
                  align: TextAlign.center,
                  maxLines: 1),
            ),
          ],
        ),
      );
}

/// Outlined secondary button (the "Edit"/"Delete" pair on beneficiary cards).
class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.icon, required this.color});

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TrustSafeDemo.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.55)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Txt(label,
                  size: 11, weight: FontWeight.w700, color: color, maxLines: 1),
            ),
          ],
        ),
      );
}

/// The small pill switch from the mockups (Settings → Biometric Login).
class _MiniSwitch extends StatelessWidget {
  const _MiniSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 42,
        height: 25,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Material(
            type: MaterialType.transparency,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: TrustSafeDemo.accent,
              inactiveTrackColor: TrustSafeDemo.line,
              inactiveThumbColor: Colors.white,
            ),
          ),
        ),
      );
}

/// Labeled bottom bar from the real app: Home · Documents · Beneficiaries · Account.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.active});

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.folder_outlined, 'Documents'),
    (Icons.group_outlined, 'Beneficiaries'),
    (Icons.settings_outlined, 'Account'),
  ];

  final int active;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 9, bottom: 4),
        decoration: const BoxDecoration(
          color: TrustSafeDemo.card,
          border: Border(top: BorderSide(color: TrustSafeDemo.line)),
        ),
        child: Row(
          children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _items[i].$1,
                      size: 19,
                      color: i == active ? TrustSafeDemo.accent : TrustSafeDemo.muted,
                    ),
                    const SizedBox(height: 3),
                    Txt(
                      _items[i].$2,
                      size: 9,
                      weight: FontWeight.w600,
                      color: i == active ? TrustSafeDemo.accent : TrustSafeDemo.muted,
                      align: TextAlign.center,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}

/// A document row as in "My Documents": peach icon chip, name, date, ⋮ menu.
class _DocRow extends StatelessWidget {
  const _DocRow({required this.title, required this.date});

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Surface(
          color: TrustSafeDemo.card,
          radius: 14,
          border: TrustSafeDemo.line,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TrustSafeDemo.chip,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_outlined,
                    size: 16, color: TrustSafeDemo.accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Txt(title,
                        size: 12,
                        weight: FontWeight.w700,
                        color: TrustSafeDemo.ink,
                        maxLines: 1),
                    Txt(date, size: 10, color: TrustSafeDemo.muted, maxLines: 1),
                  ],
                ),
              ),
              const Icon(Icons.more_vert_rounded,
                  size: 18, color: TrustSafeDemo.ink),
            ],
          ),
        ),
      );
}

/// Dashed rounded drop zone, hand-painted (no third-party dotted border).
class _DashedBox extends StatelessWidget {
  const _DashedBox({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: CustomPaint(
          foregroundPainter: const _DashedBorderPainter(),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Center(child: child),
          ),
        ),
      );
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC9B7A2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(14)));
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = math.min(dist + 6, metric.length);
        canvas.drawPath(metric.extractPath(dist, next), paint);
        dist = next + 5;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => false;
}

// ------------------------------------------------------- beat 0 · login/splash

/// trustsafe_0 + trustsafe_1: brand mark, "TrustSafe LLC" wordmark,
/// then the real "Welcome Back" login form revealed in stages.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const SizedBox(height: 14),
          _Reveal(
            index: 0,
            child: Center(
              child: FakeImage(
                size: const Size(128, 106),
                from: const Color(0xFFF0E2CE),
                to: const Color(0xFF8F6A45),
                radius: 20,
                icon: Icons.pets,
                iconColor: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _Reveal(
            index: 1,
            child: Txt('TrustSafe LLC',
                size: 19,
                weight: FontWeight.w700,
                color: TrustSafeDemo.ink,
                align: TextAlign.center),
          ),
          const SizedBox(height: 16),
          const _Reveal(
            index: 2,
            child: Txt('Welcome Back',
                size: 21,
                weight: FontWeight.w800,
                color: TrustSafeDemo.ink,
                align: TextAlign.center),
          ),
          const SizedBox(height: 4),
          const _Reveal(
            index: 3,
            child: Txt('Log in to access your secure vault.',
                size: 11.5,
                weight: FontWeight.w600,
                color: TrustSafeDemo.muted,
                align: TextAlign.center),
          ),
          const SizedBox(height: 18),
          _Reveal(
            index: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Txt('Email Address',
                    size: 11.5,
                    weight: FontWeight.w700,
                    color: TrustSafeDemo.ink),
                SizedBox(height: 6),
                _Field(icon: Icons.mail_outline, hint: 'Enter your email'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Reveal(
            index: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Txt('Password',
                    size: 11.5,
                    weight: FontWeight.w700,
                    color: TrustSafeDemo.ink),
                SizedBox(height: 6),
                _Field(
                  icon: Icons.lock_outline,
                  hint: 'Enter your password',
                  trailing: Icons.visibility_off_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _Reveal(index: 6, child: _PrimaryButton(label: 'Login')),
          const SizedBox(height: 14),
          _Reveal(
            index: 7,
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  Txt("Don't have an account?",
                      size: 11.5,
                      weight: FontWeight.w700,
                      color: TrustSafeDemo.ink),
                  SizedBox(width: 6),
                  Txt('Register Now',
                      size: 11.5,
                      weight: FontWeight.w700,
                      color: TrustSafeDemo.accent),
                ],
              ),
            ),
          ),
        ],
      );
}

class _Field extends StatelessWidget {
  const _Field({required this.icon, required this.hint, this.trailing});

  final IconData icon;
  final String hint;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) => Surface(
        color: TrustSafeDemo.card,
        radius: 12,
        border: TrustSafeDemo.line,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 17, color: TrustSafeDemo.muted),
            const SizedBox(width: 10),
            Expanded(
              child: Txt(hint,
                  size: 12.5, color: TrustSafeDemo.muted, maxLines: 1),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Icon(trailing, size: 17, color: TrustSafeDemo.muted),
            ],
          ],
        ),
      );
}

// -------------------------------------------------------- beat 1 · document vault

/// trustsafe_6 "My Documents": centered title, real document names with
/// "Added on 11/26/2025" dates, ⋮ menus, CTA pinned above the labeled tab bar.
class _Vault extends StatelessWidget {
  const _Vault();

  static const _docs = [
    ('HIPPA', 'Updated on 12/01/2025'),
    ('Power Of Attorney', 'Added on 11/26/2025'),
    ('Codicil', 'Added on 11/26/2025'),
    ('Deed', 'Added on 11/26/2025'),
    ('Health Care Directives', 'Added on 11/26/2025'),
    ('Codicil', 'Added on 11/26/2025'),
  ];

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const Txt('My Documents',
              size: 16,
              weight: FontWeight.w800,
              color: TrustSafeDemo.ink,
              align: TextAlign.center),
          const SizedBox(height: 14),
          for (var i = 0; i < _docs.length; i++)
            _Reveal(
              index: i,
              total: 1300,
              child: _DocRow(title: _docs[i].$1, date: _docs[i].$2),
            ),
        ],
        footer: const Column(
          children: [
            SizedBox(height: 4),
            _PrimaryButton(label: 'Add New Document', icon: Icons.add_rounded),
            _Tabs(active: 1),
          ],
        ),
      );
}

// ----------------------------------------------------------- beat 2 · add document

/// trustsafe_2/_4 "Add New Document": back chevron + centered title, the
/// "Type of Document" select, and the dashed "Attach Document" drop zone.
/// The staged machine still runs: type selects itself, then the file encrypts.
class _Upload extends StatefulWidget {
  const _Upload();

  @override
  State<_Upload> createState() => _UploadState();
}

class _UploadState extends State<_Upload> {
  int _type = -1;
  double _progress = 0;
  Timer? _timer;

  static const _types = [
    'Power Of Attorney',
    'Codicil',
    'Health Care Directives',
  ];
  static const _files = [
    'power-of-attorney.pdf',
    'codicil.pdf',
    'health-care-directives.pdf',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 320), (_) {
      if (!mounted) return;
      setState(() {
        if (_type < _types.length - 1) {
          _type++;
        } else if (_progress < 1) {
          _progress = (_progress + 0.09).clamp(0.0, 1.0);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _progress >= 1;
    final uploading = _type >= _types.length - 1;
    return ScreenBody(
      body: [
        Row(
          children: const [
            Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: TrustSafeDemo.ink),
            Expanded(
              child: Txt(
                'Add New Document',
                size: 15,
                weight: FontWeight.w800,
                color: TrustSafeDemo.ink,
                align: TextAlign.center,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 20),
        const Txt('Type of Document',
            size: 12,
            weight: FontWeight.w700,
            color: TrustSafeDemo.ink),
        const SizedBox(height: 8),
        Surface(
          color: TrustSafeDemo.card,
          radius: 12,
          border: TrustSafeDemo.line,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  child: Txt(
                    _type < 0 ? 'Select document type' : _types[_type],
                    key: ValueKey(_type),
                    size: 12,
                    color: _type < 0 ? const Color(0xFFB8A997) : TrustSafeDemo.ink,
                    weight: FontWeight.w600,
                    maxLines: 1,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down_rounded,
                  size: 20, color: TrustSafeDemo.ink),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Txt('Attach Document',
            size: 12,
            weight: FontWeight.w700,
            color: TrustSafeDemo.ink),
        const SizedBox(height: 8),
        _DashedBox(
          height: 208,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 340),
            child: !uploading
                ? Column(
                    key: const ValueKey('idle'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload_outlined,
                          size: 30, color: Color(0xFFB8A997)),
                      SizedBox(height: 10),
                      Txt('Select File to Upload',
                          size: 12,
                          weight: FontWeight.w700,
                          color: TrustSafeDemo.ink,
                          align: TextAlign.center),
                      SizedBox(height: 5),
                      Txt('Allowed file types: .pdf, .doc, .docx',
                          size: 9.5,
                          color: TrustSafeDemo.muted,
                          align: TextAlign.center),
                    ],
                  )
                : done
                    ? Column(
                        key: const ValueKey('done'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: TrustSafeDemo.chip,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded,
                                size: 24, color: TrustSafeDemo.accent),
                          ),
                          const SizedBox(height: 10),
                          Txt(_files[_files.length - 1],
                              size: 10.5,
                              weight: FontWeight.w600,
                              color: TrustSafeDemo.ink,
                              align: TextAlign.center),
                          const SizedBox(height: 4),
                          const Txt('Encrypted & stored',
                              size: 12,
                              weight: FontWeight.w700,
                              color: TrustSafeDemo.accent,
                              align: TextAlign.center),
                          const SizedBox(height: 3),
                          const Txt('Added to My Documents',
                              size: 10,
                              color: TrustSafeDemo.muted,
                              align: TextAlign.center),
                        ],
                      )
                    : Column(
                        key: const ValueKey('busy'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Txt(_files[_type],
                              size: 10.5,
                              weight: FontWeight.w600,
                              color: TrustSafeDemo.ink,
                              align: TextAlign.center),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: _progress,
                                minHeight: 7,
                                backgroundColor: TrustSafeDemo.line,
                                color: TrustSafeDemo.accent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Txt(
                            _progress < 0.6
                                ? 'Encrypting…'
                                : 'Writing access log…',
                            size: 11.5,
                            weight: FontWeight.w700,
                            color: TrustSafeDemo.ink,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ beat 3 · grant access

/// Built on trustsafe_8 "Beneficiaries" — the real cards (Robert Davis,
/// Michael Johnson, Sarah Johnson with their roles and Edit/Delete pair).
/// The mockups have no permissions sheet, so the grant-access switch rides on
/// each real card and flips in sequence.
class _Access extends StatefulWidget {
  const _Access();

  @override
  State<_Access> createState() => _AccessState();
}

class _AccessState extends State<_Access> {
  final List<bool> _on = [false, false, false];
  Timer? _timer;
  int _cursor = 0;

  static const _people = [
    ('Robert Davis', 'Guardian of Minor, Agent'),
    ('Michael Johnson', 'Executor, Family, Beneficiary, Successor Trustee'),
    ('Sarah Johnson', 'Executor, Beneficiary, Trustee, Family'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (!mounted || _cursor >= _people.length) return;
      setState(() {
        _on[_cursor] = true;
        _cursor++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const Txt('Beneficiaries',
              size: 16,
              weight: FontWeight.w800,
              color: TrustSafeDemo.ink,
              align: TextAlign.center),
          const SizedBox(height: 14),
          for (var i = 0; i < _people.length; i++)
            _Reveal(
              index: i,
              total: 1300,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Surface(
                  color: TrustSafeDemo.card,
                  radius: 14,
                  border: TrustSafeDemo.line,
                  padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt(_people[i].$1,
                          size: 12.5,
                          weight: FontWeight.w800,
                          color: TrustSafeDemo.ink),
                      const SizedBox(height: 3),
                      Txt(_people[i].$2,
                          size: 10.5,
                          color: TrustSafeDemo.muted,
                          height: 1.4),
                      const SizedBox(height: 8),
                      const Divider(
                          height: 1, thickness: 1, color: TrustSafeDemo.line),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Txt(
                              _on[i] ? 'Access granted' : 'Grant access',
                              size: 11.5,
                              weight: FontWeight.w700,
                              color: _on[i]
                                  ? TrustSafeDemo.accent
                                  : TrustSafeDemo.ink,
                              maxLines: 1,
                            ),
                          ),
                          _MiniSwitch(
                            value: _on[i],
                            onChanged: (v) => setState(() => _on[i] = v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _OutlineButton(
                              label: 'Edit',
                              icon: Icons.edit_outlined,
                              color: TrustSafeDemo.accent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _OutlineButton(
                              label: 'Delete',
                              icon: Icons.delete_outline_rounded,
                              color: TrustSafeDemo.danger,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        footer: const Column(
          children: [
            SizedBox(height: 4),
            _PrimaryButton(
                label: 'Add New Beneficiary', icon: Icons.add_rounded),
            _Tabs(active: 2),
          ],
        ),
      );
}

// ------------------------------------------------------- beat 4 · biometric unlock

/// trustsafe_7 "Unlock with a Touch.": the shield-and-padlock mark, the navy
/// "Authentication Required" heading, the biometric CTA and the logged-in line.
class _Unlock extends StatefulWidget {
  const _Unlock();

  @override
  State<_Unlock> createState() => _UnlockState();
}

class _UnlockState extends State<_Unlock> {
  Timer? _pulse;
  bool _armed = false;

  @override
  void initState() {
    super.initState();
    _pulse = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (mounted) setState(() => _armed = !_armed);
    });
  }

  @override
  void dispose() {
    _pulse?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const SizedBox(height: 40),
          const Center(
            child: _Reveal(
              index: 0,
              child: SizedBox(
                width: 76,
                height: 76,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.shield_outlined,
                        size: 76, color: TrustSafeDemo.accent),
                    Icon(Icons.lock_outline,
                        size: 24, color: TrustSafeDemo.accent),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: _Reveal(
              index: 1,
              child: Txt('Authentication Required',
                  size: 17,
                  weight: FontWeight.w700,
                  color: TrustSafeDemo.navy,
                  align: TextAlign.center,
                  maxLines: 1),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: _Reveal(
              index: 2,
              child: Txt(
                'Please use your biometric credentials to unlock the app.',
                size: 11.5,
                color: TrustSafeDemo.muted,
                align: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 26),
          _Reveal(
            index: 3,
            child: AnimatedOpacity(
              opacity: _armed ? 1 : .8,
              duration: const Duration(milliseconds: 520),
              child: const _PrimaryButton(
                  label: 'Unlock with Biometrics',
                  icon: Icons.fingerprint_rounded),
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: _Reveal(
              index: 4,
              child: Txt('Logged in as User Password',
                  size: 10.5,
                  color: TrustSafeDemo.muted,
                  align: TextAlign.center,
                  maxLines: 1),
            ),
          ),
        ],
      );
}

// ---------------------------------------------------------- beat 5 · security settings

/// trustsafe_5 "Settings": Account / Support / Actions sections with brown
/// section labels, white bordered rows, and the Biometric Login switch that
/// flips itself on. Logout in sienna, tab bar with Account active.
class _Settings extends StatefulWidget {
  const _Settings();

  @override
  State<_Settings> createState() => _SettingsState();
}

class _SettingsState extends State<_Settings> {
  bool _biometric = false;
  Timer? _flip;

  @override
  void initState() {
    super.initState();
    _flip = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _biometric = true);
    });
  }

  @override
  void dispose() {
    _flip?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenBody(
        body: [
          const Txt('Settings',
              size: 16,
              weight: FontWeight.w800,
              color: TrustSafeDemo.ink,
              align: TextAlign.center),
          const SizedBox(height: 16),
          const Txt('Account',
              size: 11.5,
              weight: FontWeight.w700,
              color: TrustSafeDemo.accent),
          const SizedBox(height: 8),
          const _SettingRow(
              icon: Icons.person_outline_rounded, label: 'Profile'),
          const _SettingRow(
              icon: Icons.apartment_rounded, label: 'Estate Plan Location'),
          const SizedBox(height: 12),
          const Txt('Support',
              size: 11.5,
              weight: FontWeight.w700,
              color: TrustSafeDemo.accent),
          const SizedBox(height: 8),
          const _SettingRow(
              icon: Icons.mode_comment_outlined, label: 'FAQ'),
          const _SettingRow(
              icon: Icons.headset_mic_outlined, label: 'Contact Us'),
          const SizedBox(height: 12),
          const Txt('Actions',
              size: 11.5,
              weight: FontWeight.w700,
              color: TrustSafeDemo.accent),
          const SizedBox(height: 8),
          Surface(
            color: TrustSafeDemo.card,
            radius: 12,
            border: TrustSafeDemo.line,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              children: [
                const Icon(Icons.fingerprint_rounded,
                    size: 19, color: TrustSafeDemo.ink),
                const SizedBox(width: 10),
                const Expanded(
                  child: Txt('Biometric Login',
                      size: 12,
                      weight: FontWeight.w600,
                      color: TrustSafeDemo.ink,
                      maxLines: 1),
                ),
                _MiniSwitch(
                  value: _biometric,
                  onChanged: (v) => setState(() => _biometric = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const _SettingRow(
            icon: Icons.logout_rounded,
            label: 'Logout',
            labelColor: TrustSafeDemo.accent,
          ),
        ],
        footer: const _Tabs(active: 3),
      );
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Surface(
          color: TrustSafeDemo.card,
          radius: 12,
          border: TrustSafeDemo.line,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 17, color: labelColor ?? TrustSafeDemo.ink),
              const SizedBox(width: 10),
              Expanded(
                child: Txt(label,
                    size: 12,
                    weight: FontWeight.w600,
                    color: labelColor ?? TrustSafeDemo.ink,
                    maxLines: 1),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 17, color: TrustSafeDemo.muted),
            ],
          ),
        ),
      );
}
