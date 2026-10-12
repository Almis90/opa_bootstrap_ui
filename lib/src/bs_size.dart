/// Bootstrap component sizing, as used by buttons, form controls, input groups and so on.
enum BsSize {
  sm,
  normal,
  lg;

  /// Bootstrap's name for this size, as used in its utility names (for example `sm`).
  String? get className => this == BsSize.normal ? null : name;
}
