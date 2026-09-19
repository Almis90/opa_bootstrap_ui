import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_variant.dart';
import 'tokens/bs_badge_style.dart';

/// A Bootstrap badge (`.badge`): a small count/label pill.
///
/// Matches the `.badge.text-bg-{variant}` pattern used throughout
/// Bootstrap's docs — background is [variant]'s raw color, and text color
/// is computed via [BsColorUtils.contrast] rather than Bootstrap's static
/// `$badge-color: $white` fallback, so `light`/`warning` badges correctly
/// get dark text. Pass [pill] for the fully-rounded `.rounded-pill` variant.
class BsBadge extends StatelessWidget {
  const BsBadge({super.key, required this.child, this.variant = BsVariant.primary, this.pill = false, this.style});

  /// The badge's content, typically a [Text].
  final Widget child;

  /// The Bootstrap contextual color, e.g. [BsVariant.primary].
  final BsVariant variant;

  /// Whether to render fully-rounded (pill-shaped) corners.
  final bool pill;

  /// Style overrides layered on top of [BsBadgeStyle.defaults].
  final BsBadgeStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsBadgeStyle.defaults.merge(this.style);
    final background = style.background ?? variant.color;
    final color = style.color ?? BsColorUtils.contrast(background);
    final borderRadius = style.borderRadius ?? BsBadgeStyle.defaultBorderRadius;

    return Container(
      padding: style.padding ?? BsBadgeStyle.defaultPadding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(pill ? 1000 : borderRadius),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: color,
          fontSize: style.fontSize ?? BsBadgeStyle.defaultFontSize,
          fontWeight: style.fontWeight ?? BsBadgeStyle.defaultFontWeight,
          height: 1,
        ),
        textAlign: TextAlign.center,
        child: child,
      ),
    );
  }
}
