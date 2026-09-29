import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ModalPage extends StatelessWidget {
  const ModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Modal',
      lead:
          'showBsModal pushes a BsModalDialog (header, body, footer) as a route via the ambient Navigator, so it '
          'gets a real barrier, focus handling, and back-button dismissal for free rather than being hand-rolled with an Overlay.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'The default modal: tap the backdrop, press escape, or call Navigator.pop to dismiss it.',
          code: '''
showBsModal<void>(
  context: context,
  builder: (context) => BsModalDialog(
    child: BsModal(
      header: BsModalHeader(
        onClose: () => Navigator.of(context).pop(),
        child: Text('Modal title'),
      ),
      body: BsModalBody(child: Text('Woohoo, you are reading this text in a modal!')),
      footer: BsModalFooter(
        children: [
          BsButton(outline: true, onPressed: () => Navigator.of(context).pop(), child: Text('Close')),
          BsButton(onPressed: () => Navigator.of(context).pop(), child: Text('Save changes')),
        ],
      ),
    ),
  ),
)''',
          preview: BsButton(onPressed: () => _showBasic(context), child: const Text('Launch modal')),
        ),
        DocExample(
          title: 'Static backdrop',
          description:
              'barrierDismissible: false keeps the modal open when the backdrop is tapped or escape is pressed.',
          code: '''
showBsModal<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => BsModalDialog(
    child: BsModal(
      header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: Text('Modal title')),
      body: BsModalBody(
        child: Text("I will not close if you click outside of me. Don't even try to press escape key."),
      ),
    ),
  ),
)''',
          preview: BsButton(
            onPressed: () => _showBasic(context, barrierDismissible: false),
            child: const Text('Launch static-backdrop modal'),
          ),
        ),
        DocExample(
          title: 'Centered',
          description: 'centered: true on BsModalDialog vertically centers the dialog in the viewport.',
          code: '''
showBsModal<void>(
  context: context,
  builder: (context) => BsModalDialog(
    centered: true,
    child: BsModal(
      header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: Text('Centered modal')),
      body: BsModalBody(child: Text('This modal is vertically centered in the viewport.')),
    ),
  ),
)''',
          preview: BsButton(onPressed: () => _showCentered(context), child: const Text('Launch centered modal')),
        ),
        DocExample(
          title: 'Scrollable long content',
          description: 'scrollableBody: true keeps the header/footer fixed and scrolls only the body when its content overflows.',
          code: '''
showBsModal<void>(
  context: context,
  builder: (context) => BsModalDialog(
    child: BsModal(
      scrollableBody: true,
      header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: Text('Scrollable modal')),
      body: BsModalBody(
        child: Column(
          children: [for (var i = 1; i <= 30; i++) Text('Line \$i of long content.')],
        ),
      ),
      footer: BsModalFooter(
        children: [BsButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close'))],
      ),
    ),
  ),
)''',
          preview: BsButton(onPressed: () => _showScrollable(context), child: const Text('Launch scrollable modal')),
        ),
        DocExample(
          title: 'Sizes',
          description: 'size accepts BsModalSize.small, .large, or .extraLarge to widen or narrow the dialog.',
          code: '''
showBsModal<void>(
  context: context,
  builder: (context) => BsModalDialog(
    size: BsModalSize.large,
    child: BsModal(
      header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: Text('Large modal')),
      body: BsModalBody(child: Text('This modal demonstrates a non-default size.')),
    ),
  ),
)''',
          preview: Wrap(
            spacing: 8,
            children: [
              BsButton(
                onPressed: () => _showSized(context, BsModalSize.small, 'Small modal'),
                child: const Text('Small'),
              ),
              BsButton(
                onPressed: () => _showSized(context, BsModalSize.large, 'Large modal'),
                child: const Text('Large'),
              ),
              BsButton(
                onPressed: () => _showSized(context, BsModalSize.extraLarge, 'Extra large modal'),
                child: const Text('Extra large'),
              ),
            ],
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsModalController lets code outside show(), hide(), toggle(), or enable()/disable() a modal. '
              'Unlike BsTooltipController/BsPopoverController/BsDropdownController, show()/hide() need a '
              "BuildContext (showBsModal pushes a route rather than driving a persistent widget), and disable() "
              "only blocks a *future* show() — it can't force-close one already open. Note the footer's own Hide "
              "button below also calls controller.hide(context) — the page's Hide button sits behind the modal's "
              "own barrier once the modal is open, so it can't be tapped to demonstrate the same call.",
          code: '''
final controller = BsModalController();

Widget buildModal(BuildContext context) => BsModalDialog(
  child: BsModal(
    header: BsModalHeader(
      onClose: () => Navigator.of(context).pop(),
      child: Text('Modal'),
    ),
    body: BsModalBody(child: Text('Driven by an external BsModalController.')),
    footer: BsModalFooter(
      children: [BsButton(onPressed: () => controller.hide(context), child: Text('Hide'))],
    ),
  ),
);

Wrap(
  spacing: 8,
  children: [
    BsButton(
      onPressed: () => controller.show(context: context, builder: buildModal),
      child: Text('Show'),
    ),
    BsButton(
      onPressed: () => controller.toggle(context: context, builder: buildModal),
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
              "route's own fade animation, firing at the same points as BsOffcanvas's slide — mirroring "
              "Bootstrap's show.bs.modal/shown.bs.modal/hide.bs.modal/hidden.bs.modal. Open it and close it to "
              'see the log below.',
          code: '''
showBsModal<void>(
  context: context,
  builder: (context) => BsModalDialog(
    child: BsModal(
      header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: Text('Modal')),
      body: BsModalBody(child: Text('Close this to see the events logged below.')),
    ),
  ),
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
)''',
          preview: const _EventsDemo(),
        ),
      ],
    );
  }

  static void _showBasic(BuildContext context, {bool barrierDismissible = true}) {
    showBsModal<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => BsModalDialog(
        child: BsModal(
          header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Modal title')),
          body: BsModalBody(
            child: Text(
              barrierDismissible
                  ? 'Woohoo, you are reading this text in a modal!'
                  : "I will not close if you click outside of me. Don't even try to press escape key.",
            ),
          ),
          footer: BsModalFooter(
            children: [
              BsButton(outline: true, onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
              BsButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Save changes')),
            ],
          ),
        ),
      ),
    );
  }

  static void _showCentered(BuildContext context) {
    showBsModal<void>(
      context: context,
      builder: (context) => BsModalDialog(
        centered: true,
        child: BsModal(
          header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Centered modal')),
          body: const BsModalBody(child: Text('This modal is vertically centered in the viewport.')),
        ),
      ),
    );
  }

  static void _showScrollable(BuildContext context) {
    showBsModal<void>(
      context: context,
      builder: (context) => BsModalDialog(
        child: BsModal(
          scrollableBody: true,
          header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Scrollable modal')),
          body: BsModalBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 1; i <= 30; i++)
                  Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('Line $i of long content.')),
              ],
            ),
          ),
          footer: BsModalFooter(
            children: [BsButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
          ),
        ),
      ),
    );
  }

  static void _showSized(BuildContext context, BsModalSize size, String title) {
    showBsModal<void>(
      context: context,
      builder: (context) => BsModalDialog(
        size: size,
        child: BsModal(
          header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: Text(title)),
          body: const BsModalBody(child: Text('This modal demonstrates a non-default size.')),
        ),
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
  late final BsModalController _controller = BsModalController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildModal(BuildContext context) => BsModalDialog(
    child: BsModal(
      header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Modal')),
      body: const BsModalBody(child: Text('Driven by an external BsModalController.')),
      footer: BsModalFooter(
        children: [BsButton(onPressed: () => _controller.hide(context), child: const Text('Hide'))],
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
          onPressed: () => _controller.show<void>(context: context, builder: _buildModal),
          child: const Text('Show'),
        ),
        BsButton(
          size: BsSize.sm,
          onPressed: () => _controller.toggle<void>(context: context, builder: _buildModal),
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
          onPressed: () => showBsModal<void>(
            context: context,
            builder: (context) => BsModalDialog(
              child: BsModal(
                header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Modal')),
                body: const BsModalBody(child: Text('Close this to see the events logged below.')),
              ),
            ),
            onShow: () => _log('show'),
            onShown: () => _log('shown'),
            onHide: () => _log('hide'),
            onHidden: () => _log('hidden'),
          ),
          child: const Text('Open modal'),
        ),
        const SizedBox(height: 16),
        if (_events.isEmpty)
          Text(
            'No events yet — open the modal above and close it.',
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
