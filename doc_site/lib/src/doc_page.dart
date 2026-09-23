import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'doc_example.dart';

/// The template shared by every docs page: a title, a one- or two-sentence
/// lead paragraph, and a list of [DocExample]s.
///
/// Mirrors Bootstrap's docs page layout (`<h1>` + `.lead` + a series of
/// `.bd-example` blocks) from `DocsLayout.astro`.
class DocPage extends StatelessWidget {
  const DocPage({super.key, required this.title, required this.lead, this.examples = const []});

  final String title;
  final String lead;
  final List<DocExample> examples;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 32, 40, 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: BsColors.gray900)),
          const SizedBox(height: 12),
          Text(lead, style: const TextStyle(fontSize: 18, color: BsColors.gray700, height: 1.5)),
          const SizedBox(height: 32),
          ...examples,
        ],
      ),
    );
  }
}
