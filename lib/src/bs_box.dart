import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'bs_color_utils.dart';
import 'bs_colors.dart';
import 'bs_flex.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';
import 'bs_variant.dart';
import 'tokens/bs_body.dart';
import 'tokens/bs_borders.dart';

/// `fs-1`…`fs-6`: Bootstrap's responsive font sizes. Below the `xl` breakpoint
/// the larger ones scale with the viewport (`calc(1.375rem + 1.5vw)` for
/// `fs-1`…), from `xl` up they are fixed; [sizeFor] resolves either.
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

  /// The CSS class suffix used by Bootstrap, e.g. `4` in `fs-4`.
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

/// `text-*`: Bootstrap's text color utilities.
enum BsTextColor {
  /// `text-primary`.
  primary,

  /// `text-secondary`: `--bs-secondary`, `#6c757d` in both themes.
  secondary,
  success,
  info,
  warning,
  danger,
  light,
  dark,

  /// `text-white`.
  white,

  /// `text-black`.
  black,

  /// `text-body`.
  body,

  /// `text-body-secondary`.
  bodySecondary,

  /// `text-body-tertiary`.
  bodyTertiary,

  /// `text-body-emphasis` (also what `link-body-emphasis` uses).
  bodyEmphasis;

  /// The CSS class suffix used by Bootstrap, e.g. `body-secondary` in
  /// `text-body-secondary`.
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

/// `bg-*`: Bootstrap's background utilities.
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

  /// `bg-body`.
  body,

  /// `bg-body-secondary`.
  bodySecondary,

  /// `bg-body-tertiary`.
  bodyTertiary,
  transparent;

  /// The CSS class suffix used by Bootstrap, e.g. `body-tertiary` in
  /// `bg-body-tertiary`.
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

/// `rounded-0`…`rounded-5`, `rounded-circle`, `rounded-pill`: Bootstrap's
/// border-radius utilities.
enum BsRounded {
  /// `rounded-0`.
  r0(0),

  /// `rounded-1` (`$border-radius-sm`, `.25rem`).
  r1(4),

  /// `rounded-2` (`$border-radius`, `.375rem`).
  r2(6),

  /// `rounded-3` (`$border-radius-lg`, `.5rem`).
  r3(8),

  /// `rounded-4` (`$border-radius-xl`, `1rem`).
  r4(16),

  /// `rounded-5` (`$border-radius-xxl`, `2rem`).
  r5(32),

  /// `rounded-circle`: fully rounded (a circle on a square box).
  circle(9999),

  /// `rounded-pill` (`$border-radius-pill`, `50rem`).
  pill(800);

  const BsRounded(this.radius);

  /// The corner radius in logical pixels.
  final double radius;

  /// The CSS class suffix used by Bootstrap, e.g. `3` in `rounded-3`.
  String get className =>
      this == circle || this == pill ? name : name.substring(1);
}

/// `text-start`/`text-center`/`text-end`.
enum BsTextAlign implements BsResponsive<BsTextAlign> {
  start,
  center,
  end;

  /// The CSS class suffix used by Bootstrap, e.g. `end` in `text-end`.
  String get className => name;

  @override
  BsTextAlign resolve(BsBreakpoint breakpoint) => this;
}

/// A block element with Bootstrap's utility classes on it — the `<div
/// class="py-3 mb-4 border-bottom text-bg-dark">` of a Bootstrap page.
///
/// Prop names are the classes' own: spacing is `m`/`p` with `x`/`y`/`t`/`e`/
/// `b`/`s` (`mx`, `pb`, `ms`…, the `e`nd and `s`tart being logical), borders
/// `border`/`borderTop`/`borderEnd`/`borderBottom`/`borderStart`, then [bg],
/// [textBg], [textColor], [fs], [textAlign] and [w]. Spacing, [fs], [textAlign]
/// and [w] take a [BsResponsive] — a plain value, or a [BsResponsiveValue]
/// for `mb-3 mb-md-0` — resolved against the viewport's breakpoint.
///
/// Where spacing props overlap the most specific wins, as in the CSS: `pt`
/// over `py` over `p` (and `ps`/`pe` over `px` over `p`), likewise for margins.
/// A margin of [BsSpacing.auto] on the inline axis centres (`mx-auto`) or
/// aligns the box to one side (`ms-auto`, `me-auto`) within its parent.
///
/// Margins and padding sum rather than collapse. For the margins of a child of
/// a [BsFlex], use [BsFlexItem] instead.
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
    this.bg,
    this.rounded,
    this.textBg,
    this.textColor,
    this.fs,
    this.textAlign,
    this.w,
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

  /// `border-top`.
  final bool borderTop;

  /// `border-end`.
  final bool borderEnd;

  /// `border-bottom`.
  final bool borderBottom;

  /// `border-start`.
  final bool borderStart;

  /// `bg-*`.
  final BsBg? bg;

  /// `rounded-*`.
  final BsRounded? rounded;

  /// `text-bg-*`: the variant's background with a contrasting text color.
  final BsVariant? textBg;

  /// `text-*`.
  final BsTextColor? textColor;

  /// `fs-*`.
  final BsResponsive<BsFs>? fs;

  /// `text-start`/`text-center`/`text-end`.
  final BsResponsive<BsTextAlign>? textAlign;

  /// `w-25`…`w-100`.
  final BsResponsive<BsWidth>? w;

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
        (color != null || fontSize != null || align != null)) {
      content = DefaultTextStyle.merge(
        style: TextStyle(color: color, fontSize: fontSize),
        textAlign: switch (align) {
          BsTextAlign.start => TextAlign.start,
          BsTextAlign.center => TextAlign.center,
          BsTextAlign.end => TextAlign.end,
          null => null,
        },
        child: content,
      );
      if (align != null) {
        // Inline content follows text-align too, not just text.
        content = Align(
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
            borderStart)
        ? BoxDecoration(
            color: bg?.of(context) ?? textBg?.color,
            borderRadius: rounded == null
                ? null
                : BorderRadius.circular(rounded!.radius),
            border:
                (border ||
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
    Widget box = Container(
      decoration: decoration,
      padding: padding == EdgeInsetsDirectional.zero ? null : padding,
      child: content,
    );

    final width = w?.resolve(breakpoint)?.fraction;
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
