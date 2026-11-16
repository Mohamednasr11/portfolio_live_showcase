import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'showcase/showcase_page.dart';
import 'portfolio/portfolio_page.dart';

void main() => runApp(const LiveShowcaseApp());

Route<void> _route(RouteSettings settings) {
  final name = settings.name ?? '/';
  final uri = Uri.parse(name);

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
      theme: AppTheme.darkTheme,
      onGenerateRoute: _route,
      onGenerateInitialRoutes: (initial) => [
        _route(const RouteSettings(name: '/')),
        if (Uri.parse(initial).path == '/showcase')
          _route(RouteSettings(name: initial)),
      ],
    );
  }
}
