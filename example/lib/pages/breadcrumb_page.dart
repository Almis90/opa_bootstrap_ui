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
      ],
    );
  }
}
