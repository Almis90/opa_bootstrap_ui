import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_spacing.dart';
import 'bs_theme.dart';
import 'bs_variant.dart';
import 'tokens/bs_badge_style.dart';
import 'bs_decorated_box.dart';

/// A Bootstrap badge: a small count or label pill.
///
/// The background is [variant]'s raw color and the text color is computed via
/// [BsColorUtils.contrast] rather than a static white, so that light and warning badges
/// correctly get dark text. Pass [pill] for fully rounded ends.
class BsBadge extends StatelessWidget {
  const BsBadge({
    super.key,
    required this.child,
    this.variant = BsVariant.primary,
    this.pill = false,
    this.subtle = false,
    this.emphasis,
    this.border = false,
    this.borderVariant,
    this.p,
    this.pe,
    this.style,
  });

  /// The badge's content, typically a [Text].
  final Widget child;

  /// The Bootstrap contextual color, e.g. [BsVariant.primary].
  final BsVariant variant;

  /// Whether to render fully-rounded (pill-shaped) corners.
  final bool pill;

  /// A pale background with dark text of the same hue, instead of the solid variant color with
  /// contrasting text.
  final bool subtle;

  /// The text color of this variant's emphasis colors (for a [subtle] badge whose text is another
  /// hue than its background).
  final BsVariant? emphasis;

  /// A 1px border, in [borderVariant]'s subtle border color (or [variant]'s). It adds to the
  /// badge's size.
  final bool border;

  /// A border in the subtle border color of a variant other than the badge's own.
  final BsVariant? borderVariant;

  /// Padding on every side in place of the badge's default.
  final BsSpacing? p;

  /// The end padding, over [p] and the default.
  final BsSpacing? pe;

  /// Style overrides layered on top of [BsBadgeStyle.defaults].
  final BsBadgeStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsBadgeStyle.defaults.merge(this.style);
    // The font size and padding are relative to the text the badge sits in (a badge in a
    // heading is 75% of the heading), unless the style sets its own.
    final parentSize = DefaultTextStyle.of(context).style.fontSize ?? 16;
    final fontSize = this.style?.fontSize ?? parentSize * 0.75;
    final dark = BsTheme.of(context) == Brightness.dark;
    final background =
        style.background ??
        (subtle
            ? (dark ? variant.darkBgSubtle : variant.bgSubtle)
            : variant.color);
    final emphasisVariant = emphasis ?? variant;
    final color =
        style.color ??
        (subtle || emphasis != null
            ? (dark
                  ? emphasisVariant.darkTextEmphasis
                  : emphasisVariant.textEmphasis)
            : BsColorUtils.contrast(background));
    final borderRadius = style.borderRadius ?? BsBadgeStyle.defaultBorderRadius;
    final borderColor = (borderVariant ?? variant);
    var padding =
        this.style?.padding ??
        EdgeInsets.symmetric(horizontal: 0.65 * fontSize, vertical: 0.35 * fontSize);
    if (p != null || pe != null) {
      final resolved = padding.resolve(TextDirection.ltr);
      final all = p?.size;
      padding = EdgeInsetsDirectional.only(
        start: all ?? resolved.left,
        end: pe?.size ?? all ?? resolved.right,
        top: all ?? resolved.top,
        bottom: all ?? resolved.bottom,
      );
    }

    return BsDecoratedContainer(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        border: border
            ? Border.all(
                color: dark
                    ? borderColor.darkBorderSubtle
                    : borderColor.borderSubtle,
              )
            : null,
        borderRadius: BorderRadius.circular(pill ? 1000 : borderRadius),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: style.fontWeight ?? BsBadgeStyle.defaultFontWeight,
          height: 1,
        ),
        textAlign: TextAlign.center,
        softWrap: false,
        child: child,
      ),
    );
  }
}
