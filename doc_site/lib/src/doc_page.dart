import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'doc_example.dart';

/// The template shared by every docs page: a title, a one- or two-sentence
/// lead paragraph, and either a list of [DocExample]s or arbitrary
/// [children] (for pages like Introduction that don't fit the
/// live-preview-plus-code-toggle shape).
///
/// Mirrors Bootstrap's docs page layout (`<h1>` + `.lead` + a series of
/// `.bd-example` blocks) from `DocsLayout.astro`.
class DocPage extends StatelessWidget {
  const DocPage({super.key, required this.title, required this.lead, this.examples = const [], this.children = const []});

  final String title;
  final String lead;
  final List<DocExample> examples;

  /// Extra content appended after [examples], for pages that need something
  /// other than a `DocExample`.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < BsBreakpoint.md.minWidth;
        final horizontalPadding = isMobile ? 16.0 : 40.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, isMobile ? 20 : 32, horizontalPadding, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: isMobile ? 26 : 32, fontWeight: FontWeight.w600, color: BsBody.colorOf(context)),
              ),
              const SizedBox(height: 12),
              Text(lead, style: TextStyle(fontSize: 18, color: BsBody.secondaryColorOf(context), height: 1.5)),
              const SizedBox(height: 32),
              ...examples,
              ...children,
            ],
          ),
        );
      },
    );
  }
}
