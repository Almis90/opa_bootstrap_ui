import 'package:flutter/widgets.dart';

import 'tokens/bs_accordion_style.dart';

/// One collapsible section of a [BsAccordion].
class BsAccordionItem {
  const BsAccordionItem({required this.header, required this.body});

  /// The always-visible header content, typically a [Text].
  final Widget header;

  /// The content revealed when this item is expanded.
  final Widget body;
}

/// A Bootstrap accordion (`.accordion`): a vertical stack of collapsible
/// [BsAccordionItem]s.
///
/// Mirrors `scss/_accordion.scss`'s borders/radius/colors, and — inspired by
/// Material's `ExpansionPanelList`/`ExpansionTile` — an animated chevron and
/// an animated height reveal for the body instead of Bootstrap's CSS
/// `collapse` transition.
///
/// By default only one item is expanded at a time (Bootstrap's
/// `data-bs-parent` behavior); pass [alwaysOpen] to let multiple items stay
/// expanded independently, and [flush] for the edge-to-edge
/// `.accordion-flush` variant (no outer border or rounded corners).
class BsAccordion extends StatefulWidget {
  const BsAccordion({
    super.key,
    required this.items,
    this.initiallyExpanded = const <int>{},
    this.alwaysOpen = false,
    this.flush = false,
    this.style,
    this.iconBuilder,
    this.onExpansionChanged,
  });

  /// The items to render, top to bottom.
  final List<BsAccordionItem> items;

  /// Indices expanded when the accordion first builds.
  final Set<int> initiallyExpanded;

  /// Whether more than one item can be expanded at once. When false
  /// (Bootstrap's default), expanding an item collapses the others.
  final bool alwaysOpen;

  /// Whether to render the borderless, edge-to-edge `.accordion-flush`
  /// variant.
  final bool flush;

  /// Style overrides layered on top of [BsAccordionStyle.defaults].
  final BsAccordionStyle? style;

  /// Overrides the chevron entirely, replacing Bootstrap's
  /// `$accordion-btn-icon`/`$accordion-btn-active-icon`. Called with the
  /// resolved icon color and whether the item is expanded; the returned
  /// widget is rotated automatically per [BsAccordionStyle.iconRotationTurns]
  /// unless you opt out by building your own [AnimatedRotation].
  final Widget Function(BuildContext context, Color color, bool isExpanded)? iconBuilder;

  /// Called with the toggled item's index and its new expanded state.
  final void Function(int index, bool isExpanded)? onExpansionChanged;

  @override
  State<BsAccordion> createState() => _BsAccordionState();
}

class _BsAccordionState extends State<BsAccordion> {
  late final Set<int> _expanded = {...widget.initiallyExpanded};

  void _toggle(int index) {
    final expanding = !_expanded.contains(index);
    setState(() {
      if (!widget.alwaysOpen) _expanded.clear();
      if (expanding) {
        _expanded.add(index);
      } else {
        _expanded.remove(index);
      }
    });
    widget.onExpansionChanged?.call(index, expanding);
  }

  @override
  Widget build(BuildContext context) {
    final style = BsAccordionStyle.defaults.merge(widget.style);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.items.length; i++)
          _BsAccordionItemView(
            item: widget.items[i],
            isFirst: i == 0,
            isLast: i == widget.items.length - 1,
            isExpanded: _expanded.contains(i),
            flush: widget.flush,
            style: style,
            iconBuilder: widget.iconBuilder,
            onTap: () => _toggle(i),
          ),
      ],
    );
  }
}

class _BsAccordionItemView extends StatefulWidget {
  const _BsAccordionItemView({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.isExpanded,
    required this.flush,
    required this.style,
    this.iconBuilder,
    required this.onTap,
  });

  final BsAccordionItem item;
  final bool isFirst;
  final bool isLast;
  final bool isExpanded;
  final bool flush;
  final BsAccordionStyle style;
  final Widget Function(BuildContext context, Color color, bool isExpanded)? iconBuilder;
  final VoidCallback onTap;

  @override
  State<_BsAccordionItemView> createState() => _BsAccordionItemViewState();
}

class _BsAccordionItemViewState extends State<_BsAccordionItemView> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final borderWidth = style.borderWidth ?? BsAccordionStyle.defaultBorderWidth;
    final borderColor = style.borderColor ?? BsAccordionStyle.defaultBorderColor;
    final outerRadius = style.borderRadius ?? BsAccordionStyle.defaultBorderRadius;
    final background = style.background ?? BsAccordionStyle.defaultBackground;
    final transitionDuration = style.transitionDuration ?? BsAccordionStyle.defaultTransitionDuration;

    final innerRadius = style.innerBorderRadius ?? BsAccordionStyle.defaultInnerBorderRadius;

    final borderRadius = widget.flush
        ? BorderRadius.zero
        : BorderRadius.vertical(
            top: widget.isFirst ? Radius.circular(outerRadius) : Radius.zero,
            bottom: widget.isLast ? Radius.circular(outerRadius) : Radius.zero,
          );

    // The button's own fill uses a slightly smaller radius than the item's
    // outer border, per $accordion-inner-border-radius, so it nests inside
    // the border curve instead of sharing it exactly. Bootstrap only rounds
    // the last item's button when collapsed — once expanded, the body below
    // it carries the bottom radius instead (handled by the outer ClipRRect).
    final buttonRadius = widget.flush
        ? BorderRadius.zero
        : BorderRadius.vertical(
            top: widget.isFirst ? Radius.circular(innerRadius) : Radius.zero,
            bottom: (widget.isLast && !widget.isExpanded) ? Radius.circular(innerRadius) : Radius.zero,
          );

    final side = BorderSide(color: borderColor, width: borderWidth);
    final border = widget.flush
        ? Border(top: widget.isFirst ? BorderSide.none : side)
        : Border(
            top: widget.isFirst ? side : BorderSide.none,
            left: side,
            right: side,
            bottom: side,
          );

    final buttonColor = widget.isExpanded
        ? (style.buttonActiveColor ?? BsAccordionStyle.defaultColor)
        : (style.buttonColor ?? BsAccordionStyle.defaultColor);
    final buttonBackground = widget.isExpanded
        ? (style.buttonActiveBackground ?? background)
        : (style.buttonBackground ?? background);
    final iconColor = widget.isExpanded
        ? (style.iconActiveColor ?? buttonColor)
        : (style.iconColor ?? BsAccordionStyle.defaultIconColor);

    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(border: border, borderRadius: borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Focus(
              onFocusChange: (focused) => setState(() => _focused = focused),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTap,
                  child: AnimatedContainer(
                    duration: transitionDuration,
                    padding: style.padding ?? BsAccordionStyle.defaultPadding,
                    decoration: BoxDecoration(
                      color: buttonBackground,
                      borderRadius: buttonRadius,
                      boxShadow: [
                        if (widget.isExpanded) BoxShadow(color: borderColor, offset: Offset(0, borderWidth)),
                        if (_focused)
                          BoxShadow(
                            color: (style.focusRingColor ?? BsAccordionStyle.defaultFocusRingColor)
                                .withValues(alpha: 0.5),
                            spreadRadius: style.focusRingWidth ?? BsAccordionStyle.defaultFocusRingWidth,
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultTextStyle.merge(
                            style: TextStyle(color: buttonColor, fontWeight: FontWeight.w500),
                            child: widget.item.header,
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedRotation(
                          turns: widget.isExpanded
                              ? (style.iconRotationTurns ?? BsAccordionStyle.defaultIconRotationTurns)
                              : 0,
                          duration: style.iconTransitionDuration ?? BsAccordionStyle.defaultIconTransitionDuration,
                          child: widget.iconBuilder?.call(context, iconColor, widget.isExpanded) ??
                              _BsChevron(
                                size: style.iconWidth ?? BsAccordionStyle.defaultIconWidth,
                                color: iconColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: transitionDuration,
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: widget.isExpanded
                  ? Container(
                      width: double.infinity,
                      padding: style.bodyPadding ?? style.padding ?? BsAccordionStyle.defaultPadding,
                      color: background,
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: style.color ?? BsAccordionStyle.defaultColor),
                        child: widget.item.body,
                      ),
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }
}

/// A minimal chevron-down glyph, replicating Bootstrap's accordion caret
/// without depending on an icon font/package.
class _BsChevron extends StatelessWidget {
  const _BsChevron({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _BsChevronPainter(color));
  }
}

class _BsChevronPainter extends CustomPainter {
  _BsChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.35)
      ..lineTo(size.width * 0.5, size.height * 0.65)
      ..lineTo(size.width * 0.8, size.height * 0.35);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BsChevronPainter oldDelegate) => oldDelegate.color != color;
}
