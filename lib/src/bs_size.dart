/// Bootstrap component sizing, as used by buttons, form controls, input
/// groups, etc. (e.g. `btn-sm`, `btn-lg`).
enum BsSize {
  sm,
  normal,
  lg;

  /// The CSS class suffix used by Bootstrap, e.g. `sm` in `btn-sm`.
  ///
  /// [normal] has no suffix, since it is Bootstrap's unmodified default.
  String? get className => this == BsSize.normal ? null : name;
}
