import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../../showcase/theme.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.label,
    required this.url,
    this.icon = Icons.north_east_rounded,
    this.primary = false,
  });

  final String label;
  final String url;
  final IconData icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(url);

    return Link(
      uri: uri,
      target: uri.scheme == 'mailto' ? LinkTarget.self : LinkTarget.blank,
      builder: (context, follow) {
        return primary
            ? FilledButton.icon(
                onPressed: follow,
                icon: Icon(icon, size: 18),
                label: Text(label),
                style: FilledButton.styleFrom(
                  backgroundColor: Show.accent,
                  foregroundColor: Show.bg,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              )
            : OutlinedButton.icon(
                onPressed: follow,
                icon: Icon(icon, size: 16),
                label: Text(label),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Show.accent,
                  side: const BorderSide(color: Show.accent),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              );
      },
    );
  }
}
