import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';
import '../../src/doc_syntax.dart';

/// "Get started": installing the package, a first page, and the settings
/// every `Bs*` widget relies on.
class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocPage(
      leadGap: 0,
      title: 'Get started with opa_bootstrap_ui',
      lead:
          'opa_bootstrap_ui is Bootstrap for Flutter: a family of Bs* widgets '
          'built on Flutter\'s widgets layer. Build anything, from prototype '
          'to production, in minutes.',
      children: [
        DocHeading('Quick start'),
        DocText([
          'Get started by adding the package and wrapping your app in ',
          DocCode('BsApp'),
          '. Every ',
          DocCode('Bs*'),
          ' widget works with no further setup. See it in practice in the ',
          DocLink.examples('official examples'),
          '.',
        ]),
        DocList(ordered: true, [
          DocListItem(
            [
              DocBold('Add the package to your project.'),
              ' Use the command line, or add the dependency to ',
              DocCode('pubspec.yaml'),
              ' yourself.',
            ],
            children: [
              DocCodeSnippet(
                'flutter pub add opa_bootstrap_ui',
                language: DocLanguage.bash,
              ),
              DocCodeSnippet(
                'dependencies:\n  opa_bootstrap_ui: ^1.0.0',
                language: DocLanguage.yaml,
              ),
            ],
          ),
          DocListItem(
            [
              DocBold(['Wrap your app in ', DocCode('BsApp'), '.']),
              ' It takes the place of other app widgets, and sets up the theme, '
                  'the base text style and navigation that every ',
              DocCode('Bs*'),
              ' widget uses.',
            ],
            children: [
              DocCodeSnippet('''
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BsApp(home: HomePage());
  }
}'''),
            ],
          ),
          DocListItem(
            [
              DocBold('Hello, world!'),
              ' Run the app to see your Bootstrapped page. Now you can start '
                  'building with opa_bootstrap_ui by creating your own ',
              DocLink.page('layout', 'Layout', 'Containers'),
              ', adding dozens of ',
              DocLink.page('components', 'Components', 'Buttons'),
              ', and exploring ',
              DocLink.examples('our official examples'),
              '.',
            ],
            children: [
              DocCodeSnippet('''
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BsContainer(
      py: BsSpacing.s5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BsHeading(BsHeadingLevel.h1, child: Text('Hello, world!')),
          BsButton(onPressed: () {}, child: const Text('Primary')),
        ],
      ),
    );
  }
}'''),
            ],
          ),
        ]),
        DocHeading('Next steps'),
        DocList([
          DocListItem([
            'Read a bit more about the ',
            'important global settings',
            ' that ',
            DocCode('BsApp'),
            ' applies, below.',
          ]),
          DocListItem([
            'Learn how pages are laid out with ',
            DocLink.page('breakpoints', 'Layout', 'Breakpoints'),
            ', ',
            DocLink.page('containers', 'Layout', 'Containers'),
            ' and ',
            DocLink.page('flex', 'Utilities', 'Flex'),
            '.',
          ]),
          DocListItem([
            'Browse the ',
            DocLink.page('components', 'Components', 'Accordion'),
            ': each one is a widget with the same name and options as in Bootstrap.',
          ]),
          DocListItem([
            'Every component takes a style object to override its look. See ',
            DocLink.page('buttons', 'Components', 'Buttons'),
            ' for an example.',
          ]),
          DocListItem([
            'Looking for whole pages? The ',
            DocLink.examples('examples'),
            ' rebuild Bootstrap\'s own templates.',
          ]),
        ]),
        DocHeading('Important globals'),
        DocText([
          DocCode('BsApp'),
          ' sets up a handful of global settings that every ',
          DocCode('Bs*'),
          ' widget relies on. Most of them make a Flutter app read and behave '
              'like a Bootstrap page. Let\'s dive in.',
        ]),
        DocHeading('Text defaults', sub: true),
        DocText([
          DocCode('BsApp'),
          ' gives the whole app Bootstrap\'s base text: the system font stack '
              'at 16 logical pixels, a line height of 1.5 and the body color. '
              'Pass ',
          DocCode('textStyle'),
          ' to use your own, and ',
          DocCode('extraFontFamilyFallback'),
          ' to add fonts for scripts the stack does not cover, such as Arabic.',
        ]),
        DocHeading('Color modes', sub: true),
        DocText([
          DocCode('brightness'),
          ' picks the light or dark theme. Pass null to follow the operating '
              'system, switching live when it changes. Components resolve their '
              'colors from the nearest ',
          DocCode('BsTheme'),
          ', so a ',
          DocCode('BsTheme'),
          ' around a subtree makes just that part light or dark.',
        ]),
        DocCodeSnippet('''
BsApp(
  brightness: null, // follow the system; or Brightness.light / Brightness.dark
  home: const HomePage(),
)'''),
        DocHeading('Mobile first', sub: true),
        DocText([
          'Bootstrap is developed ',
          DocBold('mobile first'),
          ': code is written for small screens first and scaled up at '
              'breakpoints. Flutter has no viewport tag to add, as the viewport '
              'is the window. Every responsive value in opa_bootstrap_ui, such '
              'as a ',
          DocCode('BsResponsiveValue'),
          ' or the props of ',
          DocCode('BsFlex'),
          ' and ',
          DocCode('BsContainer'),
          ', is resolved against the window\'s width with the same breakpoints.',
        ]),
        DocCodeSnippet('''
BsBox(
  // 16 logical pixels of margin, none from the md breakpoint up.
  mb: const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
  child: const Text('Responsive'),
)'''),
        DocHeading('Right to left', sub: true),
        DocText([
          'Layout follows the ambient ',
          DocCode('Directionality'),
          ': start and end are logical, so wrapping a subtree in a ',
          DocCode('Directionality'),
          ' with ',
          DocCode('TextDirection.rtl'),
          ' flips it, with no second stylesheet.',
        ]),
        DocHeading('Reduced motion', sub: true),
        DocText([
          'Transitions and animations respect the system\'s reduced-motion '
              'setting (',
          DocCode('MediaQuery.disableAnimations'),
          ') with nothing for you to configure.',
        ]),
        DocHeading('Keyboard focus', sub: true),
        DocText([
          'Focus rings show for keyboard focus only, so a clicked button gets '
              'no ring, and a control loses focus when something else is '
              'pressed, as in a browser.',
        ]),
        DocHeading('Community'),
        DocText([
          'Stay up-to-date on the development of opa_bootstrap_ui and reach out '
              'with these helpful resources.',
        ]),
        DocList([
          DocListItem([
            'Browse the source and follow the development on ',
            DocLink.url(
              'GitHub',
              'https://github.com/Almis90/opa_bootstrap_ui',
            ),
            '.',
          ]),
          DocListItem([
            'Report a bug or ask for a feature in the ',
            DocLink.url(
              'issue tracker',
              'https://github.com/Almis90/opa_bootstrap_ui/issues',
            ),
            '.',
          ]),
          DocListItem([
            'For the design that the widgets follow, read ',
            DocLink.url(
              'Bootstrap\'s own documentation',
              'https://getbootstrap.com/docs/5.3/',
            ),
            '.',
          ]),
        ]),
      ],
    );
  }
}
