import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'bootstrap_icon.dart';

/// Bootstrap's `.icon-link` helper (`<a class="icon-link">`): an `inline-flex`
/// link with a `.375rem` gap between its text and a `1em` icon (or [iconSize]),
/// centred on each other, with only the text underlined.
class ExampleIconLink extends StatelessWidget {
  const ExampleIconLink({
    super.key,
    required this.text,
    required this.icon,
    this.iconSize = 16,
    this.iconFirst = false,
    this.gap = 6,
    this.onTap,
  });

  final String text;
  final BootstrapIconData icon;

  /// The icon's width and height (`.icon-link > .bi { width: 1em }`).
  final double iconSize;

  /// Markup order: the `<svg>` before the text.
  final bool iconFirst;

  /// The gap between text and icon: `.375rem`, or `gap-1` (`.25rem`).
  final double gap;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = BsLink.colorOf(context);
    final label = Text(
      text,
      style: TextStyle(
        color: color,
        decoration: TextDecoration.underline,
        decorationColor: color.withValues(alpha: 0.5),
      ),
    );
    final glyph = BootstrapIcon(
      icon,
      width: iconSize,
      height: iconSize,
      color: color,
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: BsFlex(
          inline: true,
          alignItems: BsAlign.center,
          children: [
            if (iconFirst) glyph else label,
            SizedBox(width: gap),
            if (iconFirst) label else glyph,
          ],
        ),
      ),
    );
  }
}
