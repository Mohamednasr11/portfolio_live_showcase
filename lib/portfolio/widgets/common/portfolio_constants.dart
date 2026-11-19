import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';

abstract final class P {
  static const body = Color(0xFFA9B4CF);
  static const card = Show.surface;
  static const maxWidth = 1120.0;
}

void openShowcase(BuildContext context, [String? demoId]) {
  Navigator.of(context)
      .pushNamed(demoId == null ? '/showcase' : '/showcase?demo=$demoId');
}
