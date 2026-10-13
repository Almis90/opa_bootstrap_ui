import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';
import '../../src/doc_syntax.dart';

const _repository = 'https://github.com/Almis90/opa_bootstrap_ui';

/// "Installation": adding the package to a project, and getting its source.
class InstallationPage extends StatelessWidget {
  const InstallationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocPage(
      leadGap: 0,
      title: 'Installation',
      lead:
          'Install opa_bootstrap_ui from pub.dev, from GitHub or from a folder '
          'on your disk, or get its source to read and build on.',
      children: [
        DocHeading('Package installation'),
        DocText([
          'opa_bootstrap_ui is a Flutter package: you add it to your '
              'project\'s ',
          DocCode('pubspec.yaml'),
          '. The dependency can come from pub.dev, from GitHub or from a '
              'local copy.',
        ]),
        DocHeading('pub.dev', sub: true),
        DocText([
          'The quickest way is ',
          DocCode('flutter pub add'),
          ', which adds the dependency to ',
          DocCode('pubspec.yaml'),
          ' and runs ',
          DocCode('flutter pub get'),
          '.',
        ]),
        DocCodeSnippet(
          'flutter pub add opa_bootstrap_ui',
          language: DocLanguage.bash,
        ),
        DocText(['Or add the dependency yourself, then fetch it:']),
        DocCodeSnippet(
          'dependencies:\n  opa_bootstrap_ui: ^1.0.0',
          language: DocLanguage.yaml,
        ),
        DocCodeSnippet('flutter pub get', language: DocLanguage.bash),
        DocText(['Then import the library wherever you use it:']),
        DocCodeSnippet(
          "import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';",
        ),
        DocHeading('GitHub installation', sub: true),
        DocText([
          'To try the latest changes before they are released, or a branch or '
              'a tag, depend on the Git repository:',
        ]),
        DocCodeSnippet('''
dependencies:
  opa_bootstrap_ui:
    git:
      url: $_repository.git
      ref: main''', language: DocLanguage.yaml),
        DocText([
          DocCode('ref'),
          ' can be a branch, a tag or a commit. Leave it out to follow the '
              'default branch.',
        ]),
        DocHeading('Local installation', sub: true),
        DocText([
          'While you work on the package itself, or to try a change, depend '
              'on a local copy with a ',
          DocCode('path'),
          ' dependency:',
        ]),
        DocCodeSnippet(
          'dependencies:\n  opa_bootstrap_ui:\n    path: ../opa_bootstrap_ui',
          language: DocLanguage.yaml,
        ),
        DocText([
          'The path is relative to your ',
          DocCode('pubspec.yaml'),
          '. Edits to the package are picked up as you work, like any other '
              'source file of your project.',
        ]),
        DocHeading('Source files'),
        DocText([
          'Get the Dart source to read it, to build on it or to contribute. '
              'Clone the repository:',
        ]),
        DocCodeSnippet(
          'git clone $_repository.git',
          language: DocLanguage.bash,
        ),
        DocText(['Or download the source as a zip archive:']),
        DocButton(
          'Download source',
          '$_repository/archive/refs/heads/main.zip',
        ),
        DocText(['The repository holds:']),
        DocList([
          DocListItem([DocCode('lib'), ': the widgets, tokens and utilities.']),
          DocListItem([DocCode('test'), ': the tests of the library.']),
          DocListItem([
            DocCode('example'),
            ': a Flutter app that shows the components.',
          ]),
          DocListItem([
            DocCode('doc_site'),
            ': this documentation site, with the page templates of the examples.',
          ]),
        ]),
        DocHeading('Examples'),
        DocText([
          'The ',
          DocCode('example'),
          ' project is a Flutter app you can run from a checkout:',
        ]),
        DocCodeSnippet(
          'cd opa_bootstrap_ui/example\nflutter run',
          language: DocLanguage.bash,
        ),
        DocText([
          'The full-page templates of the ',
          DocLink.examples('Examples'),
          ' are pages of the documentation project. Browse their source on '
              'GitHub:',
        ]),
        DocButton(
          'View examples on GitHub',
          '$_repository/tree/main/doc_site/lib/pages/examples',
        ),
        DocHeading('IDE support'),
        DocText([
          'The Dart and Flutter extensions for Visual Studio Code, and the '
              'Flutter plugin for Android Studio (which brings the Dart '
              'plugin), complete and check your code as you write it. Start '
              'typing ',
          DocCode('Bs'),
          ' to list every widget, and see the parameters, their types and the '
              'documentation of each as you type or hover. Quick fixes add the '
              'missing import for you. ',
          DocLink.url(
            'Set up your editor',
            'https://docs.flutter.dev/get-started/editor',
          ),
          ' if you have not yet.',
        ]),
      ],
    );
  }
}
