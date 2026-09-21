import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'bs_variant.dart';
import 'tokens/bs_body.dart';
import 'tokens/bs_list_group_style.dart';

/// Which way a [BsListGroup] stacks its items.
enum BsListGroupOrientation {
  /// `.list-group` (default): items stack top to bottom.
  vertical,

  /// `.list-group-horizontal`: items sit side by side.
  horizontal,
}

/// A single row in a [BsListGroup].
class BsListGroupItem {
  const BsListGroupItem({required this.child, this.onTap, this.active = false, this.disabled = false, this.variant});

  final Widget child;

  /// `.list-group-item-action`: called when tapped. Adds hover/press
  /// styling; leave null for a plain, non-interactive row.
  final VoidCallback? onTap;

  /// `.active`: highlights this item as the current selection.
  final bool active;

  /// `.disabled`: dims the item and ignores taps.
  final bool disabled;

  /// `.list-group-item-{variant}`: tints the item with a contextual color,
  /// via the same [BsVariant.bgSubtle]/[BsVariant.textEmphasis] recipe
  /// [BsAlert] uses.
  final BsVariant? variant;
}

/// A Bootstrap list group (`.list-group`): a series of [items] rendered as
/// one bordered block with a shared border between rows and only the
/// group's outer corners rounded — the same seam technique [BsCardGroup]
/// uses for adjoining cards.
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

  /// `.list-group-flush`: removes the outer border and corner rounding,
  /// leaving only the dividers between items — for embedding edge to edge
  /// in a container like [BsCard].
  final bool flush;

  /// `.list-group-numbered`: prefixes each item with its 1-based position.
  final bool numbered;

  /// Style overrides layered on top of [BsListGroupStyle.defaults].
  final BsListGroupStyle? style;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final style = BsListGroupStyle.defaults.merge(this.style);
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
      return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: children));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
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

    final borderWidth = style.borderWidth ?? BsListGroupStyle.defaultBorderWidth;
    final borderColor = item.active
        ? style.activeBorderColor ?? BsListGroupStyle.defaultActiveBackground
        : item.variant?.borderSubtle ?? style.borderColor ?? BsListGroupStyle.defaultBorderColor;
    final side = BorderSide(color: borderColor, width: borderWidth);

    final Border border;
    if (widget.flush) {
      final dividerSide = widget.isLast ? BorderSide.none : side;
      border = widget.horizontal ? Border(right: dividerSide) : Border(bottom: dividerSide);
    } else if (widget.horizontal) {
      border = Border(top: side, right: side, bottom: side, left: widget.isFirst ? side : BorderSide.none);
    } else {
      border = Border(left: side, right: side, bottom: side, top: widget.isFirst ? side : BorderSide.none);
    }

    final BorderRadius borderRadius;
    if (widget.flush) {
      borderRadius = BorderRadius.zero;
    } else {
      final radius = Radius.circular(style.borderRadius ?? BsListGroupStyle.defaultBorderRadius);
      borderRadius = widget.horizontal
          ? BorderRadius.horizontal(
              left: widget.isFirst ? radius : Radius.zero,
              right: widget.isLast ? radius : Radius.zero,
            )
          : BorderRadius.vertical(
              top: widget.isFirst ? radius : Radius.zero,
              bottom: widget.isLast ? radius : Radius.zero,
            );
    }

    final Color background;
    final Color? color;
    if (item.disabled) {
      background = style.disabledBackground ?? BsListGroupStyle.defaultDisabledBackground;
      color = style.disabledColor ?? BsListGroupStyle.defaultActionColor;
    } else if (item.active) {
      background = style.activeBackground ?? BsListGroupStyle.defaultActiveBackground;
      color = style.activeColor ?? BsListGroupStyle.defaultActiveColor;
    } else if (_pressed && enabled) {
      background = style.actionActiveBackground ?? style.hoverBackground ?? BsListGroupStyle.defaultHoverBackground;
      color = style.actionActiveColor ?? BsBody.color;
    } else if (_hovered && enabled) {
      background = style.hoverBackground ?? BsListGroupStyle.defaultHoverBackground;
      color = style.actionHoverColor ?? BsColors.black;
    } else if (item.variant != null) {
      background = item.variant!.bgSubtle;
      color = item.variant!.textEmphasis;
    } else {
      background = style.background ?? BsListGroupStyle.defaultBackground;
      color = interactive ? (style.actionColor ?? BsListGroupStyle.defaultActionColor) : (style.color ?? BsBody.color);
    }

    final content = Padding(
      padding: style.itemPadding ?? BsListGroupStyle.defaultItemPadding,
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
        child: DecoratedBox(
          decoration: BoxDecoration(color: background, border: border, borderRadius: borderRadius),
          child: content,
        ),
      ),
    );
  }
}
