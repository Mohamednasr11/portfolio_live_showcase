import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'device_frame.dart';
import 'theme.dart';

export 'device_frame.dart'
    show DeviceScreenTone, DeviceToneScope, LiveScreenStack;

/// Primitives shared by the four live demos. They exist so each demo file reads
/// like a product screen rather than a wall of BoxDecoration.

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.background,
    required this.child,
    this.rtl = false,
    this.padding = const EdgeInsets.fromLTRB(18, 44, 18, 16),
    this.tone = DeviceScreenTone.dark,
  });

  final Color background;
  final Widget child;
  final bool rtl;
  final EdgeInsets padding;
  final DeviceScreenTone tone;

  @override
  Widget build(BuildContext context) {
    return DeviceToneScope(
      tone: tone,
      child: ColoredBox(
        color: background,
        child: Directionality(
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: padding,
            child: SafeArea(
              top: false,
              bottom: false,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A screen body that scrolls when the content is taller than the device, with
/// an optional pinned footer (tab bar, pay button). Keeps a beat's framing
/// honest: nothing is ever clipped, but nothing floats off-screen either.
class ScreenBody extends StatelessWidget {
  const ScreenBody({
    super.key,
    required this.body,
    this.footer,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> body;
  final Widget? footer;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: body,
              ),
            ),
          ),
          ?footer,
        ],
      );
}

class Txt extends StatelessWidget {
  const Txt(
    this.text, {
    super.key,
    this.size = 13,
    this.color = Colors.white,
    this.weight = FontWeight.w500,
    this.height,
    this.letterSpacing,
    this.align,
    this.maxLines,
    this.fontFamily,
  });

  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final double? height;
  final double? letterSpacing;
  final TextAlign? align;
  final int? maxLines;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => Text(
        text,
        textAlign: align,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: ShowType.arabicFallback,
          color: color,
          fontSize: size,
          fontWeight: weight,
          height: height,
          letterSpacing: letterSpacing,
        ),
      );
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.color = const Color(0xFF16161C),
    this.radius = 18,
    this.padding = const EdgeInsets.all(14),
    this.border,
    this.gradient,
    this.width,
    this.height,
    this.alignment,
  });

  final Widget child;
  final Color color;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? border;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        alignment: alignment,
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
          border: border == null ? null : Border.all(color: border!),
        ),
        child: child,
      );
}

class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    required this.selected,
    this.onTap,
    this.accent = const Color(0xFF6C5CE7),
    this.textColor,
    this.dense = false,
  });

  final String text;
  final bool selected;
  final VoidCallback? onTap;
  final Color accent;
  final Color? textColor;
  final bool dense;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
              horizontal: dense ? 12 : 16, vertical: dense ? 7 : 9),
          decoration: BoxDecoration(
            color: selected ? accent : const Color(0xFF1A1A21),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Txt(
            text,
            size: dense ? 11.5 : 12.5,
            weight: FontWeight.w700,
            color: selected
                ? (textColor ?? Colors.white)
                : const Color(0xFF9A9AA5),
          ),
        ),
      );
}

/// Types characters in when it first appears, then holds.
class TypeOn extends StatefulWidget {
  const TypeOn(
    this.text, {
    super.key,
    required this.playKey,
    this.style,
    this.speedPerChar = const Duration(milliseconds: 45),
    this.startDelay = Duration.zero,
  });

  final String text;
  final Object playKey;
  final TextStyle? style;
  final Duration speedPerChar;
  final Duration startDelay;

  @override
  State<TypeOn> createState() => _TypeOnState();
}

class _TypeOnState extends State<TypeOn> {
  int _shown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(TypeOn old) {
    super.didUpdateWidget(old);
    if (old.playKey != widget.playKey) {
      setState(() => _shown = 0);
      _start();
    }
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer(widget.startDelay, () {
      final tick = Timer.periodic(widget.speedPerChar, (t) {
        if (!mounted || _shown >= widget.text.length) {
          t.cancel();
          return;
        }
        setState(() => _shown++);
      });
      _timer = tick;
    });
  }

  @override
  void dispose() {
    // A Future.delayed chain cannot be cancelled, so a disposed TypeOn kept
    // firing timers into the test zone; a real Timer can be.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
        widget.text.substring(0, math.min(_shown, widget.text.length)),
        style: widget.style,
      );
}

/// Animates 0 → [value] whenever [playKey] changes.
class CountUp extends StatefulWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.playKey,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 0,
    this.duration = const Duration(milliseconds: 900),
  });

  final double value;
  final Object playKey;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int decimals;
  final Duration duration;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late Animation<double> _anim =
      Tween<double>(begin: 0, end: widget.value).animate(
    CurvedAnimation(parent: _c, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void didUpdateWidget(CountUp old) {
    super.didUpdateWidget(old);
    if (old.playKey != widget.playKey || old.value != widget.value) {
      _c.reset();
      _anim = Tween<double>(begin: 0, end: widget.value)
          .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Text(
          '${widget.prefix}${_anim.value.toStringAsFixed(widget.decimals)}'
          '${widget.suffix}',
          style: widget.style,
          // The animated value is a single number; without this the widest
          // frame ("$19.99") wraps inside a narrow Flexible and the price
          // reads as "$19.9" over "9".
          maxLines: 1,
        ),
      );
}

class RingProgress extends StatelessWidget {
  const RingProgress({
    super.key,
    required this.value,
    this.size = 92,
    this.stroke = 8,
    this.color = const Color(0xFFFF8A1E),
    this.track = const Color(0x22FFFFFF),
    this.child,
  });

  final double value;
  final double size;
  final double stroke;
  final Color color;
  final Color track;
  final Widget? child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(value: v, stroke: stroke,
                    color: color, track: track),
              ),
              if (child != null) ?child,
            ],
          ),
        ),
      );
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.stroke,
    required this.color,
    required this.track,
  });

  final double value;
  final double stroke;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);
    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * value,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color;
}

class CheckStamp extends StatelessWidget {
  const CheckStamp({
    super.key,
    required this.size,
    this.color = const Color(0xFF35C77E),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, v, _) => Transform.scale(
          scale: v,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2.4),
            ),
            child: Icon(Icons.check_rounded,
                size: size * 0.55, color: color),
          ),
        ),
      );
}

/// A dot that arcs from a product tile up to the cart tab — the classic
/// "add to cart" affordance, rebuilt instead of screenshotted.
class FlyToCart extends StatefulWidget {
  const FlyToCart({
    super.key,
    required this.playKey,
    required this.from,
    required this.to,
    this.color = const Color(0xFF6C5CE7),
  });

  final Object playKey;
  final Offset from;
  final Offset to;
  final Color color;

  @override
  State<FlyToCart> createState() => _FlyToCartState();
}

class _FlyToCartState extends State<FlyToCart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void didUpdateWidget(FlyToCart old) {
    super.didUpdateWidget(old);
    if (old.playKey != widget.playKey) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = Curves.easeInCubic.transform(_c.value);
          final x = widget.from.dx + (widget.to.dx - widget.from.dx) * t;
          final y = widget.from.dy +
              (widget.to.dy - widget.from.dy) * t -
              math.sin(t * math.pi) * 70;
          return Positioned(
            left: x - 9,
            top: y - 9,
            child: Opacity(
              opacity: _c.value < 0.9 ? 1 : 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.5),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

class BottomTabs extends StatelessWidget {
  const BottomTabs({
    super.key,
    required this.items,
    required this.active,
    this.accent = const Color(0xFF6C5CE7),
    this.inactive = const Color(0xFF6E6E7A),
    this.barColor = const Color(0xFF141419),
  });

  final List<IconData> items;
  final int active;
  final Color accent;
  final Color inactive;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < items.length; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              padding: EdgeInsets.symmetric(
                  horizontal: i == active ? 14 : 9, vertical: 8),
              decoration: BoxDecoration(
                color: i == active
                    ? accent.withValues(alpha: 0.18)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                items[i],
                size: 19,
                color: i == active ? accent : inactive,
              ),
            ),
        ],
      ),
    );
  }
}

class FakeImage extends StatelessWidget {
  const FakeImage({
    super.key,
    required this.size,
    required this.from,
    required this.to,
    this.radius = 14,
    this.icon,
    this.iconColor = Colors.white70,
  });

  final Size size;
  final Color from;
  final Color to;
  final double radius;
  final IconData? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, box) {
          // [size] may be infinite ("fill me"), so measure the icon from the
          // space actually granted, not from the requested size.
          final side = math.min(box.maxWidth, box.maxHeight);
          return Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [from, to],
              ),
            ),
            child: icon == null || !side.isFinite
                ? null
                : Icon(icon,
                    color: iconColor, size: (side * 0.42).clamp(0, 96)),
          );
        },
      );
}
