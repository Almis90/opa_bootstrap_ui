/// Bootstrap's global z-index stacking order.
///
/// Mirrors the `zindex-stack` group from Bootstrap's SCSS source
/// (`$zindex-*`). Avoid customizing these values; they're designed to all
/// work together, the same way Bootstrap warns against changing them.
abstract final class BsZIndex {
  /// `$zindex-dropdown`.
  static const int dropdown = 1000;

  /// `$zindex-sticky`.
  static const int sticky = 1020;

  /// `$zindex-fixed`.
  static const int fixed = 1030;

  /// `$zindex-offcanvas-backdrop`.
  static const int offcanvasBackdrop = 1040;

  /// `$zindex-offcanvas`.
  static const int offcanvas = 1045;

  /// `$zindex-modal-backdrop`.
  static const int modalBackdrop = 1050;

  /// `$zindex-modal`.
  static const int modal = 1055;

  /// `$zindex-popover`.
  static const int popover = 1070;

  /// `$zindex-tooltip`.
  static const int tooltip = 1080;

  /// `$zindex-toast`.
  static const int toast = 1090;
}
