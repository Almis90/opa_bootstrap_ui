import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class OffcanvasPage extends StatelessWidget {
  const OffcanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Offcanvas',
      children: [
        DemoSection(
          title: 'Placements',
          child: Wrap(
            spacing: 8,
            children: [
              for (final placement in BsOffcanvasPlacement.values)
                BsButton(
                  onPressed: () => _show(context, placement),
                  child: Text(placement.name),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _show(BuildContext context, BsOffcanvasPlacement placement) {
    showBsOffcanvas<void>(
      context: context,
      placement: placement,
      builder: (context) => BsOffcanvas(
        placement: placement,
        header: BsOffcanvasHeader(
          onClose: () => Navigator.of(context).pop(),
          child: Text('${placement.name} offcanvas'),
        ),
        body: const BsOffcanvasBody(
          child: Text('This is some placeholder content for the offcanvas.'),
        ),
      ),
    );
  }
}
