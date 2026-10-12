import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_breakpoint.dart';
import 'bs_color_utils.dart';
import 'bs_css_line_height.dart';
import 'bs_flex.dart';
import 'bs_spacing.dart';
import 'bs_colors.dart';
import 'bs_theme.dart';
import 'tokens/bs_typography.dart';

/// Which [BsTypography] heading size, weight and line height a [BsHeading] renders at.
enum BsHeadingLevel { h1, h2, h3, h4, h5, h6 }

/// A Bootstrap heading (levels 1 to 6), sized per [level] from [BsTypography]'s heading scale
/// (fluid below the `xl` breakpoint for levels 1 to 4, as Bootstrap's responsive font sizes
/// make them), with a bottom margin matching [BsTypography.headingsMarginBottom].
///
/// [fw] and [lh] set the heading's own weight and line height (a [BsBox] around a heading
/// cannot override them).
class BsHeading extends StatelessWidget {
  const BsHeading(
    this.level, {
    super.key,
    required this.child,
    this.fw,
    this.lh,
    this.mb,
    this.fs,
  });

  final BsHeadingLevel level;
  final Widget child;

  /// The heading's font weight.
  final BsFw? fw;

  /// The heading's line height.
  final BsLh? lh;

  /// The bottom margin, in place of the heading's default.
  final BsSpacing? mb;

  /// A size in place of the level's. The heading keeps its level's weight and line height.
  final BsFs? fs;

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
    final width = MediaQuery.sizeOf(context).width;
    final fontSize = fs?.sizeFor(width) ?? _fontSizeFor(level, width);
    final height = lh?.height ?? BsTypography.headingsLineHeight;
    return Padding(
      padding: EdgeInsets.only(
        bottom: mb?.size ?? BsTypography.headingsMarginBottom,
      ),
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

/// Which [BsTypography] display size a [BsDisplayHeading] renders at, from the largest (1)
/// to the smallest (6).
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

  /// The font size at a viewport [width]: scaled with the width below the `xl` breakpoint
  /// (Bootstrap's responsive font sizes), fixed from there up.
  double sizeFor(double width) => width >= BsBreakpoint.xl.minWidth
      ? _rem * 16
      : _baseRem * 16 + width * _vw;
}

/// A Bootstrap display heading: larger and lighter than [BsHeading], for hero-style text.
///
/// [fw] and [lh] set the heading's own weight and line height.
class BsDisplayHeading extends StatelessWidget {
  const BsDisplayHeading(
    this.level, {
    super.key,
    required this.child,
    this.fw,
    this.lh,
  });

  final BsDisplayLevel level;
  final Widget child;

  /// The heading's font weight.
  final BsFw? fw;

  /// The heading's line height.
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

/// A larger, lighter lead-in paragraph.
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

/// Small text: 87.5% of the surrounding size.
///
/// As inline text it does not shrink the lines it sits on: they stay as tall as the
/// surrounding block's (24px in a 16px block with a 1.5 line height, not 21px). As a [block]
/// (or a flex item) its lines are its own, 21px.
class BsSmall extends StatelessWidget {
  const BsSmall({super.key, required this.child, this.block = false});

  final Widget child;

  /// A box of its own rather than inline text.
  final bool block;

  @override
  Widget build(BuildContext context) {
    final parent = DefaultTextStyle.of(context).style;
    final base = parent.fontSize ?? 16;
    final size = base * 0.875;
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: size,
        height: block
            ? parent.height
            : base * (parent.height ?? BsTypography.lineHeightBase) / size,
      ),
      child: child,
    );
  }
}

/// A highlighted inline text span.
///
/// Bootstrap defines no dedicated token for the highlight, so this uses its actual default:
/// a light tint of [BsColors.yellow], computed the way [BsVariant.bgSubtle] is. The text color
/// inherits the ambient one in both themes (already brightness-aware via [BsApp]'s default
/// text style), so only the background is swapped in dark mode, to a dark shade of yellow.
class BsMark extends StatelessWidget {
  const BsMark({super.key, required this.child});

  final Widget child;

  static final Color _background = BsColorUtils.tint(BsColors.yellow, 0.8);
  static final Color _darkBackground = BsColorUtils.shade(BsColors.yellow, 0.6);

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    return Container(
      // An inline box's vertical padding paints but takes no room, so only the sides are
      // padded here.
      padding: const EdgeInsets.symmetric(horizontal: BsTypography.markPadding),
      color: isDark ? _darkBackground : _background,
      child: child,
    );
  }
}

/// A larger-font quotation, with an optional [footer] (typically a [BsBlockquoteFooter])
/// attributing its source.
class BsBlockquote extends StatelessWidget {
  const BsBlockquote({super.key, required this.child, this.footer});

  final Widget child;

  /// Typically a [BsBlockquoteFooter].
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    // The bottom margin is 16 logical pixels, and the larger font size is on the blockquote
    // itself, so its footer's smaller size is relative to that.
    return Padding(
      padding: const EdgeInsets.only(bottom: BsTypography.blockquoteMarginY),
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: BsTypography.blockquoteFontSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [child, ?footer],
        ),
      ),
    );
  }
}

/// A small, muted attribution line for a [BsBlockquote], prefixed with an em dash.
class BsBlockquoteFooter extends StatelessWidget {
  const BsBlockquoteFooter({
    super.key,
    required this.child,
    this.color,
    this.standalone = false,
  });

  final Widget child;

  /// A text color in place of the footer's default.
  final Color? color;

  /// Places the footer after the blockquote rather than inside it: it is pulled up over the
  /// blockquote's bottom margin, and placed by the surrounding text alignment.
  final bool standalone;

  /// `::before { content: "— " }`, flowing into the text when it is a [Text]
  /// (so a long attribution wraps as one run), or beside it otherwise.
  static Widget _withDash(Widget child) {
    if (child is Text) {
      final span = child.textSpan ?? TextSpan(text: child.data);
      return Text.rich(
        TextSpan(text: '—\u00A0', children: [span]),
        style: child.style,
        textAlign: child.textAlign,
        softWrap: child.softWrap,
        maxLines: child.maxLines,
        overflow: child.overflow,
      );
    }
    return BsFlex(
      inline: true,
      alignItems: BsAlign.start,
      children: [const Text('—\u00A0'), child],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The footer is 87.5% of the surrounding size.
    final base = DefaultTextStyle.of(context).style.fontSize ?? BsTypography.fontSizeBase;
    Widget footer = DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: base * 0.875,
        color: color ?? BsTypography.blockquoteFooterColor,
      ),
      child: _withDash(child),
    );
    if (standalone) {
      footer = _PullUp(
        amount: BsTypography.blockquoteMarginY,
        child: BsBox(inlineBlock: true, child: footer),
      );
    }
    return footer;
  }
}

/// A negative top margin: [child] sits [amount] higher and takes that much less
/// room.
class _PullUp extends SingleChildRenderObjectWidget {
  const _PullUp({required this.amount, required super.child});

  final double amount;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderPullUp(amount);

  @override
  void updateRenderObject(BuildContext context, _RenderPullUp renderObject) {
    renderObject.amount = amount;
  }
}

class _RenderPullUp extends RenderShiftedBox {
  _RenderPullUp(this._amount) : super(null);

  double _amount;
  set amount(double v) {
    if (v != _amount) {
      _amount = v;
      markNeedsLayout();
    }
  }

  Size _size(Size childSize) =>
      Size(childSize.width, childSize.height - _amount);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    return child == null
        ? constraints.smallest
        : constraints.constrain(_size(child.getDryLayout(constraints)));
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(_size(child.size));
    (child.parentData! as BoxParentData).offset = Offset(0, -_amount);
  }
}
