/// Bootstrap's global stacking order. Avoid customizing these values: they are
/// designed to work together.
abstract final class BsZIndex {
  /// Dropdown menus.
  static const int dropdown = 1000;

  /// Sticky elements.
  static const int sticky = 1020;

  /// Fixed elements.
  static const int fixed = 1030;

  /// The offcanvas backdrop.
  static const int offcanvasBackdrop = 1040;

  /// Offcanvas panels.
  static const int offcanvas = 1045;

  /// The modal backdrop.
  static const int modalBackdrop = 1050;

  /// Modal dialogs.
  static const int modal = 1055;

  /// Popovers.
  static const int popover = 1070;

  /// Tooltips.
  static const int tooltip = 1080;

  /// Toasts.
  static const int toast = 1090;
}
