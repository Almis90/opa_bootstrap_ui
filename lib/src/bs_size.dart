/// Bootstrap component sizing, as used by buttons, form controls, input
/// groups, etc. (e.g. `btn-sm`, `btn-lg`).
enum BsSize {
  sm,
  normal,
  lg;

  /// Bootstrap's name for this size, as used in its utility names (for example `sm`).
  String? get className => this == BsSize.normal ? null : name;
}
