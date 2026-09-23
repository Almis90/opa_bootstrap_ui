import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class BreadcrumbPage extends StatelessWidget {
  const BreadcrumbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Breadcrumb',
      lead:
          'BsBreadcrumb lays out a list of BsBreadcrumbItem labels separated by a divider, indicating the current '
          "page's location within a hierarchy. Items without onTap render as plain, non-interactive text.",
      examples: [
        DocExample(
          title: 'Example',
          description: 'A single tappable crumb.',
          code: '''
BsBreadcrumb(
  items: [BsBreadcrumbItem(label: Text('Home'), onTap: () {})],
)''',
          preview: BsBreadcrumb(items: [BsBreadcrumbItem(label: const Text('Home'), onTap: () {})]),
        ),
        DocExample(
          title: 'Multiple levels',
          description: 'Items without onTap (typically the last, current one) render without a tap target.',
          code: '''
BsBreadcrumb(
  items: [
    BsBreadcrumbItem(label: Text('Home'), onTap: () {}),
    BsBreadcrumbItem(label: Text('Library'), onTap: () {}),
    BsBreadcrumbItem(label: Text('Data')),
  ],
)''',
          preview: BsBreadcrumb(
            items: [
              BsBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              BsBreadcrumbItem(label: const Text('Library'), onTap: () {}),
              const BsBreadcrumbItem(label: Text('Data')),
            ],
          ),
        ),
        DocExample(
          title: 'Custom text divider',
          description: 'BsBreadcrumbStyle(divider: ...) swaps the default slash for any string.',
          code: '''
BsBreadcrumb(
  style: BsBreadcrumbStyle(divider: '>'),
  items: [
    BsBreadcrumbItem(label: Text('Home'), onTap: () {}),
    BsBreadcrumbItem(label: Text('Library')),
  ],
)''',
          preview: BsBreadcrumb(
            style: const BsBreadcrumbStyle(divider: '>'),
            items: [BsBreadcrumbItem(label: const Text('Home'), onTap: () {}), const BsBreadcrumbItem(label: Text('Library'))],
          ),
        ),
        DocExample(
          title: 'Icon divider',
          description: 'dividerBuilder swaps the divider for any widget, such as a small chevron icon.',
          code: '''
BsBreadcrumb(
  dividerBuilder: (context) => const ChevronDivider(),
  items: [
    BsBreadcrumbItem(label: Text('Home'), onTap: () {}),
    BsBreadcrumbItem(label: Text('Library')),
  ],
)''',
          preview: BsBreadcrumb(
            dividerBuilder: (context) => const _ChevronDivider(),
            items: [BsBreadcrumbItem(label: const Text('Home'), onTap: () {}), const BsBreadcrumbItem(label: Text('Library'))],
          ),
        ),
        DocExample(
          title: 'No divider',
          description: "An empty divider string removes the separator entirely, leaving just the items' own spacing.",
          code: '''
BsBreadcrumb(
  style: BsBreadcrumbStyle(divider: ''),
  items: [
    BsBreadcrumbItem(label: Text('Home'), onTap: () {}),
    BsBreadcrumbItem(label: Text('Library')),
  ],
)''',
          preview: BsBreadcrumb(
            style: const BsBreadcrumbStyle(divider: ''),
            items: [BsBreadcrumbItem(label: const Text('Home'), onTap: () {}), const BsBreadcrumbItem(label: Text('Library'))],
          ),
        ),
      ],
    );
  }
}

/// A small right-pointing chevron used as a custom breadcrumb divider.
class _ChevronDivider extends StatelessWidget {
  const _ChevronDivider();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(8, 8), painter: _ChevronDividerPainter());
  }
}

class _ChevronDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.31, 0)
      ..lineTo(size.width * 0.125, size.height * 0.19)
      ..lineTo(size.width * 0.44, size.height * 0.5)
      ..lineTo(size.width * 0.125, size.height * 0.81)
      ..lineTo(size.width * 0.31, size.height)
      ..lineTo(size.width, size.height * 0.5)
      ..close();
    canvas.drawPath(path, Paint()..color = BsBreadcrumbStyle.defaultDividerColor);
  }

  @override
  bool shouldRepaint(covariant _ChevronDividerPainter oldDelegate) => false;
}
