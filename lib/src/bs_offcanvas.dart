import 'package:flutter/widgets.dart';

import 'bs_close_button.dart';
import 'tokens/bs_offcanvas_style.dart';

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
/// the route (e.g. `Navigator.of(context).pop()`).
Future<T?> showBsOffcanvas<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  BsOffcanvasPlacement placement = BsOffcanvasPlacement.start,
  bool barrierDismissible = true,
  String barrierLabel = 'Dismiss',
  BsOffcanvasStyle? style,
}) {
  final resolvedStyle = BsOffcanvasStyle.defaults.merge(style);
  final backdropOpacity =
      resolvedStyle.backdropOpacity ?? BsOffcanvasStyle.defaultBackdropOpacity;
  final backdropColor =
      (resolvedStyle.backdropColor ?? BsOffcanvasStyle.defaultBackdropColor)
          .withValues(alpha: backdropOpacity);

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: backdropColor,
    transitionDuration:
        resolvedStyle.transitionDuration ??
        BsOffcanvasStyle.defaultTransitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) =>
        _BsOffcanvasPositioned(
          placement: placement,
          style: resolvedStyle,
          child: builder(context),
        ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final beginOffset = switch (placement) {
        BsOffcanvasPlacement.start => const Offset(-1, 0),
        BsOffcanvasPlacement.end => const Offset(1, 0),
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

/// Aligns and sizes a [showBsOffcanvas] route's content to [placement]'s
/// edge: a fixed width flush to the full viewport height for
/// [BsOffcanvasPlacement.start]/[BsOffcanvasPlacement.end], or the full
/// viewport width at [BsOffcanvasStyle.verticalHeightFraction] height for
/// [BsOffcanvasPlacement.top]/[BsOffcanvasPlacement.bottom].
class _BsOffcanvasPositioned extends StatelessWidget {
  const _BsOffcanvasPositioned({
    required this.child,
    required this.placement,
    required this.style,
  });

  final Widget child;
  final BsOffcanvasPlacement placement;
  final BsOffcanvasStyle style;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final horizontal =
        placement == BsOffcanvasPlacement.start ||
        placement == BsOffcanvasPlacement.end;
    final alignment = switch (placement) {
      BsOffcanvasPlacement.start => Alignment.centerLeft,
      BsOffcanvasPlacement.end => Alignment.centerRight,
      BsOffcanvasPlacement.top => Alignment.topCenter,
      BsOffcanvasPlacement.bottom => Alignment.bottomCenter,
    };
    final width = horizontal
        ? (style.horizontalWidth ?? BsOffcanvasStyle.defaultHorizontalWidth)
        : viewport.width;
    final height = horizontal
        ? viewport.height
        : viewport.height *
              (style.verticalHeightFraction ??
                  BsOffcanvasStyle.defaultVerticalHeightFraction);

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
    final style = BsOffcanvasStyle.defaults.merge(this.style);
    final borderSide = BorderSide(
      color: style.borderColor ?? BsOffcanvasStyle.defaultBorderColor,
      width: style.borderWidth ?? BsOffcanvasStyle.defaultBorderWidth,
    );
    final border = switch (placement) {
      BsOffcanvasPlacement.start => Border(right: borderSide),
      BsOffcanvasPlacement.end => Border(left: borderSide),
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
  const BsOffcanvasHeader({
    super.key,
    required this.child,
    this.onClose,
    this.style,
  });

  final Widget child;

  /// Shows a [BsCloseButton] calling this when tapped. Omit to hide it.
  final VoidCallback? onClose;

  final BsOffcanvasStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsOffcanvasStyle.defaults.merge(this.style);

    return Padding(
      padding: style.padding ?? BsOffcanvasStyle.defaultPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: style.titleLineHeight,
              ),
              child: child,
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 16),
            BsCloseButton(onPressed: onClose),
          ],
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
    final style = BsOffcanvasStyle.defaults.merge(this.style);
    return Padding(
      padding: style.padding ?? BsOffcanvasStyle.defaultPadding,
      child: SingleChildScrollView(child: child),
    );
  }
}
