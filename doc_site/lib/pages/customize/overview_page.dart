import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';

/// "Customize": the ways to theme and extend the package, and a map of the
/// section.
class CustomizeOverviewPage extends StatelessWidget {
  const CustomizeOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Customize',
      lead:
          'Learn how to theme, customize and extend opa_bootstrap_ui with '
          'style objects, a few app-wide settings, an expansive color system '
          'and color modes.',
      children: [
        const DocHeading('Overview'),
        DocText([
          'Bootstrap is customized with Sass variables before it is compiled, '
              'and with CSS variables after. opa_bootstrap_ui is compiled '
              'Dart, so its counterparts are different: the design tokens are '
              'constants of the package, and everything you change, you '
              'change from your own code. There are three ways, from the '
              'smallest to the widest:',
        ]),
        DocList(ordered: true, [
          DocListItem([
            DocBold('One widget.'),
            ' Pass a ',
            DocCode('style'),
            ' to it: a ',
            DocCode('Bs*Style'),
            ' object that sets only the fields you name and keeps the '
                'Bootstrap default for the rest, as an override of '
                'a component\'s CSS variables does.',
          ]),
          DocListItem([
            DocBold('One kind of widget.'),
            ' Wrap the widget in one of your own, so that its style lives '
                'in a single place, the way a Sass variable does.',
          ]),
          DocListItem([
            DocBold('The whole app.'),
            ' Set the brightness, the base text style and the fonts on ',
            DocCode('BsApp'),
            ', and the brightness of a part of the tree with ',
            DocCode('BsTheme'),
            '.',
          ]),
        ]),
        const DocCodeSnippet('''
// One widget: only the fields you set change.
BsButton(
  onPressed: () {},
  style: const BsButtonStyle(borderRadius: BorderRadius.all(Radius.circular(24))),
  child: const Text('Pill'),
)

// One kind of widget: your own, used everywhere.
class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onPressed, required this.child});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BsButton(
      onPressed: onPressed,
      style: const BsButtonStyle(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: child,
    );
  }
}

// The whole app.
BsApp(
  brightness: null, // follow the system
  extraFontFamilyFallback: const ['Noto Sans Arabic'],
  home: const MyHome(),
)'''),
        DocText([
          'The tokens themselves, such as the font sizes of ',
          DocCode('BsTypography'),
          ' or the radii of ',
          DocCode('BsBorders'),
          ', cannot be reassigned from outside, in the same way that you do '
              'not edit a compiled Bootstrap stylesheet. If you need to '
              'change one for good, depend on your own copy of the package '
              'with a ',
          DocLink.page(
            'local or Git dependency',
            'Getting started',
            'Installation',
          ),
          '.',
        ]),
        const DocHeading('In this section'),
        DocTable(
          headers: ['Page', 'Bootstrap counterpart', 'What it covers'],
          rows: [
            [
              DocText([DocLink.page('Tokens', 'Customize', 'Tokens')]),
              'Sass',
              'The constants and functions that the library is built from.',
            ],
            [
              DocText([DocLink.page('Options', 'Customize', 'Options')]),
              'Options',
              'The global preferences of Bootstrap, and where each one '
                  'lives, or why it does not apply.',
            ],
            [
              DocText([DocLink.page('Color', 'Customize', 'Color')]),
              'Color',
              'The palette, the theme colors and how to add your own.',
            ],
            [
              DocText([
                DocLink.page('Color modes', 'Customize', 'Color modes'),
              ]),
              'Color modes',
              'Light, dark and automatic, app-wide or for one subtree.',
            ],
            [
              DocText([DocLink.page('Components', 'Customize', 'Components')]),
              'Components',
              'How components are built from a base and modifiers, and how '
                  'to build your own the same way.',
            ],
            [
              DocText([
                DocLink.page('Style classes', 'Customize', 'Style classes'),
              ]),
              'CSS variables',
              'The Bs*Style objects: the variables of each component.',
            ],
            [
              DocText([DocLink.page('Optimize', 'Customize', 'Optimize')]),
              'Optimize',
              'Keeping an app that uses the library small and fast.',
            ],
          ],
        ),
        const DocHeading('Icons and assets'),
        DocText([
          'Several Bootstrap components embed SVG images in their CSS, as a ',
          DocCode('background-image'),
          ', which organizations with a strict Content Security Policy have '
              'to review. Nothing of the kind exists here. The same glyphs '
              'are drawn in code: the chevrons of the accordion, the select '
              'and the carousel controls, the cross of the close button, the '
              'checkmark of a check, the lines of the navbar toggler and the '
              'validation icons. There is no image to host, no URL to allow '
              'and nothing to replace, and they take the colors of the '
              'style they are in.',
        ]),
      ],
    );
  }
}
