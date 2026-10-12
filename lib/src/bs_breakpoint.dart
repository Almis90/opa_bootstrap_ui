/// Bootstrap's responsive breakpoints, from the smallest (`xs`) to the largest (`xxl`).
enum BsBreakpoint {
  xs(0),
  sm(576),
  md(768),
  lg(992),
  xl(1200),
  xxl(1400);

  const BsBreakpoint(this.minWidth);

  /// The minimum viewport width (in logical pixels) at which this breakpoint applies.
  final double minWidth;

  /// Returns the breakpoint that applies to [width], i.e. the largest
  /// breakpoint whose [minWidth] is `<= width`.
  static BsBreakpoint forWidth(double width) {
    var result = BsBreakpoint.xs;
    for (final breakpoint in BsBreakpoint.values) {
      if (width >= breakpoint.minWidth) {
        result = breakpoint;
      }
    }
    return result;
  }
}
