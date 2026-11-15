import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideOffset = 0.15,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  bool _isVisible = false;
  late final String _detectorKey;

  @override
  void initState() {
    super.initState();
    _detectorKey = 'reveal_${identityHashCode(this)}';
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      return widget.child;
    }

    if (_isVisible) {
      return widget.child
          .animate(delay: widget.delay)
          .fadeIn(duration: widget.duration, curve: Curves.easeOutCubic)
          .slideY(
            begin: widget.slideOffset,
            end: 0,
            duration: widget.duration,
            curve: Curves.easeOutCubic,
          );
    }

    return VisibilityDetector(
      key: Key(_detectorKey),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= 0.3 && !_isVisible && mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Opacity(opacity: 0, child: widget.child),
    );
  }
}
