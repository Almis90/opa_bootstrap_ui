import 'package:flutter/widgets.dart';

import 'bootstrap_icon.dart';

/// An inline-level box sitting in a block's line box, as the original's
/// `<div class="col-md-3"><a class="d-inline-flex">` or `<svg class="bi">`
/// does: the line box is the strut's descent taller than the box, so the box
/// rests at the top of its line rather than in its middle.
///
/// The descent is font-metric dependent: Chrome rounds Roboto's ascent (0.928em)
/// and descent (0.244em) to whole *device* pixels, adds the line-height's
/// leading around them (the ascent side gets the floored half), and the
/// descent side is what's left — 7px at 1x, 6.5px at 2x. [lowered] is how far
/// the box itself hangs below the baseline (`.bi`'s `vertical-align:
/// -.125em` is 2px), which it already accounts for.
class InlineLine extends StatelessWidget {
  const InlineLine({super.key, this.lowered = 0, required this.child});

  final double lowered;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final ascent = (0.9277 * 16 * dpr).round();
    final descent = (0.2441 * 16 * dpr).round();
    final lineHeight = 24 * dpr;
    final above = ascent + ((lineHeight - ascent - descent) / 2).floor();
    final below = (lineHeight - above) / dpr;
    return Padding(
      padding: EdgeInsets.only(bottom: below > lowered ? below - lowered : 0),
      child: child,
    );
  }
}

/// `<svg class="bi me-2" width="16" height="16"> Label` in one line of text:
/// the icon sits on the baseline (hanging [lowered] below it, `.bi`'s
/// `vertical-align: -.125em`), so it is level with the label's x-height rather
/// than centred on its line. The line keeps the surrounding block's
/// [lineHeight].
class InlineIconLabel extends StatelessWidget {
  const InlineIconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.iconWidth = 16,
    this.iconHeight = 16,
    this.gap = 8,
    this.lowered = 2,
    this.fontSize = 16,
    this.lineHeight = 24,
  });

  final BootstrapIconData icon;
  final Widget label;
  final double iconWidth;
  final double iconHeight;

  /// The width of the space between the `<svg>` and the label in the
  /// markup (Roboto's, at 16px).
  static const inlineSpace = 3.92;

  /// `me-2`.
  final double gap;
  final double lowered;
  final double fontSize;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final ascent = (0.9277 * fontSize * dpr).round();
    final descent = (0.2441 * fontSize * dpr).round();
    final above = ascent + ((lineHeight * dpr - ascent - descent) / 2).floor();
    final top = (above - (iconHeight - lowered) * dpr) / dpr;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: top < 0 ? 0 : top),
          child: BootstrapIcon(icon, width: iconWidth, height: iconHeight),
        ),
        SizedBox(width: gap + inlineSpace),
        label,
      ],
    );
  }
}
