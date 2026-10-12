import 'dart:async';

import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_colors.dart';
import 'bs_theme.dart';
import 'bs_validation_icon.dart';
import 'tokens/bs_form_style.dart';
import 'bs_decorated_box.dart';

/// How tall and large-text a [BsFormControl] renders.
enum BsFormControlSize { small, normal, large }

/// A Bootstrap text input.
///
/// Built directly on [EditableText], since this package has no dependency on a design system's
/// text field. As a result there is no platform selection toolbar: only basic typing, a caret
/// and keyboard-driven selection are supported.
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
    this.roundedTop,
    this.roundedBottom,
    this.borderRadius,
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

  /// Grays out the background and blocks input.
  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  /// 1 for a single-line input; more for a multi-line control.
  final int maxLines;

  final TextInputType? keyboardType;

  /// The control's size.
  final BsFormControlSize size;

  /// The validation state: tints the border [BsFormStyle.validColor] when true or
  /// [BsFormStyle.invalidColor] when false. Null renders neither.
  final bool? valid;

  /// Set false inside a `BsInputGroup`, which draws one shared border
  /// around the whole group instead.
  final bool showBorder;

  /// The radius of the top corners in place of the control's.
  final BsRounded? roundedTop;

  /// The radius of the bottom corners in place of the control's.
  final BsRounded? roundedBottom;

  /// The four corner radii in place of the control's (and of [roundedTop] and [roundedBottom]):
  /// a control in an input group squares the side that meets the next element.
  final BorderRadius? borderRadius;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  State<BsFormControl> createState() => _BsFormControlState();
}

class _BsFormControlState extends State<BsFormControl>
    with WidgetsBindingObserver {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  // Switching browser tabs (or windows) blurs the page's text input, and Flutter web's engine
  // answers by closing the text-input connection, which unfocuses this field before the
  // window's `AppLifecycleState.inactive` arrives, so the framework's own restore of focus on
  // resume (it only remembers a node that is still focused when the app goes inactive) has
  // nothing to restore. A native text input keeps focus across a tab switch, so this does the
  // same: a focus loss immediately followed by the app going inactive is the window losing
  // focus, not the user moving on, and gets undone on resume.
  bool _hadFocus = false;
  bool _justLostFocus = false;
  Timer? _justLostFocusTimer;
  bool _refocusOnResume = false;
  TextSelection? _selectionToRestore;

  @override
  void initState() {
    super.initState();
    _hadFocus = _focusNode.hasFocus;
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
  }

  void _onFocusChange() {
    final hasFocus = _focusNode.hasFocus;
    if (_hadFocus && !hasFocus) {
      _justLostFocus = true;
      _selectionToRestore = _controller.selection;
      _justLostFocusTimer?.cancel();
      _justLostFocusTimer = Timer(
        const Duration(milliseconds: 250),
        () => _justLostFocus = false,
      );
    }
    if (hasFocus) _refocusOnResume = false;
    _hadFocus = hasFocus;
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (_focusNode.hasFocus) _selectionToRestore = _controller.selection;
        if (_focusNode.hasFocus || _justLostFocus) _refocusOnResume = true;
      case AppLifecycleState.resumed:
        if (!_refocusOnResume) return;
        _refocusOnResume = false;
        // Let the framework's own restore (if it had one) run first.
        Timer.run(_refocusAfterResume);
      case AppLifecycleState.detached:
        break;
    }
  }

  void _refocusAfterResume() {
    if (!mounted || !widget.enabled || _focusNode.hasFocus) return;
    final primary = FocusManager.instance.primaryFocus;
    // Unfocusing leaves focus on the enclosing scope (a FocusScopeNode), which
    // is "nobody"; a real node means something else took focus meanwhile.
    final someoneElseHasFocus =
        primary != null && primary is! FocusScopeNode && primary != _focusNode;
    if (someoneElseHasFocus) return;
    final selection = _selectionToRestore;
    _focusNode.requestFocus();
    // Regaining focus can select everything; put the caret back where it was.
    if (selection != null &&
        selection.isValid &&
        selection.end <= _controller.text.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.hasFocus) _controller.selection = selection;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _justLostFocusTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

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

    // A Container (not a bare DecoratedBox and Padding): a border drawn by DecoratedBox sits
    // over its child's box instead of adding to it, which would leave the control 2px short of
    // its intended height (line height, padding and border).
    final validated = widget.valid != null;
    final effectivePadding = !validated
        ? padding
        : padding
              .resolve(Directionality.of(context))
              .copyWith(
                right: fontSize * 1.5 + 12,
              );
    final box = BsDecoratedContainer(
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
            ? widget.borderRadius ??
                  BorderRadius.vertical(
                    top: Radius.circular(
                      widget.roundedTop?.radius ?? borderRadius,
                    ),
                    bottom: Radius.circular(
                      widget.roundedBottom?.radius ?? borderRadius,
                    ),
                  )
            : null,
        boxShadow: widget.showBorder
            ? (focused ? style.inputFocusBoxShadow : style.inputBoxShadow)
            : null,
      ),
      padding: effectivePadding,
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
          // A disabled input cannot be clicked into or tabbed to.
          ExcludeFocus(
            excluding: !widget.enabled,
            child: EditableText(
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
                leadingDistribution: TextLeadingDistribution.even,
              ),
              cursorColor: style.inputColor ?? BsFormStyle.defaultInputColor,
              // Browsers draw a 1px caret the height of the font's ascent and descent (about 1.17 times
              // the font size for Roboto), not Flutter's 2px full-line-height one, which, in a 1.5 line
              // box, is also visibly taller.
              cursorWidth: 1,
              cursorHeight: fontSize * 1.17,
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
          ),
        ],
      ),
    );
    if (!validated) return box;
    return Stack(
      children: [
        box,
        Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                end: 1 + fontSize * 0.375 + 3,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: BsValidationIcon(
                  valid: widget.valid!,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
