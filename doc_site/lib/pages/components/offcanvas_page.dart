import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

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
          description:
              'Each BsOffcanvasPlacement slides the panel in from a different edge — start, end, top, or bottom.',
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
                BsButton(onPressed: () => _show(context, placement), child: Text(placement.name)),
            ],
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsOffcanvasController lets code outside show(), hide(), toggle(), or enable()/disable() an '
              'offcanvas. Unlike BsTooltipController/BsPopoverController/BsDropdownController, show()/hide() need '
              'a BuildContext (showBsOffcanvas pushes a route rather than driving a persistent widget), and '
              "disable() only blocks a *future* show() — it can't force-close one already open. Note the body's "
              "own Hide button below also calls controller.hide(context) — the page's Hide button sits behind "
              "the offcanvas's own barrier once it's open, so it can't be tapped to demonstrate the same call.",
          code: '''
final controller = BsOffcanvasController();

Widget buildOffcanvas(BuildContext context) => BsOffcanvas(
  header: BsOffcanvasHeader(
    onClose: () => Navigator.of(context).pop(),
    child: Text('Offcanvas'),
  ),
  body: BsOffcanvasBody(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Driven by an external BsOffcanvasController.'),
        BsButton(onPressed: () => controller.hide(context), child: Text('Hide')),
      ],
    ),
  ),
);

Wrap(
  spacing: 8,
  children: [
    BsButton(
      onPressed: () => controller.show(context: context, builder: buildOffcanvas),
      child: Text('Show'),
    ),
    BsButton(
      onPressed: () => controller.toggle(context: context, builder: buildOffcanvas),
      child: Text('Toggle'),
    ),
    BsButton(onPressed: controller.disable, child: Text('Disable')),
    BsButton(onPressed: controller.enable, child: Text('Enable')),
  ],
)''',
          preview: const _ControllerDemo(),
        ),
        DocExample(
          title: 'Events',
          description:
              'onShow fires synchronously before the route is even pushed; onShown/onHide/onHidden hang off the '
              "route's own slide animation instead of a fade like BsTooltip's, but fire at the same points — "
              "mirroring Bootstrap's show.bs.offcanvas/shown.bs.offcanvas/hide.bs.offcanvas/hidden.bs.offcanvas. "
              'Open it and close it to see the log below.',
          code: '''
showBsOffcanvas<void>(
  context: context,
  builder: (context) => BsOffcanvas(
    header: BsOffcanvasHeader(onClose: () => Navigator.of(context).pop(), child: Text('Offcanvas')),
    body: BsOffcanvasBody(child: Text('Close this to see the events logged below.')),
  ),
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
)''',
          preview: const _EventsDemo(),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsOffcanvasStyle',
          defaultsNote:
              'borderColor, background, and color swap for their dark-theme counterparts when BsTheme.of(context) '
              "is Brightness.dark. backdropColor/backdropOpacity don't — a backdrop stays the same dark scrim "
              'regardless of page theme.',
          rows: [
            DocStyleRow(field: 'padding', defaultValue: 'EdgeInsets.all(16)'),
            DocStyleRow(field: 'horizontalWidth', defaultValue: '400'),
            DocStyleRow(field: 'verticalHeightFraction', defaultValue: '0.3 (30% of the viewport height)'),
            DocStyleRow(field: 'transitionDuration', defaultValue: '300ms'),
            DocStyleRow(field: 'borderColor', defaultValue: 'Black at ~18% opacity'),
            DocStyleRow(field: 'borderWidth', defaultValue: '1'),
            DocStyleRow(field: 'titleLineHeight', defaultValue: '1.5'),
            DocStyleRow(field: 'background', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'color', defaultValue: 'BsColors.gray900'),
            DocStyleRow(field: 'boxShadow', defaultValue: 'Black at ~7% opacity, offset (0, 2), 4 blur'),
            DocStyleRow(field: 'backdropColor', defaultValue: 'BsColors.black'),
            DocStyleRow(field: 'backdropOpacity', defaultValue: '0.5'),
          ],
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
        body: const BsOffcanvasBody(child: Text('This is some placeholder content for the offcanvas.')),
      ),
    );
  }
}

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  late final BsOffcanvasController _controller = BsOffcanvasController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildOffcanvas(BuildContext context) => BsOffcanvas(
    header: BsOffcanvasHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Offcanvas')),
    body: BsOffcanvasBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Driven by an external BsOffcanvasController.'),
          const SizedBox(height: 12),
          BsButton(onPressed: () => _controller.hide(context), child: const Text('Hide')),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        BsButton(
          size: BsSize.sm,
          onPressed: () => _controller.show<void>(context: context, builder: _buildOffcanvas),
          child: const Text('Show'),
        ),
        BsButton(
          size: BsSize.sm,
          onPressed: () => _controller.toggle<void>(context: context, builder: _buildOffcanvas),
          child: const Text('Toggle'),
        ),
        BsButton(
          size: BsSize.sm,
          variant: BsVariant.secondary,
          onPressed: _controller.disable,
          child: const Text('Disable'),
        ),
        BsButton(
          size: BsSize.sm,
          variant: BsVariant.secondary,
          onPressed: _controller.enable,
          child: const Text('Enable'),
        ),
      ],
    );
  }
}

class _EventsDemo extends StatefulWidget {
  const _EventsDemo();

  @override
  State<_EventsDemo> createState() => _EventsDemoState();
}

class _EventsDemoState extends State<_EventsDemo> {
  final _events = <String>[];

  void _log(String event) => setState(() => _events.add(event));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsButton(
          onPressed: () => showBsOffcanvas<void>(
            context: context,
            builder: (context) => BsOffcanvas(
              header: BsOffcanvasHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Offcanvas')),
              body: const BsOffcanvasBody(child: Text('Close this to see the events logged below.')),
            ),
            onShow: () => _log('show'),
            onShown: () => _log('shown'),
            onHide: () => _log('hide'),
            onHidden: () => _log('hidden'),
          ),
          child: const Text('Open offcanvas'),
        ),
        const SizedBox(height: 16),
        if (_events.isEmpty)
          Text(
            'No events yet — open the offcanvas above and close it.',
            style: TextStyle(color: BsBody.secondaryColorOf(context)),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final event in _events) BsBadge(variant: BsVariant.secondary, child: Text(event))],
          ),
      ],
    );
  }
}
