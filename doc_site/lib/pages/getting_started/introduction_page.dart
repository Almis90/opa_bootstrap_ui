import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Introduction',
      lead:
          'opa_bootstrap_ui ports Bootstrap 5 components to Flutter as a family of Bs*-prefixed '
          'widgets, built directly on flutter/widgets.dart with no Material or Cupertino dependency.',
      examples: [
        DocExample(
          title: 'Quick start',
          description:
              'Add the package to pubspec.yaml, then wrap your app in a WidgetsApp (not '
              'MaterialApp) — the package renders on raw widgets, so no design system is pulled '
              'in for free, and none is required.',
          code: '''
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: BsColors.blue,
      builder: (context, child) => DefaultTextStyle(
        style: const TextStyle(color: BsColors.gray900),
        child: child!,
      ),
      home: const HomePage(),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      ),
    );
  }
}''',
          preview: const _QuickStartPreview(),
        ),
        DocExample(
          title: 'Variants, sizes, and styles',
          description:
              'Components that carry Bootstrap contextual colors expose a variant enum '
              '(BsVariant), and most accept a style override built on the same tokens used '
              'internally, so a whole component can be recolored without subclassing it.',
          code: '''
BsButton(
  variant: BsVariant.success,
  onPressed: () {},
  child: const Text('Saved'),
)''',
          preview: Wrap(
            spacing: 12,
            children: [
              BsButton(variant: BsVariant.success, onPressed: () {}, child: const Text('Saved')),
              BsButton(variant: BsVariant.danger, outline: true, onPressed: () {}, child: const Text('Delete')),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickStartPreview extends StatelessWidget {
  const _QuickStartPreview();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Every Bs* widget renders standalone — no ancestor app widget is required to preview one, '
      'as this page demonstrates.',
      style: TextStyle(color: BsColors.gray700),
    );
  }
}
