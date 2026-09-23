import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class OffcanvasPage extends StatelessWidget {
  const OffcanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Offcanvas',
      lead:
          'showBsOffcanvas pushes a BsOffcanvas panel in from an edge of the screen over a dismissible backdrop, '
          'reusing the same route-based overlay machinery as showBsModal but sliding from placement instead of '
          'centering.',
      examples: [
        DocExample(
          title: 'Placements',
          description: 'Each BsOffcanvasPlacement slides the panel in from a different edge — start, end, top, or bottom.',
          code: '''
for (final placement in BsOffcanvasPlacement.values)
  BsButton(
    onPressed: () => showBsOffcanvas<void>(
      context: context,
      placement: placement,
      builder: (context) => BsOffcanvas(
        placement: placement,
        header: BsOffcanvasHeader(
          onClose: () => Navigator.of(context).pop(),
          child: Text('\${placement.name} offcanvas'),
        ),
        body: const BsOffcanvasBody(
          child: Text('This is some placeholder content for the offcanvas.'),
        ),
      ),
    ),
    child: Text(placement.name),
  )''',
          preview: Wrap(
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
