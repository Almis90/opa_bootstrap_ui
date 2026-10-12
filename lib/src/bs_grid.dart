import 'bs_breakpoint.dart';

/// Bootstrap's grid system tokens: column count, gutter width and each breakpoint's container
/// maximum width, assuming the default 16 logical pixel base font size.
abstract final class BsGrid {
  /// The number of columns in a row.
  static const int columns = 12;

  /// The horizontal gap between columns.
  static const double gutterWidth = 24;

  /// The largest number of columns a row can be divided into with equal-width columns.
  static const int rowColumns = 6;

  /// A container's horizontal padding: half of [gutterWidth], the other half being supplied by
  /// the row inside it.
  static const double containerPaddingX = gutterWidth / 2;

  /// A container's maximum width at each breakpoint. [BsBreakpoint.xs] has no entry: a container
  /// is full-width until `sm`.
  static const Map<BsBreakpoint, double> containerMaxWidths = {
    BsBreakpoint.sm: 540,
    BsBreakpoint.md: 720,
    BsBreakpoint.lg: 960,
    BsBreakpoint.xl: 1140,
    BsBreakpoint.xxl: 1320,
  };

  /// The maximum width a container should take at [breakpoint], or null for [BsBreakpoint.xs]
  /// (full-width).
  static double? containerMaxWidthFor(BsBreakpoint breakpoint) => containerMaxWidths[breakpoint];
}
