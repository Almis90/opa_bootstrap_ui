import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';
import '../../src/doc_syntax.dart';

const _repository = 'https://github.com/Almis90/opa_bootstrap_ui';

/// "Contribute": working on the package, its example app and this site.
class ContributePage extends StatelessWidget {
  const ContributePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Contribute',
      lead:
          'Help develop opa_bootstrap_ui with the example app, the '
          'documentation site and the tests.',
      children: [
        const DocHeading('Tooling setup'),
        DocText([
          'There is no build step: the package is plain Dart. You need ',
          DocLink.url(
            'Flutter',
            'https://docs.flutter.dev/get-started/install',
          ),
          ' on the stable channel, with a Dart SDK of 3.13.4 or newer (the '
              'example app and this site require it), and Git. Follow these '
              'steps and you should be ready to rock:',
        ]),
        DocList(ordered: true, [
          DocListItem([
            'Fork and clone ',
            DocLink.url('the repository', _repository),
            '.',
          ]),
          DocListItem([
            'Run ',
            DocCode('flutter pub get'),
            ' in the root directory, and in ',
            DocCode('example/'),
            ' and ',
            DocCode('doc_site/'),
            '. They are three packages with a pubspec of their own, and '
                'both apps use the package from the root through a ',
            DocCode('path'),
            ' dependency.',
          ]),
        ]),
        const DocCodeSnippet('''
git clone https://github.com/Almis90/opa_bootstrap_ui.git
cd opa_bootstrap_ui
flutter pub get
(cd example && flutter pub get)
(cd doc_site && flutter pub get)''', language: DocLanguage.bash),
        const DocHeading('Tasks'),
        DocText([
          'Run these from the directory in the first column. Node is only '
              'needed for the last task.',
        ]),
        DocTable(
          headers: ['Where', 'Command', 'Description'],
          rows: [
            [
              'Root',
              'flutter test',
              'Runs the tests of the package, in test/.',
            ],
            [
              'Root',
              'flutter analyze',
              'Checks the package against flutter_lints.',
            ],
            [
              'example/',
              'flutter run',
              'Runs the example app: one demo page per component.',
            ],
            [
              'doc_site/',
              'flutter run -d chrome',
              'Runs this documentation site, with the flag below.',
            ],
            [
              'example/, doc_site/',
              'flutter test',
              'Runs the tests of the example app and of this site.',
            ],
            [
              'doc_site/',
              'flutter build web --release --base-href /opa_bootstrap_ui/',
              'Builds the site as it is deployed.',
            ],
            [
              'Root',
              'node tool/vendor_examples.mjs',
              'Builds and serves Bootstrap\'s own example pages, to compare '
                  'them with the ports.',
            ],
          ],
        ),
        DocText([
          'Run the site with Chrome\'s experimental web platform features, '
              'so that Flutter web draws text with the system font, as '
              'Bootstrap\'s pages do, instead of falling back to Roboto:',
        ]),
        const DocCodeSnippet(
          'flutter run -d chrome --web-browser-flag=--enable-experimental-web-platform-features',
          language: DocLanguage.bash,
        ),
        const DocHeading('Formatting'),
        DocText([
          'Format the files you change with ',
          DocCode('dart format'),
          ', and only those. Running it on the whole of ',
          DocCode('lib/'),
          ' rewrites dozens of files that you did not touch and buries your '
              'change in the diff.',
        ]),
        const DocCodeSnippet(
          'dart format lib/src/bs_badge.dart test/bs_badge_subtle_test.dart',
          language: DocLanguage.bash,
        ),
        const DocHeading('Bootstrap\'s source'),
        DocText([
          'Every component is a port, so the Bootstrap source is the '
              'reference. Clone it into ',
          DocCode('vendor/'),
          ', which Git ignores, at the tag of the version the docs follow: ',
          DocBold('v5.3.8'),
          '. The main branch is Bootstrap 6 and ',
          DocCode('v5-dev'),
          ' is unreleased 5.3 work: do not compare against either, or the '
              'ports will drift from what getbootstrap.com/docs/5.3 shows.',
        ]),
        const DocCodeSnippet('''
git clone https://github.com/twbs/bootstrap.git vendor/bootstrap
git -C vendor/bootstrap checkout v5.3.8''', language: DocLanguage.bash),
        DocList([
          DocListItem([
            DocCode('vendor/bootstrap/scss/'),
            ': the Sass source, with the variables that the style classes '
                'and tokens mirror.',
          ]),
          DocListItem([
            DocCode('vendor/bootstrap/site/src/content/docs/'),
            ': the documentation, which the pages of this site follow, '
                'section by section.',
          ]),
          DocListItem([
            DocCode(
              'vendor/bootstrap/site/src/assets/examples/<name>/index.astro',
            ),
            ': the markup of each official example.',
          ]),
        ]),
        DocText([
          DocCode('tool/vendor_examples.mjs'),
          ' turns those examples into static pages and serves them on port ',
          DocCode('8800'),
          ', so you can open the original and the port side by side in the '
              'same browser. Use ',
          DocCode('--port'),
          ' to pick another port, ',
          DocCode('--out'),
          ' to build somewhere else and ',
          DocCode('--no-serve'),
          ' to only build. ',
          DocCode('--font roboto --grayscale'),
          ' renders them in Roboto without macOS text smoothing, which '
              'compares cleanly with the text Flutter draws on a canvas. The '
              'site opens an example directly with ',
          DocCode('?example=<slug>'),
          ', where the slug is the title in lower case with dashes, such as ',
          DocCode('navbar-bottom'),
          '.',
        ]),
        const DocHeading('Adding a component'),
        DocText([
          'Components are added one at a time, each in a commit of its own, '
              'and follow Bootstrap\'s names, so that someone who knows '
              'Bootstrap can read the library. Look at Flutter\'s Material '
              'and Cupertino widgets for ideas on how to build it, but do not '
              'depend on them.',
        ]),
        DocList(ordered: true, [
          DocListItem([
            'Check ',
            DocCode('lib/src/tokens/'),
            ' for a ',
            DocCode('bs_*_style.dart'),
            ' that is already there, or add one with the component\'s '
                'values from the Sass source.',
          ]),
          DocListItem([
            'Write the widget in ',
            DocCode('lib/src/'),
            ' and export it from ',
            DocCode('lib/opa_bootstrap_ui.dart'),
            ', in alphabetical order. Check the names of the tokens first: '
                'a class that is already there cannot be reused.',
          ]),
          DocListItem(['Add a test in ', DocCode('test/'), '.']),
          DocListItem([
            'Add a demo page in ',
            DocCode('example/lib/pages/'),
            ' and list it in ',
            DocCode('home_page.dart'),
            ', keeping the list alphabetical.',
          ]),
          DocListItem(['Add its page to this site, as described below.']),
        ]),
        const DocHeading('Documentation'),
        DocText([
          'This site follows the structure of the Bootstrap docs: the '
              'sections and pages in ',
          DocCode('doc_site/lib/main.dart'),
          ' mirror the ones of getbootstrap.com/docs/5.3, and the pages that '
              'do not exist yet are listed there as ',
          DocCode('DocNavPage.planned'),
          '. A page of Bootstrap that has no counterpart in Flutter, such as '
              'the guides to bundlers, is left out.',
        ]),
        DocList(ordered: true, [
          DocListItem([
            'Read the page of the Bootstrap docs, then write the page for '
                'this package, rather than translate it: keep what '
                'applies, replace what does not with its Flutter '
                'counterpart and leave out the rest.',
          ]),
          DocListItem([
            'Put it in ',
            DocCode('doc_site/lib/pages/<section>/'),
            ' on a ',
            DocCode('DocPage'),
            ', with ',
            DocCode('DocExample'),
            ' for a live preview next to its code and the ',
            DocCode('Doc*'),
            ' widgets of ',
            DocCode('lib/src/doc_content.dart'),
            ' for text, tables and code.',
          ]),
          DocListItem([
            'Replace the ',
            DocCode('DocNavPage.planned'),
            ' entry in ',
            DocCode('main.dart'),
            ' with a ',
            DocCode('DocNavPage'),
            ' for the page.',
          ]),
          DocListItem([
            'Add a test in ',
            DocCode('doc_site/test/pages/'),
            ' that the page renders without errors.',
          ]),
        ]),
        DocText([
          'Every push to ',
          DocCode('main'),
          ' builds the site and publishes it on GitHub Pages, with the ',
          DocCode('deploy-docs'),
          ' workflow.',
        ]),
        const DocHeading('Troubleshooting'),
        DocText([
          'Should you encounter problems with installing dependencies, run ',
          DocCode('flutter clean'),
          ' and then ',
          DocCode('flutter pub get'),
          ' again in the package that fails.',
        ]),
      ],
    );
  }
}
