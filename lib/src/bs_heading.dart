import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_breakpoint.dart';
import 'bs_color_utils.dart';
import 'bs_css_line_height.dart';
import 'bs_colors.dart';
import 'bs_theme.dart';
import 'tokens/bs_typography.dart';

/// `h1`-`h6`: which [BsTypography] heading size/weight/line-height a
/// [BsHeading] renders at.
enum BsHeadingLevel { h1, h2, h3, h4, h5, h6 }

/// A Bootstrap heading (`h1`-`h6`), sized per [level] from [BsTypography]'s
/// `$h#-font-size` scale — fluid below the `xl` breakpoint, as Bootstrap's
/// responsive font sizes make `h1`-`h4` — with a bottom margin matching
/// [BsTypography.headingsMarginBottom].
///
/// [fw] and [lh] are the `fw-*`/`lh-*` utilities for the heading's own element
/// (a [BsBox] around a heading can't override its weight or line-height).
class BsHeading extends StatelessWidget {
  const BsHeading(this.level, {super.key, required this.child, this.fw, this.lh});

  final BsHeadingLevel level;
  final Widget child;

  /// `fw-*`.
  final BsFw? fw;

  /// `lh-*`.
  final BsLh? lh;

  static double _fontSizeFor(BsHeadingLevel level, double viewportWidth) =>
      switch (level) {
        BsHeadingLevel.h1 => BsFs.fs1.sizeFor(viewportWidth),
        BsHeadingLevel.h2 => BsFs.fs2.sizeFor(viewportWidth),
        BsHeadingLevel.h3 => BsFs.fs3.sizeFor(viewportWidth),
        BsHeadingLevel.h4 => BsFs.fs4.sizeFor(viewportWidth),
        BsHeadingLevel.h5 => BsTypography.h5FontSize,
        BsHeadingLevel.h6 => BsTypography.h6FontSize,
      };

  @override
  Widget build(BuildContext context) {
    final fontSize = _fontSizeFor(level, MediaQuery.sizeOf(context).width);
    final height = lh?.height ?? BsTypography.headingsLineHeight;
    return Padding(
      padding: const EdgeInsets.only(bottom: BsTypography.headingsMarginBottom),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fw?.weight ?? BsTypography.headingsFontWeight,
          height: height,
        ),
        child: BsCssLineHeight(
          fontSize: fontSize,
          lineHeight: height,
          perLine: true,
          child: child,
        ),
      ),
    );
  }
}

/// `.display-1`-`.display-6`: which [BsTypography] display size a
/// [BsDisplayHeading] renders at.
enum BsDisplayLevel {
  d1(5, 1.625, 0.045),
  d2(4.5, 1.575, 0.039),
  d3(4, 1.525, 0.033),
  d4(3.5, 1.475, 0.027),
  d5(3, 1.425, 0.021),
  d6(2.5, 1.375, 0.015);

  const BsDisplayLevel(this._rem, this._baseRem, this._vw);

  final double _rem;
  final double _baseRem;
  final double _vw;

  /// The font size at a viewport [width]: `calc(<base>rem + <n>vw)` below the
  /// `xl` breakpoint (Bootstrap's responsive font sizes), `$display-font-sizes`
  /// from there up.
  double sizeFor(double width) => width >= BsBreakpoint.xl.minWidth
      ? _rem * 16
      : _baseRem * 16 + width * _vw;
}

/// A Bootstrap display heading (`.display-1`-`.display-6`): larger, lighter
/// weight than [BsHeading], for hero-style text.
///
/// [fw] and [lh] are the `fw-*`/`lh-*` utilities for the heading's own element
/// (`<h1 class="display-5 fw-bold lh-1">`).
class BsDisplayHeading extends StatelessWidget {
  const BsDisplayHeading(this.level, {super.key, required this.child, this.fw, this.lh});

  final BsDisplayLevel level;
  final Widget child;

  /// `fw-*`.
  final BsFw? fw;

  /// `lh-*`.
  final BsLh? lh;

  @override
  Widget build(BuildContext context) {
    final fontSize = level.sizeFor(MediaQuery.sizeOf(context).width);
    final height = lh?.height ?? BsTypography.displayLineHeight;
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fw?.weight ?? BsTypography.displayFontWeight,
        height: height,
      ),
      child: BsCssLineHeight(
        fontSize: fontSize,
        lineHeight: height,
        perLine: true,
        child: child,
      ),
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

/// `small`/`.small`: text at `.875em` — 87.5% of the surrounding size.
///
/// As an inline element it doesn't shrink the lines it sits on: they stay as
/// tall as the surrounding block's (24px in a 16px/1.5 block, not 21px).
class BsSmall extends StatelessWidget {
  const BsSmall({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parent = DefaultTextStyle.of(context).style;
    final base = parent.fontSize ?? 16;
    final size = base * 0.875;
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: size,
        height: base * (parent.height ?? BsTypography.lineHeightBase) / size,
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
/// uses — directly. `$mark-color` inherits the ambient text color in both
/// themes (already brightness-aware via [BsApp]'s `DefaultTextStyle`), so
/// only the background needs to swap for `$mark-bg-dark`
/// (`shade-color($yellow, 60%)`).
class BsMark extends StatelessWidget {
  const BsMark({super.key, required this.child});

  final Widget child;

  static final Color _background = BsColorUtils.tint(BsColors.yellow, 0.8);
  static final Color _darkBackground = BsColorUtils.shade(BsColors.yellow, 0.6);

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(BsTypography.markPadding),
      color: isDark ? _darkBackground : _background,
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
