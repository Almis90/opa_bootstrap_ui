import 'package:flutter/widgets.dart';

/// Tracks whether [builder]'s subtree has keyboard focus, replacing the
/// `bool _focused` field + `Focus(onFocusChange: ...)` boilerplate that
/// every focus-ring-drawing `Bs*` widget ([BsButton], [BsNav],
/// [BsAccordion], [BsNavbar]'s toggler, [BsPagination], [BsCloseButton])
/// used to hand-roll individually.
class BsFocusableBuilder extends StatefulWidget {
  const BsFocusableBuilder({super.key, this.focusNode, this.autofocus = false, this.enabled = true, required this.builder});

  /// Forwarded to the underlying [Focus] widget. Omit to let one be
  /// created — and disposed — internally.
  final FocusNode? focusNode;

  /// Forwarded to the underlying [Focus] widget.
  final bool autofocus;

  /// When false, focus changes are ignored and [builder] is always called
  /// with `focused: false` — matching how a disabled `Bs*` item already
  /// ignored focus before this was extracted.
  final bool enabled;

  /// Rebuilt whenever focus changes, with the current state.
  final Widget Function(BuildContext context, bool focused) builder;

  @override
  State<BsFocusableBuilder> createState() => _BsFocusableBuilderState();
}

class _BsFocusableBuilderState extends State<BsFocusableBuilder> {
  bool _focused = false;

  void _setFocused(bool value) {
    if (_focused != value) setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: widget.enabled ? _setFocused : null,
      child: widget.builder(context, widget.enabled ? _focused : false),
    );
  }
}
