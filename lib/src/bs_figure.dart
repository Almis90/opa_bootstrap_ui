import 'package:flutter/widgets.dart';

import 'tokens/bs_figure_style.dart';

/// A Bootstrap figure (`<figure class="figure">`): an [image] with an
/// optional [caption] underneath.
class BsFigure extends StatelessWidget {
  const BsFigure({super.key, required this.image, this.caption});

  /// Typically an [Image].
  final Widget image;

  /// Typically a [BsFigureCaption].
  final Widget? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [image, ?caption],
    );
  }
}

/// `.figure-caption`: a small, muted caption for a [BsFigure].
class BsFigureCaption extends StatelessWidget {
  const BsFigureCaption({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsFigureStyle.defaults].
  final BsFigureStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsFigureStyle.defaults.merge(this.style);
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: style.captionFontSize ?? BsFigureStyle.defaultCaptionFontSize,
        color: style.captionColor ?? BsFigureStyle.defaultCaptionColor,
      ),
      child: child,
    );
  }
}
