/// Bootstrap's spacing scale, used by the margin/padding/gap utilities
/// (e.g. `m-3`, `px-2`, `gap-4`).
///
/// Mirrors the `$spacers` map from Bootstrap's SCSS source, expressed as
/// multiples of `$spacer` (1rem): 0, .25rem, .5rem, 1rem, 1.5rem, 3rem.
enum BsSpacing {
  s0(0, 0),
  s1(1, 0.25),
  s2(2, 0.5),
  s3(3, 1),
  s4(4, 1.5),
  s5(5, 3);

  const BsSpacing(this.step, this.rem);

  /// The Bootstrap step number (0-5), as used in class names like `m-3`.
  final int step;

  /// The size in rem units, assuming the default `$spacer: 1rem`.
  final double rem;

  /// The CSS class suffix used by Bootstrap, e.g. `3` in `m-3`.
  String get className => step.toString();
}
