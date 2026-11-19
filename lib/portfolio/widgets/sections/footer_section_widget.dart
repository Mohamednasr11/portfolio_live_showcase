import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import '../../profile_data.dart';
import '../common/section_frame_widget.dart';

class FooterSectionWidget extends StatelessWidget {
  const FooterSectionWidget({
    super.key,
    required this.isArabic,
    required this.isDark,
  });

  final bool isArabic;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Show.getBorder(isDark))),
      ),
      child: WidthContainer(
        child: Text(
          isArabic
              ? '© ${DateTime.now().year} ${Profile.name} · تم البناء باستخدام Flutter Web'
              : '© ${DateTime.now().year} ${Profile.name} · Built with Flutter Web',
          style: TextStyle(
            fontFamily: isArabic ? 'Graphic' : Show.body,
            color: Show.getMuted(isDark),
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
