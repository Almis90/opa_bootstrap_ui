import 'package:flutter/gestures.dart';
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

/// A link to `#` as a widget: [child] with the pointing hand, scrolling the
/// page to the top when tapped.
class ExampleTopLink extends StatelessWidget {
  const ExampleTopLink({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => scrollExampleToTop(context),
        child: child,
      ),
    );
  }
}

/// Links to `#` inside a paragraph: [builder] gets the recognizer to give each
/// link's [TextSpan] (with `mouseCursor: SystemMouseCursors.click`); it
/// scrolls the page to the top. Owns and disposes the recognizer.
class ExampleTopLinks extends StatefulWidget {
  const ExampleTopLinks({super.key, required this.builder});

  final Widget Function(BuildContext context, GestureRecognizer recognizer)
  builder;

  @override
  State<ExampleTopLinks> createState() => _ExampleTopLinksState();
}

class _ExampleTopLinksState extends State<ExampleTopLinks> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () => scrollExampleToTop(context);

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _recognizer);
}
