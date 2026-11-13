import 'package:flutter/material.dart';

import 'controller.dart';
import 'demos.dart';
import 'shell.dart';

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key, this.demoId});

  final String? demoId;

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  late final PresentationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PresentationController(demos: buildDemos());
    final index = _controller.demos.indexWhere((d) => d.id == widget.demoId);
    if (index > 0) _controller.goToDemo(index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      PresentationRoot(controller: _controller);
}
