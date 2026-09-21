import 'package:flutter/widgets.dart';

import 'tokens/bs_form_style.dart';

/// `.form-label`: a form field's label, with a bottom margin separating it
/// from the control.
class BsFormLabel extends StatelessWidget {
  const BsFormLabel({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsFormStyle.defaults.merge(this.style);
    return Padding(
      padding: EdgeInsets.only(
        bottom: style.labelMarginBottom ?? BsFormStyle.defaultLabelMarginBottom,
      ),
      child: child,
    );
  }
}

/// `.form-text`: small, muted help text below a form field.
class BsFormText extends StatelessWidget {
  const BsFormText({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsFormStyle.defaults.merge(this.style);
    return Padding(
      padding: EdgeInsets.only(
        top: style.textMarginTop ?? BsFormStyle.defaultTextMarginTop,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: style.textFontSize ?? BsFormStyle.defaultTextFontSize,
          color: style.textColor ?? BsFormStyle.defaultTextColor,
        ),
        child: child,
      ),
    );
  }
}
