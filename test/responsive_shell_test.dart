import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio_live_showcase/showcase/controller.dart';
import 'package:portfolio_live_showcase/showcase/demos.dart';
import 'package:portfolio_live_showcase/showcase/shell.dart';

const _viewports = <String, Size>{
  'phone 360x780': Size(360, 780),
  'phone 390x844': Size(390, 844),
  'tablet 820x1180': Size(820, 1180),
  'laptop 1280x800': Size(1280, 800),
};

void main() {
  for (final entry in _viewports.entries) {
    testWidgets('showcase player lays out on ${entry.key}', (tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final controller = PresentationController(demos: buildDemos());
      await tester.pumpWidget(
        MaterialApp(home: PresentationRoot(controller: controller)),
      );
      await tester.pump(const Duration(milliseconds: 700));
      final errors = <Object>[];
      for (var d = 0; d < controller.demos.length; d++) {
        controller.goToDemo(d, step: 1);
        await tester.pump(const Duration(milliseconds: 700));
        final e = tester.takeException();
        if (e != null) errors.add('${controller.demo.name}: $e');
      }
      controller.pause();
      await tester.pumpWidget(const SizedBox());
      expect(errors, isEmpty);
    });
  }
}
