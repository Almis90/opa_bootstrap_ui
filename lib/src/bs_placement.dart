import 'package:flutter/widgets.dart';

/// The side of the trigger an overlay sits on, in physical (not text-direction) terms.
enum BsPlacementSide {
  top,
  bottom,
  left,
  right;

  bool get isVertical => this == top || this == bottom;

  BsPlacementSide get opposite => switch (this) {
    top => bottom,
    bottom => top,
    left => right,
    right => left,
  };
}

/// Where an overlay lines up with its trigger along the axis the [BsPlacementSide] does not
/// cover: at its start, its end, or centered. Physical too: `start` is the left (for top and
/// bottom sides) or top (for left and right sides) edge, regardless of text direction.
enum BsPlacementAlign {
  start,
  center,
  end;

  BsPlacementAlign get opposite => switch (this) {
    start => end,
    center => center,
    end => start,
  };

  /// −1, 0 or 1: this alignment's [Alignment] coordinate along its axis.
  double get coordinate => switch (this) {
    start => -1,
    center => 0,
    end => 1,
  };
}

/// A placement of an overlay: a [side] of the trigger plus an [align]ment along the other axis
/// (`bottom-start`, `top`, `right-end`…).
@immutable
class BsPlacement {
  const BsPlacement(this.side, [this.align = BsPlacementAlign.center]);

  final BsPlacementSide side;
  final BsPlacementAlign align;

  /// The other side, with the same alignment.
  BsPlacement get opposite => BsPlacement(side.opposite, align);

  /// The same side with the other alignment (itself, for a centered placement).
  BsPlacement get oppositeVariation => BsPlacement(side, align.opposite);

  /// The point on the trigger the overlay attaches to.
  Alignment get targetAnchor => switch (side) {
    BsPlacementSide.top => Alignment(align.coordinate, -1),
    BsPlacementSide.bottom => Alignment(align.coordinate, 1),
    BsPlacementSide.left => Alignment(-1, align.coordinate),
    BsPlacementSide.right => Alignment(1, align.coordinate),
  };

  /// The point on the overlay that sits at [targetAnchor].
  Alignment get followerAnchor => switch (side) {
    BsPlacementSide.top => Alignment(align.coordinate, 1),
    BsPlacementSide.bottom => Alignment(align.coordinate, -1),
    BsPlacementSide.left => Alignment(1, align.coordinate),
    BsPlacementSide.right => Alignment(-1, align.coordinate),
  };

  /// The gap [spacer] pushes the overlay away from the trigger by.
  Offset offset(double spacer) => switch (side) {
    BsPlacementSide.bottom => Offset(0, spacer),
    BsPlacementSide.top => Offset(0, -spacer),
    BsPlacementSide.right => Offset(spacer, 0),
    BsPlacementSide.left => Offset(-spacer, 0),
  };

  /// Where an overlay of size [content] lands, in the same space as [target].
  Rect rect(Rect target, Size content, double spacer) {
    Offset at(Rect r, Alignment a) => r.topLeft + Offset((a.x + 1) / 2 * r.width, (a.y + 1) / 2 * r.height);
    final follower = followerAnchor;
    final origin =
        at(target, targetAnchor) +
        offset(spacer) -
        Offset((follower.x + 1) / 2 * content.width, (follower.y + 1) / 2 * content.height);
    return origin & content;
  }

  @override
  bool operator ==(Object other) => other is BsPlacement && other.side == side && other.align == align;

  @override
  int get hashCode => Object.hash(side, align);

  @override
  String toString() => align == BsPlacementAlign.center ? side.name : '${side.name}-${align.name}';
}

/// A [BsPlacement] together with the nudge applied along the other axis to keep the overlay
/// inside the viewport.
@immutable
class BsResolvedPlacement {
  const BsResolvedPlacement(this.placement, [this.shift = Offset.zero]);

  final BsPlacement placement;
  final Offset shift;

  /// How far [shift] moved the overlay along the axis its arrow slides on
  /// (x for top/bottom, y for left/right).
  double get alongShift => placement.side.isVertical ? shift.dx : shift.dy;

  @override
  bool operator ==(Object other) =>
      other is BsResolvedPlacement && other.placement == placement && other.shift == shift;

  @override
  int get hashCode => Object.hash(placement, shift);

  @override
  String toString() => '$placement + $shift';
}

/// Chooses where an overlay goes so that it stays on screen, as Bootstrap's dropdowns,
/// popovers and tooltips do.
///
/// Starting from [preferred], tries the same side with the opposite alignment (skipped for
/// centered placements, which have none), then the opposite side with each alignment, and takes
/// the first placement that leaves the overlay entirely inside [viewport]. If none does it
/// settles for the first one that at least clears the side it opens towards (and, failing that,
/// the preferred one). The result is then slid along the alignment axis, if need be, so that
/// the overlay does not poke out of the viewport.
///
/// [target] is the trigger's rect and [content] the overlay's size, both in the viewport's
/// coordinate space. With [flip] false only the shift is applied.
BsResolvedPlacement resolvePlacement({
  required BsPlacement preferred,
  required Rect target,
  required Size content,
  required Rect viewport,
  required double spacer,
  bool flip = true,
}) {
  double overflow(Rect r, BsPlacementSide side) => switch (side) {
    BsPlacementSide.top => viewport.top - r.top,
    BsPlacementSide.bottom => r.bottom - viewport.bottom,
    BsPlacementSide.left => viewport.left - r.left,
    BsPlacementSide.right => r.right - viewport.right,
  };

  // Three checks per placement: the side it opens towards, then the two sides along the
  // alignment axis (the far one first).
  List<bool> checks(BsPlacement p) {
    final r = p.rect(target, content, spacer);
    final (far, near) = p.side.isVertical
        ? (p.align == BsPlacementAlign.start
              ? (BsPlacementSide.right, BsPlacementSide.left)
              : (BsPlacementSide.left, BsPlacementSide.right))
        : (p.align == BsPlacementAlign.start
              ? (BsPlacementSide.bottom, BsPlacementSide.top)
              : (BsPlacementSide.top, BsPlacementSide.bottom));
    return [overflow(r, p.side) <= 0, overflow(r, far) <= 0, overflow(r, near) <= 0];
  }

  var chosen = preferred;
  if (flip) {
    final candidates = <BsPlacement>[
      preferred,
      if (preferred.align != BsPlacementAlign.center) preferred.oppositeVariation,
      preferred.opposite,
      if (preferred.align != BsPlacementAlign.center) preferred.opposite.oppositeVariation,
    ];
    final results = {for (final p in candidates) p: checks(p)};
    final fitting = candidates.where((p) => results[p]!.every((ok) => ok));
    if (fitting.isNotEmpty) {
      chosen = fitting.first;
    } else {
      for (var n = 3; n > 0; n--) {
        final partial = candidates.where((p) => results[p]!.take(n).every((ok) => ok));
        if (partial.isNotEmpty) {
          chosen = partial.first;
          break;
        }
      }
    }
  }

  final r = chosen.rect(target, content, spacer);
  double slide(double start, double end, double vStart, double vEnd) {
    var d = 0.0;
    if (end > vEnd) d = vEnd - end;
    if (start + d < vStart) d = vStart - start; // too big to fit: favour the start edge
    return d;
  }

  final shift = chosen.side.isVertical
      ? Offset(slide(r.left, r.right, viewport.left, viewport.right), 0)
      : Offset(0, slide(r.top, r.bottom, viewport.top, viewport.bottom));
  return BsResolvedPlacement(chosen, shift);
}

/// How far to slide a popover or tooltip arrow so that it keeps pointing at the trigger after
/// [shift] moved the bubble: the opposite way, but never past [padding] (the bubble's corner
/// radius) from either end of a bubble [contentExtent] long.
double arrowShift({
  required double shift,
  required double contentExtent,
  required double arrowExtent,
  required double padding,
}) {
  final max = (contentExtent - arrowExtent) / 2 - padding;
  if (max <= 0) return 0;
  return (-shift).clamp(-max, max);
}

/// Shared open-time bookkeeping for anything that places an overlay next to a trigger and
/// flips it to stay on screen ([BsDropdown], [BsPopover], [BsTooltip]).
///
/// The overlay is first laid out invisibly at [preferredPlacement] so that its size is known
/// ([placementPending] says to hide it); the first frame after [startResolvingPlacement]
/// measures it against the trigger and the screen and stores the outcome in
/// [resolvedPlacement]. It then re-measures after every frame while [placementActive], so the
/// overlay follows its trigger when the page scrolls or resizes. Re-registering from inside a
/// post-frame callback does not schedule a frame of its own, so an idle open overlay costs
/// nothing.
///
/// Wrap the trigger in a [CompositedTransformTarget] keyed [placementTargetKey]
/// and the overlay's own root widget in [placementContentKey].
mixin BsPlacementTracker<T extends StatefulWidget> on State<T> {
  final placementTargetKey = GlobalKey();
  final placementContentKey = GlobalKey();

  BsResolvedPlacement? _resolvedPlacement;
  Size? _contentSize;
  bool _tracking = false;

  /// The placement asked for, before any flipping.
  BsPlacement get preferredPlacement;

  /// The gap between trigger and overlay.
  double get placementSpacer => 0;

  /// Whether to keep the overlay on screen by flipping and shifting it; false opens exactly at
  /// [preferredPlacement].
  bool get flipEnabled => true;

  /// Whether the overlay is currently open (tracking stops once it isn't).
  bool get placementActive;

  /// Called after each measurement, with whether the outcome changed. Defaults
  /// to a [setState] when it did.
  void placementChanged() => setState(() {});

  /// Where the overlay goes right now: the measured result, or the preferred
  /// placement until the first measurement.
  BsResolvedPlacement get currentPlacement => _resolvedPlacement ?? BsResolvedPlacement(preferredPlacement);

  /// The overlay's measured size, once known.
  Size? get placementContentSize => _contentSize;

  /// True while the overlay is open but not yet measured, and so should be
  /// invisible and inert.
  bool get placementPending => flipEnabled && _resolvedPlacement == null;

  /// Forget the last measurement; call when the overlay opens.
  void resetPlacement() {
    _resolvedPlacement = null;
    _contentSize = null;
  }

  void startResolvingPlacement() {
    if (_tracking) return;
    _tracking = true;
    WidgetsBinding.instance.addPostFrameCallback(_placementStep);
  }

  void _placementStep(Duration _) {
    if (!mounted || !placementActive) {
      _tracking = false;
      return;
    }
    _measurePlacement();
    WidgetsBinding.instance.addPostFrameCallback(_placementStep);
  }

  void _measurePlacement() {
    if (!flipEnabled) return;
    final target = placementTargetKey.currentContext?.findRenderObject();
    final content = placementContentKey.currentContext?.findRenderObject();
    if (target is! RenderBox || content is! RenderBox || !target.hasSize || !content.hasSize || !target.attached) {
      return;
    }
    final resolved = resolvePlacement(
      preferred: preferredPlacement,
      target: target.localToGlobal(Offset.zero) & target.size,
      content: content.size,
      viewport: Offset.zero & MediaQuery.sizeOf(context),
      spacer: placementSpacer,
    );
    if (resolved != _resolvedPlacement || content.size != _contentSize) {
      _resolvedPlacement = resolved;
      _contentSize = content.size;
      placementChanged();
    }
  }
}
