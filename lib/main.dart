import 'package:flutter/material.dart';

import 'portfolio/portfolio_page.dart';
import 'showcase/showcase_page.dart';
import 'showcase/theme.dart';

void main() => runApp(const LiveShowcaseApp());

Route<void> _route(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '/');
  if (uri.path == '/showcase') {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => ShowcasePage(demoId: uri.queryParameters['demo']),
    );
  }
  return MaterialPageRoute(
    settings: const RouteSettings(name: '/'),
    builder: (_) => const PortfolioPage(),
  );
}

class LiveShowcaseApp extends StatelessWidget {
  const LiveShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohamed Nasr Eldeen · Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Show.bg,
        colorScheme: const ColorScheme.dark(
          primary: Show.accent,
          secondary: Show.accent2,
          surface: Show.surface,
          onPrimary: Show.bg,
          onSurface: Show.text,
        ),
        fontFamily: Show.body,
        fontFamilyFallback: ShowType.arabicFallback,
      ),
      onGenerateRoute: _route,
      // Keep the portfolio below deep links so the player can return to it.
      onGenerateInitialRoutes: (initial) => [
        _route(const RouteSettings(name: '/')),
        if (Uri.parse(initial).path == '/showcase')
          _route(RouteSettings(name: initial)),
      ],
    );
  }
}
