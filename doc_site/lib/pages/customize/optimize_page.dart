import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';
import '../../src/doc_syntax.dart';

/// "Optimize": keeping an app that uses the package small and fast.
class OptimizePage extends StatelessWidget {
  const OptimizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Optimize',
      lead:
          'Keep your app lean, responsive and maintainable so you can '
          'deliver the best experience and focus on more important jobs.',
      children: [
        DocText([
          'Bootstrap\'s advice is about what you ship to the browser: Sass '
              'imports, JavaScript, prefixes, unused CSS and compression. '
              'Most of it is done for you by the Flutter and Dart tools, and '
              'what is left is a short list.',
        ]),
        const DocHeading('Lean imports'),
        DocText([
          'Bootstrap asks you to import only the components you use. With '
              'this package you import the whole library, with a single ',
          DocCode('import'),
          ', and a release build leaves out what the app never refers to: '
              'Dart removes unreachable code (tree shaking), so a component '
              'that you do not use does not add to the size of the app. There '
              'is no list of imports to trim, and no dependencies between '
              'them to keep in mind.',
        ]),
        const DocCodeSnippet('''
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';'''),
        DocText([
          'You can still limit what a file sees with ',
          DocCode('show'),
          ' if you want the names it uses to be explicit, but that is for '
              'readability, not for size.',
        ]),
        const DocHeading('Lean JavaScript'),
        DocText([
          'There is no JavaScript to remove and no Popper to list as a '
              'dependency. Dropdowns, tooltips, popovers, modals, offcanvas '
              'panels and toasts are widgets that use Flutter\'s own '
              'overlays, so nothing is added when you use them. The package '
              'depends on Flutter alone and on no other package, and it does '
              'not import Material or Cupertino, so neither of them is pulled '
              'into your app by it.',
        ]),
        const DocHeading('Prefixes and browsers'),
        DocText([
          'Bootstrap relies on Autoprefixer and a ',
          DocCode('.browserslistrc'),
          ' to add vendor prefixes. Flutter draws on its own, on a canvas, '
              'so there are no CSS properties to prefix and nothing to '
              'configure. The browsers that you support are the ones that '
              'Flutter supports: see ',
          DocLink.page(
            'Platforms & devices',
            'Getting started',
            'Platforms & devices',
          ),
          '.',
        ]),
        const DocHeading('Unused assets'),
        DocText([
          'There is no stylesheet to purge. What the package could add to '
              'your app besides code is assets, and it adds none: it has no '
              'fonts, images or icon fonts, and the glyphs of the close '
              'button, the carousel controls, the checkbox and the like are '
              'painted. The assets that your app bundles are yours, so '
              'bundle only the font files and the weights you use; a family '
              'with a file per weight adds up quickly, in particular for a '
              'script like Arabic (see ',
          DocLink.page('RTL', 'Getting started', 'RTL'),
          ').',
        ]),
        const DocHeading('Build for release'),
        DocText([
          'This is the counterpart of minifying and gzipping. A debug build '
              'is neither small nor fast, so measure and ship a release one. '
              'For the web, ',
          DocCode('--release'),
          ' is the default of ',
          DocCode('flutter build web'),
          ', which compiles to minified JavaScript, or to WebAssembly with ',
          DocCode('--wasm'),
          ' on the browsers that support it.',
        ]),
        const DocCodeSnippet('''
flutter build web --release
flutter build web --wasm''', language: DocLanguage.bash),
        DocText([
          'Compression is done by your host, as it is for Bootstrap\'s files: '
              'serve the ',
          DocCode('.js'),
          ', ',
          DocCode('.wasm'),
          ' and font files of ',
          DocCode('build/web'),
          ' with gzip or Brotli. Most hosts, GitHub Pages among them, '
              'already do.',
        ]),
        const DocHeading('Non-blocking code'),
        DocText([
          'Bootstrap defers the scripts and styles that the first paint does '
              'not need. The counterpart for a Flutter app is deferred '
              'loading: a library imported with ',
          DocCode('deferred as'),
          ' is split off and downloaded on the web only when you call ',
          DocCode('loadLibrary()'),
          '. Use it for a screen that most visitors never open, such as '
              'settings or an admin area, so that the code of the screen, and '
              'the widgets only it uses, is not part of the first download. '
              'On other platforms the library is simply there, and the call '
              'returns at once.',
        ]),
        const DocCodeSnippet('''
import 'reports_page.dart' deferred as reports;

Future<Widget> openReports() async {
  await reports.loadLibrary();
  return reports.ReportsPage();
}'''),
        DocText([
          'Show a ',
          DocLink.page('spinner', 'Components', 'Spinners'),
          ' or ',
          DocLink.page('placeholders', 'Components', 'Placeholders'),
          ' while it loads, for example inside a ',
          DocCode('FutureBuilder'),
          '.',
        ]),
        const DocHeading('Cheap rebuilds'),
        DocText([
          'This one has no counterpart in a stylesheet. A widget is rebuilt '
              'whenever its state changes, and the way the package is used '
              'decides how much that costs.',
        ]),
        const DocList([
          DocListItem([
            'Make widgets and styles ',
            DocCode('const'),
            ' wherever you can. The widgets of the package have ',
            DocCode('const'),
            ' constructors, and so do the ',
            DocCode('Bs*Style'),
            ' classes, so a style kept in a constant is built once.',
          ]),
          DocListItem([
            'Keep ',
            DocCode('setState'),
            ' low in the tree: put the state in the small widget that '
                'changes, not in the page.',
          ]),
          DocListItem([
            'Build long lists lazily, with ',
            DocCode('ListView.builder'),
            ', rather than putting hundreds of widgets in a ',
            DocCode('Column'),
            '.',
          ]),
        ]),
        const DocHeading('Always use HTTPS'),
        DocText([
          'Serve your app over HTTPS in production. A page served over HTTPS '
              'cannot load images or other resources over plain HTTP: the '
              'browser blocks them as mixed content, so use ',
          DocCode('https://'),
          ' URLs for the images and data your app requests. Whether you host '
              'the app yourself or on a service, only use secure connections.',
        ]),
        const DocHeading('Additional resources'),
        DocList([
          DocListItem([
            DocLink.url(
              'Performance best practices, in the Flutter documentation',
              'https://docs.flutter.dev/perf/best-practices',
            ),
          ]),
          DocListItem([
            DocLink.url(
              'Deferred components and libraries, on dart.dev',
              'https://dart.dev/language/libraries#lazily-loading-a-library',
            ),
          ]),
          DocListItem([
            DocLink.url(
              'Support for WebAssembly',
              'https://docs.flutter.dev/platform-integration/web/wasm',
            ),
          ]),
        ]),
      ],
    );
  }
}
