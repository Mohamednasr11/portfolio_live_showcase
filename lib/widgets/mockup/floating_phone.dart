import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'goldie_device_mockup.dart';

class FloatingPhone extends StatefulWidget {
  final List<String> screenImages;
  final double width;
  final double height;

  const FloatingPhone({
    super.key,
    required this.screenImages,
    this.width = 240,
    this.height = 480,
  });

  @override
  State<FloatingPhone> createState() => _FloatingPhoneState();
}

class _FloatingPhoneState extends State<FloatingPhone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  int _currentScreen = 0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _floatAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _cycleScreen() {
    if (widget.screenImages.isNotEmpty) {
      setState(() {
        _currentScreen = (_currentScreen + 1) % widget.screenImages.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final currentImage = widget.screenImages.isNotEmpty
        ? widget.screenImages[_currentScreen]
        : 'assets/buildguard/Home.png';

    Widget phoneMockup = GestureDetector(
      onTap: _cycleScreen,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.95,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentScreen),
                child: GoldieDeviceMockup(
                  imagePath: currentImage,
                  width: widget.width,
                  height: widget.height,
                  enableHoverEffect: false,
                  badgeText:
                      'Screen ${_currentScreen + 1}/${widget.screenImages.length}',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.touch_app_rounded,
                    size: 14,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tap phone to cycle screens',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (disableAnimations) {
      return phoneMockup;
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          );
        },
        child: phoneMockup,
      ),
    );
  }
}
