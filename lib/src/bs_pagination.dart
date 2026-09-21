import 'package:flutter/widgets.dart';

import 'tokens/bs_focus_ring.dart';
import 'tokens/bs_pagination_style.dart';

/// A single `.page-item`/`.page-link` within a [BsPagination].
class BsPaginationItem {
  const BsPaginationItem({required this.child, this.onTap, this.active = false, this.disabled = false});

  /// Typically a page number's [Text], or a chevron for prev/next.
  final Widget child;

  final VoidCallback? onTap;

  /// `.active`: highlights this as the current page.
  final bool active;

  /// `.disabled`: dims the item and ignores taps.
  final bool disabled;
}

/// A Bootstrap pagination (`.pagination`): a row of [items] rendered as one
/// block with a shared border between them and only the row's outer
/// corners rounded — the same overlap technique [BsButtonGroup] uses to
/// join adjacent buttons.
///
/// Bootstrap's own SCSS gives `.pagination` an essentially identical
/// bordered-row structure to `.btn-group`, and neither Material nor
/// Cupertino has a numbered-page-link widget to borrow from instead, so
/// this reuses that in-package technique rather than reaching outside it.
///
/// Use [BsPagination.numberedItems] to generate a page-number-plus-prev/next
/// item list for the common case.
class BsPagination extends StatelessWidget {
  const BsPagination({super.key, required this.items, this.style});

  /// The items to render, in order.
  final List<BsPaginationItem> items;

  /// Style overrides layered on top of [BsPaginationStyle.defaults].
  final BsPaginationStyle? style;

  /// Builds items for [pageCount] numbered pages plus prev/next arrows,
  /// covering Bootstrap's most common `.pagination` example. [currentPage]
  /// is 1-based; prev/next are disabled at the first/last page.
  static List<BsPaginationItem> numberedItems({
    required int pageCount,
    required int currentPage,
    required ValueChanged<int> onSelect,
    bool showPrevNext = true,
  }) {
    return [
      if (showPrevNext)
        BsPaginationItem(
          child: const Text('‹'),
          onTap: currentPage > 1 ? () => onSelect(currentPage - 1) : null,
          disabled: currentPage <= 1,
        ),
      for (var page = 1; page <= pageCount; page++)
        BsPaginationItem(child: Text('$page'), active: page == currentPage, onTap: () => onSelect(page)),
      if (showPrevNext)
        BsPaginationItem(
          child: const Text('›'),
          onTap: currentPage < pageCount ? () => onSelect(currentPage + 1) : null,
          disabled: currentPage >= pageCount,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final style = BsPaginationStyle.defaults.merge(this.style);
    final borderWidth = style.borderWidth ?? BsPaginationStyle.defaultBorderWidth;
    final radius = Radius.circular(style.borderRadius ?? BsPaginationStyle.defaultBorderRadius);

    final widgets = <Widget>[];
    var cumulativeOverlap = 0.0;
    for (var i = 0; i < items.length; i++) {
      final isFirst = i == 0;
      final isLast = i == items.length - 1;
      final itemRadius = BorderRadius.horizontal(
        left: isFirst ? radius : Radius.zero,
        right: isLast ? radius : Radius.zero,
      );

      final child = _BsPaginationItemWidget(item: items[i], style: style, borderRadius: itemRadius);

      // Overlap adjacent items by one border width so each shared seam
      // reads as a single border, per Bootstrap's negative-margin trick —
      // the same technique BsButtonGroup uses.
      if (!isFirst) cumulativeOverlap += borderWidth;

      widgets.add(isFirst ? child : Transform.translate(offset: Offset(-cumulativeOverlap, 0), child: child));
    }

    return Row(mainAxisSize: MainAxisSize.min, children: widgets);
  }
}

class _BsPaginationItemWidget extends StatefulWidget {
  const _BsPaginationItemWidget({required this.item, required this.style, required this.borderRadius});

  final BsPaginationItem item;
  final BsPaginationStyle style;
  final BorderRadius borderRadius;

  @override
  State<_BsPaginationItemWidget> createState() => _BsPaginationItemWidgetState();
}

class _BsPaginationItemWidgetState extends State<_BsPaginationItemWidget> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final enabled = item.onTap != null && !item.disabled;

    final Color color;
    final Color background;
    final Color borderColor;
    if (item.disabled) {
      color = style.disabledColor ?? BsPaginationStyle.defaultDisabledColor;
      background = style.disabledBackground ?? BsPaginationStyle.defaultDisabledBackground;
      borderColor = style.disabledBorderColor ?? BsPaginationStyle.defaultBorderColor;
    } else if (item.active) {
      color = style.activeColor ?? BsPaginationStyle.defaultActiveColor;
      background = style.activeBackground ?? BsPaginationStyle.defaultActiveBackground;
      borderColor = style.activeBorderColor ?? BsPaginationStyle.defaultActiveBackground;
    } else if (_focused) {
      color = style.focusColor ?? BsPaginationStyle.defaultColor;
      background = style.focusBackground ?? BsPaginationStyle.defaultFocusBackground;
      borderColor = style.borderColor ?? BsPaginationStyle.defaultBorderColor;
    } else if (_hovered && enabled) {
      color = style.hoverColor ?? BsPaginationStyle.defaultColor;
      background = style.hoverBackground ?? BsPaginationStyle.defaultHoverBackground;
      borderColor = style.hoverBorderColor ?? BsPaginationStyle.defaultBorderColor;
    } else {
      color = style.color ?? BsPaginationStyle.defaultColor;
      background = style.background ?? BsPaginationStyle.defaultBackground;
      borderColor = style.borderColor ?? BsPaginationStyle.defaultBorderColor;
    }

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: Focus(
        onFocusChange: enabled ? (focused) => setState(() => _focused = focused) : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? item.onTap : null,
          child: AnimatedContainer(
            duration: style.transitionDuration ?? BsPaginationStyle.defaultTransitionDuration,
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: borderColor, width: style.borderWidth ?? BsPaginationStyle.defaultBorderWidth),
              borderRadius: widget.borderRadius,
              boxShadow: [
                if (_focused)
                  BoxShadow(color: BsFocusRing.color(), spreadRadius: BsPaginationStyle.defaultFocusRingWidth),
              ],
            ),
            child: Padding(
              padding: style.padding ?? BsPaginationStyle.defaultPadding,
              child: DefaultTextStyle.merge(
                style: TextStyle(color: color, fontSize: style.fontSize ?? BsPaginationStyle.defaultFontSize),
                textAlign: TextAlign.center,
                child: item.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
