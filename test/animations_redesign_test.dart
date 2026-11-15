import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_live_showcase/widgets/common/brand_logo.dart';
import 'package:portfolio_live_showcase/widgets/common/reveal_on_scroll.dart';
import 'package:portfolio_live_showcase/widgets/navigation/header_nav_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  testWidgets('RevealOnScroll renders child and reveals on visibility', (
    tester,
  ) async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RevealOnScroll(child: Text('Revealed Content')),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Revealed Content'), findsOneWidget);
  });

  testWidgets('HeaderNavBar renders logo, navigation items, and buttons', (
    tester,
  ) async {
    String? navigatedTo;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeaderNavBar(
            onNavigate: (section) => navigatedTo = section,
            activeSection: 'Projects',
            isScrolled: true,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Check logo
    expect(find.byType(BrandLogo), findsOneWidget);
    expect(find.text('Mohamed'), findsOneWidget);

    // Check nav links or showcase button
    expect(find.text('Live showcase'), findsOneWidget);

    // Tap logo to navigate home
    await tester.tap(find.byType(BrandLogo));
    await tester.pumpAndSettle();
    expect(navigatedTo, 'Hero');

    // Tap language toggle
    final langBtn = find.text('العربية');
    if (langBtn.evaluate().isNotEmpty) {
      await tester.tap(langBtn);
      await tester.pumpAndSettle();
      expect(find.text('EN'), findsOneWidget);
    }
  });
}
