import 'package:flutter/widgets.dart';

import 'tokens/bs_accordion_style.dart';

/// Controls which [BsAccordion] items are expanded, for programmatic
/// show/hide — the same pattern Flutter itself uses for [TabController],
/// [ScrollController] and `ExpansionTileController`: pass an instance you
/// created to [BsAccordion.controller] and call [expand]/[collapse]/
/// [toggle] from anywhere with access to it. If you don't need programmatic
/// control, omit it — [BsAccordion] creates and manages its own internally.
class BsAccordionController extends ChangeNotifier {
  BsAccordionController({Set<int> initiallyExpanded = const <int>{}, Set<int> detachedIndices = const <int>{}})
      : _expanded = {...initiallyExpanded},
        _detached = {...detachedIndices} {
    _normalizeGroupedExpansion();
  }

  final Set<int> _expanded;
  Set<int> _detached;

  /// Which indices are "detached" — mirroring Bootstrap's `.accordion-collapse`
  /// omitting `data-bs-parent`: a detached item toggles independently and
  /// never collapses, or is collapsed by, any other item. [BsAccordion] keeps
  /// this in sync with [BsAccordionItem.detached] on every build; set it
  /// yourself only if you're driving the controller without a [BsAccordion].
  Set<int> get detachedIndices => Set.unmodifiable(_detached);
  set detachedIndices(Set<int> value) {
    _detached = {...value};
    _normalizeGroupedExpansion();
  }

  /// Grouped (non-detached) items are mutually exclusive, so at most one of
  /// them may start, or be marked, expanded at once. If more than one ends
  /// up in [_expanded] — e.g. via `initiallyExpanded` — keep the first and
  /// collapse the rest, matching what [expand] would enforce, and flag the
  /// mistake in debug builds instead of silently rendering two open items
  /// that normal interaction could never produce.
  void _normalizeGroupedExpansion() {
    final grouped = _expanded.where((i) => !_detached.contains(i)).toList()..sort();
    if (grouped.length <= 1) return;
    assert(
      false,
      'BsAccordionController: items $grouped were all initially expanded, '
      'but only one non-detached item can be open at a time — keeping '
      '${grouped.first} and collapsing the rest. Mark the others as '
      'detached (BsAccordionItem.detached) if they should stay open '
      'independently.',
    );
    for (final i in grouped.skip(1)) {
      _expanded.remove(i);
    }
  }

  /// The currently expanded indices. Do not mutate the returned set;
  /// use [expand]/[collapse]/[toggle]/[collapseAll] instead.
  Set<int> get expanded => Set.unmodifiable(_expanded);

  bool isExpanded(int index) => _expanded.contains(index);

  /// Expands [index]. If [index] is detached (see [detachedIndices]), every
  /// other item is left untouched. Otherwise, every other *non-detached*
  /// item collapses first (Bootstrap's `data-bs-parent` grouping) while any
  /// detached items stay exactly as they were.
  void expand(int index) {
    if (_detached.contains(index)) {
      if (_expanded.contains(index)) return;
      _expanded.add(index);
      notifyListeners();
      return;
    }

    final hasOtherGroupedExpanded = _expanded.any((i) => i != index && !_detached.contains(i));
    if (_expanded.contains(index) && !hasOtherGroupedExpanded) return;
    _expanded.removeWhere((i) => !_detached.contains(i));
    _expanded.add(index);
    notifyListeners();
  }

  void collapse(int index) {
    if (_expanded.remove(index)) notifyListeners();
  }

  void toggle(int index) => isExpanded(index) ? collapse(index) : expand(index);

  /// Collapses every item, including detached ones.
  void collapseAll() {
    if (_expanded.isEmpty) return;
    _expanded.clear();
    notifyListeners();
  }
}

/// One collapsible section of a [BsAccordion].
class BsAccordionItem {
  const BsAccordionItem({required this.header, required this.body, this.detached = false});

  /// The always-visible header content, typically a [Text].
  final Widget header;

  /// The content revealed when this item is expanded.
  final Widget body;

  /// Mirrors omitting `data-bs-parent` on this item's `.accordion-collapse`
  /// in Bootstrap: when true, this item expands/collapses independently and
  /// never affects, or is affected by, the other items in the same
  /// [BsAccordion] — even if those items are grouped with each other. A
  /// "detached" item is simply one that opted out of the accordion's
  /// single-open grouping; set it on every item to reproduce Bootstrap's
  /// "always open" example, or on just one to make that item independent
  /// while the rest still behave as a single-open group.
  final bool detached;
}

/// A Bootstrap accordion (`.accordion`): a vertical stack of collapsible
/// [BsAccordionItem]s.
///
/// Mirrors `scss/_accordion.scss`'s borders/radius/colors, and — inspired by
/// Material's `ExpansionPanelList`/`ExpansionTile` — an animated chevron and
/// an animated height reveal for the body instead of Bootstrap's CSS
/// `collapse` transition.
///
/// By default all items are grouped into a single-open set (Bootstrap's
/// `data-bs-parent` behavior); set [BsAccordionItem.detached] on any item
/// to exclude it from that grouping — it then expands/collapses on its own,
/// regardless of what the other items do. Pass [allDetached] as a shorthand
/// for detaching every item at once, reproducing Bootstrap's "always open"
/// example. [flush] renders the edge-to-edge `.accordion-flush` variant (no
/// outer border or rounded corners).
class BsAccordion extends StatefulWidget {
  const BsAccordion({
    super.key,
    required this.items,
    this.controller,
    this.initiallyExpanded = const <int>{},
    this.allDetached = false,
    this.flush = false,
    this.style,
    this.iconBuilder,
    this.onExpansionChanged,
    this.onExpansionEnd,
  }) : assert(
         controller == null || initiallyExpanded == const <int>{},
         'initiallyExpanded has no effect when controller is set — pass it to '
         'BsAccordionController(initiallyExpanded: ...) instead.',
       );

  /// The items to render, top to bottom.
  final List<BsAccordionItem> items;

  /// Controls which items are expanded, for programmatic show/hide. Omit to
  /// let [BsAccordion] create and manage its own controller internally —
  /// only supply one if you need to expand/collapse items from outside this
  /// widget (see [BsAccordionController]). When set, [initiallyExpanded] is
  /// ignored in favor of the controller's own settings.
  final BsAccordionController? controller;

  /// Indices expanded when the accordion first builds. Ignored when
  /// [controller] is set.
  final Set<int> initiallyExpanded;

  /// Shorthand for marking every item [BsAccordionItem.detached], so all of
  /// them expand/collapse independently — Bootstrap's "always open" example
  /// — without having to set `detached: true` on each one individually. Set
  /// [BsAccordionItem.detached] on specific items instead if only *some*
  /// should be independent.
  final bool allDetached;

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

  /// Called immediately when an item starts expanding or collapsing —
  /// whether triggered by a tap or programmatically via [controller] —
  /// mirroring Bootstrap's `show.bs.collapse`/`hide.bs.collapse` events.
  final void Function(int index, bool isExpanded)? onExpansionChanged;

  /// Called once an item's expand/collapse animation finishes, mirroring
  /// Bootstrap's `shown.bs.collapse`/`hidden.bs.collapse` events. Useful for
  /// e.g. scrolling newly-revealed content into view, or lazily building it
  /// only once actually visible.
  final void Function(int index, bool isExpanded)? onExpansionEnd;

  @override
  State<BsAccordion> createState() => _BsAccordionState();
}

class _BsAccordionState extends State<BsAccordion> {
  BsAccordionController? _internalController;
  late Set<int> _lastExpanded;

  BsAccordionController get _controller => widget.controller ?? _internalController!;

  Set<int> get _detachedIndices => {
    for (var i = 0; i < widget.items.length; i++)
      if (widget.allDetached || widget.items[i].detached) i,
  };

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = BsAccordionController(
        initiallyExpanded: widget.initiallyExpanded,
        detachedIndices: _detachedIndices,
      );
    }
    _lastExpanded = {..._controller.expanded};
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(BsAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(_handleControllerChanged);
      if (widget.controller == null) {
        _internalController ??= BsAccordionController(
          initiallyExpanded: widget.initiallyExpanded,
          detachedIndices: _detachedIndices,
        );
      }
      _lastExpanded = {..._controller.expanded};
      _controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    super.dispose();
  }

  // Fires onExpansionChanged/onExpansionEnd for whatever changed, regardless
  // of whether the change came from a tap or programmatically via the
  // controller — mirroring Bootstrap's events, which fire the same way for
  // both a user click and a scripted `.collapse('show')` call. Diffing sets
  // (rather than hooking the tap handler directly) also means a grouped
  // expand that both opens one item and closes another correctly reports
  // both, in one pass.
  void _handleControllerChanged() {
    final current = _controller.expanded;
    final becameExpanded = current.difference(_lastExpanded);
    final becameCollapsed = _lastExpanded.difference(current);
    _lastExpanded = {...current};

    for (final i in becameExpanded) {
      widget.onExpansionChanged?.call(i, true);
    }
    for (final i in becameCollapsed) {
      widget.onExpansionChanged?.call(i, false);
    }

    if (widget.onExpansionEnd != null && (becameExpanded.isNotEmpty || becameCollapsed.isNotEmpty)) {
      final style = BsAccordionStyle.defaults.merge(widget.style);
      final duration = style.transitionDuration ?? BsAccordionStyle.defaultTransitionDuration;
      for (final i in becameExpanded) {
        _scheduleExpansionEnd(i, true, duration);
      }
      for (final i in becameCollapsed) {
        _scheduleExpansionEnd(i, false, duration);
      }
    }

    setState(() {});
  }

  void _scheduleExpansionEnd(int index, bool isExpanded, Duration duration) {
    Future.delayed(duration, () {
      if (!mounted) return;
      // Only fire if the item is still in the state we scheduled this for —
      // a rapid second toggle before this fires means this transition never
      // actually completed, so reporting it would be a stale/incorrect
      // notification.
      if (_controller.isExpanded(index) == isExpanded) {
        widget.onExpansionEnd?.call(index, isExpanded);
      }
    });
  }

  void _toggle(int index) => _controller.toggle(index);

  @override
  Widget build(BuildContext context) {
    final style = BsAccordionStyle.defaults.merge(widget.style);
    _controller.detachedIndices = _detachedIndices;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.items.length; i++)
          _BsAccordionItemView(
            item: widget.items[i],
            isFirst: i == 0,
            isLast: i == widget.items.length - 1,
            isExpanded: _controller.isExpanded(i),
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
