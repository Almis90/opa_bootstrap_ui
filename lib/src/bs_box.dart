import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'bs_clip_rrect.dart';
import 'bs_breakpoint.dart';
import 'bs_color_utils.dart';
import 'bs_colors.dart';
import 'bs_flex.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';
import 'bs_variant.dart';
import 'tokens/bs_body.dart';
import 'tokens/bs_borders.dart';
import 'tokens/bs_shadows.dart';
import 'bs_css_line_height.dart';
import 'bs_dashed_border.dart';
import 'bs_decorated_box.dart';

/// Bootstrap's six responsive font sizes, from the largest (1) to the smallest (6). Below the
/// `xl` breakpoint the larger ones scale with the viewport; from `xl` up they are fixed.
/// [sizeFor] resolves either.
enum BsFs implements BsResponsive<BsFs> {
  fs1(2.5, 1.375, 0.015),
  fs2(2, 1.325, 0.009),
  fs3(1.75, 1.3, 0.006),
  fs4(1.5, 1.275, 0.003),
  fs5(1.25, null, null),
  fs6(1, null, null);

  const BsFs(this._rem, this._baseRem, this._vw);

  final double _rem;
  final double? _baseRem;
  final double? _vw;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => name.substring(2);

  /// The font size in logical pixels at a viewport [width] (`16px` root size).
  double sizeFor(double width) {
    if (_baseRem == null || width >= BsBreakpoint.xl.minWidth) {
      return _rem * 16;
    }
    return _baseRem * 16 + width * _vw!;
  }

  @override
  BsFs resolve(BsBreakpoint breakpoint) => this;
}

/// Bootstrap's text colors: the theme colors plus white, black and the body tones.
enum BsTextColor {
  /// The primary color.
  primary,

  /// The secondary color, `#6c757d` in both themes.
  secondary,
  success,
  info,
  warning,
  danger,
  light,
  dark,

  /// White.
  white,

  /// Black.
  black,

  /// The body text color.
  body,

  /// The secondary body text color: a muted tone.
  bodySecondary,

  /// The tertiary body text color: more muted still.
  bodyTertiary,

  /// The emphasized body text color: the strongest contrast. Also used for emphasized links.
  bodyEmphasis;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => switch (this) {
    bodySecondary => 'body-secondary',
    bodyTertiary => 'body-tertiary',
    bodyEmphasis => 'body-emphasis',
    _ => name,
  };

  /// The color in the ambient theme.
  Color of(BuildContext context) => switch (this) {
    primary => BsVariant.primary.color,
    secondary => BsVariant.secondary.color,
    success => BsVariant.success.color,
    info => BsVariant.info.color,
    warning => BsVariant.warning.color,
    danger => BsVariant.danger.color,
    light => BsVariant.light.color,
    dark => BsVariant.dark.color,
    white => BsColors.white,
    black => BsColors.black,
    body => BsBody.colorOf(context),
    bodySecondary => BsBody.secondaryColorOf(context),
    bodyTertiary => BsBody.tertiaryColorOf(context),
    bodyEmphasis => BsBody.emphasisColorOf(context),
  };
}

/// Bootstrap's background colors: the theme colors plus white, black and the body tones.
enum BsBg {
  primary,
  secondary,
  success,
  info,
  warning,
  danger,
  light,
  dark,
  white,
  black,

  /// The page background.
  body,

  /// The secondary body background.
  bodySecondary,

  /// The tertiary body background: a subtle step from the page.
  bodyTertiary,
  transparent;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => switch (this) {
    bodySecondary => 'body-secondary',
    bodyTertiary => 'body-tertiary',
    _ => name,
  };

  /// The color in the ambient theme.
  Color of(BuildContext context) => switch (this) {
    primary => BsVariant.primary.color,
    secondary => BsVariant.secondary.color,
    success => BsVariant.success.color,
    info => BsVariant.info.color,
    warning => BsVariant.warning.color,
    danger => BsVariant.danger.color,
    light => BsVariant.light.color,
    dark => BsVariant.dark.color,
    white => BsColors.white,
    black => BsColors.black,
    body => BsBody.backgroundOf(context),
    bodySecondary => BsBody.secondaryBackgroundOf(context),
    bodyTertiary => BsBody.tertiaryBackgroundOf(context),
    transparent => const Color(0x00000000),
  };
}

/// Bootstrap's corner radii, from none to large, plus circle and pill.
enum BsRounded {
  /// No rounding.
  r0(0),

  /// Small corner radius (4).
  r1(4),

  /// Default corner radius (6).
  r2(6),

  /// Large corner radius (8).
  r3(8),

  /// Extra large corner radius (16).
  r4(16),

  /// Double extra large corner radius (32).
  r5(32),

  /// Fully rounded (a circle on a square box).
  circle(9999),

  /// Fully rounded ends.
  pill(800);

  const BsRounded(this.radius);

  /// The corner radius in logical pixels.
  final double radius;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className =>
      this == circle || this == pill ? name : name.substring(1);
}

/// Text alignment: at the start, centered or at the end.
enum BsTextAlign implements BsResponsive<BsTextAlign> {
  start,
  center,
  end;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => name;

  @override
  BsTextAlign resolve(BsBreakpoint breakpoint) => this;
}

/// A height as a share of the parent's (which has to have one; a column stretched by a row
/// does).
enum BsHeight implements BsResponsive<BsHeight> {
  h25(0.25),
  h50(0.5),
  h75(0.75),
  h100(1),
  auto(null);

  const BsHeight(this.fraction);

  final double? fraction;

  @override
  BsHeight resolve(BsBreakpoint breakpoint) => this;
}

/// Opacity steps from transparent to opaque.
enum BsOpacity {
  o0(0),
  o25(0.25),
  o50(0.5),
  o75(0.75),
  o100(1);

  const BsOpacity(this.value);

  final double value;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => name.substring(1);
}

/// Bootstrap's font weights.
enum BsFw {
  /// Bold (700).
  bold(FontWeight.w700),

  /// Bolder (800).
  bolder(FontWeight.w800),

  /// Semibold (600).
  semibold(FontWeight.w600),

  /// Medium (500).
  medium(FontWeight.w500),

  /// Normal (400).
  normal(FontWeight.w400),

  /// Light (300).
  light(FontWeight.w300),

  /// Lighter (200).
  lighter(FontWeight.w200);

  const BsFw(this.weight);

  final FontWeight weight;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => name;
}

/// Bootstrap's line heights.
enum BsLh {
  /// Line height of 1 (tight).
  lh1(1),

  /// Small line height (1.25).
  sm(1.25),

  /// Base line height (1.5).
  base(1.5),

  /// Large line height (2).
  lg(2);

  const BsLh(this.height);

  /// The unitless line-height multiplier.
  final double height;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => switch (this) {
    lh1 => '1',
    _ => name,
  };
}

/// Bootstrap's shadow sizes.
enum BsShadow {
  /// No shadow.
  none(<BoxShadow>[]),

  /// Small shadow.
  sm(BsShadows.shadowSm),

  /// Default shadow.
  normal(BsShadows.shadow),

  /// Large shadow.
  lg(BsShadows.shadowLg);

  const BsShadow(this.shadows);

  final List<BoxShadow> shadows;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => switch (this) {
    none => 'shadow-none',
    sm => 'shadow-sm',
    normal => 'shadow',
    lg => 'shadow-lg',
  };
}

/// The style of a [BsBox]'s border. Only a border on all four sides can be dashed.
enum BsBorderStyle { solid, dashed }

/// A block container with Bootstrap's utilities applied to it: spacing, borders, background,
/// text color, font size, alignment and width.
///
/// Prop names follow Bootstrap's: spacing is `m` or `p` with `x`, `y`, `t`, `e`, `b` or `s`
/// (`mx`, `pb`, `ms`…, where `e`nd and `s`tart are logical), borders are `border`, `borderTop`,
/// `borderEnd`, `borderBottom` and `borderStart`, followed by [bg], [textBg], [textColor],
/// [fs], [textAlign] and [w]. Spacing, [fs], [textAlign] and [w] take a [BsResponsive]: a plain
/// value, or a [BsResponsiveValue] that changes with the viewport's breakpoint.
///
/// Where spacing props overlap, the most specific wins: `pt` over `py` over `p` (and `ps` or
/// `pe` over `px` over `p`), likewise for margins. A margin of [BsSpacing.auto] on the inline
/// axis centers the box, or aligns it to one side with `ms` or `me`, within its parent.
///
/// Margins and padding sum rather than collapse. For the margins of a child of a [BsFlex],
/// use [BsFlexItem] instead.
class BsBox extends StatelessWidget {
  const BsBox({
    super.key,
    this.child,
    this.p,
    this.px,
    this.py,
    this.pt,
    this.pe,
    this.pb,
    this.ps,
    this.m,
    this.mx,
    this.my,
    this.mt,
    this.me,
    this.mb,
    this.ms,
    this.border = false,
    this.borderTop = false,
    this.borderEnd = false,
    this.borderBottom = false,
    this.borderStart = false,
    this.borderStyle = BsBorderStyle.solid,
    this.bg,
    this.rounded,
    this.textBg,
    this.textColor,
    this.fs,
    this.fw,
    this.lh,
    this.textAlign,
    this.w,
    this.h,
    this.col,
    this.shadow,
    this.overflowHidden = false,
    this.inlineBlock = false,
    this.opacity,
    this.textNoWrap = false,
  });

  final Widget? child;

  final BsResponsive<BsSpacing>? p;
  final BsResponsive<BsSpacing>? px;
  final BsResponsive<BsSpacing>? py;
  final BsResponsive<BsSpacing>? pt;
  final BsResponsive<BsSpacing>? pe;
  final BsResponsive<BsSpacing>? pb;
  final BsResponsive<BsSpacing>? ps;

  final BsResponsive<BsSpacing>? m;
  final BsResponsive<BsSpacing>? mx;
  final BsResponsive<BsSpacing>? my;
  final BsResponsive<BsSpacing>? mt;
  final BsResponsive<BsSpacing>? me;
  final BsResponsive<BsSpacing>? mb;
  final BsResponsive<BsSpacing>? ms;

  /// `border`: a border on all four sides.
  final bool border;

  /// A border on the top edge.
  final bool borderTop;

  /// A border on the end edge.
  final bool borderEnd;

  /// A border on the bottom edge.
  final bool borderBottom;

  /// A border on the start edge.
  final bool borderStart;

  /// The style of [border] (all four sides).
  final BsBorderStyle borderStyle;

  /// The background color.
  final BsBg? bg;

  /// The corner radius.
  final BsRounded? rounded;

  /// `text-bg-*`: the variant's background with a contrasting text color.
  final BsVariant? textBg;

  /// The text color.
  final BsTextColor? textColor;

  /// The font size.
  final BsResponsive<BsFs>? fs;

  /// The font weight.
  final BsFw? fw;

  /// The line height.
  final BsLh? lh;

  /// The text alignment.
  final BsResponsive<BsTextAlign>? textAlign;

  /// The width as a share of the parent's.
  final BsResponsive<BsWidth>? w;

  /// The height as a share of the parent's.
  final BsResponsive<BsHeight>? h;

  /// The box's width as a share of 12 columns of its parent, outside a row (`col-lg-6` with
  /// centering is half the parent, centered, from `lg`).
  final BsResponsive<BsCol>? col;

  /// The shadow.
  final BsShadow? shadow;

  /// Sizes the box to its content rather than its parent, and places it by the inherited text
  /// alignment as inline content is (for example a bordered image in a centered block).
  final bool inlineBlock;

  /// Fades the whole box, content included.
  final BsOpacity? opacity;

  /// Prevents the text from wrapping.
  final bool textNoWrap;

  /// Clips the content to the box (inside its border, with its rounded corners).
  final bool overflowHidden;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context).width;
    final breakpoint = BsBreakpoint.forWidth(viewport);

    BsSpacing? pick(List<BsResponsive<BsSpacing>?> candidates) {
      for (final c in candidates) {
        final v = c?.resolve(breakpoint);
        if (v != null) {
          return v;
        }
      }
      return null;
    }

    double px0(BsSpacing? s) => s?.size ?? 0;

    var content = child;

    // Text: color, size, alignment.
    final color =
        textColor?.of(context) ??
        (textBg == null ? null : BsColorUtils.contrast(textBg!.color));
    final fontSize = fs?.resolve(breakpoint)?.sizeFor(viewport);
    final align = textAlign?.resolve(breakpoint);
    if (content != null &&
        (color != null ||
            fontSize != null ||
            align != null ||
            fw != null ||
            lh != null ||
            textNoWrap)) {
      content = DefaultTextStyle.merge(
        softWrap: textNoWrap ? false : null,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fw?.weight,
          height: lh?.height,
        ),
        textAlign: switch (align) {
          BsTextAlign.start => TextAlign.start,
          BsTextAlign.center => TextAlign.center,
          BsTextAlign.end => TextAlign.end,
          null => null,
        },
        child: content,
      );
      if (fontSize != null) {
        content = BsCssLineHeight(
          fontSize: fontSize,
          lineHeight:
              lh?.height ?? DefaultTextStyle.of(context).style.height ?? 1.5,
          perLine: true,
          child: content,
        );
      }
      if (align != null) {
        // Inline content follows text-align too, not just text.
        content = _TextAligned(
          alignment: switch (align) {
            BsTextAlign.start => AlignmentDirectional.topStart,
            BsTextAlign.center => AlignmentDirectional.topCenter,
            BsTextAlign.end => AlignmentDirectional.topEnd,
          },
          child: content,
        );
      }
    }

    // Border, background, padding — one Container so the border adds to the size.
    final borderColor = BsBorders.colorOf(context);
    final side = BorderSide(color: borderColor, width: BsBorders.width);
    const none = BorderSide.none;
    final decoration =
        (bg != null ||
            rounded != null ||
            textBg != null ||
            border ||
            borderTop ||
            borderEnd ||
            borderBottom ||
            borderStart ||
            (shadow != null && shadow != BsShadow.none))
        ? BoxDecoration(
            color: bg?.of(context) ?? textBg?.color,
            boxShadow: shadow?.shadows,
            borderRadius: rounded == null
                ? null
                : BorderRadius.circular(rounded!.radius),
            border: border && borderStyle == BsBorderStyle.dashed
                ? BsDashedBorder(color: borderColor, width: BsBorders.width)
                : (border ||
                      borderTop ||
                      borderEnd ||
                      borderBottom ||
                      borderStart)
                ? BorderDirectional(
                    top: (border || borderTop) ? side : none,
                    end: (border || borderEnd) ? side : none,
                    bottom: (border || borderBottom) ? side : none,
                    start: (border || borderStart) ? side : none,
                  )
                : null,
          )
        : null;
    final padding = EdgeInsetsDirectional.only(
      top: px0(pick([pt, py, p])),
      end: px0(pick([pe, px, p])),
      bottom: px0(pick([pb, py, p])),
      start: px0(pick([ps, px, p])),
    );
    final hasPadding = padding != EdgeInsetsDirectional.zero;
    if (overflowHidden && content != null) {
      // Clipped to the padding box: inside the border, with its (inner) corners.
      final inner = rounded == null
          ? BorderRadius.zero
          : BorderRadius.circular(
              (rounded!.radius - (border ? BsBorders.width : 0)).clamp(
                0,
                double.infinity,
              ),
            );
      content = BsClipRRect(
        borderRadius: inner,
        child: hasPadding ? Padding(padding: padding, child: content) : content,
      );
    }
    Widget box = BsDecoratedContainer(
      decoration: decoration,
      padding: hasPadding && !(overflowHidden && content != null)
          ? padding
          : null,
      child: content,
    );

    if (inlineBlock) {
      box = _TextAligned(
        alignment: switch (DefaultTextStyle.of(context).textAlign) {
          TextAlign.center => AlignmentDirectional.topCenter,
          TextAlign.end => AlignmentDirectional.topEnd,
          TextAlign.right => Alignment.topRight,
          TextAlign.left => Alignment.topLeft,
          _ => AlignmentDirectional.topStart,
        },
        child: box,
      );
    }

    if (opacity != null && opacity != BsOpacity.o100) {
      box = Opacity(opacity: opacity!.value, child: box);
    }

    final height = h?.resolve(breakpoint)?.fraction;
    if (height != null) {
      final inner = box;
      box = LayoutBuilder(
        builder: (context, constraints) => constraints.hasBoundedHeight
            ? SizedBox(height: constraints.maxHeight * height, child: inner)
            : inner,
      );
    }

    final colWidth = col?.resolve(breakpoint);
    final width =
        (colWidth?.columns == null ? null : colWidth!.columns! / 12) ??
        w?.resolve(breakpoint)?.fraction;
    if (width != null) {
      box = FractionallySizedBox(
        widthFactor: width,
        alignment: AlignmentDirectional.topStart,
        child: box,
      );
    }

    // Margins (auto ones align the box within its parent).
    final mTop = pick([mt, my, m]);
    final mBottom = pick([mb, my, m]);
    final mStart = pick([ms, mx, m]);
    final mEnd = pick([me, mx, m]);
    final autoStart = mStart == BsSpacing.auto,
        autoEnd = mEnd == BsSpacing.auto;
    final margin = EdgeInsetsDirectional.only(
      top: px0(mTop),
      end: autoEnd ? 0 : px0(mEnd),
      bottom: px0(mBottom),
      start: autoStart ? 0 : px0(mStart),
    );
    if (margin != EdgeInsetsDirectional.zero) {
      box = Padding(padding: margin, child: box);
    }
    if (autoStart || autoEnd) {
      box = Align(
        alignment: autoStart && autoEnd
            ? AlignmentDirectional.topCenter
            : autoStart
            ? AlignmentDirectional.topEnd
            : AlignmentDirectional.topStart,
        heightFactor: 1,
        child: box,
      );
    }
    return box;
  }
}

/// Places inline [child] content at the start, center or end of a block that has a width to
/// place it in, and is as wide as the content otherwise.
///
/// A plain [Align] always fills the width it is allowed, which would make an end-aligned box
/// a flex item as wide as its whole line, instead of shrinking to its content, and so defeat
/// center justification.
class _TextAligned extends SingleChildRenderObjectWidget {
  const _TextAligned({required this.alignment, required super.child});

  final AlignmentGeometry alignment;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderTextAligned(
    alignment: alignment,
    textDirection: Directionality.of(context),
  );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTextAligned renderObject,
  ) {
    renderObject
      ..alignment = alignment
      ..textDirection = Directionality.of(context);
  }
}

class _RenderTextAligned extends RenderAligningShiftedBox {
  _RenderTextAligned({required super.alignment, required super.textDirection});

  Size _sizeFor(BoxConstraints constraints, Size childSize) =>
      constraints.constrain(
        Size(
          constraints.hasTightWidth ? constraints.maxWidth : childSize.width,
          childSize.height,
        ),
      );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) {
      return constraints.smallest;
    }
    return _sizeFor(constraints, child.getDryLayout(constraints.loosen()));
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(constraints.loosen(), parentUsesSize: true);
    size = _sizeFor(constraints, child.size);
    alignChild();
  }
}
