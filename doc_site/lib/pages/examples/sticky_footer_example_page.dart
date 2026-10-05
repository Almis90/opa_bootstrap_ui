import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_sticky_footer.dart';

/// The "Sticky footer" example: a port of Bootstrap's own
/// `examples/sticky-footer` page — a `main` with a heading and text and a
/// `footer.mt-auto.py-3.bg-body-tertiary` pinned to the bottom of the viewport,
/// both in the page's `.container { width: auto; max-width: 680px; padding: 0
/// 15px }`.
class StickyFooterExamplePage extends StatelessWidget {
  const StickyFooterExamplePage({super.key});

  /// `.container` of `sticky-footer.css`: [child] centred in at most 680px
  /// with `15px` of padding at the sides.
  static Widget container(Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final link = BsLink.colorOf(context);
    return ExampleStickyFooter(
      main: container(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <h1 class="mt-5">
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: BsHeading(BsHeadingLevel.h1, child: Text('Sticky footer')),
            ),
            const BsBox(
              mb: BsSpacing.s3,
              child: BsLead(
                child: Text(
                  'Pin a footer to the bottom of the viewport in desktop '
                  'browsers with this custom HTML and CSS.',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Use '),
                    TextSpan(
                      text: 'the sticky footer with a fixed navbar',
                      style: TextStyle(
                        color: link,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' if need be, too.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // <footer class="footer mt-auto py-3 bg-body-tertiary">
      footer: BsBox(
        bg: BsBg.bodyTertiary,
        py: BsSpacing.s3,
        child: container(
          Text(
            'Place sticky footer content here.',
            style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
          ),
        ),
      ),
    );
  }
}
