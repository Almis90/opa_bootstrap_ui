import 'package:flutter/widgets.dart';

import 'bs_button.dart';
import 'bs_button_style.dart';
import 'bs_size.dart';

/// A Bootstrap button group (`.btn-group`/`.btn-group-vertical`): a row (or
/// column) of [BsButton]s rendered as one visual block, with only the
/// group's outer corners rounded and a shared size applied uniformly.
///
/// Mirrors `scss/_button-group.scss`, which has no dedicated variables of
/// its own — corner rounding reuses `$btn-border-radius`, and `.btn-group-sm`
/// /`.btn-group-lg` just re-apply the regular button size classes. Adjacent
/// buttons overlap by one border width, per Bootstrap's
/// `margin-left: calc(-1 * $btn-border-width)`, so the seam between them
/// reads as a single shared border rather than a doubled-up one.
class BsButtonGroup extends StatelessWidget {
  const BsButtonGroup({super.key, required this.children, this.vertical = false, this.size});

  /// The buttons to group. Each keeps its own [BsButton.variant]/
  /// [BsButton.outline]/[BsButton.style]; only [BsButton.size] and the
  /// corner radii are overridden by the group.
  final List<BsButton> children;

  /// Whether to stack the buttons vertically (`.btn-group-vertical`)
  /// instead of side by side.
  final bool vertical;

  /// Applies this size to every child, per `.btn-group-sm`/`.btn-group-lg`.
  /// Leaves each child's own [BsButton.size] alone when null.
  final BsSize? size;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final widgets = <Widget>[];
    var cumulativeOverlap = 0.0;
    for (var i = 0; i < children.length; i++) {
      final button = children[i];
      final effectiveSize = size ?? button.size;
      final radius = switch (effectiveSize) {
        BsSize.sm => BsButtonStyle.borderRadiusSm,
        BsSize.normal => BsButtonStyle.borderRadiusBase,
        BsSize.lg => BsButtonStyle.borderRadiusLg,
      };

      final isFirst = i == 0;
      final isLast = i == children.length - 1;
      final borderRadius = vertical
          ? BorderRadius.vertical(
              top: isFirst ? Radius.circular(radius) : Radius.zero,
              bottom: isLast ? Radius.circular(radius) : Radius.zero,
            )
          : BorderRadius.horizontal(
              left: isFirst ? Radius.circular(radius) : Radius.zero,
              right: isLast ? Radius.circular(radius) : Radius.zero,
            );

      final child = BsButton(
        key: button.key,
        onPressed: button.onPressed,
        variant: button.variant,
        outline: button.outline,
        size: effectiveSize,
        style: (button.style ?? const BsButtonStyle()).merge(BsButtonStyle(borderRadius: borderRadius)),
        active: button.active,
        noWrap: button.noWrap,
        focusNode: button.focusNode,
        autofocus: button.autofocus,
        child: button.child,
      );

      // Overlap adjacent buttons by one border width so each shared seam
      // reads as a single border, per Bootstrap's negative-margin trick.
      // Painted later, a button's own edge sits on top of its neighbor's.
      // Row/Column lay out each child at its natural (unshifted) slot, so
      // the shift must accumulate across every prior seam, not just the
      // immediately preceding one, or gaps reopen from the 3rd item on.
      if (!isFirst) {
        final borderWidth = button.style?.borderWidth ?? BsButtonStyle.defaultBorderWidth;
        cumulativeOverlap += borderWidth;
      }

      widgets.add(
        isFirst
            ? child
            : Transform.translate(
                offset: vertical ? Offset(0, -cumulativeOverlap) : Offset(-cumulativeOverlap, 0),
                child: child,
              ),
      );
    }

    return vertical
        ? Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets)
        : Row(mainAxisSize: MainAxisSize.min, children: widgets);
  }
}
