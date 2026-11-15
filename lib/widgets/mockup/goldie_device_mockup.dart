import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// A realistic smartphone mockup widget inspired by Goldie showcase frames.
/// Wraps any image/screenshot in a high-fidelity mobile device bezel
/// complete with camera punch-hole, glass reflection, drop shadows, and optional headline badges.
class GoldieDeviceMockup extends StatefulWidget {
  final String imagePath;
  final String? headline;
  final String? badgeText;
  final double width;
  final double? height;
  final double borderRadius;
  final bool enableHoverEffect;
  final BoxFit fit;

  const GoldieDeviceMockup({
    super.key,
    required this.imagePath,
    this.headline,
    this.badgeText,
    this.width = 280,
    this.height,
    this.borderRadius = 32,
    this.enableHoverEffect = true,
    this.fit = BoxFit.cover,
  });

  @override
  State<GoldieDeviceMockup> createState() => _GoldieDeviceMockupState();
}

class _GoldieDeviceMockupState extends State<GoldieDeviceMockup> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final frameBorderRadius = BorderRadius.circular(widget.borderRadius);
    final screenBorderRadius = BorderRadius.circular(widget.borderRadius - 6.0);

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(
        0,
        _hovered && widget.enableHoverEffect ? -8 : 0,
        0,
      ),
      decoration: BoxDecoration(
        color: AppColors.mockupBezelOuter,
        borderRadius: frameBorderRadius,
        border: Border.all(
          color: _hovered && widget.enableHoverEffect
              ? AppColors.withAlphaOpacity(AppColors.lime, 0.6)
              : const Color(0xFF2E4250),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: _hovered && widget.enableHoverEffect
                ? AppColors.withAlphaOpacity(AppColors.lime, 0.22)
                : AppColors.withAlphaOpacity(Colors.black, 0.45),
            blurRadius: _hovered && widget.enableHoverEffect ? 32 : 24,
            spreadRadius: _hovered && widget.enableHoverEffect ? 2 : 0,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.withAlphaOpacity(Colors.black, 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(7.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mockupBezelInner,
          borderRadius: screenBorderRadius,
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // App Screenshot Image
            Image.asset(
              widget.imagePath,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              errorBuilder: (_, _, _) => Container(
                width: widget.width,
                height: widget.height ?? (widget.width * 2),
                color: AppColors.panelLight,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mobile_off_rounded,
                      color: AppColors.muted,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Preview Unavailable',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),

            // Optional Top Goldie Headline Overlay
            if (widget.headline != null)
              Positioned(
                top: 24,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.withAlphaOpacity(Colors.black, 0.65),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    widget.headline!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

            // Top Notch / Dynamic Island
            Positioned(
              top: 8,
              child: Container(
                width: widget.width * 0.28,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.mockupCameraPin,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF14212D),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Optional Bottom Store Badge Tag
            if (widget.badgeText != null)
              Positioned(
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.badgeText!,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

            // Screen Glass Glare / Reflection Overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: screenBorderRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mockupGlare,
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.enableHoverEffect) {
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: content,
      );
    }

    return content;
  }
}
