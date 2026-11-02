import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Positive control for the render gate: if this test ever passes silently, the
/// per-beat tests are not actually observing overflow and their green is void.
void main() {
  testWidgets('the gate sees a deliberate horizontal overflow', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              // A Row lays its children out on an unbounded main axis, so a
              // fixed 1200px child genuinely escapes the 320px parent. A
              // stretch Column would clamp it and overflow nothing.
              child: Row(
                children: const [SizedBox(width: 1200, height: 8)],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNotNull,
        reason: 'overflow must surface as a test exception');
  });

  testWidgets('the gate sees a deliberate vertical overflow', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              height: 200,
              child: Column(
                children: const [SizedBox(height: 900, width: 40)],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNotNull);
  });
}
