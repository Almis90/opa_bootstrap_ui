import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_spacing.dart';
import 'bs_theme.dart';
import 'bs_variant.dart';
import 'tokens/bs_badge_style.dart';
import 'bs_decorated_box.dart';

/// A Bootstrap badge (`.badge`): a small count/label pill.
///
/// Matches the `.badge.text-bg-{variant}` pattern used throughout
/// Bootstrap's docs — background is [variant]'s raw color, and text color
/// is computed via [BsColorUtils.contrast] rather than Bootstrap's static
/// `$badge-color: $white` fallback, so `light`/`warning` badges correctly
/// get dark text. Pass [pill] for the fully-rounded `.rounded-pill` variant.
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

  /// `bg-{variant}-subtle text-{variant}-emphasis` instead of `text-bg-{variant}`:
  /// a pale background with dark text of the same hue.
  final bool subtle;

  /// `text-{variant}-emphasis`: the text color of this variant's emphasis
  /// colors (for a [subtle] badge whose text is another hue than its
  /// background, `text-dark-emphasis bg-light-subtle`).
  final BsVariant? emphasis;

  /// `border border-{variant}-subtle`: a 1px border, in [borderVariant]'s
  /// subtle border color (or [variant]'s). It adds to the badge's size.
  final bool border;

  /// `border-{variant}-subtle` of another variant than the badge's own.
  final BsVariant? borderVariant;

  /// `p-*`: padding on every side in place of the badge's `.35em .65em`.
  final BsSpacing? p;

  /// `pe-*`: the end padding, over [p] and the default.
  final BsSpacing? pe;

  /// Style overrides layered on top of [BsBadgeStyle.defaults].
  final BsBadgeStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsBadgeStyle.defaults.merge(this.style);
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
    var padding = style.padding ?? BsBadgeStyle.defaultPadding;
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
          fontSize: style.fontSize ?? BsBadgeStyle.defaultFontSize,
          fontWeight: style.fontWeight ?? BsBadgeStyle.defaultFontWeight,
          height: 1,
        ),
        textAlign: TextAlign.center,
        // `.badge { white-space: nowrap }`
        softWrap: false,
        child: child,
      ),
    );
  }
}
