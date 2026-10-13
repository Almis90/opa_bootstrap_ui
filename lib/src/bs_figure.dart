import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
import 'tokens/bs_figure_style.dart';

/// A Bootstrap figure: an [image] with an optional [caption] underneath.
///
/// The figure is as wide as its widest part, as an inline block is, and the [caption] is as wide
/// as the figure, so that the text alignment of a box around it aligns the caption with the
/// image. The [image] has to be able to tell its width, as an [Image] or a `BsImage` can.
class BsFigure extends StatelessWidget {
  const BsFigure({super.key, required this.image, this.caption});

  /// Typically an [Image].
  final Widget image;

  /// Typically a [BsFigureCaption]. It sits 8 logical pixels under the image.
  final Widget? caption;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          image,
          if (caption != null) const SizedBox(height: 8),
          ?caption,
        ],
      ),
    );
  }
}

/// A small, muted caption for a [BsFigure].
class BsFigureCaption extends StatelessWidget {
  const BsFigureCaption({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsFigureStyle.defaults].
  final BsFigureStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFigureStyle.darkDefaults : BsFigureStyle.defaults)
        .merge(this.style);
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: style.captionFontSize ?? BsFigureStyle.defaultCaptionFontSize,
        color: style.captionColor ?? BsFigureStyle.defaultCaptionColor,
      ),
      child: child,
    );
  }
}
