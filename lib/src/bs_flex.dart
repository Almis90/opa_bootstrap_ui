import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_breakpoint.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';

/// `justify-content-*`: where a [BsFlex]'s items sit along its main axis.
enum BsJustify implements BsResponsive<BsJustify> {
  start,
  end,
  center,
  between,
  around,
  evenly;

  /// The CSS class suffix used by Bootstrap, e.g. `between` in
  /// `justify-content-between`.
  String get className => name;

  @override
  BsJustify resolve(BsBreakpoint breakpoint) => this;
}

/// `align-items-*` / `align-self-*`: how an item sits on a [BsFlex] line's
/// cross axis. (`baseline` is not supported.)
enum BsAlign implements BsResponsive<BsAlign> {
  start,
  end,
  center,
  stretch;

  /// The CSS class suffix used by Bootstrap, e.g. `center` in
  /// `align-items-center`.
  String get className => name;

  @override
  BsAlign resolve(BsBreakpoint breakpoint) => this;
}

/// `flex-row`, `flex-row-reverse`, `flex-column`, `flex-column-reverse`: the
/// direction a [BsFlex] lays its items out in.
///
/// A column stacks the items vertically, stretching them to the container's
/// width unless `alignItems` says otherwise — which is also what Bootstrap's
/// `d-grid gap-2` (a one-column grid) looks like, so `d-grid d-sm-flex` is a
/// `flex-column flex-sm-row`.
enum BsFlexDirection implements BsResponsive<BsFlexDirection> {
  row,
  rowReverse,
  column,
  columnReverse;

  /// The CSS class suffix used by Bootstrap, e.g. `row-reverse` in
  /// `flex-row-reverse`.
  String get className => switch (this) {
    rowReverse => 'row-reverse',
    columnReverse => 'column-reverse',
    _ => name,
  };

  bool get isColumn => this == column || this == columnReverse;

  @override
  BsFlexDirection resolve(BsBreakpoint breakpoint) => this;
}

/// `.col-*`: a [BsFlexItem]'s width as a share of a 12-column row —
/// `BsCol(12)` is `col-12` (a full line), `BsCol(3)` is `col-3` (25%), and
/// [auto] is `col-auto` (the item's natural width).
///
/// Used on its own (outside a `.row`), as Bootstrap's header examples do: it
/// sets the item's width and doesn't let it shrink.
class BsCol implements BsResponsive<BsCol> {
  const BsCol(int columns)
    : columns = columns,
      fill = false,
      assert(columns >= 1 && columns <= 12);

  const BsCol._auto() : columns = null, fill = false;

  const BsCol._fill() : columns = null, fill = true;

  /// `col-auto`.
  static const BsCol auto = BsCol._auto();

  /// `col`: equal-width columns that share the line (`flex: 1 0 0%`).
  static const BsCol equal = BsCol._fill();

  /// Whether this is [equal].
  final bool fill;

  /// 1-12, or null for [auto].
  final int? columns;

  @override
  BsCol resolve(BsBreakpoint breakpoint) => this;
}

/// `w-25`/`w-50`/`w-75`/`w-100`/`w-auto`: a width as a share of the container's.
enum BsWidth implements BsResponsive<BsWidth> {
  w25(0.25),
  w50(0.5),
  w75(0.75),
  w100(1),
  auto(null);

  const BsWidth(this.fraction);

  /// The share of the container's width, or null for [auto].
  final double? fraction;

  @override
  BsWidth resolve(BsBreakpoint breakpoint) => this;
}

/// `d-flex`: a row of items laid out with CSS flexbox's rules — each item keeps
/// its natural width (or its [BsCol]/[BsWidth]), lines wrap if [wrap] is set,
/// and free space goes to auto margins, then to [justifyContent].
///
/// Children may be wrapped in a [BsFlexItem] for the item-level utilities
/// (`me-auto`, `col-12`, `mb-3`…); anything else is an item with none.
/// Responsive props (anything taking a [BsResponsive]) are resolved against the
/// *viewport's* breakpoint, as Bootstrap's media queries are.
///
/// ```dart
/// // <div class="d-flex flex-wrap align-items-center justify-content-center
/// //             justify-content-lg-start">
/// BsFlex(
///   wrap: true,
///   alignItems: BsAlign.center,
///   justifyContent: BsResponsiveValue(xs: BsJustify.center, lg: BsJustify.start),
///   children: [...],
/// )
/// ```
class BsFlex extends StatelessWidget {
  const BsFlex({
    super.key,
    required this.children,
    this.wrap = false,
    this.inline = false,
    this.justifyContent,
    this.alignItems,
    this.gap,
    this.direction,
  }) : _gutterX = 0,
       _gutterY = 0,
       _masonry = false,
       _rowCols = null,
       _row = false;

  /// A `.row`'s flex: items are `width: 100%` (unless a `col-*` says
  /// otherwise), padded by half the horizontal gutter on each side, and
  /// separated vertically by the vertical gutter.
  const BsFlex._row({
    required this.children,
    required double gutterX,
    required double gutterY,
    this.justifyContent,
    this.alignItems,
    this.direction,
    bool masonry = false,
    int? rowCols,
  }) : _gutterX = gutterX,
       _gutterY = gutterY,
       _masonry = masonry,
       _rowCols = rowCols,
       _row = true,
       wrap = true,
       inline = false,
       gap = null;

  final List<Widget> children;

  final double _gutterX;
  final double _gutterY;
  final bool _row;
  final bool _masonry;
  final int? _rowCols;

  /// `flex-wrap` (the default, `flex-nowrap`, shrinks items instead).
  final bool wrap;

  /// `d-inline-flex`: as wide as its content rather than filling its container
  /// (which `d-flex` does, unless it is itself a flex item).
  final bool inline;

  /// `justify-content-*`. Defaults to `start`.
  final BsResponsive<BsJustify>? justifyContent;

  /// `align-items-*`. Defaults to `stretch`, as in CSS.
  final BsResponsive<BsAlign>? alignItems;

  /// `gap-*`: the space between items, and between wrapped lines.
  final BsResponsive<BsSpacing>? gap;

  /// `flex-row`, `flex-column-reverse`…. Defaults to `row`.
  final BsResponsive<BsFlexDirection>? direction;

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    return _BsFlexRenderObjectWidget(
      wrap: wrap,
      inline: inline,
      justify: justifyContent?.resolve(breakpoint) ?? BsJustify.start,
      align: alignItems?.resolve(breakpoint) ?? BsAlign.stretch,
      gap: gap?.resolve(breakpoint)?.size ?? 0,
      direction: direction?.resolve(breakpoint) ?? BsFlexDirection.row,
      gutterX: _gutterX,
      gutterY: _gutterY,
      row: _row,
      masonry: _masonry,
      rowCols: _rowCols,
      breakpoint: breakpoint,
      textDirection: Directionality.of(context),
      children: children,
    );
  }
}

/// The item-level utilities of a [BsFlex] child: its margins (`m-*`, `me-*`,
/// `mb-*`…, including `auto`), width (`col-*`, `w-*`), and grow/shrink/align
/// behaviour.
///
/// Where margin props overlap the most specific wins, as in Bootstrap's CSS:
/// `mt` over `my` over `m`, and `ms`/`me` over `mx` over `m`.
class BsFlexItem extends ParentDataWidget<_BsFlexParentData> {
  const BsFlexItem({
    super.key,
    required super.child,
    this.col,
    this.offset,
    this.w,
    this.m,
    this.mx,
    this.my,
    this.mt,
    this.me,
    this.mb,
    this.ms,
    this.p,
    this.px,
    this.py,
    this.pt,
    this.pe,
    this.pb,
    this.ps,
    this.alignSelf,
    this.flexGrow = false,
    this.flexShrink,
    this.maxWidth,
  });

  /// `col-*`: width as a share of 12 columns; the item doesn't shrink.
  final BsResponsive<BsCol>? col;

  /// `offset-*`: a start margin of that many columns (`BsCol(1)` is
  /// `offset-1`, 8.33% of the line).
  final BsResponsive<BsCol>? offset;

  /// `w-*`: width as a share of the container's; the item may still shrink.
  final BsResponsive<BsWidth>? w;

  final BsResponsive<BsSpacing>? m;
  final BsResponsive<BsSpacing>? mx;
  final BsResponsive<BsSpacing>? my;
  final BsResponsive<BsSpacing>? mt;

  /// `me-*`: margin at the inline end (right in LTR).
  final BsResponsive<BsSpacing>? me;
  final BsResponsive<BsSpacing>? mb;

  /// `ms-*`: margin at the inline start (left in LTR).
  final BsResponsive<BsSpacing>? ms;

  /// The item's own padding (`p-3`, `pt-lg-3`…), laid out inside its box — and,
  /// in a [BsRow], replacing the gutter's padding on the sides it names, as the
  /// utilities' `!important` does.
  final BsResponsive<BsSpacing>? p;
  final BsResponsive<BsSpacing>? px;
  final BsResponsive<BsSpacing>? py;
  final BsResponsive<BsSpacing>? pt;
  final BsResponsive<BsSpacing>? pe;
  final BsResponsive<BsSpacing>? pb;
  final BsResponsive<BsSpacing>? ps;

  /// `align-self-*`.
  final BsResponsive<BsAlign>? alignSelf;

  /// A `max-width` in logical pixels (an inline style or custom CSS: Bootstrap
  /// has no utility for it, only the `mw-100` of 100%).
  final double? maxWidth;

  /// `flex-grow-1`: take a share of the line's free space.
  final bool flexGrow;

  /// `flex-shrink-0` (false) / `flex-shrink-1` (true). Null is CSS's default:
  /// shrinks, unless a [col] was given.
  final bool? flexShrink;

  @override
  void applyParentData(RenderObject renderObject) {
    final data = renderObject.parentData! as _BsFlexParentData;
    data
      ..col = col
      ..colOffset = offset
      ..w = w
      ..m = m
      ..mx = mx
      ..my = my
      ..mt = mt
      ..me = me
      ..mb = mb
      ..ms = ms
      ..p = p
      ..px = px
      ..py = py
      ..pt = pt
      ..pe = pe
      ..pb = pb
      ..ps = ps
      ..alignSelf = alignSelf
      ..flexGrow = flexGrow
      ..flexShrink = flexShrink
      ..maxWidth = maxWidth;
    renderObject.parent?.markNeedsLayout();
  }

  @override
  Type get debugTypicalAncestorWidgetClass => BsFlex;
}

class _BsFlexParentData extends ContainerBoxParentData<RenderBox> {
  BsResponsive<BsCol>? col;
  BsResponsive<BsCol>? colOffset;
  BsResponsive<BsWidth>? w;
  BsResponsive<BsSpacing>? m, mx, my, mt, me, mb, ms;
  BsResponsive<BsSpacing>? p, px, py, pt, pe, pb, ps;
  BsResponsive<BsAlign>? alignSelf;
  bool flexGrow = false;
  bool? flexShrink;
  double? maxWidth;
}

class _BsFlexRenderObjectWidget extends MultiChildRenderObjectWidget {
  const _BsFlexRenderObjectWidget({
    required super.children,
    required this.wrap,
    required this.inline,
    required this.justify,
    required this.align,
    required this.gap,
    required this.direction,
    required this.gutterX,
    required this.gutterY,
    required this.row,
    required this.masonry,
    required this.rowCols,
    required this.breakpoint,
    required this.textDirection,
  });

  final BsFlexDirection direction;
  final double gutterX;
  final double gutterY;
  final bool row;
  final bool masonry;
  final int? rowCols;
  final bool wrap;
  final bool inline;
  final BsJustify justify;
  final BsAlign align;
  final double gap;
  final BsBreakpoint breakpoint;
  final TextDirection textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderBsFlex(
    wrap: wrap,
    inline: inline,
    justify: justify,
    align: align,
    gap: gap,
    direction: direction,
    gutterX: gutterX,
    gutterY: gutterY,
    row: row,
    masonry: masonry,
    rowCols: rowCols,
    breakpoint: breakpoint,
    textDirection: textDirection,
  );

  @override
  void updateRenderObject(BuildContext context, _RenderBsFlex renderObject) {
    renderObject
      ..wrap = wrap
      ..inline = inline
      ..justify = justify
      ..align = align
      ..gap = gap
      ..direction = direction
      ..gutterX = gutterX
      ..gutterY = gutterY
      ..row = row
      ..masonry = masonry
      ..rowCols = rowCols
      ..breakpoint = breakpoint
      ..textDirection = textDirection;
  }
}

/// One child's resolved flex properties and, while laying out, its measurements.
class _Item {
  _Item(this.child);

  final RenderBox child;
  // Margins along the main axis are *logical* (start/end): layout runs in
  // reading order and mirrors the result for RTL at the end.
  double ms = 0, me = 0, mt = 0, mb = 0;
  // Padding, physical: the gutter's (or the item's own utilities') inset of
  // the child inside the item's box.
  double padL = 0, padR = 0, padT = 0, padB = 0;
  bool autoStart = false, autoEnd = false;
  double? fraction;
  double offsetFraction = 0;
  bool growEqual = false;
  double maxWidth = double.infinity;
  bool grow = false;
  bool shrink = true;
  BsAlign? alignSelf;

  double width = 0, height = 0;

  double get fixedMargins => ms + me;
  double get outerWidth => width + ms + me;
}

class _Line {
  final items = <_Item>[];
  double crossSize = 0;
  double crossOffset = 0;
}

// The private fields can't be named constructor parameters (names starting with
// an underscore), so they're initialised from differently-named ones.
// ignore_for_file: prefer_initializing_formals
class _RenderBsFlex extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _BsFlexParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _BsFlexParentData> {
  _RenderBsFlex({
    required bool wrap,
    required bool inline,
    required BsJustify justify,
    required BsAlign align,
    required double gap,
    required BsFlexDirection direction,
    required double gutterX,
    required double gutterY,
    required bool row,
    required bool masonry,
    required int? rowCols,
    required BsBreakpoint breakpoint,
    required TextDirection textDirection,
  }) : _direction = direction,
       _masonry = masonry,
       _rowCols = rowCols,
       _gutterX = gutterX,
       _gutterY = gutterY,
       _row = row,
       _wrap = wrap,
       _inline = inline,
       _justify = justify,
       _align = align,
       _gap = gap,
       _breakpoint = breakpoint,
       _textDirection = textDirection;

  BsFlexDirection _direction;
  set direction(BsFlexDirection v) {
    if (v == _direction) {
      return;
    }
    _direction = v;
    markNeedsLayout();
  }

  double _gutterX;
  set gutterX(double v) {
    if (v == _gutterX) {
      return;
    }
    _gutterX = v;
    markNeedsLayout();
  }

  double _gutterY;
  set gutterY(double v) {
    if (v == _gutterY) {
      return;
    }
    _gutterY = v;
    markNeedsLayout();
  }

  int? _rowCols;
  set rowCols(int? v) {
    if (v == _rowCols) {
      return;
    }
    _rowCols = v;
    markNeedsLayout();
  }

  bool _masonry;
  set masonry(bool v) {
    if (v == _masonry) {
      return;
    }
    _masonry = v;
    markNeedsLayout();
  }

  bool _row;
  set row(bool v) {
    if (v == _row) {
      return;
    }
    _row = v;
    markNeedsLayout();
  }

  bool _inline;
  set inline(bool v) {
    if (v == _inline) {
      return;
    }
    _inline = v;
    markNeedsLayout();
  }

  bool _wrap;
  bool get wrap => _wrap;
  set wrap(bool v) {
    if (v == _wrap) {
      return;
    }
    _wrap = v;
    markNeedsLayout();
  }

  BsJustify _justify;
  set justify(BsJustify v) {
    if (v == _justify) {
      return;
    }
    _justify = v;
    markNeedsLayout();
  }

  BsAlign _align;
  set align(BsAlign v) {
    if (v == _align) {
      return;
    }
    _align = v;
    markNeedsLayout();
  }

  double _gap;
  set gap(double v) {
    if (v == _gap) {
      return;
    }
    _gap = v;
    markNeedsLayout();
  }

  BsBreakpoint _breakpoint;
  set breakpoint(BsBreakpoint v) {
    if (v == _breakpoint) {
      return;
    }
    _breakpoint = v;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection v) {
    if (v == _textDirection) {
      return;
    }
    _textDirection = v;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _BsFlexParentData) {
      child.parentData = _BsFlexParentData();
    }
  }

  // ---------------------------------------------------------------- resolve

  List<_Item> _resolveItems([double lineWidth = 0]) {
    final items = <_Item>[];
    final reversed = _direction == BsFlexDirection.rowReverse;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final d = child.parentData! as _BsFlexParentData;
      final item = _Item(child);

      BsSpacing? pick(List<BsResponsive<BsSpacing>?> candidates) {
        for (final c in candidates) {
          final v = c?.resolve(_breakpoint);
          if (v != null) return v;
        }
        return null;
      }

      final top = pick([d.mt, d.my, d.m]);
      final bottom = pick([d.mb, d.my, d.m]);
      final start = pick([d.ms, d.mx, d.m]);
      final end = pick([d.me, d.mx, d.m]);
      item.mt = top?.size ?? 0;
      item.mb = bottom?.size ?? 0;
      final startAuto = start == BsSpacing.auto,
          endAuto = end == BsSpacing.auto;
      final startPx = start?.size ?? 0, endPx = end?.size ?? 0;
      item.ms = startPx;
      item.me = endPx;
      item.autoStart = startAuto;
      item.autoEnd = endAuto;

      final col = d.col?.resolve(_breakpoint);
      final w = d.w?.resolve(_breakpoint);
      if (col != null && col.fill) {
        // `.col`: `flex: 1 0 0%`.
        item.fraction = 0;
        item.shrink = false;
        item.growEqual = true;
      } else if (col != null && col.columns != null) {
        item.fraction = col.columns! / 12;
        item.shrink = d.flexShrink ?? false;
      } else if (_row && _rowCols != null && col == null && w == null) {
        // `.row-cols-*`: each child is 1/n of the line.
        item.fraction = 1 / _rowCols!;
        item.shrink = d.flexShrink ?? false;
      } else if (_row && col == null && w == null) {
        // `.row > *`: width 100% and no shrinking, unless a col-* says otherwise.
        item.fraction = 1;
        item.shrink = d.flexShrink ?? false;
      } else {
        item.fraction = w?.fraction;
        item.shrink = d.flexShrink ?? (col == null);
      }
      item.grow = d.flexGrow || item.growEqual;
      item.maxWidth = d.maxWidth ?? double.infinity;
      item.alignSelf = d.alignSelf?.resolve(_breakpoint);
      item.mt += _gutterY;
      // `.row > *` pads by half the gutter; p-* utilities override that.
      final padStart = pick([d.ps, d.px, d.p])?.size ?? _gutterX / 2;
      final padEnd = pick([d.pe, d.px, d.p])?.size ?? _gutterX / 2;
      final rtl = _textDirection == TextDirection.rtl;
      item.padL = rtl ? padEnd : padStart;
      item.padR = rtl ? padStart : padEnd;
      item.padT = pick([d.pt, d.py, d.p])?.size ?? 0;
      item.padB = pick([d.pb, d.py, d.p])?.size ?? 0;
      final offsetColumns = d.colOffset?.resolve(_breakpoint)?.columns;
      if (offsetColumns != null) {
        item.ms += offsetColumns / 12 * lineWidth;
      }
      if (reversed) {
        // The line flows from the end: what is the start margin of the
        // reading direction is the *end* one of the flow.
        final ms = item.ms, autoStart = item.autoStart;
        item.ms = item.me;
        item.autoStart = item.autoEnd;
        item.me = ms;
        item.autoEnd = autoStart;
      }
      items.add(item);
    }
    return items;
  }

  bool _isFlexItem() {
    RenderObject? p = parent;
    while (p is RenderProxyBox) {
      p = p.parent;
    }
    return p is _RenderBsFlex;
  }

  // ----------------------------------------------------------------- layout

  /// The size of [item]'s box — its child plus the item's padding.
  Size _measure(_Item item, BoxConstraints c, bool dry) {
    final padX = item.padL + item.padR, padY = item.padT + item.padB;
    final inner = padX == 0 && padY == 0
        ? c
        : BoxConstraints(
            minWidth: math.max(0.0, c.minWidth - padX),
            maxWidth: math.max(0.0, c.maxWidth - padX),
            minHeight: math.max(0.0, c.minHeight - padY),
            maxHeight: math.max(0.0, c.maxHeight - padY),
          );
    Size size;
    if (dry) {
      size = item.child.getDryLayout(inner);
    } else {
      item.child.layout(inner, parentUsesSize: true);
      size = item.child.size;
    }
    return Size(size.width + padX, size.height + padY);
  }

  /// Lays the items out with flexbox's rules. With [dry] no child is laid out
  /// for real and nothing is positioned; otherwise each child gets its offset.
  Size _computeLayout(BoxConstraints constraints, {required bool dry}) {
    if (_masonry) {
      return _computeMasonry(constraints, dry: dry);
    }
    if (_direction.isColumn) {
      return _computeColumn(constraints, dry: dry);
    }
    final items = _resolveItems(
      constraints.hasBoundedWidth ? constraints.maxWidth : 0,
    );
    if (items.isEmpty) {
      return constraints.constrain(
        Size(constraints.hasBoundedWidth ? constraints.maxWidth : 0, 0),
      );
    }

    final bounded = constraints.hasBoundedWidth;
    final maxW = constraints.maxWidth;

    // 1. Flex basis and natural height of every item.
    for (final item in items) {
      Size size;
      if (item.fraction != null && bounded) {
        final basis = math.max(0.0, maxW * item.fraction!);
        size = _measure(item, BoxConstraints.tightFor(width: basis), dry);
      } else {
        final room = bounded
            ? math.max(0.0, maxW - item.fixedMargins)
            : double.infinity;
        size = _measure(item, BoxConstraints(maxWidth: room), dry);
      }
      item.width = size.width;
      item.height = size.height;
    }

    // 2. Break into lines.
    final lines = <_Line>[_Line()];
    var lineMain = 0.0;
    for (final item in items) {
      final line = lines.last;
      final gapBefore = line.items.isEmpty ? 0.0 : _gap;
      if (_wrap &&
          bounded &&
          line.items.isNotEmpty &&
          lineMain + gapBefore + item.outerWidth > maxW + 0.01) {
        lines.add(_Line());
        lineMain = 0;
      }
      final target = lines.last;
      lineMain += (target.items.isEmpty ? 0.0 : _gap) + item.outerWidth;
      target.items.add(item);
    }

    // 3. Main axis: shrink, auto margins / grow, justify.
    final xs = <_Item, double>{};
    var contentWidth = 0.0;
    for (final line in lines) {
      final n = line.items.length;
      double used() =>
          line.items.fold<double>(0, (s, i) => s + i.outerWidth) +
          _gap * (n - 1);

      if (bounded && used() > maxW + 0.01) {
        // flex-shrink: take the overflow from the shrinkable items, in
        // proportion to their widths — but never below an item's content
        // (`min-width: auto`: its min-content width), freezing the items that
        // hit that and sharing what is left among the rest.
        // (Only for content that can wrap, whose min-content is less than its
        // width: a fixed-size box has no content to protect, and a `text-nowrap`
        // item says so with `flexShrink: false`.)
        final floors = <_Item, double>{
          for (final item in line.items)
            if (item.shrink)
              item: () {
                final min =
                    item.child.getMinIntrinsicWidth(double.infinity) +
                    item.padL +
                    item.padR;
                return min < item.width - 0.01 ? min : 0.0;
              }(),
        };
        final active = line.items.where((i) => i.shrink).toList();
        final targets = <_Item, double>{};
        var overflow = used() - maxW;
        while (active.isNotEmpty && overflow > 0.01) {
          final basisSum = active.fold<double>(0, (s, i) => s + i.width);
          if (basisSum <= 0) break;
          var frozen = false;
          for (final item in List<_Item>.of(active)) {
            final target = item.width - overflow * item.width / basisSum;
            if (target < floors[item]!) {
              targets[item] = floors[item]!;
              overflow -= item.width - floors[item]!;
              active.remove(item);
              frozen = true;
              break;
            }
          }
          if (!frozen) {
            for (final item in active) {
              targets[item] = item.width - overflow * item.width / basisSum;
            }
            break;
          }
        }
        for (final entry in targets.entries) {
          final item = entry.key;
          final target = math.max(0.0, entry.value);
          if ((target - item.width).abs() > 0.01) {
            final size = _measure(
              item,
              BoxConstraints.tightFor(width: target),
              dry,
            );
            item.width = size.width;
            item.height = size.height;
          }
        }
      }

      // max-width clamps what the items came to.
      for (final item in line.items) {
        if (item.width > item.maxWidth + 0.01) {
          final size = _measure(
            item,
            BoxConstraints.tightFor(width: item.maxWidth),
            dry,
          );
          item.width = size.width;
          item.height = size.height;
        }
      }

      var free = bounded ? math.max(0.0, maxW - used()) : 0.0;
      var autoCount = 0;
      for (final item in line.items) {
        autoCount += (item.autoStart ? 1 : 0) + (item.autoEnd ? 1 : 0);
      }
      var lead = 0.0, between = _gap;
      if (autoCount > 0 && free > 0) {
        final share = free / autoCount;
        for (final item in line.items) {
          if (item.autoStart) item.ms += share;
          if (item.autoEnd) item.me += share;
        }
        free = 0;
      } else if (free > 0 && line.items.any((i) => i.grow)) {
        final growers = line.items.where((i) => i.grow).toList();
        final share = free / growers.length;
        for (final item in growers) {
          final size = _measure(
            item,
            BoxConstraints.tightFor(width: item.width + share),
            dry,
          );
          item.width = size.width;
          item.height = size.height;
        }
        free = 0;
      } else if (free > 0) {
        switch (_justify) {
          case BsJustify.start:
            break;
          case BsJustify.end:
            lead = free;
          case BsJustify.center:
            lead = free / 2;
          case BsJustify.between:
            if (n > 1) between = _gap + free / (n - 1);
          case BsJustify.around:
            between = _gap + free / n;
            lead = free / n / 2;
          case BsJustify.evenly:
            between = _gap + free / (n + 1);
            lead = free / (n + 1);
        }
      }

      var x = lead;
      for (final item in line.items) {
        xs[item] = x;
        x += item.outerWidth + between;
      }
      contentWidth = math.max(contentWidth, x - between);
    }

    // 4. Cross axis: line heights, stretching, alignment.
    var y = 0.0;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      line.crossSize = line.items.fold<double>(
        0,
        (s, it) => math.max(s, it.height + it.mt + it.mb),
      );
      line.crossOffset = y;
      y += line.crossSize + (i == lines.length - 1 ? 0 : _gap);
    }
    // A `d-flex` in normal flow fills its container, but as a flex item itself
    // (`<a class="d-flex">` inside a `d-flex` header) its width is the
    // content's — so a BsFlex nested in another (through any transparent
    // wrappers such as a link) shrink-wraps.
    final width = bounded && !_inline && !_isFlexItem()
        ? maxW
        : math.min(contentWidth, maxW);
    final size = constraints.constrain(Size(width, y));
    // `align-content: normal` (stretch): a container given more height than its
    // lines need — e.g. a flex item stretched by its own parent — shares the
    // extra among them, which for the usual single line makes the line as tall
    // as the container, so `align-items: center` centres in it.
    final extra = size.height - y;
    if (extra > 0.01) {
      final share = extra / lines.length;
      for (var i = 0; i < lines.length; i++) {
        lines[i].crossSize += share;
        lines[i].crossOffset += share * i;
      }
    }

    for (final line in lines) {
      for (final item in line.items) {
        final align = item.alignSelf ?? _align;
        var top = line.crossOffset + item.mt;
        if (align == BsAlign.stretch) {
          final target = line.crossSize - item.mt - item.mb;
          if ((target - item.height).abs() > 0.01) {
            final s = _measure(
              item,
              BoxConstraints.tightFor(width: item.width, height: target),
              dry,
            );
            item.height = s.height;
          }
        } else if (align == BsAlign.center) {
          top += (line.crossSize - item.mt - item.mb - item.height) / 2;
        } else if (align == BsAlign.end) {
          top += line.crossSize - item.mt - item.mb - item.height;
        }
        if (!dry) {
          final logicalLeft = xs[item]! + item.ms;
          final mirror =
              (_textDirection == TextDirection.rtl) !=
              (_direction == BsFlexDirection.rowReverse);
          final left = mirror ? width - logicalLeft - item.width : logicalLeft;
          (item.child.parentData! as _BsFlexParentData).offset = Offset(
            left + item.padL,
            top + item.padT,
          );
        }
      }
    }
    return size;
  }

  /// Masonry's layout (`data-masonry='{"percentPosition": true}'` on a `.row`):
  /// the first item's width is the column width, the row holds as many such
  /// columns as fit, and each item goes — in order — into the column (or
  /// run of columns) whose bottom is highest.
  Size _computeMasonry(BoxConstraints constraints, {required bool dry}) {
    final bounded = constraints.hasBoundedWidth;
    final maxW = bounded ? constraints.maxWidth : 0.0;
    final items = _resolveItems(maxW);
    if (items.isEmpty) {
      return constraints.constrain(Size(maxW, 0));
    }
    for (final item in items) {
      final basis = (item.fraction ?? 1) * maxW;
      final size = _measure(item, BoxConstraints.tightFor(width: basis), dry);
      item.width = size.width;
      item.height = size.height;
    }
    final columnWidth = items.first.outerWidth;
    var columns = columnWidth > 0 ? maxW / columnWidth : 1.0;
    // Masonry rounds instead of flooring when the last column is nearly whole.
    final excess = columnWidth - maxW % columnWidth;
    columns = (excess > 0 && excess < 1
        ? columns.roundToDouble()
        : columns.floorToDouble());
    final count = math.max(1, columns.toInt());
    final colY = List<double>.filled(count, 0);
    for (final item in items) {
      final span = math.min(
        count,
        math.max(1, (item.outerWidth / columnWidth - 0.01).ceil()),
      );
      var bestCol = 0;
      var bestY = double.infinity;
      for (var c = 0; c <= count - span; c++) {
        var top = 0.0;
        for (var k = c; k < c + span; k++) {
          top = math.max(top, colY[k]);
        }
        if (top < bestY - 0.0001) {
          bestY = top;
          bestCol = c;
        }
      }
      final outerHeight = item.mt + item.height + item.mb;
      for (var k = bestCol; k < bestCol + span; k++) {
        colY[k] = bestY + outerHeight;
      }
      if (!dry) {
        final logicalLeft = bestCol * columnWidth + item.ms;
        final left = _textDirection == TextDirection.rtl
            ? maxW - logicalLeft - item.width
            : logicalLeft;
        (item.child.parentData! as _BsFlexParentData).offset = Offset(
          left + item.padL,
          bestY + item.mt + item.padT,
        );
      }
    }
    return constraints.constrain(Size(maxW, colY.reduce(math.max)));
  }

  /// `flex-column` (and a `d-grid`'s single column): items stacked
  /// vertically, stretched to the container's width unless aligned otherwise.
  Size _computeColumn(BoxConstraints constraints, {required bool dry}) {
    final bounded = constraints.hasBoundedWidth;
    final maxW = constraints.maxWidth;
    var items = _resolveItems(bounded ? maxW : 0);
    if (_direction == BsFlexDirection.columnReverse) {
      items = items.reversed.toList();
    }
    final fillsWidth = bounded && !_inline && !_isFlexItem();
    if (items.isEmpty) {
      return constraints.constrain(Size(fillsWidth ? maxW : 0, 0));
    }

    var y = 0.0, contentWidth = 0.0;
    final ys = <_Item, double>{};
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final align = item.alignSelf ?? _align;
      final margins = item.fixedMargins;
      final room = bounded ? math.max(0.0, maxW - margins) : double.infinity;
      final c = item.fraction != null && bounded
          ? BoxConstraints.tightFor(
              width: math.min(
                item.maxWidth,
                math.max(0.0, maxW * item.fraction!),
              ),
            )
          : align == BsAlign.stretch &&
                bounded &&
                !item.autoStart &&
                !item.autoEnd
          ? BoxConstraints.tightFor(width: room)
          : BoxConstraints(maxWidth: room);
      final size = _measure(item, c, dry);
      item.width = size.width;
      item.height = size.height;
      y += i == 0 ? 0 : _gap;
      ys[item] = y + item.mt;
      y += item.mt + item.height + item.mb;
      contentWidth = math.max(contentWidth, item.outerWidth);
    }

    final width = fillsWidth ? maxW : math.min(contentWidth, maxW);
    final size = constraints.constrain(Size(width, y));
    if (!dry) {
      for (final item in items) {
        final align = item.alignSelf ?? _align;
        // (An item wider than the container still centres: its overflow is
        // shared by both sides, as in CSS's default `unsafe` alignment.)
        final free = size.width - item.outerWidth;
        var x = item.ms;
        if (item.autoStart && item.autoEnd) {
          x += math.max(0.0, free) / 2;
        } else if (item.autoStart) {
          x += math.max(0.0, free);
        } else if (!item.autoEnd) {
          if (align == BsAlign.center) {
            x += free / 2;
          } else if (align == BsAlign.end) {
            x += free;
          }
        }
        final left = _textDirection == TextDirection.rtl
            ? size.width - x - item.width
            : x;
        (item.child.parentData! as _BsFlexParentData).offset = Offset(
          left + item.padL,
          ys[item]! + item.padT,
        );
      }
    }
    return size;
  }

  @override
  void performLayout() {
    size = _computeLayout(constraints, dry: false);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _computeLayout(constraints, dry: true);

  // ------------------------------------------------------------ intrinsics

  double _marginsOf(RenderBox child) {
    final items = _resolveItems();
    final item = items.firstWhere((i) => i.child == child);
    return item.fixedMargins + item.padL + item.padR;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var total = 0.0, widest = 0.0, count = 0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final w = child.getMaxIntrinsicWidth(double.infinity) + _marginsOf(child);
      total += w;
      widest = math.max(widest, w);
      count++;
    }
    return _direction.isColumn ? widest : total + _gap * math.max(0, count - 1);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (_wrap || _direction.isColumn) {
      var widest = 0.0;
      for (var child = firstChild; child != null; child = childAfter(child)) {
        widest = math.max(
          widest,
          child.getMinIntrinsicWidth(double.infinity) + _marginsOf(child),
        );
      }
      return widest;
    }
    var total = 0.0, count = 0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      total += child.getMinIntrinsicWidth(double.infinity) + _marginsOf(child);
      count++;
    }
    return total + _gap * math.max(0, count - 1);
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      getDryLayout(BoxConstraints(maxWidth: width)).height;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      getDryLayout(BoxConstraints(maxWidth: width)).height;

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToHighestActualBaseline(baseline);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

/// `.row` (with its `g-*`/`gx-*`/`gy-*` gutters) — a wrapping [BsFlex] whose
/// items are `col-*` wide ([BsFlexItem.col]), padded by half the horizontal
/// gutter on each side, and spaced by the vertical one. The row itself is
/// pulled out by half the gutter on both sides (`margin-inline: -½gutter`), so
/// the first and last columns' content lines up with the row's parent.
///
/// An item with no `col` is `width: 100%`, as in `.row > *`. The row's own
/// element can carry utilities too ([p], [border], [rounded], [shadow]…).
///
/// ```dart
/// // <div class="row flex-lg-row-reverse align-items-center g-5 py-5">
/// BsRow(
///   direction: BsFlexDirection.rowReverse (from lg),
///   alignItems: BsAlign.center,
///   g: BsSpacing.s5,
///   py: BsSpacing.s5,
///   children: [BsFlexItem(col: ..., child: ...), ...],
/// )
/// ```
class BsRow extends StatelessWidget {
  const BsRow({
    super.key,
    required this.children,
    this.g,
    this.gx,
    this.gy,
    this.alignItems,
    this.justifyContent,
    this.direction,
    this.p,
    this.px,
    this.py,
    this.pt,
    this.pe,
    this.pb,
    this.ps,
    this.border = false,
    this.rounded,
    this.shadow,
    this.masonry = false,
    this.rowCols,
  });

  final List<Widget> children;

  /// `row-cols-*`: how many equal columns each child takes a share of (`row-cols-1
  /// row-cols-md-3` is `BsResponsiveValue(xs: 1, md: 3)`).
  final BsResponsive<int>? rowCols;

  /// `data-masonry='{"percentPosition": true}'`: the columns are packed the
  /// way the Masonry plugin does — each item into the shortest column — instead
  /// of in lines.
  final bool masonry;

  /// `g-*`: both gutters. The default is `$grid-gutter-width` (`g-4`, 1.5rem)
  /// horizontally and none vertically.
  final BsResponsive<BsSpacing>? g;

  /// `gx-*` (wins over [g]).
  final BsResponsive<BsSpacing>? gx;

  /// `gy-*` (wins over [g]).
  final BsResponsive<BsSpacing>? gy;

  /// `align-items-*`.
  final BsResponsive<BsAlign>? alignItems;

  /// `justify-content-*`.
  final BsResponsive<BsJustify>? justifyContent;

  /// `flex-row-reverse`, `flex-lg-column`….
  final BsResponsive<BsFlexDirection>? direction;

  final BsResponsive<BsSpacing>? p;
  final BsResponsive<BsSpacing>? px;
  final BsResponsive<BsSpacing>? py;
  final BsResponsive<BsSpacing>? pt;
  final BsResponsive<BsSpacing>? pe;
  final BsResponsive<BsSpacing>? pb;
  final BsResponsive<BsSpacing>? ps;

  /// `border`.
  final bool border;

  /// `rounded-*`.
  final BsRounded? rounded;

  /// `shadow-*`.
  final BsShadow? shadow;

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final x =
        (gx ?? g)?.resolve(breakpoint)?.size ??
        BsSpacing.s4.size; // --bs-gutter-x: 1.5rem
    final y = (gy ?? g)?.resolve(breakpoint)?.size ?? 0.0;
    return _RowMargin(
      gutterX: x,
      gutterY: y,
      child: BsBox(
        p: p,
        px: px,
        py: py,
        pt: pt,
        pe: pe,
        pb: pb,
        ps: ps,
        border: border,
        rounded: rounded,
        shadow: shadow,
        child: BsFlex._row(
          gutterX: x,
          gutterY: y,
          justifyContent: justifyContent,
          alignItems: alignItems,
          direction: direction,
          masonry: masonry,
          rowCols: rowCols?.resolve(breakpoint),
          children: children,
        ),
      ),
    );
  }
}

/// `margin: calc(-1 * var(--bs-gutter-y)) calc(-.5 * var(--bs-gutter-x)) 0`.
class _RowMargin extends SingleChildRenderObjectWidget {
  const _RowMargin({
    required this.gutterX,
    required this.gutterY,
    required super.child,
  });

  final double gutterX;
  final double gutterY;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderRowMargin(gutterX, gutterY);

  @override
  void updateRenderObject(BuildContext context, _RenderRowMargin renderObject) {
    renderObject
      ..gutterX = gutterX
      ..gutterY = gutterY;
  }
}

class _RenderRowMargin extends RenderShiftedBox {
  _RenderRowMargin(this._gutterX, this._gutterY) : super(null);

  double _gutterX;
  set gutterX(double v) {
    if (v != _gutterX) {
      _gutterX = v;
      markNeedsLayout();
    }
  }

  double _gutterY;
  set gutterY(double v) {
    if (v != _gutterY) {
      _gutterY = v;
      markNeedsLayout();
    }
  }

  BoxConstraints _childConstraints(BoxConstraints c) => c.hasBoundedWidth
      ? c.copyWith(
          minWidth: c.minWidth + _gutterX,
          maxWidth: c.maxWidth + _gutterX,
          minHeight: 0,
        )
      : c.copyWith(minHeight: 0);

  Size _sizeFor(BoxConstraints c, Size childSize) => c.constrain(
    Size(
      c.hasBoundedWidth ? childSize.width - _gutterX : childSize.width,
      math.max(0.0, childSize.height - _gutterY),
    ),
  );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) {
      return constraints.smallest;
    }
    return _sizeFor(
      constraints,
      child.getDryLayout(_childConstraints(constraints)),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_childConstraints(constraints), parentUsesSize: true);
    size = _sizeFor(constraints, child.size);
    (child.parentData! as BoxParentData).offset = Offset(
      constraints.hasBoundedWidth ? -_gutterX / 2 : 0,
      -_gutterY,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      getDryLayout(BoxConstraints(maxWidth: width)).height;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      getDryLayout(BoxConstraints(maxWidth: width)).height;
}
