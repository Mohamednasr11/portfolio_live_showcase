import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticsLabel,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
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

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    final scale = _pressed ? 0.98 : (active ? 1.01 : 1.0);
    final translateY = active ? -6.0 : 0.0;

    return Semantics(
      label: widget.semanticsLabel,
      button: true,
      enabled: widget.onTap != null,
      focusable: true,
      focused: _focused,
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            _handleTap();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          cursor: widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) {
              setState(() => _pressed = false);
              _handleTap();
            },
            onTapCancel: () => setState(() => _pressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              // ignore: deprecated_member_use
              transform: Matrix4.identity()
                // ignore: deprecated_member_use
                ..translate(0.0, translateY, 0.0)
                // ignore: deprecated_member_use
                ..scale(scale, scale, 1.0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? AppColors.accent : AppColors.border,
                  width: active ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: active
                        ? AppColors.withAlphaOpacity(AppColors.accent, 0.2)
                        : Colors.black26,
                    blurRadius: active ? 28 : 12,
                    offset: Offset(0, active ? 10 : 4),
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
