import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/localization/language_controller.dart';
import '../widgets/common/section_header.dart';

class MotionLabSection extends StatelessWidget {
  const MotionLabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        return SectionWrapper(
          number: '05',
          eyebrow: isAr ? 'مختبر الحركة والتفاعل' : 'INTERACTION PLAYGROUND',
          title: isAr ? 'حركات وانتقالات' : 'Motion, with',
          accent: isAr ? 'هادفة وواضحة.' : 'a Purpose.',
          description: isAr
              ? 'نماذج تفاعلية حية تستعرض انسيابية الانتقالات والدقة في التحكم بالحركة واستجابة واجهات المستخدم.'
              : 'Live interactive micro-interactions demonstrating custom animations and physics-inspired UI motion.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 900
                  ? 3
                  : (constraints.maxWidth > 590 ? 2 : 1);
              const gap = 18.0;
              final width = (constraints.maxWidth - gap * (cols - 1)) / cols;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  SizedBox(
                    width: width,
                    child: _MotionCard(
                      title: isAr ? 'مؤشر النبض التفاعلي' : 'Soft Pulse Glow',
                      subtitle: isAr ? 'مؤشر حالة حي بهالة شعاعية' : 'Living status indicator with radial glow',
                      demo: const PulseDemoPlus(),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _MotionCard(
                      title: isAr ? 'مؤشر التحميل المداري' : 'Orbit Ring Loader',
                      subtitle: isAr ? 'محاكاة انتظار بمدارات متعددة' : 'Multi-orbit physics waiting state',
                      demo: const OrbitDemoPlus(),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _MotionCard(
                      title: isAr ? 'زر تحول الحالة' : 'State Morph Switch',
                      subtitle: isAr ? 'اضغط لتجربة التغير في اللون والحجم' : 'Tap to trigger interactive scale & color morphing',
                      demo: const SwitchDemoPlus(),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _MotionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget demo;

  const _MotionCard({
    required this.title,
    required this.subtitle,
    required this.demo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 165,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: demo,
            ),
          ),
          const SizedBox(height: 17),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.paper,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class PulseDemoPlus extends StatefulWidget {
  const PulseDemoPlus({super.key});

  @override
  State<PulseDemoPlus> createState() => _PulseDemoPlusState();
}

class _PulseDemoPlusState extends State<PulseDemoPlus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutSine,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final val = _scaleAnimation.value;
        return Container(
          height: 165,
          color: const Color(0xFF091923),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: 0.8 + val * 0.7,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.withAlphaOpacity(AppColors.lime, 0.4 * (1 - val)),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.85 + val * 0.3,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.withAlphaOpacity(AppColors.lime, 0.3 + val * 0.4),
                          blurRadius: 24 + val * 24,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrbitDemoPlus extends StatefulWidget {
  const OrbitDemoPlus({super.key});

  @override
  State<OrbitDemoPlus> createState() => _OrbitDemoPlusState();
}

class _OrbitDemoPlusState extends State<OrbitDemoPlus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      color: const Color(0xFF091923),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final angle = _controller.value * math.pi * 2;
            final angle2 = -_controller.value * math.pi * 2 * 1.5;

            return SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.withAlphaOpacity(AppColors.cyan, 0.3),
                      ),
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.withAlphaOpacity(AppColors.lime, 0.25),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.panelLight,
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.lime,
                      size: 18,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(math.cos(angle) * 38, math.sin(angle) * 38),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.lime, blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                      math.cos(angle + math.pi) * 38,
                      math.sin(angle + math.pi) * 38,
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.cyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                      math.cos(angle2) * 23,
                      math.sin(angle2) * 23,
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SwitchDemoPlus extends StatefulWidget {
  const SwitchDemoPlus({super.key});

  @override
  State<SwitchDemoPlus> createState() => _SwitchDemoPlusState();
}

class _SwitchDemoPlusState extends State<SwitchDemoPlus> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, _) {
        final isAr = LanguageController.instance.isArabic;

        return Container(
          height: 165,
          color: const Color(0xFF091923),
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => _active = !_active),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutBack,
                width: 200,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _active ? const Color(0xFF193F37) : AppColors.panelLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _active
                        ? AppColors.withAlphaOpacity(AppColors.lime, 0.6)
                        : Colors.white12,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _active
                          ? AppColors.withAlphaOpacity(AppColors.lime, 0.2)
                          : Colors.black26,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Row(
                    key: ValueKey(_active),
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _active ? AppColors.lime : const Color(0xFF34505A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _active ? Icons.check_rounded : Icons.touch_app_rounded,
                          color: _active ? AppColors.ink : AppColors.paper,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _active
                                ? (isAr ? 'تم الحفظ' : 'Saved')
                                : (isAr ? 'حفظ العنصر' : 'Save Item'),
                            style: const TextStyle(
                              color: AppColors.paper,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _active
                                ? (isAr ? 'اضغط للتراجع' : 'Tap to undo')
                                : (isAr ? 'اضغط للتجربة' : 'Tap to try animation'),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
