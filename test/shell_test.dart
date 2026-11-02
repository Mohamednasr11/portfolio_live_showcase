import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio_live_showcase/showcase/controller.dart';
import 'package:portfolio_live_showcase/showcase/demos.dart';
import 'package:portfolio_live_showcase/showcase/shell.dart';

/// The shell rebuilds its panels off an InheritedWidget dependency. These tests
/// exist because a `const` panel silently froze on the first frame: the device
/// advanced while the notes, rail counter and flow list did not.
void main() {
  Future<PresentationController> boot(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1680, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final controller = PresentationController(demos: buildDemos());
    await tester.pumpWidget(
      MaterialApp(home: PresentationRoot(controller: controller)),
    );
    await tester.pump(const Duration(milliseconds: 600));
    return controller;
  }

  /// Pausing cancels the beat scheduler and unmounting cancels the typewriters;
  /// without this the binding fails on a timer that is still pending at teardown.
  Future<void> halt(WidgetTester tester, PresentationController c) async {
    c.pause();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('notes panel tracks the beat, not the first frame',
      (tester) async {
    final c = await boot(tester);
    final beats = c.demos.first.steps;

    expect(find.text(beats[0].speakerNote), findsOneWidget);

    c.next();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text(beats[1].speakerNote), findsOneWidget);
    expect(find.text(beats[0].speakerNote), findsNothing);
    await halt(tester, c);
  });

  testWidgets('rail counter follows the beat', (tester) async {
    final c = await boot(tester);
    expect(find.text('1/${c.demo.steps.length} beats'), findsOneWidget);

    c.next();
    c.next();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('3/${c.demo.steps.length} beats'), findsOneWidget);
    await halt(tester, c);
  });

  testWidgets('jumping projects updates the top bar and flow list',
      (tester) async {
    final c = await boot(tester);
    final target = c.demos[2];

    c.goToDemo(2);
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text(target.name), findsWidgets);
    expect(find.text(target.steps[0].speakerNote), findsOneWidget);
    expect(find.text('1/${target.steps.length} beats'), findsOneWidget);
    await halt(tester, c);
  });

  testWidgets('space starts playback through the keyboard handler',
      (tester) async {
    final c = await boot(tester);
    expect(c.playing, isFalse);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump(const Duration(milliseconds: 100));

    expect(c.playing, isTrue);
    await halt(tester, c);
  });

  // Both project-switch bindings are documented in the README, and the browser
  // harness can only prove one of them: a CDP-synthesised Shift trips a
  // keysPressed assert and the hop is swallowed, so digits are what the
  // screenshots were walked with. This covers the real Shift+arrow path.
  testWidgets('shift + arrow and the digit row both switch projects',
      (tester) async {
    final c = await boot(tester);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    expect(HardwareKeyboard.instance.isShiftPressed, isTrue);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump(const Duration(milliseconds: 600));
    expect(c.demo.id, c.demos[1].id);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
    await tester.pump(const Duration(milliseconds: 600));
    expect(c.demo.id, c.demos[3].id);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump(const Duration(milliseconds: 600));
    expect(c.demo.id, c.demos[2].id);

    await halt(tester, c);
  });
}
