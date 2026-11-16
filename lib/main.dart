import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'portfolio/portfolio_page.dart';
import 'showcase/showcase_page.dart';

void main() {
  debugPrint('[PortfolioLog] App main() executed.');
  runApp(const LiveShowcaseApp());
}

Route<void> _route(RouteSettings settings) {
  final name = settings.name ?? '/';
  debugPrint('[PortfolioLog] _route requested with settings.name: "$name"');
  final uri = Uri.parse(name);

  if (uri.path == '/showcase') {
    debugPrint('[PortfolioLog] Routing to ShowcasePage with demoId: ${uri.queryParameters['demo']}');
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => ShowcasePage(demoId: uri.queryParameters['demo']),
    );
  }

  debugPrint('[PortfolioLog] Routing to main PortfolioPage');
  return MaterialPageRoute(
    settings: const RouteSettings(name: '/'),
    builder: (_) => const PortfolioPage(),
  );
}

class LiveShowcaseApp extends StatelessWidget {
  const LiveShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[PortfolioLog] LiveShowcaseApp build() called.');
    return MaterialApp(
      title: 'Mohamed Nasr Eldeen · Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      onGenerateRoute: _route,
      onGenerateInitialRoutes: (initial) {
        debugPrint('[PortfolioLog] onGenerateInitialRoutes called with initial: "$initial"');
        return [
          _route(const RouteSettings(name: '/')),
          if (Uri.parse(initial).path == '/showcase')
            _route(RouteSettings(name: initial)),
        ];
      },
    );
  }
}
