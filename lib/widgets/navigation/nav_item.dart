import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/language_controller.dart';

class NavItem extends StatefulWidget {
  final String name;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.name,
    this.isActive = false,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.isActive || _hovered;
    final isAr = LanguageController.instance.isArabic;

    return Semantics(
      label: 'Navigate to ${widget.name}',
      button: true,
      selected: widget.isActive,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontFamily: isAr ? 'Cairo' : 'DM Sans',
                  color: highlighted ? AppColors.accent : AppColors.muted,
                  fontSize: 12,
                  fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(widget.name),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 16 : (_hovered ? 8 : 0),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
