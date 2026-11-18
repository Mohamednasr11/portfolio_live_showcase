import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';
import '../../profile_data.dart';

class NavBrand extends StatelessWidget {
  const NavBrand({
    super.key,
    required this.isDark,
    required this.isArabic,
    required this.name,
    this.compact = false,
  });

  final bool isDark;
  final bool isArabic;
  final bool compact;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Show.accent, width: 2),
            image: const DecorationImage(
              image: AssetImage('assets/ME/me.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 11),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: Show.display,
                  color: Show.getText(isDark),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                isArabic ? 'مطور تطبيقات Flutter' : 'Flutter Developer',
                style: TextStyle(
                  fontFamily: Show.body,
                  color: Show.getMuted(isDark),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
