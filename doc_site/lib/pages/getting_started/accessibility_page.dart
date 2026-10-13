import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';

/// "Accessibility": what the library does for assistive technologies, and what
/// is left to the app.
class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocPage(
      leadGap: 0,
      title: 'Accessibility',
      lead:
          'A guide to the accessibility features of opa_bootstrap_ui, and to '
          'where building an accessible app is up to you.',
      children: [
        DocHeading('Overview and limitations'),
        DocText([
          'Whether an app is accessible depends on how its widgets are used '
              'and configured: its labels, its colors, its structure. '
              'opa_bootstrap_ui follows Bootstrap\'s visual design and adds '
              'keyboard focus rings, reduced-motion handling and parameters '
              'for labels, but it does not make an app compliant by itself. '
              'Aim for the ',
          DocLink.url(
            'Web Content Accessibility Guidelines (WCAG) 2.2',
            'https://www.w3.org/TR/WCAG22/',
          ),
          ', which also guide mobile and desktop apps, and test with real '
              'assistive technology.',
        ]),
        DocText([
          'The library does not yet expose full semantics for every '
              'component, and some keyboard interactions are missing. They '
              'are listed below, each with what you can do about it.',
        ]),
        DocHeading('Semantic structure'),
        DocText([
          'Flutter builds a tree of semantics from the widgets, which '
              'assistive technologies read. Text, text fields and images take '
              'part in it by themselves, and the ',
          DocCode('Semantics'),
          ' widget adds a label, a role or a state to anything else.',
        ]),
        DocText([
          'In opa_bootstrap_ui, ',
          DocCode('BsFormControl'),
          ' is a real text field, ',
          DocCode('BsImage'),
          ' takes an ',
          DocCode('alt'),
          ' description, and the spinners take a ',
          DocCode('semanticsLabel'),
          '. Most other interactive components do not declare roles such as '
              'button or tab yet, so a screen reader announces their text '
              'only. Wrap them in a ',
          DocCode('Semantics'),
          ' where the role matters:',
        ]),
        DocCodeSnippet('''
Semantics(
  button: true,
  label: 'Save the document',
  child: BsButton(onPressed: save, child: const Text('Save')),
)'''),
        DocHeading('Interactive components'),
        DocList([
          DocListItem([
            DocBold('Buttons and links.'),
            ' They take keyboard focus and show a focus ring for it. A button '
                'with no ',
            DocCode('onPressed'),
            ' is disabled and skipped by the Tab key.',
          ]),
          DocListItem([
            DocBold('Form controls.'),
            ' Text fields take typing, a checkbox, radio or switch toggles '
                'with the Space key, and a range moves with the arrow keys.',
          ]),
          DocListItem([
            DocBold('Dropdowns.'),
            ' Escape closes an open menu. The items of a menu are not '
                'reached with the arrow keys yet.',
          ]),
          DocListItem([
            DocBold('Modals and offcanvas panels.'),
            ' They are routes: the system back button dismisses them, and so '
                'does a tap outside when ',
            DocCode('barrierDismissible'),
            ' is set.',
          ]),
          DocListItem([
            DocBold('Tooltips.'),
            ' They appear on hover or a long press, so keyboard users do not '
                'get them. Do not put essential information in a tooltip.',
          ]),
        ]),
        DocHeading('Keyboard navigation'),
        DocText([
          'The Tab and Shift+Tab keys move the focus through the focusable '
              'widgets in the order they appear. A focus ring shows for '
              'keyboard focus only: a click or a tap does not draw one, and '
              'the next key press does.',
        ]),
        DocText([
          DocBold(
            'Activating a control with the Enter or Space key is not '
            'built in yet',
          ),
          ' for buttons, nav links, accordion headers and the like: they take '
              'focus, but only a click or a tap triggers them. Until it is, '
              'bind the keys yourself:',
        ]),
        DocCodeSnippet('''
CallbackShortcuts(
  bindings: {
    const SingleActivator(LogicalKeyboardKey.enter): save,
    const SingleActivator(LogicalKeyboardKey.space): save,
  },
  child: BsButton(onPressed: save, child: const Text('Save')),
)'''),
        DocHeading('Screen reader accessibility'),
        DocText([
          'There is no off-screen text to write, as there is on a web page: '
              'give a control a name with a semantic label. Do it for every '
              'control that has no text of its own, such as an icon button '
              'or a close button:',
        ]),
        DocCodeSnippet('''
Semantics(
  button: true,
  label: 'Close',
  child: BsCloseButton(onPressed: close),
)

BsSpinnerBorder(semanticsLabel: 'Loading…')'''),
        DocHeading('Screen readers'),
        DocText([
          'Flutter hands its semantics to the screen reader of the platform: '
              'TalkBack on Android, VoiceOver on iOS and macOS, and the screen '
              'readers of Windows and Linux. On the web the tree is not '
              'built until assistive technology asks for it, or your app '
              'calls ',
          DocCode('SemanticsBinding.instance.ensureSemantics()'),
          '.',
        ]),
        DocHeading('Color contrast'),
        DocText([
          'WCAG asks for a contrast ratio of at least 4.5:1 for text (3:1 for '
              'large text) and 3:1 for the parts of controls. Bootstrap\'s '
              'colors are chosen with this in mind, but not every pairing '
              'passes, so check yours. The variants of buttons and '
              'badges pick their text color from the background for contrast.',
        ]),
        DocText([
          'When you set your own colors, let ',
          DocCode('BsColorUtils.contrast'),
          ' pick the text color, which falls back to the better of white and '
              'black:',
        ]),
        DocCodeSnippet('''
const background = Color(0xFF6F42C1);
final text = BsColorUtils.contrast(background);

BsButton(
  onPressed: save,
  style: BsButtonStyle(background: background, color: text),
  child: const Text('Save'),
)'''),
        DocHeading('Reduced motion'),
        DocText([
          'Components follow the platform\'s reduced-motion setting: ',
          DocCode('MediaQuery.disableAnimations'),
          ', which comes from Remove animations on Android, Reduce Motion on '
              'iOS and macOS, and the browser\'s preference on the web. '
              'Transitions then finish at once, and animations that repeat '
              'forever, such as the stripes of an animated progress bar and '
              'the glow or wave of a placeholder, stand still.',
        ]),
        DocText([
          'These follow it: toasts, tooltips, switches, modals, offcanvas '
              'panels, alerts, carousels, progress bars, accordions, '
              'floating labels, tab views, collapses, navbars, pagination, '
              'buttons, close buttons and placeholders. Two things do not: '
              'the spinners keep turning, because they show that something is '
              'in progress, and a carousel keeps advancing on its own. Pass ',
          DocCode('interval: null'),
          ' to a carousel to stop that.',
        ]),
        DocHeading('Text scaling'),
        DocText([
          'Text follows the size the user chose in the system settings, '
              'through ',
          DocCode('MediaQuery.textScaler'),
          ', and the components around it grow with it, because their size '
              'comes from their text. Spacing, borders and icons stay fixed in '
              'logical pixels. Try your screens at 200% (WCAG 1.4.4), as a '
              'component of a fixed size can overflow at large scales.',
        ]),
        DocHeading('Touch targets'),
        DocText([
          'WCAG 2.2 asks for targets of at least 24 by 24 logical pixels, '
              'and platform guidelines advise more: 44 on iOS and 48 on '
              'Android. A default button is 38 tall, a small one 31 and a '
              'large one 48; a close button is 24. A checkbox, radio or '
              'switch is small, but its label toggles it too. Where touch is '
              'the main input, use large buttons or add padding:',
        ]),
        DocCodeSnippet('''
BsButton(
  size: BsSize.lg,
  px: BsSpacing.s4,
  onPressed: save,
  child: const Text('Save'),
)'''),
        DocHeading('Accessibility testing'),
        DocText([
          'Flutter checks some of this in tests. Turn the semantics on, then '
              'ask for the guidelines:',
        ]),
        DocCodeSnippet('''
testWidgets('meets the accessibility guidelines', (tester) async {
  final semantics = tester.ensureSemantics();
  await tester.pumpWidget(const BsApp(home: MyPage()));

  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));

  semantics.dispose();
});'''),
        DocText([
          'Pass ',
          DocCode('showSemanticsDebugger: true'),
          ' to ',
          DocCode('BsApp'),
          ' to see the semantics tree drawn over your app. Tests do not '
              'replace trying the app with TalkBack or VoiceOver, with the '
              'keyboard alone, with large text and with reduced motion on.',
        ]),
        DocHeading('Additional resources'),
        DocList([
          DocListItem([
            DocLink.url(
              'Web Content Accessibility Guidelines (WCAG) 2.2',
              'https://www.w3.org/TR/WCAG22/',
            ),
          ]),
          DocListItem([
            DocLink.url(
              'Accessibility in Flutter',
              'https://docs.flutter.dev/ui/accessibility',
            ),
          ]),
          DocListItem([
            DocLink.url('The A11Y Project', 'https://www.a11yproject.com/'),
          ]),
          DocListItem([
            DocLink.url(
              'WebAIM contrast checker',
              'https://webaim.org/resources/contrastchecker/',
            ),
          ]),
          DocListItem([
            DocLink.url(
              'Bootstrap\'s accessibility documentation',
              'https://getbootstrap.com/docs/5.3/getting-started/accessibility/',
            ),
          ]),
        ]),
      ],
    );
  }
}
