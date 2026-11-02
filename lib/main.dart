import 'package:flutter/material.dart';

import 'showcase/controller.dart';
import 'showcase/demos.dart';
import 'showcase/shell.dart';
import 'showcase/theme.dart';

void main() => runApp(const LiveShowcaseApp());

class LiveShowcaseApp extends StatelessWidget {
  const LiveShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Live UX Showcase',
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
      home: PresentationRoot(
        controller: PresentationController(demos: buildDemos()),
      ),
    );
  }
}
