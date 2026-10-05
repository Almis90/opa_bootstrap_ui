import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'bs_flex.dart';
import 'bs_grid.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';

/// A Bootstrap container (`.container`): a centered, width-capped box that
/// applies [BsGrid.containerPaddingX] and constrains itself to
/// [BsGrid.containerMaxWidths] at each breakpoint — the breakpoint of the
/// viewport (the window), as in Bootstrap's CSS.
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
    this.px,
    this.py,
    this.my,
    this.col,
    this.alignment = Alignment.topCenter,
  }) : fluid = false,
       minBreakpoint = null;

  const BsContainer.responsiveFrom(
    this.minBreakpoint, {
    super.key,
    required this.child,
    this.padding,
    this.px,
    this.py,
    this.my,
    this.col,
    this.alignment = Alignment.topCenter,
  }) : fluid = false;

  const BsContainer.fluid({
    super.key,
    required this.child,
    this.padding,
    this.px,
    this.py,
    this.my,
    this.col,
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

  /// `px-*` on the container: horizontal padding in place of the default
  /// `$grid-gutter-width`/2 (`container px-4`). Ignored if [padding] is given.
  final BsResponsive<BsSpacing>? px;

  /// `py-*`: vertical padding. Ignored if [padding] is given.
  final BsResponsive<BsSpacing>? py;

  /// `my-*`: vertical margin (`container my-5`).
  final BsResponsive<BsSpacing>? my;

  /// `col-*` on the container (`container col-xxl-8`): its width as a share of
  /// 12 columns of its parent, still capped by the container's max-width.
  final BsResponsive<BsCol>? col;

  /// How to align the (possibly narrower-than-parent) container box.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The *viewport's* breakpoint, as Bootstrap's `.container` media queries
        // use — not the width this container happens to be given, which is
        // narrower wherever the page pads or indents it (a `p-3` header, a
        // sidebar layout) and would pick a smaller breakpoint's max-width.
        final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
        final constrained =
            !fluid &&
            (minBreakpoint == null || breakpoint.index >= minBreakpoint!.index);
        final maxWidth = constrained
            ? BsGrid.containerMaxWidthFor(breakpoint)
            : null;

        final columns = col?.resolve(breakpoint)?.columns;
        final width = columns != null && constraints.hasBoundedWidth
            ? constraints.maxWidth * columns / 12
            : double.infinity;
        final margin = my?.resolve(breakpoint)?.size ?? 0;
        Widget container = Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
            child: SizedBox(
              width: width,
              child: Padding(
                padding:
                    padding ??
                    EdgeInsets.symmetric(
                      horizontal:
                          px?.resolve(breakpoint)?.size ??
                          BsGrid.containerPaddingX,
                      vertical: py?.resolve(breakpoint)?.size ?? 0,
                    ),
                child: child,
              ),
            ),
          ),
        );
        if (margin != 0) {
          container = Padding(
            padding: EdgeInsets.symmetric(vertical: margin),
            child: container,
          );
        }
        return container;
      },
    );
  }
}
