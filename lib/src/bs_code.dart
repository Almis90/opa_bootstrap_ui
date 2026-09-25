import 'package:flutter/widgets.dart';

import 'tokens/bs_borders.dart';
import 'tokens/bs_code_style.dart';
import 'tokens/bs_typography.dart';

/// `code`: an inline, monospaced, [BsCodeStyle.codeColor]-tinted span.
class BsCode extends StatelessWidget {
  const BsCode({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsCodeStyle.defaults].
  final BsCodeStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsCodeStyle.defaults.merge(this.style);
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontFamily: BsTypography.fontFamilyMonospace.first,
        fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
        fontSize: style.codeFontSize ?? BsCodeStyle.defaultCodeFontSize,
        color: style.codeColor ?? BsCodeStyle.defaultCodeColor,
      ),
      child: child,
    );
  }
}

/// `kbd`: an inline, monospaced keyboard-input span with a dark, rounded
/// background.
class BsKbd extends StatelessWidget {
  const BsKbd({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsCodeStyle.defaults].
  final BsCodeStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsCodeStyle.defaults.merge(this.style);
    return Container(
      padding: style.kbdPadding ?? BsCodeStyle.defaultKbdPadding,
      decoration: BoxDecoration(
        color: style.kbdBackground ?? BsCodeStyle.defaultKbdBackground,
        borderRadius: BorderRadius.circular(BsBorders.radiusSm),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontFamily: BsTypography.fontFamilyMonospace.first,
          fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
          fontSize: style.kbdFontSize ?? BsCodeStyle.defaultKbdFontSize,
          fontWeight: FontWeight.bold,
          color: style.kbdColor ?? BsCodeStyle.defaultKbdColor,
        ),
        child: child,
      ),
    );
  }
}

/// `pre`: a block of preformatted, monospaced text.
class BsPre extends StatelessWidget {
  const BsPre({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsCodeStyle.defaults].
  final BsCodeStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsCodeStyle.defaults.merge(this.style);
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontFamily: BsTypography.fontFamilyMonospace.first,
        fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
        fontSize: style.codeFontSize ?? BsCodeStyle.defaultCodeFontSize,
        color: style.preColor,
      ),
      child: child,
    );
  }
}
