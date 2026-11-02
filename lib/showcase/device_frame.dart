import 'package:flutter/material.dart';

import 'theme.dart';

/// Physical phone bezel that hosts a *live* widget tree instead of a screenshot.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    super.key,
    required this.child,
    this.width = 320,
    this.statusBarTime = '9:41',
    this.batteryLevel = 0.82,
  });

  final Widget child;
  final double width;
  final String statusBarTime;
  final double batteryLevel;

  static const double _bezel = 9;

  double get screenW => width - _bezel * 2;
  double get screenH => screenW * 2.09;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // .phone-frame::before / ::after — the physical keys sticking out of
        // the shell (volume pair on the left, power on the right).
        Positioned(
          left: -12,
          top: 131,
          child: Container(
            width: 4,
            height: 87,
            decoration: const BoxDecoration(
              color: Show.buttonStub,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
              ),
            ),
          ),
        ),
        Positioned(
          left: -12,
          top: 189,
          child: Container(
            width: 4,
            height: 47,
            decoration: const BoxDecoration(
              color: Show.buttonStub,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
              ),
            ),
          ),
        ),
        Positioned(
          right: -12,
          top: 160,
          child: Container(
            width: 4,
            height: 58,
            decoration: const BoxDecoration(
              color: Show.buttonStub,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
          ),
        ),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Show.frameShell,
            borderRadius: BorderRadius.circular(52),
            border: Border.all(color: Show.frameEdge),
            boxShadow: const [
              BoxShadow(color: Show.frameRing, spreadRadius: 3),
              BoxShadow(color: Show.frameRingOuter, spreadRadius: 7),
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 58,
                offset: Offset(0, 35),
              ),
            ],
          ),
          padding: const EdgeInsets.all(_bezel),
          child: Container(
            width: screenW,
            height: screenH,
            decoration: BoxDecoration(
              color: Show.screenBlack,
              borderRadius: BorderRadius.circular(41),
              border: Border.all(color: Show.screenEdge),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(child: child),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _StatusBar(time: statusBarTime, battery: batteryLevel),
                ),
                // .phone-notch — a tab hanging from the top edge, not a hole.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        width: 131,
                        height: 41,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Show.frameShell,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                          ),
                        ),
                        child: Container(
                          width: 44,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Show.buttonStub,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // .phone-reflection — the 105deg glass streak across the panel.
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(41),
                        gradient: const LinearGradient(
                          begin: Alignment(-0.97, -0.26),
                          end: Alignment(0.97, 0.26),
                          colors: [
                            Color(0x0DFFFFFF),
                            Color(0x0DFFFFFF),
                            Color(0x1AFFFFFF),
                            Color(0x0DFFFFFF),
                            Color(0x00FFFFFF),
                          ],
                          stops: [0, 0.4, 0.42, 0.45, 0.5],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.time, required this.battery});

  final String time;
  final double battery;

  @override
  Widget build(BuildContext context) {
    final dark = _isLightScreen(context);
    final tint = dark ? Colors.black87 : Colors.white;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 20, 0),
      child: Row(
        children: [
          SizedBox(
            width: 54,
            child: Text(
              time,
              style: TextStyle(
                color: tint,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Icon(Icons.signal_cellular_alt_rounded, size: 13, color: tint),
          const SizedBox(width: 5),
          Icon(Icons.wifi_rounded, size: 13, color: tint),
          const SizedBox(width: 6),
          _Battery(fraction: battery, tint: tint),
        ],
      ),
    );
  }

  /// The status bar sits on top of the demo; pick a readable tint from the
  /// screen background the demo asked for.
  bool _isLightScreen(BuildContext context) {
    final tone = DeviceToneScope.maybeOf(context);
    return tone == DeviceScreenTone.light;
  }
}

class _Battery extends StatelessWidget {
  const _Battery({required this.fraction, required this.tint});

  final double fraction;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 12,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: tint.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Positioned(
            left: 2,
            top: 2,
            bottom: 2,
            width: 16 * fraction,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum DeviceScreenTone { light, dark }

/// Demos wrap themselves in this so the fake status bar can pick a legible tint.
class DeviceToneScope extends InheritedWidget {
  const DeviceToneScope({
    super.key,
    required this.tone,
    required super.child,
  });

  final DeviceScreenTone tone;

  static DeviceScreenTone? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DeviceToneScope>()
      ?.tone;

  @override
  bool updateShouldNotify(DeviceToneScope oldWidget) => tone != oldWidget.tone;
}

/// App-like push transition between live screens, driven by the tour step.
class LiveScreenStack extends StatelessWidget {
  const LiveScreenStack({
    super.key,
    required this.screenKey,
    required this.child,
  });

  final String screenKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          ...previous.whereType<Widget>(),
          ?current,
        ],
      ),
      transitionBuilder: (child, animation) {
        final incoming = animation;
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(incoming),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: incoming,
              curve: const Interval(0.35, 1),
            ),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(key: ValueKey(screenKey), child: child),
    );
  }
}
