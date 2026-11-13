import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio_live_showcase/main.dart';
import 'package:portfolio_live_showcase/portfolio/portfolio_page.dart';
import 'package:portfolio_live_showcase/portfolio/profile_data.dart';
import 'package:portfolio_live_showcase/showcase/shell.dart';
import 'package:portfolio_live_showcase/showcase/theme.dart';

/// Every external URL the page may link to. Each was fetched and returned 200
/// (LinkedIn answers 301 to bots). A typo or a new unchecked link fails here.
const verifiedUrls = {
  'https://github.com/Mohamednasr11',
  'https://www.linkedin.com/in/mohamed-nasr-eldeen-3057b8240/',
  'https://github.com/Mohamednasr11/portfolio_live_showcase',
  'https://github.com/Mohamednasr11/code_alpha_fitness_tracker_app',
  'https://github.com/Mohamednasr11/meals_app',
  'https://github.com/Mohamednasr11/smart_route_finder',
  'https://github.com/Mo-Nasr-Eldeen/ITI-Final-Project',
  'https://iti-final-project-w77f.vercel.app/',
  'mailto:mohamed.nasr.flutter@gmail.com',
};

void main() {
  void size(WidgetTester tester, Size s) {
    tester.view.physicalSize = s;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> teardown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  }

  ScrollPosition pagePosition(WidgetTester tester) => tester
      .state<ScrollableState>(
        find
            .descendant(
              of: find.byType(PortfolioPage),
              matching: find.byType(Scrollable),
            )
            .first,
      )
      .position;

  for (final s in const [
    Size(360, 780),
    Size(390, 844),
    Size(820, 1180),
    Size(1440, 900),
  ]) {
    testWidgets('portfolio lays out cleanly at ${s.width.toInt()}px', (
      tester,
    ) async {
      size(tester, s);
      await tester.pumpWidget(const LiveShowcaseApp());
      await tester.pump(const Duration(milliseconds: 900));

      final pos = pagePosition(tester);
      final errors = <Object>[];
      for (var y = 0.0; y <= pos.maxScrollExtent; y += s.height * .8) {
        pos.jumpTo(y);
        await tester.pump(const Duration(milliseconds: 300));
        final e = tester.takeException();
        if (e != null) errors.add(e);
      }
      pos.jumpTo(pos.maxScrollExtent);
      await tester.pump(const Duration(milliseconds: 300));
      final e = tester.takeException();
      if (e != null) errors.add(e);
      expect(errors, isEmpty);

      final ugly = [
        for (final el in tester.allElements)
          if (el.widget is Text &&
              DefaultTextStyle.of(el).style.decorationStyle ==
                  TextDecorationStyle.double)
            (el.widget as Text).data ?? '<rich>',
      ];
      expect(ugly, isEmpty, reason: 'Text without a Material ancestor');
      await teardown(tester);
    });
  }

  testWidgets('every link is a verified URL and the key links are present', (
    tester,
  ) async {
    size(tester, const Size(1440, 900));
    await tester.pumpWidget(const LiveShowcaseApp());
    await tester.pump(const Duration(milliseconds: 600));

    final urls = tester
        .widgetList<LinkButton>(find.byType(LinkButton, skipOffstage: false))
        .map((b) => b.url)
        .toSet();
    expect(urls.difference(verifiedUrls), isEmpty);
    expect(urls, containsAll(verifiedUrls));
    expect(
      find.textContaining(
        'Data, network calls, AI responses',
        skipOffstage: false,
      ),
      findsOneWidget,
      reason: 'the simulated-content notice must stay on the page',
    );
    await teardown(tester);
  });

  testWidgets('a case study card opens the player on that project and back '
      'returns to the portfolio', (tester) async {
    size(tester, const Size(1440, 900));
    await tester.pumpWidget(const LiveShowcaseApp());
    await tester.pump(const Duration(milliseconds: 600));

    final play = find.widgetWithText(FilledButton, 'Play case study').at(1);
    await tester.ensureVisible(play);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(play);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    final root = tester.widget<PresentationRoot>(find.byType(PresentationRoot));
    expect(root.controller.demo.id, 'build_guard');

    await tester.tap(find.byTooltip('Back to portfolio'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byType(PresentationRoot), findsNothing);
    expect(find.byType(PortfolioPage), findsOneWidget);
    await teardown(tester);
  });

  testWidgets('a deep link opens the named case study over the portfolio', (
    tester,
  ) async {
    size(tester, const Size(1440, 900));
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        '/showcase?demo=trustsafe';
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await tester.pumpWidget(const LiveShowcaseApp());
    await tester.pump(const Duration(milliseconds: 900));

    final root = tester.widget<PresentationRoot>(find.byType(PresentationRoot));
    expect(root.controller.demo.id, 'trustsafe');
    final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
    expect(nav.canPop(), isTrue);
    await teardown(tester);
  });

  testWidgets('copy email writes the profile address and confirms it', (
    tester,
  ) async {
    size(tester, const Size(390, 844));
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = call.arguments['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(const LiveShowcaseApp());
    await tester.pump(const Duration(milliseconds: 600));
    final copy = find.byTooltip('Copy email address');
    await tester.ensureVisible(copy);
    await tester.tap(copy);
    await tester.pump();
    expect(copied, Profile.email);
    expect(find.text('Email address copied'), findsOneWidget);
    await teardown(tester);
  });

  test('SEO, sharing artwork and deployment build gate are configured', () {
    final html = File('web/index.html').readAsStringSync();
    expect(html, contains('<html lang="en">'));
    expect(
      html,
      contains('<title>Mohamed Nasr Eldeen · Flutter Developer</title>'),
    );
    expect(html, contains('property="og:image"'));
    expect(html, contains('name="twitter:card"'));
    expect(html, contains('_flutter.loader.loadEntrypoint'));
    expect(html, isNot(contains('A new Flutter project.')));
    final image = File('web/social-preview.png').readAsBytesSync();
    expect(image.take(8).toList(), [137, 80, 78, 71, 13, 10, 26, 10]);
    final manifest =
        jsonDecode(File('web/manifest.json').readAsStringSync()) as Map;
    expect(manifest['name'], contains(Profile.name));
    expect(manifest['background_color'], '#060810');
    final vercel = jsonDecode(File('vercel.json').readAsStringSync()) as Map;
    expect(vercel['outputDirectory'], 'build/web');
    expect(vercel['buildCommand'], 'bash tool/vercel_build.sh');
    final gate = File('tool/vercel_build.sh').readAsStringSync();
    expect(gate, contains('set -euo pipefail'));
    expect(gate, contains('flutter analyze'));
    expect(gate, contains('flutter test'));
    expect(gate, contains('flutter build web --release'));
  });

  test('profile copy carries no invented metrics', () {
    final copy = [
      Profile.intro,
      for (final p in Profile.codeProjects) ...[p.summary, ...p.points],
      for (final h in Profile.highlights) ...[h.title, h.body],
      for (final e in [...Profile.experience, ...Profile.education])
        ...e.points,
      for (final c in Profile.caseStudies) c.source,
    ].join('\n');
    expect(RegExp(r'\d+\s*[+%]').hasMatch(copy), isFalse);
    expect(copy.toLowerCase(), isNot(contains('years of experience')));
  });

  test('text colours meet WCAG AA on every page background', () {
    double ratio(Color a, Color b) {
      final la = a.computeLuminance(), lb = b.computeLuminance();
      final hi = la > lb ? la : lb, lo = la > lb ? lb : la;
      return (hi + .05) / (lo + .05);
    }

    for (final fg in [P.body, Show.text, Show.accent]) {
      for (final bg in [Show.bg, P.card, Show.surfaceAlt]) {
        expect(ratio(fg, bg), greaterThanOrEqualTo(4.5), reason: '$fg on $bg');
      }
    }
    expect(
      ratio(Show.bg, Show.accent),
      greaterThanOrEqualTo(4.5),
      reason: 'filled button label',
    );
  });
}
