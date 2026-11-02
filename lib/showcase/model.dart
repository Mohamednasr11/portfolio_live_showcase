import 'package:flutter/material.dart';

/// One beat of a demo: a screen state plus what the presenter says about it.
class DemoStep {
  const DemoStep({
    required this.screen,
    required this.label,
    required this.annotation,
    required this.techNote,
    required this.speakerNote,
    this.hold = const Duration(milliseconds: 3400),
  });

  /// Which screen the demo widget should render for this beat.
  final String screen;
  final String label;
  final String annotation;
  final String techNote;
  final String speakerNote;
  final Duration hold;
}

typedef DemoBuilder = Widget Function(BuildContext context, int step);

class DemoSpec {
  const DemoSpec({
    required this.id,
    required this.name,
    required this.category,
    required this.role,
    required this.accent,
    required this.surface,
    required this.stack,
    required this.pitch,
    this.headline = '',
    this.subtitle = '',
    required this.steps,
    required this.builder,
  });

  final String id;
  final String name;
  final String category;
  final String role;
  final Color accent;
  final Color surface;
  final List<String> stack;
  final String pitch;

  /// The project's own Arabic headline and English subtitle, copied from the
  /// user's portfolio data so the showcase never renames their work.
  final String headline;
  final String subtitle;
  final List<DemoStep> steps;
  final DemoBuilder builder;

  Duration get totalHold => steps.fold(
        Duration.zero,
        (Duration sum, DemoStep s) => sum + s.hold,
      );
}
