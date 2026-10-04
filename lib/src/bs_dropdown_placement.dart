import 'package:flutter/widgets.dart';

import 'bs_dropdown.dart' show BsDropdownDirection;

/// The side of the toggle a menu sits on, in physical (not text-direction)
/// terms, as Popper.js names them.
enum BsDropdownSide {
  top,
  bottom,
  left,
  right;

  bool get isVertical => this == top || this == bottom;

  BsDropdownSide get opposite => switch (this) {
    top => bottom,
    bottom => top,
    left => right,
    right => left,
  };
}

/// A Popper-style placement (`bottom-start`, `top-end`, `right-start`…): a
/// [side] of the toggle plus where the menu lines up along the other axis.
///
/// [alignEnd] is physical too: for [BsDropdownSide.top]/[BsDropdownSide.bottom]
/// it means the menu's right edge meets the toggle's right edge (Popper's
/// `-end`, regardless of text direction), for left/right the bottom edges.
@immutable
class BsDropdownPlacement {
  const BsDropdownPlacement(this.side, {this.alignEnd = false});

  /// The placement [BsDropdown] asks for before any flipping, resolved against
  /// [textDirection]: `.dropdown` → `bottom-start`, `.dropup` → `top-start`,
  /// `.dropstart`/`.dropend` → `left-start`/`right-start` (swapped in RTL),
  /// with `.dropdown-menu-end` as [alignEnd].
  factory BsDropdownPlacement.preferred(
    BsDropdownDirection direction, {
    required bool alignEnd,
    required TextDirection textDirection,
  }) {
    final rtl = textDirection == TextDirection.rtl;
    return switch (direction) {
      BsDropdownDirection.down => BsDropdownPlacement(BsDropdownSide.bottom, alignEnd: alignEnd != rtl),
      BsDropdownDirection.up => BsDropdownPlacement(BsDropdownSide.top, alignEnd: alignEnd != rtl),
      BsDropdownDirection.start => BsDropdownPlacement(rtl ? BsDropdownSide.right : BsDropdownSide.left),
      BsDropdownDirection.end => BsDropdownPlacement(rtl ? BsDropdownSide.left : BsDropdownSide.right),
    };
  }

  final BsDropdownSide side;
  final bool alignEnd;

  /// Popper's `getOppositePlacement`: the other side, same alignment.
  BsDropdownPlacement get opposite => BsDropdownPlacement(side.opposite, alignEnd: alignEnd);

  /// Popper's `getOppositeVariationPlacement`: same side, other alignment.
  BsDropdownPlacement get oppositeVariation => BsDropdownPlacement(side, alignEnd: !alignEnd);

  /// The point on the toggle the menu attaches to.
  Alignment get targetAnchor => switch ((side, alignEnd)) {
    (BsDropdownSide.bottom, false) => Alignment.bottomLeft,
    (BsDropdownSide.bottom, true) => Alignment.bottomRight,
    (BsDropdownSide.top, false) => Alignment.topLeft,
    (BsDropdownSide.top, true) => Alignment.topRight,
    (BsDropdownSide.right, false) => Alignment.topRight,
    (BsDropdownSide.right, true) => Alignment.bottomRight,
    (BsDropdownSide.left, false) => Alignment.topLeft,
    (BsDropdownSide.left, true) => Alignment.bottomLeft,
  };

  /// The point on the menu that sits at [targetAnchor].
  Alignment get followerAnchor => switch ((side, alignEnd)) {
    (BsDropdownSide.bottom, false) => Alignment.topLeft,
    (BsDropdownSide.bottom, true) => Alignment.topRight,
    (BsDropdownSide.top, false) => Alignment.bottomLeft,
    (BsDropdownSide.top, true) => Alignment.bottomRight,
    (BsDropdownSide.right, false) => Alignment.topLeft,
    (BsDropdownSide.right, true) => Alignment.bottomLeft,
    (BsDropdownSide.left, false) => Alignment.topRight,
    (BsDropdownSide.left, true) => Alignment.bottomRight,
  };

  /// The gap [spacer] pushes the menu away from the toggle by.
  Offset offset(double spacer) => switch (side) {
    BsDropdownSide.bottom => Offset(0, spacer),
    BsDropdownSide.top => Offset(0, -spacer),
    BsDropdownSide.right => Offset(spacer, 0),
    BsDropdownSide.left => Offset(-spacer, 0),
  };

  /// Where the menu lands, in the same space as [target].
  Rect rect(Rect target, Size menu, double spacer) {
    final anchor = target.topLeft + Offset((targetAnchor.x + 1) / 2 * target.width, (targetAnchor.y + 1) / 2 * target.height);
    final origin = anchor + offset(spacer) - Offset((followerAnchor.x + 1) / 2 * menu.width, (followerAnchor.y + 1) / 2 * menu.height);
    return origin & menu;
  }

  @override
  bool operator ==(Object other) => other is BsDropdownPlacement && other.side == side && other.alignEnd == alignEnd;

  @override
  int get hashCode => Object.hash(side, alignEnd);

  @override
  String toString() => '${side.name}-${alignEnd ? 'end' : 'start'}';
}

/// A [BsDropdownPlacement] together with the nudge Popper's `preventOverflow`
/// applies along the other axis to keep the menu inside the viewport.
@immutable
class BsDropdownResolvedPlacement {
  const BsDropdownResolvedPlacement(this.placement, [this.shift = Offset.zero]);

  final BsDropdownPlacement placement;
  final Offset shift;

  @override
  bool operator ==(Object other) =>
      other is BsDropdownResolvedPlacement && other.placement == placement && other.shift == shift;

  @override
  int get hashCode => Object.hash(placement, shift);

  @override
  String toString() => '$placement + $shift';
}

/// Popper.js's default `flip` + `preventOverflow` modifiers, as Bootstrap's
/// dropdowns run them.
///
/// Starting from [preferred], tries the same side with the opposite
/// alignment, then the opposite side with each alignment, and takes the first
/// placement that leaves the menu entirely inside [viewport]. If none does it
/// settles for the first one that at least clears the side it opens towards
/// (and, failing that, the preferred one) — Popper's fallback checks. The
/// result is then slid along the alignment axis, if need be, so the menu
/// doesn't poke out of the viewport.
///
/// [target] is the toggle's rect and [menu] the menu's size, both in the
/// viewport's coordinate space. With [flip] false only the shift is applied.
BsDropdownResolvedPlacement resolveDropdownPlacement({
  required BsDropdownPlacement preferred,
  required Rect target,
  required Size menu,
  required Rect viewport,
  required double spacer,
  bool flip = true,
}) {
  double overflow(Rect r, BsDropdownSide side) => switch (side) {
    BsDropdownSide.top => viewport.top - r.top,
    BsDropdownSide.bottom => r.bottom - viewport.bottom,
    BsDropdownSide.left => viewport.left - r.left,
    BsDropdownSide.right => r.right - viewport.right,
  };

  // Popper's three checks per placement: the side it opens towards, then the
  // two sides along the alignment axis (the far one first).
  List<bool> checks(BsDropdownPlacement p) {
    final r = p.rect(target, menu, spacer);
    final (far, near) = p.side.isVertical
        ? (p.alignEnd ? (BsDropdownSide.left, BsDropdownSide.right) : (BsDropdownSide.right, BsDropdownSide.left))
        : (p.alignEnd ? (BsDropdownSide.top, BsDropdownSide.bottom) : (BsDropdownSide.bottom, BsDropdownSide.top));
    return [overflow(r, p.side) <= 0, overflow(r, far) <= 0, overflow(r, near) <= 0];
  }

  var chosen = preferred;
  if (flip) {
    final candidates = [
      preferred,
      preferred.oppositeVariation,
      preferred.opposite,
      preferred.opposite.oppositeVariation,
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

  final r = chosen.rect(target, menu, spacer);
  double slide(double start, double end, double vStart, double vEnd) {
    var d = 0.0;
    if (end > vEnd) d = vEnd - end;
    if (start + d < vStart) d = vStart - start; // too big to fit: favour the start edge
    return d;
  }

  final shift = chosen.side.isVertical
      ? Offset(slide(r.left, r.right, viewport.left, viewport.right), 0)
      : Offset(0, slide(r.top, r.bottom, viewport.top, viewport.bottom));
  return BsDropdownResolvedPlacement(chosen, shift);
}
