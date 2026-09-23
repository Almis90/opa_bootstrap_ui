import 'package:flutter/widgets.dart';

import 'bs_form_control.dart';
import 'tokens/bs_form_style.dart';

/// A Bootstrap floating label (`.form-floating`): a [label] that sits over
/// the control until it's focused or has content, then shrinks and floats
/// to the top-left corner.
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

  /// `.form-control:disabled`: greys out the background and blocks input.
  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final TextInputType? keyboardType;

  /// `.is-valid`/`.is-invalid`: tints the border [BsFormStyle.validColor] or
  /// [BsFormStyle.invalidColor]. Null renders neither.
  final bool? valid;

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

  static const _duration = Duration(milliseconds: 150);

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
    final style = BsFormStyle.defaults.merge(widget.style);
    final height = style.floatingHeight ?? BsFormStyle.defaultFloatingHeight;
    final horizontalPadding =
        (style.floatingPadding ?? BsFormStyle.defaultFloatingPadding)
            .horizontal /
        2;
    final fontSize = style.inputFontSize ?? BsFormStyle.defaultInputFontSize;
    final labelColor =
        style.inputPlaceholderColor ?? BsFormStyle.defaultInputPlaceholderColor;
    final floatedOpacity =
        style.floatingLabelOpacity ?? BsFormStyle.defaultFloatingLabelOpacity;

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
              onChanged: (value) {
                widget.onChanged?.call(value);
                setState(() {});
              },
              onSubmitted: widget.onSubmitted,
              style: BsFormStyle(
                inputPadding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  height * 0.4,
                  horizontalPadding,
                  0,
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedAlign(
              duration: _duration,
              curve: Curves.easeOut,
              alignment: _floated ? Alignment.topLeft : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: _floated ? height * 0.22 : 0,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: _duration,
                  curve: Curves.easeOut,
                  style: TextStyle(
                    fontSize: _floated ? fontSize * 0.85 : fontSize,
                    color: _floated
                        ? labelColor.withValues(alpha: floatedOpacity)
                        : labelColor,
                  ),
                  child: widget.label,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
