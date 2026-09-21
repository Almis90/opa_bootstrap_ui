import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'bs_grid.dart';

/// A Bootstrap container (`.container`): a centered, width-capped box that
/// applies [BsGrid.containerPaddingX] and constrains itself to
/// [BsGrid.containerMaxWidths] at each breakpoint.
///
/// - [BsContainer.new] mirrors `.container`, applying a max-width from `sm`
///   upward and staying full-width below it.
/// - [BsContainer.responsiveFrom] mirrors `.container-{breakpoint}`, staying
///   full-width until [minBreakpoint] and applying a max-width from there up.
/// - [BsContainer.fluid] mirrors `.container-fluid`, always full-width.
class BsContainer extends StatelessWidget {
  const BsContainer({
    super.key,
    required this.child,
    this.padding,
    this.alignment = Alignment.topCenter,
  }) : fluid = false,
       minBreakpoint = null;

  const BsContainer.responsiveFrom(
    this.minBreakpoint, {
    super.key,
    required this.child,
    this.padding,
    this.alignment = Alignment.topCenter,
  }) : fluid = false;

  const BsContainer.fluid({
    super.key,
    required this.child,
    this.padding,
    this.alignment = Alignment.topCenter,
  }) : fluid = true,
       minBreakpoint = null;

  /// The container's content.
  final Widget child;

  /// Whether this is a `.container-fluid` (always full-width).
  final bool fluid;

  /// For `.container-{breakpoint}`: the breakpoint at and above which a
  /// max-width applies. Null for plain `.container` (max-width from `sm`
  /// up) and ignored when [fluid] is true.
  final BsBreakpoint? minBreakpoint;

  /// Horizontal (and any vertical) padding. Defaults to
  /// `EdgeInsets.symmetric(horizontal: BsGrid.containerPaddingX)`.
  final EdgeInsetsGeometry? padding;

  /// How to align the (possibly narrower-than-parent) container box.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = BsBreakpoint.forWidth(constraints.maxWidth);
        final constrained =
            !fluid &&
            (minBreakpoint == null || breakpoint.index >= minBreakpoint!.index);
        final maxWidth = constrained
            ? BsGrid.containerMaxWidthFor(breakpoint)
            : null;

        return Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    padding ??
                    const EdgeInsets.symmetric(
                      horizontal: BsGrid.containerPaddingX,
                    ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
