import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_navbar_page.dart';
import '../../src/example_sticky_footer.dart';

/// The "Sticky footer navbar" example: a port of Bootstrap's own
/// `examples/sticky-footer-navbar` page — [StickyFooterExamplePage]'s footer
/// under a `fixed-top` dark navbar (see [fixed]), with `main > .container`
/// padded `60px 15px 0` to clear it.
class StickyFooterNavbarExamplePage extends StatelessWidget {
  const StickyFooterNavbarExamplePage({super.key});

  static const _expand = BsBreakpoint.md;

  /// The `position: fixed; top: 0; right: 0; left: 0` navbar.
  static Widget fixed(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: NavbarExampleBar(
        brand: 'Fixed navbar',
        expandBreakpoint: _expand,
        items: navbarExampleItems(),
        trailing: const [NavbarSearchForm()],
      ),
    );
  }

  /// `.container`: [child] at the width of the current breakpoint, with the
  /// `15px` side padding the page's CSS gives it.
  static Widget _container(Widget child, {double top = 0}) {
    return BsContainer(
      px: BsSpacing.s0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, top, 15, 0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = TextStyle(
      fontFamily: BsTypography.fontFamilyMonospace.first,
      fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
      fontSize: 17.5,
      color: BsCodeStyle.defaultCodeColor,
    );
    final link = BsLink.colorOf(context);
    return ExampleStickyFooter(
      main: _container(
        top: 60,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: BsHeading(
                BsHeadingLevel.h1,
                child: Text('Sticky footer with fixed navbar'),
              ),
            ),
            BsBox(
              mb: BsSpacing.s3,
              child: BsLead(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'Pin a footer to the bottom of the viewport in '
                            'desktop browsers with this custom HTML and CSS. A '
                            'fixed navbar has been added with ',
                      ),
                      TextSpan(text: 'padding-top: 60px;', style: code),
                      const TextSpan(text: ' on the '),
                      TextSpan(text: 'main > .container', style: code),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Back to '),
                    TextSpan(
                      text: 'the default sticky footer',
                      style: TextStyle(
                        color: link,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' minus the navbar.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      footer: BsBox(
        bg: BsBg.bodyTertiary,
        py: BsSpacing.s3,
        child: _container(
          Text(
            'Place sticky footer content here.',
            style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
          ),
        ),
      ),
    );
  }
}
