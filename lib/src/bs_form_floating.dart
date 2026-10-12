import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_form_control.dart';
import 'bs_theme.dart';
import 'tokens/bs_form_style.dart';
import 'tokens/bs_transitions.dart';

/// A Bootstrap floating label: a [label] that sits over the control until it is focused or has
/// content, then shrinks and floats to the top-left corner.
class BsFormFloating extends StatefulWidget {
  const BsFormFloating({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.valid,
    this.roundedTop,
    this.roundedBottom,
    this.onChanged,
    this.onSubmitted,
    this.style,
  });

  /// Typically a [Text]. Floats to the top-left corner once the field is
  /// focused or [controller] is non-empty.
  final Widget label;

  /// Defaults to an internally-owned controller when null.
  final TextEditingController? controller;

  /// Defaults to an internally-owned focus node when null.
  final FocusNode? focusNode;

  final bool obscureText;

  /// Grays out the background and blocks input.
  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final TextInputType? keyboardType;

  /// The validation state: tints the border [BsFormStyle.validColor] when true or
  /// [BsFormStyle.invalidColor] when false. Null renders neither.
  final bool? valid;

  /// The radius of the input's top corners.
  final BsRounded? roundedTop;

  /// `rounded-bottom-*` on the input.
  final BsRounded? roundedBottom;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  State<BsFormFloating> createState() => _BsFormFloatingState();
}

class _BsFormFloatingState extends State<BsFormFloating> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  bool get _floated => _focusNode.hasFocus || _controller.text.isNotEmpty;

  /// Duration of the label's move.
  static const _duration = Duration(milliseconds: 100);

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
    final duration = BsTransitions.resolve(context, _duration);
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults)
        .merge(widget.style);
    final height = style.floatingHeight ?? BsFormStyle.defaultFloatingHeight;
    final horizontalPadding =
        (style.floatingPadding ?? BsFormStyle.defaultFloatingPadding)
            .horizontal /
        2;
    final fontSize = style.inputFontSize ?? BsFormStyle.defaultInputFontSize;
    final borderWidth =
        style.inputBorderWidth ?? BsFormStyle.defaultInputBorderWidth;
    // The label is the body text color at 65% opacity.
    final labelColor = isDark
        ? const Color(0xA6DEE2E6)
        : const Color(0xA6212529);
    final floatedOpacity =
        style.floatingLabelOpacity ?? BsFormStyle.defaultFloatingLabelOpacity;
    final inputPaddingTop =
        style.floatingInputPaddingTop ??
        BsFormStyle.defaultFloatingInputPaddingTop;
    final inputPaddingBottom =
        style.floatingInputPaddingBottom ??
        BsFormStyle.defaultFloatingInputPaddingBottom;
    final lineHeight =
        style.floatingLineHeight ?? BsFormStyle.defaultFloatingLineHeight;
    // The label inherits the body's line height of 1.5.
    const labelLineHeight = 1.5;
    final disabledLabelColor =
        style.floatingLabelDisabledColor ??
        BsFormStyle.defaultFloatingLabelDisabledColor;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: BsFormControl(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              valid: widget.valid,
              roundedTop: widget.roundedTop,
              roundedBottom: widget.roundedBottom,
              onChanged: (value) {
                widget.onChanged?.call(value);
                setState(() {});
              },
              onSubmitted: widget.onSubmitted,
              style: BsFormStyle(
                inputPadding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  inputPaddingTop,
                  horizontalPadding,
                  inputPaddingBottom,
                ),
                inputLineHeight: lineHeight,
              ),
            ),
          ),
          // At rest the label sits where the input's text would. Floated, it is not moved by layout
          // but by a transform (scaled down and nudged up and in from its top-start corner), which
          // animates over 100 milliseconds, easing in and out; a color change is not part of the
          // animation.
          IgnorePointer(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: _floated ? 1.0 : 0.0),
              duration: duration,
              curve: Curves.easeInOut,
              builder: (context, t, child) {
                final rtl = Directionality.of(context) == TextDirection.rtl;
                return Transform(
                  alignment: AlignmentDirectional.topStart,
                  transform: Matrix4.identity()
                    ..scaleByDouble(1 - 0.15 * t, 1 - 0.15 * t, 1, 1)
                    ..translateByDouble(
                      (rtl ? -1 : 1) * 0.15 * 16 * t,
                      -0.5 * 16 * t,
                      0,
                      1,
                    ),
                  child: child,
                );
              },
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  // The label's own box has the control's `1px` border too, and
                  // its line is centred in the control's height.
                  padding: EdgeInsetsDirectional.only(
                    start: horizontalPadding + borderWidth,
                    end: horizontalPadding + borderWidth,
                    top: (height - fontSize * labelLineHeight) / 2,
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: fontSize,
                      height: labelLineHeight,
                      color: !widget.enabled
                          ? disabledLabelColor
                          : _floated
                          ? labelColor.withValues(alpha: floatedOpacity)
                          : labelColor,
                    ),
                    child: widget.label,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
