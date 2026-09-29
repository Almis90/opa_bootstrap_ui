import 'package:flutter/widgets.dart';

import 'bs_close_button.dart';
import 'bs_theme.dart';
import 'tokens/bs_offcanvas_style.dart';
import 'tokens/bs_transitions.dart';

/// `.offcanvas-start`/`-end`/`-top`/`-bottom`: which viewport edge a
/// [BsOffcanvas] slides in from.
enum BsOffcanvasPlacement { start, end, top, bottom }

/// Opens a Bootstrap offcanvas (`.offcanvas`), the same way [showBsModal]
/// builds on [showGeneralDialog] — a route with an animated backdrop, but
/// sliding in from [placement]'s edge and sized to it (a fixed width for
/// [BsOffcanvasPlacement.start]/[BsOffcanvasPlacement.end], a fraction of
/// the viewport height for [BsOffcanvasPlacement.top]/
/// [BsOffcanvasPlacement.bottom]) rather than centered like a modal.
///
/// [builder] typically returns a [BsOffcanvas] with a matching [placement],
/// so its border lands on the edge it slides in from. Dismiss by popping
/// the route (e.g. `Navigator.of(context).pop()`) — or drive it through a
/// [BsOffcanvasController] instead, for [BsOffcanvasController.hide] plus
/// [onShow]/[onShown]/[onHide]/[onHidden] lifecycle events.
///
/// [onShow] fires synchronously, right here, before the route is even
/// pushed. [onShown] fires once the slide-in transition completes,
/// [onHide] once the route starts sliding back out — for whatever reason
/// (this covers every dismissal path: [BsOffcanvasController.hide],
/// `Navigator.pop`, an outside tap on [barrierDismissible], the system back
/// button) — and [onHidden] once it's fully gone, mirroring Bootstrap's
/// `show.bs.offcanvas`/`shown.bs.offcanvas`/`hide.bs.offcanvas`/
/// `hidden.bs.offcanvas`.
Future<T?> showBsOffcanvas<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  BsOffcanvasPlacement placement = BsOffcanvasPlacement.start,
  bool barrierDismissible = true,
  String barrierLabel = 'Dismiss',
  BsOffcanvasStyle? style,
  VoidCallback? onShow,
  VoidCallback? onShown,
  VoidCallback? onHide,
  VoidCallback? onHidden,
}) {
  final resolvedStyle = BsOffcanvasStyle.defaults.merge(style);
  final backdropOpacity = resolvedStyle.backdropOpacity ?? BsOffcanvasStyle.defaultBackdropOpacity;
  final backdropColor = (resolvedStyle.backdropColor ?? BsOffcanvasStyle.defaultBackdropColor).withValues(
    alpha: backdropOpacity,
  );

  onShow?.call();
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: backdropColor,
    transitionDuration: BsTransitions.resolve(
      context,
      resolvedStyle.transitionDuration ?? BsOffcanvasStyle.defaultTransitionDuration,
    ),
    // Registered here rather than in transitionBuilder below: buildPage
    // (which this maps to) runs once per route, while buildTransitions
    // (transitionBuilder) reruns on every state change while visible —
    // attaching the listener there would double it up on any such rebuild.
    //
    // onHidden can't be hung off the Future showGeneralDialog returns: per
    // Route.didComplete's own doc comment, that future resolves the instant
    // Navigator.pop() runs, *before* the exit transition plays — "routes
    // should not wait for their exit animation to complete before doing
    // so." AnimationStatus.dismissed (reverse reaching 0.0) is the actual
    // "fully gone" moment.
    pageBuilder: (context, animation, secondaryAnimation) {
      if (onShown != null || onHide != null || onHidden != null) {
        var hasFiredHide = false;
        animation.addStatusListener((status) {
          switch (status) {
            case AnimationStatus.completed:
              onShown?.call();
            case AnimationStatus.reverse:
              if (!hasFiredHide) {
                hasFiredHide = true;
                onHide?.call();
              }
            case AnimationStatus.dismissed:
              if (hasFiredHide) onHidden?.call();
            case AnimationStatus.forward:
              break;
          }
        });
      }
      return _BsOffcanvasPositioned(placement: placement, style: resolvedStyle, child: builder(context));
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      // .start/.end mirror Bootstrap's own logical placements — which
      // physical edge they slide in from flips with Directionality, the
      // same way .offcanvas-start/.offcanvas-end do in Bootstrap's RTL CSS.
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final beginOffset = switch (placement) {
        BsOffcanvasPlacement.start => Offset(isRtl ? 1 : -1, 0),
        BsOffcanvasPlacement.end => Offset(isRtl ? -1 : 1, 0),
        BsOffcanvasPlacement.top => const Offset(0, -1),
        BsOffcanvasPlacement.bottom => const Offset(0, 1),
      };
      return SlideTransition(
        position: Tween(begin: beginOffset, end: Offset.zero).animate(curved),
        child: child,
      );
    },
  );
}

/// Programmatic control of [showBsOffcanvas], tracking whether one is
/// currently open — mirrors [BsPopoverController]/[BsDropdownController],
/// adapted to [showBsOffcanvas] being a one-shot route push rather than a
/// persistent widget: [show] and [hide] take a [BuildContext] (there's no
/// [BsOffcanvas] `State` for the controller to attach to), and there's no
/// `setContent`/`setPlacement` override — both are baked into the route the
/// moment [show] pushes it, with no "already open" instance left to swap
/// them on afterward the way [BsPopoverController.setContent] can.
///
/// Unlike its siblings, [disable] can only prevent a *future* [show] — it
/// can't force-close an offcanvas already open through this controller,
/// since doing that needs a [BuildContext] this method isn't given.
class BsOffcanvasController extends ChangeNotifier {
  BsOffcanvasController({bool enabled = true}) {
    _enabled = enabled;
  }

  late bool _enabled;
  bool _shown = false;

  /// Whether [show] currently does anything.
  bool get enabled => _enabled;

  void enable() => _setEnabled(true);

  void disable() => _setEnabled(false);

  /// Flips [enabled], or sets it to [value] if given.
  void toggleEnabled([bool? value]) => _setEnabled(value ?? !_enabled);

  void _setEnabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    notifyListeners();
  }

  /// Whether an offcanvas opened through this controller is currently on
  /// screen. Stays false for one opened via a bare [showBsOffcanvas] call
  /// this controller wasn't passed to.
  bool get isShown => _shown;

  /// Calls [showBsOffcanvas] with these arguments, tracking [isShown]
  /// around it. Does nothing (returns null immediately) while [enabled] is
  /// false, or while one opened through this controller is already shown.
  Future<T?>? show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    BsOffcanvasPlacement placement = BsOffcanvasPlacement.start,
    bool barrierDismissible = true,
    String barrierLabel = 'Dismiss',
    BsOffcanvasStyle? style,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
  }) {
    if (!_enabled || _shown) return null;
    _shown = true;
    notifyListeners();
    return showBsOffcanvas<T>(
      context: context,
      builder: builder,
      placement: placement,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      style: style,
      onShow: onShow,
      onShown: onShown,
      onHide: onHide,
      onHidden: onHidden,
    ).then((result) {
      _shown = false;
      notifyListeners();
      return result;
    });
  }

  /// Pops the offcanvas this controller opened, if any.
  void hide(BuildContext context) {
    if (!_shown) return;
    Navigator.of(context).maybePop();
  }

  /// Calls [hide] if one opened through this controller is shown, [show]
  /// (with the same arguments) otherwise.
  Future<T?>? toggle<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    BsOffcanvasPlacement placement = BsOffcanvasPlacement.start,
    bool barrierDismissible = true,
    String barrierLabel = 'Dismiss',
    BsOffcanvasStyle? style,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
  }) {
    if (_shown) {
      hide(context);
      return null;
    }
    return show<T>(
      context: context,
      builder: builder,
      placement: placement,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      style: style,
      onShow: onShow,
      onShown: onShown,
      onHide: onHide,
      onHidden: onHidden,
    );
  }
}

/// Aligns and sizes a [showBsOffcanvas] route's content to [placement]'s
/// edge: a fixed width flush to the full viewport height for
/// [BsOffcanvasPlacement.start]/[BsOffcanvasPlacement.end], or the full
/// viewport width at [BsOffcanvasStyle.verticalHeightFraction] height for
/// [BsOffcanvasPlacement.top]/[BsOffcanvasPlacement.bottom].
class _BsOffcanvasPositioned extends StatelessWidget {
  const _BsOffcanvasPositioned({required this.child, required this.placement, required this.style});

  final Widget child;
  final BsOffcanvasPlacement placement;
  final BsOffcanvasStyle style;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final horizontal = placement == BsOffcanvasPlacement.start || placement == BsOffcanvasPlacement.end;
    final alignment = switch (placement) {
      BsOffcanvasPlacement.start => AlignmentDirectional.centerStart,
      BsOffcanvasPlacement.end => AlignmentDirectional.centerEnd,
      BsOffcanvasPlacement.top => Alignment.topCenter,
      BsOffcanvasPlacement.bottom => Alignment.bottomCenter,
    };
    final width = horizontal ? (style.horizontalWidth ?? BsOffcanvasStyle.defaultHorizontalWidth) : viewport.width;
    final height = horizontal
        ? viewport.height
        : viewport.height * (style.verticalHeightFraction ?? BsOffcanvasStyle.defaultVerticalHeightFraction);

    return Align(
      alignment: alignment,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

/// `.offcanvas`: the bordered panel holding [header] and [body], with a
/// border on the edge it slides in from per [placement].
class BsOffcanvas extends StatelessWidget {
  const BsOffcanvas({
    super.key,
    this.header,
    required this.body,
    this.placement = BsOffcanvasPlacement.start,
    this.style,
  });

  /// Typically a [BsOffcanvasHeader].
  final Widget? header;

  /// Typically a [BsOffcanvasBody].
  final Widget body;

  /// Which edge this offcanvas slides in from, matching the [placement]
  /// passed to [showBsOffcanvas] — determines which side gets the border.
  final BsOffcanvasPlacement placement;

  final BsOffcanvasStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsOffcanvasStyle.darkDefaults : BsOffcanvasStyle.defaults).merge(this.style);
    final borderSide = BorderSide(
      color: style.borderColor ?? BsOffcanvasStyle.defaultBorderColor,
      width: style.borderWidth ?? BsOffcanvasStyle.defaultBorderWidth,
    );
    // BorderDirectional for start/end so the border lands on the edge
    // actually facing the page's content in both directions — flush
    // against the start edge means the border belongs on the end side,
    // and vice versa, the same as Border(right:)/Border(left:) would only
    // happen to get right in LTR.
    final border = switch (placement) {
      BsOffcanvasPlacement.start => BorderDirectional(end: borderSide),
      BsOffcanvasPlacement.end => BorderDirectional(start: borderSide),
      BsOffcanvasPlacement.top => Border(bottom: borderSide),
      BsOffcanvasPlacement.bottom => Border(top: borderSide),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.background ?? BsOffcanvasStyle.defaultBackground,
        border: border,
        boxShadow: style.boxShadow ?? BsOffcanvasStyle.defaultBoxShadow,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: style.color ?? BsOffcanvasStyle.defaultColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ?header,
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// `.offcanvas-header`: [child] (typically a title) plus an optional close
/// button.
class BsOffcanvasHeader extends StatelessWidget {
  const BsOffcanvasHeader({super.key, required this.child, this.onClose, this.style});

  final Widget child;

  /// Shows a [BsCloseButton] calling this when tapped. Omit to hide it.
  final VoidCallback? onClose;

  final BsOffcanvasStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsOffcanvasStyle.darkDefaults : BsOffcanvasStyle.defaults).merge(this.style);

    return Padding(
      padding: style.padding ?? BsOffcanvasStyle.defaultPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: style.titleLineHeight),
              child: child,
            ),
          ),
          if (onClose != null) ...[const SizedBox(width: 16), BsCloseButton(onPressed: onClose)],
        ],
      ),
    );
  }
}

/// `.offcanvas-body`: the offcanvas's main, internally-scrollable content
/// area.
class BsOffcanvasBody extends StatelessWidget {
  const BsOffcanvasBody({super.key, required this.child, this.style});

  final Widget child;
  final BsOffcanvasStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsOffcanvasStyle.darkDefaults : BsOffcanvasStyle.defaults).merge(this.style);
    return Padding(
      padding: style.padding ?? BsOffcanvasStyle.defaultPadding,
      child: SingleChildScrollView(child: child),
    );
  }
}
