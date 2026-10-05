import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// `<code>` inside running text: Reboot's `.875em` monospace in `$code-color`.
InlineSpan codeSpan(BuildContext context, String text) {
  final dark = BsTheme.of(context) == Brightness.dark;
  final style = dark ? BsCodeStyle.darkDefaults : BsCodeStyle.defaults;
  final base = DefaultTextStyle.of(context).style.fontSize ?? 16;
  return TextSpan(
    text: text,
    style: TextStyle(
      fontFamily: BsTypography.fontFamilyMonospace.first,
      fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
      fontSize: base * 0.875,
      color: style.codeColor ?? BsCodeStyle.defaultCodeColor,
    ),
  );
}
