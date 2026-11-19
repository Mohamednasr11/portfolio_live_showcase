import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_live_showcase/core/utils/url_launcher_utils.dart';
import 'package:portfolio_live_showcase/data/portfolio_data.dart';
import 'package:portfolio_live_showcase/widgets/navigation/header_nav_bar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CV and WhatsApp Integration Tests', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/url_launcher'),
            (MethodCall methodCall) async {
              log.add(methodCall);
              if (methodCall.method == 'canLaunch') {
                return true;
              }
              if (methodCall.method == 'launch') {
                return true;
              }
              return null;
            },
          );
    });

    test('PortfolioData phone matches user phone number 2010960743334', () {
      expect(PortfolioData.phone, equals('2010960743334'));
    });

    testWidgets('HeaderNavBar renders logo and action buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeaderNavBar(
              onNavigate: (_) {},
              activeSection: 'Hero',
              isScrolled: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HeaderNavBar), findsOneWidget);
    });

    test('openWhatsApp launches correct WhatsApp URL with phone number 2010960743334', () async {
      await UrlLauncherUtils.openWhatsApp(PortfolioData.phone);

      expect(log, isNotEmpty);
      final launchCall = log.firstWhere((c) => c.method == 'launch');
      expect(
        launchCall.arguments['url'],
        equals('https://wa.me/2010960743334'),
      );
    });
  });
}
