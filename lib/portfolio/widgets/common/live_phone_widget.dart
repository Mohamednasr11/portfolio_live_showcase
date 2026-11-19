import 'package:flutter/material.dart';

import '../../../showcase/model.dart';
import '../../../widgets/mockup/floating_phone.dart';

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
    final String imagePath;

    switch (demo.id) {
      case 'matjarkom':
        imagePath = 'assets/matjarkom/hero_watch.png';
        break;
      case 'build_guard':
        imagePath = 'assets/buildguard/scan_crack.png';
        break;
      case 'brew_and_bloom':
        imagePath = 'assets/brewbloom/onboarding_cup.png';
        break;
      case 'trustsafe':
        imagePath = 'assets/brewbloom/promo_cups.png';
        break;
      default:
        imagePath = 'assets/matjarkom/hero_watch.png';
    }

    return FloatingPhone(
      screenImages: [imagePath],
      width: width,
      height: width * _frameHeight / _frameWidth,
    );
  }
}
