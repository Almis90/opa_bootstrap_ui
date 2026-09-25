import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

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
      children: const [
        _QuickStartStep(
          number: 1,
          title: 'Install',
          blocks: [
            _CodeBlock(label: 'pubspec.yaml', code: 'dependencies:\n  opa_bootstrap_ui: ^1.0.0'),
            _CodeBlock(label: 'or via the command line', code: 'flutter pub add opa_bootstrap_ui'),
          ],
        ),
        _QuickStartStep(
          number: 2,
          title: 'Set up main.dart',
          blocks: [
            _CodeBlock(
              code: '''
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
}''',
            ),
          ],
        ),
        _QuickStartStep(
          number: 3,
          title: 'Hello, world',
          blocks: [
            _CodeBlock(
              code: '''
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Hello, opa_bootstrap_ui!'));
  }
}''',
            ),
          ],
        ),
      ],
    );
  }
}

class _CodeBlock {
  const _CodeBlock({this.label, required this.code});

  final String? label;
  final String code;
}

class _QuickStartStep extends StatelessWidget {
  const _QuickStartStep({required this.number, required this.title, required this.blocks});

  final int number;
  final String title;
  final List<_CodeBlock> blocks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: BsColors.blue, shape: BoxShape.circle),
                child: Text(
                  '$number',
                  style: const TextStyle(color: BsColors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: BsBody.colorOf(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final block in blocks) ...[
            if (block.label != null) ...[
              Text(block.label!, style: TextStyle(fontSize: 13, color: BsBody.secondaryColorOf(context))),
              const SizedBox(height: 4),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BsColors.gray900,
                border: Border.all(color: BsBorders.colorOf(context)),
                borderRadius: BorderRadius.circular(BsBorders.radius),
              ),
              child: BsPre(style: const BsCodeStyle(preColor: BsColors.gray100), child: Text(block.code)),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
