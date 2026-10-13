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
  const DocPage({
    super.key,
    required this.title,
    required this.lead,
    this.examples = const [],
    this.children = const [],
    this.leadGap = 32,
  });

  final String title;
  final String lead;
  final List<DocExample> examples;

  /// Extra content appended after [examples], for pages that need something
  /// other than a `DocExample`.
  final List<Widget> children;

  /// The space between the lead and what follows it.
  final double leadGap;

  /// The widest the text of a page gets.
  static const double maxContentWidth = 805;

  /// A font size that grows with the viewport below `xl` (`calc(<base> + <vw>)`)
  /// and is [full] from there up, as Bootstrap's responsive font sizes do.
  static double _fluid(double width, double full, double base, double vw) =>
      width >= BsBreakpoint.xl.minWidth ? full : base + vw * width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.sizeOf(context).width;
        final isMobile = constraints.maxWidth < BsBreakpoint.md.minWidth;
        final horizontalPadding = isMobile ? 16.0 : 40.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            isMobile ? 20 : 32,
            horizontalPadding,
            48,
          ),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: _fluid(width, 48, 22.8, 0.021),
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: BsTextColor.bodyEmphasis.of(context),
                    ),
                  ),
                  Text(
                    lead,
                    style: TextStyle(
                      fontSize: _fluid(width, 24, 20.4, 0.003),
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: leadGap),
                  ...examples,
                  ...children,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
