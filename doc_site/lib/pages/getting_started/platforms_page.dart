import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';

/// "Supported platforms and devices": where the library runs, what has been
/// tested, and the known differences and limitations.
class PlatformsPage extends StatelessWidget {
  const PlatformsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocPage(
      leadGap: 0,
      title: 'Supported platforms and devices',
      lead:
          'opa_bootstrap_ui is built on Flutter\'s widgets layer, so it runs '
          'wherever Flutter does. Here is what is supported, and what has '
          'actually been tested.',
      children: [
        DocHeading('Platform compatibility'),
        DocText([
          'The library has no platform-specific code and no plugins: it uses '
              'only Flutter\'s widgets layer. ',
          DocBold('Supported'),
          ' means it is expected to work on that platform because of that. ',
          DocBold('Tested'),
          ' says where it has actually been run.',
        ]),
        DocTable(
          headers: ['Platform', 'Supported', 'Tested'],
          rows: [
            [
              'Web',
              'Yes',
              'Chrome on macOS (release builds, the CanvasKit renderer), and '
                  'spot checks in Safari',
            ],
            ['macOS', 'Yes', 'The tests of the library run on macOS'],
            ['Android', 'Yes', 'Not yet tested on devices'],
            ['iOS', 'Yes', 'Not yet tested on devices'],
            ['Windows', 'Yes', 'Not yet tested'],
            ['Linux', 'Yes', 'Not yet tested'],
          ],
        ),
        DocHeading('Supported Flutter versions'),
        DocText([
          'The package requires ',
          DocBold('Dart 3.12.2 or newer'),
          ', as its SDK constraint says. It is developed and tested with ',
          DocBold('Flutter 3.47'),
          ' (Dart 3.13). It does not pin a Flutter version otherwise: use a '
              'Flutter release whose Dart is 3.12.2 or newer.',
        ]),
        DocHeading('Web support'),
        DocText([
          'Flutter for the web runs in the current releases of Chrome, Edge, '
              'Firefox and Safari, and not in Internet Explorer or other '
              'browsers without modern web standards; ',
          DocLink.url(
            'Flutter\'s documentation',
            'https://docs.flutter.dev/platform-integration/web',
          ),
          ' has the current list.',
        ]),
        DocText([
          'This documentation site is built with Flutter\'s CanvasKit '
              'renderer and checked in Chrome, with occasional checks in '
              'Safari. Firefox and Edge have not been tested. Flutter draws '
              'the text itself rather than leaving it to the browser, which '
              'brings a few differences, listed under ',
          'Known limitations',
          ' below.',
        ]),
        DocHeading('Mobile platforms'),
        DocText([
          'On Android and iOS the library adds no requirements of its own to '
              'those of Flutter. See ',
          DocLink.url(
            'Flutter\'s supported platforms',
            'https://docs.flutter.dev/reference/supported-platforms',
          ),
          ' for the minimum versions of the Flutter release you use.',
        ]),
        DocHeading('Desktop platforms'),
        DocText([
          'The same goes for Windows, macOS and Linux. Hover colors, keyboard '
              'focus rings and the mouse wheel work as they do in a browser.',
        ]),
        DocHeading('Platform-specific behavior'),
        DocList([
          DocListItem([
            DocBold('Touch and pointer.'),
            ' A tooltip appears when a pointer hovers its target, or on a '
                'long press on a touch screen. Hover colors need a pointer.',
          ]),
          DocListItem([
            DocBold('The back button.'),
            ' The system back button dismisses a modal or an offcanvas '
                'panel, as popping any route does.',
          ]),
          DocListItem([
            DocBold('Overlays.'),
            ' Dropdown menus, popovers and tooltips open above the page and '
                'move to stay inside the window, on every platform.',
          ]),
          DocListItem([
            DocBold('Keyboard.'),
            ' Focus rings show for keyboard focus only, and Escape closes an '
                'open dropdown menu.',
          ]),
        ]),
        DocHeading('Overflow and scrolling'),
        DocText([
          'Scrolling is Flutter\'s own. A modal keeps its header and footer in '
              'place and scrolls only its body when ',
          DocCode('scrollableBody'),
          ' is set, and the page behind an overlay is not locked. A carousel '
              'is swiped by touch only: the mouse wheel and the two-finger '
              'scroll of a trackpad do nothing to it, so they keep scrolling '
              'the page.',
        ]),
        DocHeading('Text scaling and accessibility'),
        DocText([
          'Text follows the system text scale (',
          DocCode('MediaQuery.textScaler'),
          '), while spacing, borders and icons are fixed in logical pixels. '
              'Components that have a fixed size are not tested at very large '
              'scales. On the web, zooming the browser changes the width the '
              'layout sees, so the breakpoints respond to it as they do in a '
              'browser. Transitions follow the reduced-motion setting.',
        ]),
        DocHeading('Known limitations'),
        DocText([
          'Verified differences and gaps, with a workaround where there is one.',
        ]),
        DocList([
          DocListItem([
            DocBold('Text fields.'),
            ' ',
            DocCode('BsFormControl'),
            ' offers typing, a caret and keyboard selection only. There are '
                'no platform selection handles or copy and paste toolbar yet, '
                'which matters most on touch screens.',
          ]),
          DocListItem([
            DocBold('Monospace text on the web.'),
            ' Flutter\'s web renderer cannot use the system\'s monospace '
                'fonts, so ',
            DocCode('BsCode'),
            ', ',
            DocCode('BsPre'),
            ' and ',
            DocCode('BsKbd'),
            ' fall back to proportional text. Bundle a monospace font and '
                'declare it under one of the family names of ',
            DocCode('BsTypography.fontFamilyMonospace'),
            '.',
          ]),
          DocListItem([
            DocBold('Text rendering on the web.'),
            ' The text is drawn by Flutter, not the browser, so the thin '
                'weights look slightly lighter than browser text. Scripts the '
                'font stack does not cover, such as Arabic, need a bundled '
                'font passed as ',
            DocCode('BsApp.extraFontFamilyFallback'),
            '.',
          ]),
          DocListItem([
            DocBold('File input.'),
            ' ',
            DocCode('BsFormFile'),
            ' only draws the control. The package has no file picker, so '
                'your app opens one on ',
            DocCode('onPressed'),
            ' and passes the chosen name.',
          ]),
          DocListItem([
            DocBold('Semantics.'),
            ' Most interactive components do not declare semantic roles (such '
                'as button or tab) yet, so screen readers read their text '
                'only. The spinner and the image take a label.',
          ]),
        ]),
      ],
    );
  }
}
