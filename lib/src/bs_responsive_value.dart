import 'bs_breakpoint.dart';

/// A value that can vary per [BsBreakpoint], cascading mobile-first the
/// same way Bootstrap's responsive utility classes do: a value set at a
/// given breakpoint applies at that breakpoint and all wider ones, until
/// overridden by a value set at a larger breakpoint.
class BsResponsiveValue<T> {
  const BsResponsiveValue({this.xs, this.sm, this.md, this.lg, this.xl, this.xxl});

  /// A single value that applies at every breakpoint.
  const BsResponsiveValue.all(T value)
      : xs = value,
        sm = null,
        md = null,
        lg = null,
        xl = null,
        xxl = null;

  final T? xs;
  final T? sm;
  final T? md;
  final T? lg;
  final T? xl;
  final T? xxl;

  T? _valueFor(BsBreakpoint breakpoint) {
    switch (breakpoint) {
      case BsBreakpoint.xs:
        return xs;
      case BsBreakpoint.sm:
        return sm;
      case BsBreakpoint.md:
        return md;
      case BsBreakpoint.lg:
        return lg;
      case BsBreakpoint.xl:
        return xl;
      case BsBreakpoint.xxl:
        return xxl;
    }
  }

  /// Resolves the effective value at [breakpoint], cascading down from the
  /// largest breakpoint that has a value set, mobile-first.
  ///
  /// Returns null if no value is set at [breakpoint] or any smaller one.
  T? resolve(BsBreakpoint breakpoint) {
    for (var i = breakpoint.index; i >= 0; i--) {
      final value = _valueFor(BsBreakpoint.values[i]);
      if (value != null) return value;
    }
    return null;
  }

  /// Resolves the effective value for the given viewport [width].
  T? resolveForWidth(double width) => resolve(BsBreakpoint.forWidth(width));
}
