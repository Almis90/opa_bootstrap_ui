import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// What `<a href="#">` does on a Bootstrap page (whose `scroll-behavior` is
/// `smooth`): scrolls the page back to the top. The page here is the outermost
/// vertical scroll view above [context].
void scrollExampleToTop(BuildContext context) {
  ScrollPosition? page;
  context.visitAncestorElements((element) {
    final widget = element.widget;
    if (widget is Scrollable && element is StatefulElement) {
      final state = element.state as ScrollableState;
      if (state.position.axis == Axis.vertical) page = state.position;
    }
    return true;
  });
  final position = page;
  if (position == null || position.pixels <= position.minScrollExtent) return;
  // (the browser's smooth scroll takes longer the further it goes)
  final distance = position.pixels - position.minScrollExtent;
  final milliseconds = (300 + distance * 0.25).clamp(300, 900).round();
  position.animateTo(
    position.minScrollExtent,
    duration: BsTransitions.resolve(
      context,
      Duration(milliseconds: milliseconds),
    ),
    curve: Curves.easeInOut,
  );
}
