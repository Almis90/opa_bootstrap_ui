import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Whether the last thing the user did was press a key rather than point at
/// something: what the browsers' `:focus-visible` heuristic comes down to. A
/// click focuses a button without a focus ring; the next key press (Escape,
/// Tab, an arrow) shows it, and Tab onto a button shows it at once.
class _FocusModality extends ValueNotifier<bool> {
  _FocusModality._() : super(true);

  static final instance = _FocusModality._();

  bool _installed = false;

  void ensureInstalled() {
    if (_installed) return;
    _installed = true;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  void _onPointer(PointerEvent event) {
    if (event is PointerDownEvent) value = false;
  }

  bool _onKey(KeyEvent event) {
    // (a lone modifier doesn't count)
    final key = event.logicalKey;
    final modifier =
        key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight ||
        key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight ||
        key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight ||
        key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight;
    if (event is KeyDownEvent && !modifier) value = true;
    return false;
  }
}

/// Tracks whether [builder]'s subtree has keyboard focus, replacing the
/// `bool _focused` field + `Focus(onFocusChange: ...)` boilerplate that
/// every focus-ring-drawing `Bs*` widget ([BsButton], [BsNav],
/// [BsAccordion], [BsNavbar]'s toggler, [BsPagination], [BsCloseButton])
/// used to hand-roll individually.
class BsFocusableBuilder extends StatefulWidget {
  const BsFocusableBuilder({
    super.key,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.focusVisibleOnly = false,
    required this.builder,
  });

  /// Forwarded to the underlying [Focus] widget. Omit to let one be
  /// created — and disposed — internally.
  final FocusNode? focusNode;

  /// Forwarded to the underlying [Focus] widget.
  final bool autofocus;

  /// When false the control can't take focus at all (a click or Tab goes past
  /// it, as for a `disabled` element) and [builder] is always called with
  /// `focused: false`.
  final bool enabled;

  /// `:focus-visible` rather than `:focus`: while the user is pointing, a
  /// focused subtree reports `focused: false` (a clicked `.btn` gets no focus
  /// ring), and `true` again once a key is pressed.
  final bool focusVisibleOnly;

  /// Rebuilt whenever focus changes, with the current state.
  final Widget Function(BuildContext context, bool focused) builder;

  @override
  State<BsFocusableBuilder> createState() => _BsFocusableBuilderState();
}

class _BsFocusableBuilderState extends State<BsFocusableBuilder> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusVisibleOnly) {
      _FocusModality.instance
        ..ensureInstalled()
        ..addListener(_modalityChanged);
    }
  }

  @override
  void dispose() {
    if (widget.focusVisibleOnly) {
      _FocusModality.instance.removeListener(_modalityChanged);
    }
    super.dispose();
  }

  void _modalityChanged() {
    if (_focused) setState(() {});
  }

  void _setFocused(bool value) {
    if (_focused != value) setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus && widget.enabled,
      // A `disabled` control can neither be clicked into nor tabbed to.
      canRequestFocus: widget.enabled,
      skipTraversal: !widget.enabled,
      onFocusChange: widget.enabled ? _setFocused : null,
      child: widget.builder(
        context,
        widget.enabled &&
            _focused &&
            (!widget.focusVisibleOnly || _FocusModality.instance.value),
      ),
    );
  }
}
