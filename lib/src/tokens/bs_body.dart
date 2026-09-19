import 'package:flutter/painting.dart';

import '../bs_colors.dart';

/// Bootstrap's `<body>` tokens — the base text/background colors many
/// components default to (e.g. `$modal-content-bg: var(--bs-body-bg)`).
///
/// Mirrors the `body-variables` group from Bootstrap's SCSS source.
abstract final class BsBody {
  /// `$body-color` (`$gray-900`).
  static const Color color = BsColors.gray900;

  /// `$body-bg` (`$white`).
  static const Color background = BsColors.white;

  /// `$body-secondary-color` (`rgba($body-color, .75)`).
  static const Color secondaryColor = Color(0xBF212529);

  /// `$body-secondary-bg` (`$gray-200`).
  static const Color secondaryBackground = BsColors.gray200;

  /// `$body-tertiary-color` (`rgba($body-color, .5)`).
  static const Color tertiaryColor = Color(0x80212529);

  /// `$body-tertiary-bg` (`$gray-100`).
  static const Color tertiaryBackground = BsColors.gray100;

  /// `$body-emphasis-color` (`$black`).
  static const Color emphasisColor = BsColors.black;
}
