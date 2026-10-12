import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'bs_flex.dart';
import 'bs_grid.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';

/// A Bootstrap container: a centered, width-capped box that applies
/// [BsGrid.containerPaddingX] and constrains itself to [BsGrid.containerMaxWidths] at each
/// breakpoint, the breakpoint of the viewport (the window), as in Bootstrap.
///
/// - [BsContainer.new] applies a maximum width from `sm` upward and stays full-width below it.
/// - [BsContainer.responsiveFrom] stays full-width until [minBreakpoint] and applies a maximum
///   width from there up.
/// - [BsContainer.fluid] is always full-width.
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

  /// Whether the container is always full-width.
  final bool fluid;

  /// The breakpoint at and above which a maximum width applies. Null for the plain container
  /// (a maximum width from `sm` up) and ignored when [fluid] is true.
  final BsBreakpoint? minBreakpoint;

  /// Horizontal (and any vertical) padding. Defaults to
  /// `EdgeInsets.symmetric(horizontal: BsGrid.containerPaddingX)`.
  final EdgeInsetsGeometry? padding;

  /// Horizontal padding in place of the default half gutter. Ignored if [padding] is given.
  final BsResponsive<BsSpacing>? px;

  /// Vertical padding. Ignored if [padding] is given.
  final BsResponsive<BsSpacing>? py;

  /// Vertical margin.
  final BsResponsive<BsSpacing>? my;

  /// The container's width as a share of 12 columns of its parent, still capped by the
  /// container's maximum width.
  final BsResponsive<BsCol>? col;

  /// How to align the (possibly narrower-than-parent) container box.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The viewport's breakpoint, not the width this container happens to be given, which is
        // narrower wherever the page pads or indents it and would pick a smaller breakpoint's
        // maximum width.
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
