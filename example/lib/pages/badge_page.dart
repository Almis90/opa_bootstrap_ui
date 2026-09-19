import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Badge',
      children: [
        DemoSection(
          title: 'Example',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Example heading ', style: TextStyle(fontSize: 24)),
              const BsBadge(child: Text('New')),
            ],
          ),
        ),
        DemoSection(
          title: 'Background colors',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final variant in BsVariant.values) BsBadge(variant: variant, child: Text(variant.name)),
            ],
          ),
        ),
        DemoSection(
          title: 'Pill badges',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final variant in BsVariant.values)
                BsBadge(variant: variant, pill: true, child: Text(variant.name)),
            ],
          ),
        ),
        DemoSection(
          title: 'In buttons',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              BsButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Notifications'),
                    SizedBox(width: 8),
                    BsBadge(variant: BsVariant.light, child: Text('4')),
                  ],
                ),
              ),
              BsButton(
                variant: BsVariant.secondary,
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Messages'),
                    SizedBox(width: 8),
                    BsBadge(variant: BsVariant.light, pill: true, child: Text('12')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
