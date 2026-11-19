import 'package:flutter/material.dart';

import '../../../showcase/theme.dart';

class ChipWidget extends StatefulWidget {
  const ChipWidget(this.text, {super.key, required this.isDark});

  final String text;
  final bool isDark;

  @override
  State<ChipWidget> createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        // ignore: deprecated_member_use
        transform: Matrix4.identity()
          // ignore: deprecated_member_use
          ..scale(_hovered ? 1.05 : 1.0, _hovered ? 1.05 : 1.0, 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Show.accent.withValues(
            alpha: _hovered ? 0.25 : (widget.isDark ? 0.12 : 0.08),
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _hovered ? Show.accent : Show.getBorder(widget.isDark),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontFamily: Show.body,
            color: _hovered ? Show.accent : Show.getText(widget.isDark),
            fontSize: 13,
            fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ChipsWidget extends StatelessWidget {
  const ChipsWidget(this.items, {super.key, required this.isDark});

  final List<String> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < items.length; i++)
          ChipWidget(items[i], isDark: isDark),
      ],
    );
  }
}
