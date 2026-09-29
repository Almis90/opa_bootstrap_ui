import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
import 'tokens/bs_thumbnail_style.dart';

/// A Bootstrap thumbnail (`.img-thumbnail`): a bordered, padded, rounded
/// frame around [child], typically an [Image].
class BsThumbnail extends StatelessWidget {
  const BsThumbnail({super.key, required this.child, this.style});

  /// Typically an [Image].
  final Widget child;

  /// Style overrides layered on top of [BsThumbnailStyle.defaults].
  final BsThumbnailStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsThumbnailStyle.darkDefaults : BsThumbnailStyle.defaults).merge(this.style);
    final padding = style.padding ?? BsThumbnailStyle.defaultPadding;
    final borderWidth = style.borderWidth ?? BsThumbnailStyle.defaultBorderWidth;
    final borderColor = style.borderColor ?? BsThumbnailStyle.defaultBorderColor;
    final borderRadius = style.borderRadius ?? BsThumbnailStyle.defaultBorderRadius;
    final background = style.background ?? BsThumbnailStyle.defaultBackground;
    final radius = BorderRadius.circular(borderRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: radius,
        boxShadow: style.boxShadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Padding(padding: EdgeInsets.all(padding), child: child),
      ),
    );
  }
}
