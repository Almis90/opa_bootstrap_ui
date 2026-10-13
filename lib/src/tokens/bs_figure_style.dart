import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'bs_body.dart';

/// Visual variables of a Bootstrap figure.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsFigureStyle {
  const BsFigureStyle({this.captionFontSize, this.captionColor});

  final double? captionFontSize;

  final Color? captionColor;

  BsFigureStyle merge(BsFigureStyle? other) {
    if (other == null) return this;
    return BsFigureStyle(
      captionFontSize: other.captionFontSize ?? captionFontSize,
      captionColor: other.captionColor ?? captionColor,
    );
  }

  static const double defaultCaptionFontSize = 14;

  static const Color defaultCaptionColor = BsBody.secondaryColor;

  static const Color defaultDarkCaptionColor = BsBody.darkSecondaryColor;

  static const BsFigureStyle defaults = BsFigureStyle(
    captionFontSize: defaultCaptionFontSize,
    captionColor: defaultCaptionColor,
  );

  /// Dark-mode counterpart of [defaults]: [captionColor] is swapped, the rest is identical. Use it
  /// as the base to [merge] a caller's override when the ambient brightness is dark.
  static const BsFigureStyle darkDefaults = BsFigureStyle(
    captionFontSize: defaultCaptionFontSize,
    captionColor: defaultDarkCaptionColor,
  );
}
