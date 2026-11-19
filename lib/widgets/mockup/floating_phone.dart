import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final currentImage = widget.screenImages.isNotEmpty
        ? widget.screenImages.first
        : 'assets/buildguard/shield_house.png';

    Widget phoneMockup = GoldieDeviceMockup(
      imagePath: currentImage,
      width: widget.width,
      height: widget.height,
      enableHoverEffect: false,
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
