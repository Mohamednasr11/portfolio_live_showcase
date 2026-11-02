import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio_live_showcase/showcase/controller.dart';
import 'package:portfolio_live_showcase/showcase/demos.dart';
import 'package:portfolio_live_showcase/showcase/device_frame.dart';
import 'package:portfolio_live_showcase/showcase/model.dart';

/// Fake clock so playback logic is tested without waiting on wall time.
class _ScriptedClock {
  final List<void Function()> _due = [];

  Timer schedule(int ms, void Function() cb) {
    _due.add(cb);
    return Timer(Duration.zero, () {});
  }

  void fire() {
    final callbacks = List.of(_due);
    _due.clear();
    for (final cb in callbacks) {
      cb();
    }
  }
}

PresentationController _controller(_ScriptedClock clock) =>
    PresentationController(demos: buildDemos(), timerFactory: clock.schedule);

DemoSpec _stub({int beats = 3}) => DemoSpec(
      id: 'stub',
      name: 'Stub',
      category: 'TEST',
      role: 'TEST',
      accent: Colors.black,
      surface: Colors.black,
      stack: const [],
      pitch: '',
      steps: [
        for (var i = 0; i < beats; i++)
          DemoStep(
            screen: 's$i',
            label: 'beat $i',
            annotation: '',
            techNote: '',
            speakerNote: '',
            hold: const Duration(milliseconds: 100),
          ),
      ],
      builder: (context, step) => const SizedBox.shrink(),
    );

void main() {
  group('tour engine', () {
    test('every demo declares one builder screen per beat', () {
      for (final demo in buildDemos()) {
        expect(demo.steps, isNotEmpty, reason: demo.name);
        for (final step in demo.steps) {
          expect(step.label, isNotEmpty);
          expect(step.techNote, isNotEmpty);
          expect(step.speakerNote, isNotEmpty);
        }
      }
    });

    test('next() walks beats then rolls into the following demo', () {
      final c = PresentationController(demos: [_stub(beats: 2), _stub(beats: 3)]);
      expect(c.demoIndex, 0);
      c.next();
      expect(c.stepIndex, 1);
      c.next();
      expect(c.demoIndex, 1, reason: 'should advance to demo 2');
      expect(c.stepIndex, 0);
    });

    test('prev() walks back across the demo boundary', () {
      final c = PresentationController(demos: [_stub(), _stub()]);
      c.goToDemo(1);
      expect(c.stepIndex, 0);
      c.prev();
      expect(c.demoIndex, 0);
      expect(c.stepIndex, 2);
    });

    test('speed divides the hold of the current beat', () {
      final c = PresentationController(demos: [_stub()]);
      expect(c.remainingHold, const Duration(milliseconds: 100));
      c.setSpeed(2);
      expect(c.remainingHold, const Duration(milliseconds: 50));
    });

    test('playing with the clock advances beats', () {
      final clock = _ScriptedClock();
      final c = _controller(clock);
      c.play();
      expect(c.stepIndex, 0);
      clock.fire();
      expect(c.stepIndex, 1);
      clock.fire();
      expect(c.stepIndex, 2);
    });

    test('pausing stops the clock from moving the tour', () {
      final clock = _ScriptedClock();
      final c = _controller(clock);
      c.play();
      c.pause();
      clock.fire();
      expect(c.stepIndex, 0);
    });

    test('the last beat of the last demo parks instead of wrapping', () {
      final c = PresentationController(demos: [_stub(beats: 1)]);
      c.next();
      expect(c.playing, isFalse);
      expect(c.stepIndex, 0);
    });

    test('goToDemo clamps out-of-range indices', () {
      final c = PresentationController(demos: buildDemos());
      c.goToDemo(99, step: 999);
      expect(c.demoIndex, buildDemos().length - 1);
      expect(c.stepIndex, buildDemos().last.steps.length - 1);
    });
  });

  // One test per beat: a failure then names the exact screen, and the framework
  // prints the offending widget's file:line for it instead of a merged summary.
  for (final demo in buildDemos()) {
    for (var step = 0; step < demo.steps.length; step++) {
      testWidgets('${demo.name} beat $step (${demo.steps[step].label}) renders',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: DeviceFrame(
                  width: 320,
                  child: Builder(
                    builder: (context) => demo.builder(context, step),
                  ),
                ),
              ),
            ),
          ),
        );
        // Run far enough for every animation on the beat to settle.
        for (final d in const [
          Duration(milliseconds: 400),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ]) {
          await tester.pump(d);
        }
        // Dispose first so no periodic timer outlives the test.
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 12));

        expect(
          tester.takeException(),
          isNull,
          reason: '${demo.name} beat $step (${demo.steps[step].label})',
        );
      });
    }
  }
}
