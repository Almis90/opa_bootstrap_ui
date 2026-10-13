import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';

/// "Options": what became of Bootstrap's `$enable-*` switches.
class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Options',
      lead:
          'Bootstrap toggles its global preferences with \$enable-* variables '
          'before it is compiled. Here is where each one lives in '
          'opa_bootstrap_ui, or why it does not apply.',
      children: [
        DocText([
          'A Sass switch decides what CSS gets generated, and so it can only '
              'be thrown once, for the whole stylesheet. opa_bootstrap_ui is '
              'not generated: it is classes, and the ones you do not use '
              'are tree-shaken out of a release build. So most of the '
              'switches are either a parameter of the widget they concern, '
              'which you can set where you need it, or always the way the '
              'platform wants it. There is no file of options to edit.',
        ]),
        DocTable(
          headers: ['Variable', 'Default', 'In opa_bootstrap_ui'],
          rows: [
            [
              r'$spacer',
              '1rem',
              DocText([
                'Fixed at 16 logical pixels. ',
                DocCode('BsSpacing'),
                ' is the scale of the margin, padding and gap parameters: 0, '
                    '0.25, 0.5, 1, 1.5 and 3 times that. For any other '
                    'distance pass a number to a widget of Flutter, such as ',
                DocCode('Padding'),
                '.',
              ], bottom: 0),
            ],
            [
              r'$enable-dark-mode',
              'true',
              DocText([
                'Always on. Set the ',
                DocCode('brightness'),
                ' of ',
                DocCode('BsApp'),
                ', or let it follow the system. See ',
                DocLink.page('Color modes', 'Customize', 'Color modes'),
                '.',
              ], bottom: 0),
            ],
            [
              r'$enable-rounded',
              'true',
              DocText([
                'No global switch. Each style class has a ',
                DocCode('borderRadius'),
                ' (BsAlertStyle, BsButtonStyle, BsCardStyle, …): pass ',
                DocCode('0'),
                ' for square corners, in a widget of your own where you want '
                    'them everywhere. The radii of ',
                DocCode('BsBorders'),
                ' stay for you to read.',
              ], bottom: 0),
            ],
            [
              r'$enable-shadows',
              'false',
              DocText([
                'Off by default, and a field of the style class turns each '
                    'on: ',
                DocCode('BsButtonStyle.defaultBoxShadow'),
                ' is the shadow of a button, and the dropdown, popover, '
                    'modal, offcanvas, card, progress, thumbnail and form '
                    'styles have a ',
                DocCode('boxShadow'),
                ' of their own. The toast, which Bootstrap always '
                    'shades, keeps its shadow; an empty list removes it. ',
                DocCode('BsShadows'),
                ' has the four values to choose from.',
              ], bottom: 0),
            ],
            [
              r'$enable-gradients',
              'false',
              DocText([
                'Not built in: no widget draws a gradient overlay and there '
                    'is no ',
                DocCode('bg-gradient'),
                '. Give a ',
                DocCode('BoxDecoration'),
                ' of Flutter a ',
                DocCode('LinearGradient'),
                ' where you want one.',
              ], bottom: 0),
            ],
            [
              r'$enable-transitions',
              'true',
              DocText([
                'No global switch. The durations are tokens of ',
                DocCode('BsTransitions'),
                ', and the style classes of the animated components expose '
                    'them: ',
                DocCode('transitionDuration'),
                ' on the accordion and the carousel, for example.',
              ], bottom: 0),
            ],
            [
              r'$enable-reduced-motion',
              'true',
              DocText([
                'Always on. The animations follow the platform\'s setting, '
                    'through ',
                DocCode('BsTransitions.resolve'),
                ' (see ',
                DocLink.page(
                  'Accessibility',
                  'Getting started',
                  'Accessibility',
                ),
                ').',
              ], bottom: 0),
            ],
            [
              r'$enable-grid-classes, $enable-container-classes',
              'true',
              DocText([
                DocCode('BsFlex'),
                ', ',
                DocCode('BsCol'),
                ' and ',
                DocCode('BsContainer'),
                ' are classes like the others. The ones you do not use cost '
                    'nothing in a release build.',
              ], bottom: 0),
            ],
            [
              r'$enable-cssgrid',
              'false',
              'Not applicable. There is no CSS Grid to switch on; lay out '
                  'with the grid of Bootstrap or the widgets of Flutter.',
            ],
            [
              r'$enable-caret',
              'true',
              DocText([
                'The caret of a dropdown toggle is its own widget, ',
                DocCode('BsDropdownCaret'),
                ', which you place in the toggle when you want it.',
              ], bottom: 0),
            ],
            [
              r'$enable-button-pointers',
              'true',
              'Always on: an enabled button shows the click cursor on '
                  'the platforms that have a pointer, and a disabled one '
                  'does not.',
            ],
            [
              r'$enable-rfs',
              'true',
              DocText([
                'Comes from the opa_rfs package. See ',
                DocLink.page('RFS', 'Getting started', 'RFS'),
                '.',
              ], bottom: 0),
            ],
            [
              r'$enable-validation-icons',
              'true',
              DocText([
                'No switch. A form control with a ',
                DocCode('valid'),
                ' of true or false shows the icon with the border color, '
                    'and one with none shows neither.',
              ], bottom: 0),
            ],
            [
              r'$enable-negative-margins',
              'false',
              DocText([
                'Not a switch: ',
                DocCode('BsPullStart'),
                ' is a negative margin at the start of a child, which you '
                    'use where you need it.',
              ], bottom: 0),
            ],
            [
              r'$enable-deprecation-messages',
              'true',
              'Not applicable. A deprecation is an annotation that the Dart '
                  'analyzer reports, and an ignore comment silences.',
            ],
            [
              r'$enable-important-utilities',
              'true',
              'Not applicable. There is no cascade to win: a value you '
                  'pass to a widget is the value it uses.',
            ],
            [
              r'$enable-smooth-scroll',
              'true',
              DocText([
                'Not applicable: scrolling is the platform\'s. Where the '
                    'library scrolls for you, ',
                DocCode('BsScrollspyController.scrollToSection'),
                ' takes a ',
                DocCode('duration'),
                '.',
              ], bottom: 0),
            ],
          ],
        ),
        const DocHeading('What you can set for the whole app'),
        DocText([
          'What is left of the global options is the handful of parameters '
              'of ',
          DocCode('BsApp'),
          ':',
        ]),
        DocTable(
          headers: ['Parameter', 'Sets'],
          rows: [
            [
              'brightness',
              'Light, dark, or null to follow the system. Defaults to light.',
            ],
            [
              'textStyle',
              'The base text style of the app, in place of Bootstrap\'s '
                  'body text.',
            ],
            [
              'extraFontFamilyFallback',
              'Font families tried after the default stack, for the glyphs '
                  'it lacks.',
            ],
            [
              'locale, supportedLocales, localizationsDelegates',
              'The language of the app. It does not set the direction: see '
                  'RTL.',
            ],
            [
              'builder',
              'Wraps everything below the app, such as a Directionality.',
            ],
          ],
        ),
      ],
    );
  }
}
