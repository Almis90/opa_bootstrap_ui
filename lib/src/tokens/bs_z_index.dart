/// Bootstrap's global stacking order. Avoid customizing these values: they are
/// designed to work together.
abstract final class BsZIndex {
  static const int dropdown = 1000;

  static const int sticky = 1020;

  static const int fixed = 1030;

  static const int offcanvasBackdrop = 1040;

  static const int offcanvas = 1045;

  static const int modalBackdrop = 1050;

  static const int modal = 1055;

  static const int popover = 1070;

  static const int tooltip = 1080;

  static const int toast = 1090;
}
