import 'package:flutter/widgets.dart';

import 'bs_clip_rrect.dart';
import 'bs_decorated_box.dart';
import 'bs_form_control.dart';
import 'bs_theme.dart';
import 'tokens/bs_form_style.dart';

/// A Bootstrap file input: a "Choose File" button and the name of the chosen file, in a
/// control frame.
///
/// This package has no file picker to call (and none to depend on), so the widget only draws
/// the control: pass [onPressed] to open one, and the chosen name as [fileName].
class BsFormFile extends StatefulWidget {
  const BsFormFile({
    super.key,
    this.fileName,
    this.onPressed,
    this.enabled = true,
    this.size = BsFormControlSize.normal,
    this.buttonLabel = 'Choose File',
    this.noFileLabel = 'No file chosen',
    this.valid,
    this.style,
  });

  /// The chosen file's name; [noFileLabel] when null.
  final String? fileName;

  /// Called when the button (or the field) is tapped.
  final VoidCallback? onPressed;

  /// Draws the muted disabled background and ignores taps.
  final bool enabled;

  final BsFormControlSize size;

  /// The button's text (the browser's own, localised: "Choose File").
  final String buttonLabel;

  /// What it says while nothing is chosen ("No file chosen").
  final String noFileLabel;

  /// The validation state: the border takes the success color when true and the danger color when
  /// false.
  final bool? valid;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  State<BsFormFile> createState() => _BsFormFileState();
}

class _BsFormFileState extends State<BsFormFile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults)
        .merge(widget.style);
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
    final radius = switch (widget.size) {
      BsFormControlSize.small =>
        style.inputBorderRadiusSm ?? BsFormStyle.defaultInputBorderRadiusSm,
      BsFormControlSize.normal =>
        style.inputBorderRadius ?? BsFormStyle.defaultInputBorderRadius,
      BsFormControlSize.large =>
        style.inputBorderRadiusLg ?? BsFormStyle.defaultInputBorderRadiusLg,
    };
    final borderColor = switch (widget.valid) {
      false => style.invalidColor ?? BsFormStyle.defaultInvalidColor,
      true => style.validColor ?? BsFormStyle.defaultValidColor,
      null => style.inputBorderColor ?? BsFormStyle.defaultInputBorderColor,
    };
    final borderWidth =
        style.inputBorderWidth ?? BsFormStyle.defaultInputBorderWidth;
    final pad = padding.resolve(Directionality.of(context));
    final enabled = widget.enabled && widget.onPressed != null;
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: style.inputFontWeight ?? BsFormStyle.defaultInputFontWeight,
      color: style.inputColor ?? BsFormStyle.defaultInputColor,
      height: style.inputLineHeight ?? BsFormStyle.defaultInputLineHeight,
    );
    final buttonBackground = _hovered && widget.enabled
        ? style.fileButtonHoverBackground ??
              BsFormStyle.defaultFileButtonHoverBackground
        : style.fileButtonBackground ?? BsFormStyle.defaultFileButtonBackground;

    // The button fills the control's padding box, edge to edge.
    final button = BsDecoratedBox(
      decoration: BoxDecoration(
        color: buttonBackground,
        border: BorderDirectional(
          end: BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          pad.left,
          pad.top,
          pad.right + borderWidth,
          pad.bottom,
        ),
        child: Text(
          widget.buttonLabel,
          style: textStyle.copyWith(
            color: style.fileButtonColor ?? BsFormStyle.defaultFileButtonColor,
          ),
        ),
      ),
    );

    final box = BsDecoratedContainer(
      decoration: BoxDecoration(
        color: widget.enabled
            ? (style.inputBackground ?? BsFormStyle.defaultInputBackground)
            : (style.inputDisabledBackground ??
                  BsFormStyle.defaultInputDisabledBackground),
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: BsClipRRect(
        borderRadius: BorderRadius.circular(radius - borderWidth),
        child: Row(
          children: [
            button,
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: pad.left,
                  end: pad.right,
                  top: pad.top,
                  bottom: pad.bottom,
                ),
                child: Text(
                  widget.fileName ?? widget.noFileLabel,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (!enabled) return box;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: box,
      ),
    );
  }
}
