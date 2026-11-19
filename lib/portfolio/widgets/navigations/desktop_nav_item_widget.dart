import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';

class DesktopNavItemWidget extends StatefulWidget {
  const DesktopNavItemWidget({
    super.key,
    required this.title,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<DesktopNavItemWidget> createState() => _DesktopNavItemWidgetState();
}

class _DesktopNavItemWidgetState extends State<DesktopNavItemWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? Show.accent.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              color: _hovered ? Show.accent : Show.getMuted(widget.isDark),
              fontSize: 12.5,
              fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
