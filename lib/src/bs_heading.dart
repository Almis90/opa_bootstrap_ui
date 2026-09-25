import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_colors.dart';
import 'tokens/bs_typography.dart';

/// `h1`-`h6`: which [BsTypography] heading size/weight/line-height a
/// [BsHeading] renders at.
enum BsHeadingLevel { h1, h2, h3, h4, h5, h6 }

/// A Bootstrap heading (`h1`-`h6`), sized per [level] from [BsTypography]'s
/// `$h#-font-size` scale, with a bottom margin matching
/// [BsTypography.headingsMarginBottom].
class BsHeading extends StatelessWidget {
  const BsHeading(this.level, {super.key, required this.child});

  final BsHeadingLevel level;
  final Widget child;

  static double _fontSizeFor(BsHeadingLevel level) => switch (level) {
    BsHeadingLevel.h1 => BsTypography.h1FontSize,
    BsHeadingLevel.h2 => BsTypography.h2FontSize,
    BsHeadingLevel.h3 => BsTypography.h3FontSize,
    BsHeadingLevel.h4 => BsTypography.h4FontSize,
    BsHeadingLevel.h5 => BsTypography.h5FontSize,
    BsHeadingLevel.h6 => BsTypography.h6FontSize,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BsTypography.headingsMarginBottom),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: _fontSizeFor(level),
          fontWeight: BsTypography.headingsFontWeight,
          height: BsTypography.headingsLineHeight,
        ),
        child: child,
      ),
    );
  }
}

/// `.display-1`-`.display-6`: which [BsTypography] display size a
/// [BsDisplayHeading] renders at.
enum BsDisplayLevel { d1, d2, d3, d4, d5, d6 }

/// A Bootstrap display heading (`.display-1`-`.display-6`): larger, lighter
/// weight than [BsHeading], for hero-style text.
class BsDisplayHeading extends StatelessWidget {
  const BsDisplayHeading(this.level, {super.key, required this.child});

  final BsDisplayLevel level;
  final Widget child;

  static double _fontSizeFor(BsDisplayLevel level) => switch (level) {
    BsDisplayLevel.d1 => BsTypography.displayFontSize1,
    BsDisplayLevel.d2 => BsTypography.displayFontSize2,
    BsDisplayLevel.d3 => BsTypography.displayFontSize3,
    BsDisplayLevel.d4 => BsTypography.displayFontSize4,
    BsDisplayLevel.d5 => BsTypography.displayFontSize5,
    BsDisplayLevel.d6 => BsTypography.displayFontSize6,
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: _fontSizeFor(level),
        fontWeight: BsTypography.displayFontWeight,
        height: BsTypography.displayLineHeight,
      ),
      child: child,
    );
  }
}

/// `.lead`: a larger, lighter-weight lead-in paragraph.
class BsLead extends StatelessWidget {
  const BsLead({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        fontSize: BsTypography.leadFontSize,
        fontWeight: BsTypography.leadFontWeight,
      ),
      child: child,
    );
  }
}

/// `mark`/`.mark`: a highlighted inline text span.
///
/// Bootstrap's `$mark-bg` isn't in [BsTypography] (it has no dedicated
/// SCSS variable group), so this mirrors the actual default — a light tint
/// of [BsColors.yellow], the same `tint-color()` formula [BsVariant.bgSubtle]
/// uses — directly.
class BsMark extends StatelessWidget {
  const BsMark({super.key, required this.child});

  final Widget child;

  static final Color _background = BsColorUtils.tint(BsColors.yellow, 0.8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BsTypography.markPadding),
      color: _background,
      child: child,
    );
  }
}

/// `blockquote`/`.blockquote`: a larger-font quotation, with an optional
/// [footer] (typically a [BsBlockquoteFooter]) attributing its source.
class BsBlockquote extends StatelessWidget {
  const BsBlockquote({super.key, required this.child, this.footer});

  final Widget child;

  /// Typically a [BsBlockquoteFooter].
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BsTypography.blockquoteMarginY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle.merge(
            style: const TextStyle(fontSize: BsTypography.blockquoteFontSize),
            child: child,
          ),
          ?footer,
        ],
      ),
    );
  }
}

/// `.blockquote-footer`: a small, muted attribution line for a
/// [BsBlockquote], prefixed with an em dash like Bootstrap's
/// `::before { content: "\2014\00A0"; }`.
class BsBlockquoteFooter extends StatelessWidget {
  const BsBlockquoteFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(
        fontSize: BsTypography.blockquoteFooterFontSize,
        color: BsTypography.blockquoteFooterColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [const Text('— '), child],
      ),
    );
  }
}
