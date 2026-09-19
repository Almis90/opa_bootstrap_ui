import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class BreadcrumbPage extends StatelessWidget {
  const BreadcrumbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Breadcrumb',
      children: [
        DemoSection(
          title: 'Example',
          child: BsBreadcrumb(
            items: [BsBreadcrumbItem(label: const Text('Home'), onTap: () {})],
          ),
        ),
        DemoSection(
          title: 'Multiple levels',
          child: BsBreadcrumb(
            items: [
              BsBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              BsBreadcrumbItem(label: const Text('Library'), onTap: () {}),
              const BsBreadcrumbItem(label: Text('Data')),
            ],
          ),
        ),
        DemoSection(
          title: 'Custom text divider',
          child: BsBreadcrumb(
            style: const BsBreadcrumbStyle(divider: '>'),
            items: [
              BsBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              const BsBreadcrumbItem(label: Text('Library')),
            ],
          ),
        ),
        DemoSection(
          title: 'Icon divider',
          child: BsBreadcrumb(
            dividerBuilder: (context) => const _ChevronDivider(),
            items: [
              BsBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              const BsBreadcrumbItem(label: Text('Library')),
            ],
          ),
        ),
        DemoSection(
          title: 'No divider',
          child: BsBreadcrumb(
            style: const BsBreadcrumbStyle(divider: ''),
            items: [
              BsBreadcrumbItem(label: const Text('Home'), onTap: () {}),
              const BsBreadcrumbItem(label: Text('Library')),
            ],
          ),
        ),
      ],
    );
  }
}

/// A small right-pointing chevron, replicating Bootstrap's SVG icon-divider
/// example.
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
