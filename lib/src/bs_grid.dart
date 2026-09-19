import 'bs_breakpoint.dart';

/// Bootstrap's grid system tokens: column count, gutter width, and each
/// breakpoint's container max-width.
///
/// Mirrors the `$grid-columns`, `$grid-gutter-width`, `$grid-row-columns`,
/// `$container-padding-x` and `$container-max-widths` variables from
/// Bootstrap's SCSS source (assuming the default `16px` root font size).
abstract final class BsGrid {
  /// `$grid-columns` — the number of columns in a `.row`.
  static const int columns = 12;

  /// `$grid-gutter-width` (`1.5rem`) — the horizontal gap between columns.
  static const double gutterWidth = 24;

  /// `$grid-row-columns` — the max value supported by `.row-cols-*`.
  static const int rowColumns = 6;

  /// `$container-padding-x` (`$grid-gutter-width`) — a `.container`'s
  /// horizontal padding.
  static const double containerPaddingX = gutterWidth;

  /// `$container-max-widths` — a `.container`'s max width at each
  /// breakpoint. `xs` has no entry (a container is full-width until `sm`),
  /// matching Bootstrap's map, which also starts at `sm`.
  static const Map<BsBreakpoint, double> containerMaxWidths = {
    BsBreakpoint.sm: 540,
    BsBreakpoint.md: 720,
    BsBreakpoint.lg: 960,
    BsBreakpoint.xl: 1140,
    BsBreakpoint.xxl: 1320,
  };

  /// The max width a `.container` should take at [breakpoint], or null for
  /// [BsBreakpoint.xs] (full-width).
  static double? containerMaxWidthFor(BsBreakpoint breakpoint) => containerMaxWidths[breakpoint];
}
