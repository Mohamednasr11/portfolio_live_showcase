import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';

enum AppButtonStyle { primary, secondary, quiet }

class AppButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final AppButtonStyle style;
  final String? tooltip;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.tooltip,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    final scale = _pressed ? 0.97 : (active ? 1.03 : 1.0);

    Color bgColor;
    Color fgColor;
    BorderSide borderSide;

    switch (widget.style) {
      case AppButtonStyle.primary:
        bgColor = active ? const Color(0xFF06B6D4) : AppColors.accent;
        fgColor = AppColors.background;
        borderSide = BorderSide.none;
        break;
      case AppButtonStyle.secondary:
        bgColor = active
            ? AppColors.withAlphaOpacity(AppColors.accent, 0.15)
            : AppColors.panel;
        fgColor = active ? AppColors.accent : AppColors.textPrimary;
        borderSide = BorderSide(
          color: active ? AppColors.accent : AppColors.border,
          width: 1.2,
        );
        break;
      case AppButtonStyle.quiet:
        bgColor = active ? Colors.white10 : Colors.transparent;
        fgColor = active ? AppColors.accent : AppColors.textPrimary;
        borderSide = BorderSide.none;
        break;
    }

    Widget content = Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            // ignore: deprecated_member_use
            transform: Matrix4.identity()..scale(scale, scale, 1.0),
            transformAlignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: _focused
                  ? Border.all(color: AppColors.accent, width: 2)
                  : Border.fromBorderSide(borderSide),
              boxShadow: widget.style == AppButtonStyle.primary && active
                  ? [
                      BoxShadow(
                        color: AppColors.withAlphaOpacity(
                          AppColors.accent,
                          0.3,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 16, color: fgColor),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      content = Tooltip(message: widget.tooltip!, child: content);
    }

    return Semantics(
      label: widget.label,
      button: true,
      enabled: true,
      focused: _focused,
      child: content,
    );
  }
}
