import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_spacing.dart';
import 'bs_theme.dart';
import 'bs_variant.dart';
import 'tokens/bs_body.dart';
import 'tokens/bs_list_group_style.dart';
import 'bs_decorated_box.dart';

/// Which way a [BsListGroup] stacks its items.
enum BsListGroupOrientation {
  /// Items stack top to bottom (the default).
  vertical,

  /// Items sit side by side.
  horizontal,
}

/// A single row in a [BsListGroup].
class BsListGroupItem {
  const BsListGroupItem({
    required this.child,
    this.onTap,
    this.active = false,
    this.disabled = false,
    this.variant,
    this.py,
    this.bg,
  });

  final Widget child;

  /// Called when tapped. Adds hover and press styling; leave null for a plain,
  /// non-interactive row.
  final VoidCallback? onTap;

  /// Highlights this item as the current selection.
  final bool active;

  /// Dims the item and ignores taps.
  final bool disabled;

  /// Tints the item with a contextual color, via the same [BsVariant.bgSubtle] and
  /// [BsVariant.textEmphasis] recipe [BsAlert] uses.
  final BsVariant? variant;

  /// `py-*`: vertical padding in place of the group's.
  final BsSpacing? py;

  /// `bg-*` on the item (`bg-body-tertiary`), in place of the group's.
  final BsBg? bg;
}

/// A Bootstrap list group: a series of [items] rendered as one bordered block with a shared
/// border between rows and only the group's outer corners rounded, the same seam technique
/// [BsCardGroup] uses for adjoining cards.
class BsListGroup extends StatelessWidget {
  const BsListGroup({
    super.key,
    required this.items,
    this.orientation = BsListGroupOrientation.vertical,
    this.flush = false,
    this.numbered = false,
    this.style,
  });

  /// The rows to render, in order.
  final List<BsListGroupItem> items;

  /// Whether items stack vertically or sit side by side.
  final BsListGroupOrientation orientation;

  /// Removes the outer border and corner rounding, leaving only the dividers between items,
  /// for embedding edge to edge in a container like [BsCard].
  final bool flush;

  /// Prefixes each item with its 1-based position.
  final bool numbered;

  /// Style overrides layered on top of [BsListGroupStyle.defaults].
  final BsListGroupStyle? style;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final isDark = BsTheme.of(context) == Brightness.dark;
    final style =
        (isDark ? BsListGroupStyle.darkDefaults : BsListGroupStyle.defaults)
            .merge(this.style);
    final horizontal = orientation == BsListGroupOrientation.horizontal;

    final children = [
      for (var i = 0; i < items.length; i++)
        _BsListGroupItemWidget(
          item: items[i],
          style: style,
          horizontal: horizontal,
          flush: flush,
          isFirst: i == 0,
          isLast: i == items.length - 1,
          number: numbered ? i + 1 : null,
        ),
    ];

    if (horizontal) {
      // IntrinsicHeight bounds the row's height so crossAxisAlignment.stretch
      // can equalize every item's height instead of inheriting an unbounded
      // height from an enclosing scroll view.
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _BsListGroupItemWidget extends StatefulWidget {
  const _BsListGroupItemWidget({
    required this.item,
    required this.style,
    required this.horizontal,
    required this.flush,
    required this.isFirst,
    required this.isLast,
    required this.number,
  });

  final BsListGroupItem item;
  final BsListGroupStyle style;
  final bool horizontal;
  final bool flush;
  final bool isFirst;
  final bool isLast;
  final int? number;

  @override
  State<_BsListGroupItemWidget> createState() => _BsListGroupItemWidgetState();
}

class _BsListGroupItemWidgetState extends State<_BsListGroupItemWidget> {
  bool _hovered = false;
  bool _pressed = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final interactive = item.onTap != null;
    final enabled = interactive && !item.disabled;

    final borderWidth =
        style.borderWidth ?? BsListGroupStyle.defaultBorderWidth;
    final borderColor = item.active
        ? style.activeBorderColor ?? BsListGroupStyle.defaultActiveBackground
        : item.variant?.borderSubtle ??
              style.borderColor ??
              BsListGroupStyle.defaultBorderColor;
    final side = BorderSide(color: borderColor, width: borderWidth);

    // BorderDirectional for the horizontal orientation's shared seam, so
    // it lands on the edge two adjacent items actually touch — left in
    // LTR, right in RTL — the same fix as BsCardGroup/BsButtonGroup. The
    // vertical orientation doesn't need this: top/bottom aren't affected
    // by text direction, and its left/right sides are always both drawn
    // (the outer edges), never conditionally dropped.
    final BoxBorder border;
    if (widget.flush) {
      final dividerSide = widget.isLast ? BorderSide.none : side;
      border = widget.horizontal
          ? BorderDirectional(end: dividerSide)
          : Border(bottom: dividerSide);
    } else if (widget.horizontal) {
      // Not BorderSide.none: BorderDirectional.paint() requires every
      // side to share one color whenever borderRadius is non-null, even
      // style: none ones — BorderSide.none's own color (opaque black)
      // fails that, so it needs an explicit color match instead.
      border = BorderDirectional(
        top: side,
        end: side,
        bottom: side,
        start: widget.isFirst
            ? side
            : BorderSide(color: borderColor, style: BorderStyle.none),
      );
    } else {
      border = Border(
        left: side,
        right: side,
        bottom: side,
        top: widget.isFirst ? side : BorderSide.none,
      );
    }

    final BorderRadiusGeometry? borderRadius;
    if (widget.flush) {
      borderRadius = BorderRadius.zero;
    } else if (widget.horizontal) {
      final radius = Radius.circular(
        style.borderRadius ?? BsListGroupStyle.defaultBorderRadius,
      );
      // An item sandwiched between two neighbors squares off every
      // corner — geometrically zero, but BorderDirectional.paint() (see
      // above) only special-cases a *null* borderRadius for a
      // non-uniform-style border, not one that's merely zero-valued, so
      // this passes null instead of a zero BorderRadiusDirectional.
      borderRadius = (!widget.isFirst && !widget.isLast)
          ? null
          : BorderRadiusDirectional.horizontal(
              start: widget.isFirst ? radius : Radius.zero,
              end: widget.isLast ? radius : Radius.zero,
            );
    } else {
      final radius = Radius.circular(
        style.borderRadius ?? BsListGroupStyle.defaultBorderRadius,
      );
      borderRadius = BorderRadius.vertical(
        top: widget.isFirst ? radius : Radius.zero,
        bottom: widget.isLast ? radius : Radius.zero,
      );
    }

    final Color background;
    final Color? color;
    if (item.disabled) {
      background =
          style.disabledBackground ??
          BsListGroupStyle.defaultDisabledBackground;
      color = style.disabledColor ?? BsListGroupStyle.defaultActionColor;
    } else if (item.active) {
      background =
          style.activeBackground ?? BsListGroupStyle.defaultActiveBackground;
      color = style.activeColor ?? BsListGroupStyle.defaultActiveColor;
    } else if (_pressed && enabled) {
      background =
          style.actionActiveBackground ??
          BsListGroupStyle.defaultActionActiveBackground;
      color = style.actionActiveColor ?? BsBody.color;
    } else if (_hovered && enabled) {
      background =
          style.hoverBackground ?? BsListGroupStyle.defaultHoverBackground;
      color =
          style.actionHoverColor ?? BsListGroupStyle.defaultActionHoverColor;
    } else if (item.variant != null) {
      background = item.variant!.bgSubtle;
      color = item.variant!.textEmphasis;
    } else {
      background =
          item.bg?.of(context) ??
          style.background ??
          BsListGroupStyle.defaultBackground;
      color = interactive
          ? (style.actionColor ?? BsListGroupStyle.defaultActionColor)
          : (style.color ?? BsBody.color);
    }

    final basePadding =
        (style.itemPadding ?? BsListGroupStyle.defaultItemPadding).resolve(
          Directionality.of(context),
        );
    final content = Padding(
      padding: item.py == null
          ? basePadding
          : EdgeInsets.fromLTRB(
              basePadding.left,
              item.py!.size,
              basePadding.right,
              item.py!.size,
            ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: widget.number == null
            ? item.child
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.number}. '),
                  Expanded(child: item.child),
                ],
              ),
      ),
    );

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => _setHovered(true) : null,
      onExit: enabled ? (_) => _setHovered(false) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: enabled ? item.onTap : null,
        // // A container, not a bare DecoratedBox: the border adds to the item's size instead of being
        // // painted over its padding.
        child: BsDecoratedContainer(
          decoration: BoxDecoration(
            color: background,
            border: border,
            borderRadius: borderRadius,
          ),
          child: content,
        ),
      ),
    );
  }
}
