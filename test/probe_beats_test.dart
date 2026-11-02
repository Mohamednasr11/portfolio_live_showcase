import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_live_showcase/showcase/controller.dart';
import 'package:portfolio_live_showcase/showcase/demos.dart';
import 'package:portfolio_live_showcase/showcase/shell.dart';

void main() {
  for (final demo in buildDemos()) {
    for (var i = 0; i < demo.steps.length; i++) {
      testWidgets('${demo.name} beat $i (${demo.steps[i].screen})',
          (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 262,
                height: 518,
                child: Builder(builder: (ctx) => demo.builder(ctx, i)),
              ),
            ),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 900));
        final error = tester.takeException();
        await tester.pumpWidget(const SizedBox());
        expect(error, isNull);
      });
    }
  }

  // The bare-beat loop above misses the shell. This one walks the real
  // presentation root at the capture size, the way the browser does.
  testWidgets('whole tour inside the shell', (tester) async {
    tester.view.physicalSize = const Size(1654, 923);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final controller = PresentationController(demos: buildDemos())..pause();
    final demoList = controller.demos;
    await tester.pumpWidget(
      MaterialApp(home: PresentationRoot(controller: controller)),
    );
    await tester.pump(const Duration(milliseconds: 700));
    for (var d = 0; d < demoList.length; d++) {
      final demo = demoList[d];
      for (var i = 0; i < demo.steps.length; i++) {
        controller.goToDemo(d, step: i);
        await tester.pump(const Duration(milliseconds: 800));
        // Periodic timers (hero carousel, staged reveals) only fire once the
        // clock passes their cadence. This catches timer-shaped asserts, but
        // not the PageController multi-attach one: a widget test gives a
        // controller exactly one position, so only the browser walk sees it.
        await tester.pump(const Duration(milliseconds: 2900));
        final error = tester.takeException();
        expect(error, isNull, reason: '${demo.name} beat $i in shell');
        // A Text with no Material ancestor inherits MaterialApp's fallback
        // style (48px monospace, underlined in #FFFFFF00, double). Our styles
        // set colour and size, so only the double underline leaks through, and
        // it reads as a rendering bug in every screenshot of the shell.
        final ugly = <String>[
          for (final e in tester.allElements)
            if (e.widget is Text &&
                DefaultTextStyle.of(e).style.decorationStyle ==
                    TextDecorationStyle.double)
              (e.widget as Text).data ?? '<rich>'
        ];
        expect(ugly, isEmpty,
            reason: '${demo.name} beat $i: Text without a Material ancestor');
      }
    }
    controller.pause();
    await tester.pumpWidget(const SizedBox());
  });
}
