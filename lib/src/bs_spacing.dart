import 'bs_breakpoint.dart';
import 'bs_responsive_value.dart';

/// Bootstrap's spacing scale, used by the margin, padding and gap utilities: 0, 0.25, 0.5, 1,
/// 1.5 and 3 times the base spacing (16 logical pixels), plus [auto], which the margin
/// utilities accept.
///
/// A [BsSpacing] is itself a [BsResponsive] value, so it can be passed straight to a utility
/// prop (`BsBox(py: BsSpacing.s3)`) or wrapped in a [BsResponsiveValue] to vary per
/// breakpoint.
enum BsSpacing implements BsResponsive<BsSpacing> {
  s0(0, 0),
  s1(1, 0.25),
  s2(2, 0.5),
  s3(3, 1),
  s4(4, 1.5),
  s5(5, 3),

  /// Only valid for margins: a flex item's auto margin absorbs the free space on its side (an
  /// end margin pushes what follows to the end).
  auto(-1, 0);

  const BsSpacing(this.step, this.rem);

  /// The Bootstrap step number (0 to 5); -1 for [auto].
  final int step;

  /// The size as a multiple of the 16 logical pixel base spacing.
  final double rem;

  /// Bootstrap's name for this value, as used in its utility names.
  String get className => this == auto ? 'auto' : step.toString();

  /// The size in logical pixels, assuming the default `16px` root font size.
  /// 0 for [auto].
  double get size => rem * 16;

  @override
  BsSpacing resolve(BsBreakpoint breakpoint) => this;
}
