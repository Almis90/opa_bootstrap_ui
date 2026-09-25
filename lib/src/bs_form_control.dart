import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'bs_theme.dart';
import 'tokens/bs_form_style.dart';

/// `.form-control-sm`/(implicit default)/`.form-control-lg`: how tall and
/// large-text a [BsFormControl] renders.
enum BsFormControlSize { small, normal, large }

/// A Bootstrap text input (`.form-control`).
///
/// Built directly on [EditableText] (the same widgets-layer primitive
/// Material's `TextField` wraps), since this package has no Material/
/// Cupertino dependency to build a text field on top of — there's no
/// platform selection toolbar as a result; only basic typing, a caret, and
/// keyboard-driven selection are supported.
class BsFormControl extends StatefulWidget {
  const BsFormControl({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.keyboardType,
    this.size = BsFormControlSize.normal,
    this.valid,
    this.showBorder = true,
    this.onChanged,
    this.onSubmitted,
    this.style,
  });

  /// Defaults to an internally-owned controller when null.
  final TextEditingController? controller;

  /// Defaults to an internally-owned focus node when null.
  final FocusNode? focusNode;

  /// Shown, in [BsFormStyle.inputPlaceholderColor], while [controller] is
  /// empty.
  final String? placeholder;

  final bool obscureText;

  /// `.form-control:disabled`: greys out the background and blocks input.
  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  /// `1` for a single-line `<input>`; more for a `<textarea>`-like control.
  final int maxLines;

  final TextInputType? keyboardType;

  /// `.form-control-sm`/`.form-control-lg`.
  final BsFormControlSize size;

  /// `.is-valid`/`.is-invalid`: tints the border [BsFormStyle.validColor] or
  /// [BsFormStyle.invalidColor]. Null renders neither.
  final bool? valid;

  /// Set false inside a `BsInputGroup`, which draws one shared border
  /// around the whole group instead.
  final bool showBorder;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  State<BsFormControl> createState() => _BsFormControlState();
}

class _BsFormControlState extends State<BsFormControl> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults).merge(widget.style);
    final padding = switch (widget.size) {
      BsFormControlSize.small =>
        style.inputPaddingSm ?? BsFormStyle.defaultInputPaddingSm,
      BsFormControlSize.normal =>
        style.inputPadding ?? BsFormStyle.defaultInputPadding,
      BsFormControlSize.large =>
        style.inputPaddingLg ?? BsFormStyle.defaultInputPaddingLg,
    };
    final fontSize = switch (widget.size) {
      BsFormControlSize.small =>
        style.inputFontSizeSm ?? BsFormStyle.defaultInputFontSizeSm,
      BsFormControlSize.normal =>
        style.inputFontSize ?? BsFormStyle.defaultInputFontSize,
      BsFormControlSize.large =>
        style.inputFontSizeLg ?? BsFormStyle.defaultInputFontSizeLg,
    };
    final borderRadius = switch (widget.size) {
      BsFormControlSize.small =>
        style.inputBorderRadiusSm ?? BsFormStyle.defaultInputBorderRadiusSm,
      BsFormControlSize.normal =>
        style.inputBorderRadius ?? BsFormStyle.defaultInputBorderRadius,
      BsFormControlSize.large =>
        style.inputBorderRadiusLg ?? BsFormStyle.defaultInputBorderRadiusLg,
    };

    final focused = _focusNode.hasFocus;
    final borderColor = switch (widget.valid) {
      false => style.invalidColor ?? BsFormStyle.defaultInvalidColor,
      true => style.validColor ?? BsFormStyle.defaultValidColor,
      null when focused =>
        style.inputFocusBorderColor ?? BsFormStyle.defaultInputFocusBorderColor,
      null => style.inputBorderColor ?? BsFormStyle.defaultInputBorderColor,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.enabled
            ? (style.inputBackground ?? BsFormStyle.defaultInputBackground)
            : (style.inputDisabledBackground ??
                  BsFormStyle.defaultInputDisabledBackground),
        border: widget.showBorder
            ? Border.all(
                color: borderColor,
                width:
                    style.inputBorderWidth ??
                    BsFormStyle.defaultInputBorderWidth,
              )
            : null,
        borderRadius: widget.showBorder
            ? BorderRadius.circular(borderRadius)
            : null,
        boxShadow: widget.showBorder
            ? (focused ? style.inputFocusBoxShadow : style.inputBoxShadow)
            : null,
      ),
      child: Padding(
        padding: padding,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            if (widget.placeholder != null && _controller.text.isEmpty)
              Text(
                widget.placeholder!,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight:
                      style.inputFontWeight ?? BsFormStyle.defaultInputFontWeight,
                  color:
                      style.inputPlaceholderColor ??
                      BsFormStyle.defaultInputPlaceholderColor,
                ),
              ),
            EditableText(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              obscureText: widget.obscureText,
              readOnly: widget.readOnly || !widget.enabled,
              maxLines: widget.maxLines,
              keyboardType:
                  widget.keyboardType ??
                  (widget.maxLines == 1
                      ? TextInputType.text
                      : TextInputType.multiline),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight:
                    style.inputFontWeight ?? BsFormStyle.defaultInputFontWeight,
                color: style.inputColor ?? BsFormStyle.defaultInputColor,
                height:
                    style.inputLineHeight ?? BsFormStyle.defaultInputLineHeight,
              ),
              cursorColor: style.inputColor ?? BsFormStyle.defaultInputColor,
              backgroundCursorColor: BsColors.gray400,
              selectionColor:
                  (style.inputFocusBorderColor ??
                          BsFormStyle.defaultInputFocusBorderColor)
                      .withValues(alpha: 0.4),
              onChanged: (value) {
                widget.onChanged?.call(value);
                setState(() {});
              },
              onSubmitted: widget.onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
