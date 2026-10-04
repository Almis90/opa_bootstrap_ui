import 'bs_breakpoint.dart';

/// Anything that yields a value of type [T] at a given [BsBreakpoint]: a
/// [BsResponsiveValue] that varies per breakpoint, or a plain value (a
/// [BsSpacing], [BsJustify]…) that is the same at all of them.
///
/// It lets a utility prop take either form, as Bootstrap's classes do —
/// `mb-3` is `mb: BsSpacing.s3`, `mb-3 mb-md-0` is
/// `mb: BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0)` — with the
/// type checker still on your side.
abstract interface class BsResponsive<T> {
  /// The effective value at [breakpoint], or null if none applies there (nor at
  /// any smaller breakpoint).
  T? resolve(BsBreakpoint breakpoint);
}

/// A value that can vary per [BsBreakpoint], cascading mobile-first the
/// same way Bootstrap's responsive utility classes do: a value set at a
/// given breakpoint applies at that breakpoint and all wider ones, until
/// overridden by a value set at a larger breakpoint.
class BsResponsiveValue<T> implements BsResponsive<T> {
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
  @override
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
