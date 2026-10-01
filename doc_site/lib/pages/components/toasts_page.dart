import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

class ToastsPage extends StatelessWidget {
  const ToastsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Toasts',
      lead:
          'showBsToast pushes a BsToast into an overlay stack anchored at a BsToastPosition corner, auto-dismissing '
          'it after a duration and stacking multiple toasts at the same position rather than queueing them one at a time.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'BsToastHeader supplies a title, meta text, and close button above the BsToast body.',
          code: '''
showBsToast(
  context,
  builder: (context, dismiss) => BsToast(
    header: BsToastHeader(
      title: Text('Bootstrap'),
      meta: Text('11 mins ago'),
      onClose: dismiss,
    ),
    body: Text('Hello, world! This is a toast message.'),
  ),
)''',
          preview: BsButton(onPressed: () => _showBasic(context), child: const Text('Show live toast')),
        ),
        DocExample(
          title: 'Without a header',
          description: 'Omitting header leaves just the body text, for a minimal notification.',
          code: '''
showBsToast(
  context,
  builder: (context, dismiss) => const BsToast(
    body: Text('This toast has no header, just plain text.'),
  ),
)''',
          preview: BsButton(onPressed: () => _showBodyOnly(context), child: const Text('Show headerless toast')),
        ),
        DocExample(
          title: 'Placement',
          description:
              'position picks which screen corner (or edge center) the toast stack anchors to — including '
              'centerStart/centerEnd, which have no Bootstrap toast equivalent.',
          code: '''
showBsToast(
  context,
  position: BsToastPosition.topEnd,
  builder: (context, dismiss) => BsToast(...),
)''',
          preview: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in {
                'Top start': BsToastPosition.topStart,
                'Top center': BsToastPosition.topCenter,
                'Top end': BsToastPosition.topEnd,
                'Center start': BsToastPosition.centerStart,
                'Center end': BsToastPosition.centerEnd,
                'Bottom start': BsToastPosition.bottomStart,
                'Bottom center': BsToastPosition.bottomCenter,
                'Bottom end': BsToastPosition.bottomEnd,
              }.entries)
                BsButton(
                  outline: true,
                  onPressed: () => _showBasic(context, position: entry.value),
                  child: Text(entry.key),
                ),
            ],
          ),
        ),
        DocExample(
          title: 'Stacking',
          description: 'Calling showBsToast repeatedly at the same position stacks each new toast above the last.',
          code: '''
for (var i = 1; i <= 3; i++) {
  showBsToast(
    context,
    builder: (context, dismiss) => BsToast(
      header: BsToastHeader(title: Text('Notification \$i'), onClose: dismiss),
      body: Text('Hello, world! This is a toast message.'),
    ),
  );
}''',
          preview: BsButton(
            onPressed: () {
              for (var i = 1; i <= 3; i++) {
                _showBasic(context, title: 'Notification $i');
              }
            },
            child: const Text('Show three at once'),
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'showBsToast returns a BsToastController — hold onto it to hide() that specific toast early, '
              'instead of waiting for its own auto-dismiss timer or close button. Mirrors '
              "Bootstrap's own bootstrap.Toast.getInstance(el).hide().",
          code: '''
BsToastController? controller;

Wrap(
  spacing: 8,
  children: [
    BsButton(
      onPressed: () => controller = showBsToast(
        context,
        builder: (context, dismiss) => BsToast(
          header: BsToastHeader(title: Text('Bootstrap'), onClose: dismiss),
          body: Text('Driven by an external BsToastController.'),
        ),
      ),
      child: Text('Show toast'),
    ),
    BsButton(onPressed: () => controller?.hide(), child: Text('Dismiss')),
  ],
)''',
          preview: const _ControllerDemo(),
        ),
        DocExample(
          title: 'Events',
          description:
              'onShow/onHide fire immediately once a show or dismissal is triggered; onShown/onHidden fire once '
              "the fade animation actually finishes — mirroring Bootstrap's show.bs.toast/shown.bs.toast/"
              'hide.bs.toast/hidden.bs.toast.',
          code: '''
showBsToast(
  context,
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
  builder: (context, dismiss) => BsToast(
    header: BsToastHeader(title: Text('Bootstrap'), onClose: dismiss),
    body: Text('Close this (or wait) to see the events logged below.'),
  ),
)''',
          preview: const _EventsDemo(),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsToastStyle',
          defaultsNote:
              'background, borderColor, headerColor, headerBackground, and headerBorderColor swap for their '
              "dark-theme counterparts when BsTheme.of(context) is Brightness.dark. color doesn't swap — it's "
              "left null in both, so a toast's body text inherits whatever color surrounds it.",
          rows: [
            DocStyleRow(field: 'maxWidth', defaultValue: '350'),
            DocStyleRow(field: 'padding', defaultValue: 'EdgeInsets.symmetric(horizontal: 12, vertical: 8)'),
            DocStyleRow(field: 'fontSize', defaultValue: '14'),
            DocStyleRow(field: 'color', defaultValue: 'null — inherits the surrounding text color'),
            DocStyleRow(field: 'background', defaultValue: 'BsColors.white at 85% opacity'),
            DocStyleRow(field: 'borderWidth', defaultValue: '1'),
            DocStyleRow(field: 'borderColor', defaultValue: 'Black at ~18% opacity'),
            DocStyleRow(field: 'borderRadius', defaultValue: '6'),
            DocStyleRow(field: 'boxShadow', defaultValue: 'Black at ~15% opacity, offset (0, 8), 16 blur'),
            DocStyleRow(field: 'spacing', defaultValue: '24'),
            DocStyleRow(field: 'headerColor', defaultValue: 'BsColors.gray600'),
            DocStyleRow(field: 'headerBackground', defaultValue: 'BsColors.white at 85% opacity; same as background'),
            DocStyleRow(field: 'headerBorderColor', defaultValue: 'Black at ~18% opacity; same as borderColor'),
          ],
        ),
      ],
    );
  }

  void _showBasic(BuildContext context, {BsToastPosition position = BsToastPosition.bottomEnd, String? title}) {
    showBsToast(
      context,
      position: position,
      builder: (context, dismiss) => BsToast(
        header: BsToastHeader(title: Text(title ?? 'Bootstrap'), meta: const Text('11 mins ago'), onClose: dismiss),
        body: const Text('Hello, world! This is a toast message.'),
      ),
    );
  }

  void _showBodyOnly(BuildContext context) {
    showBsToast(
      context,
      builder: (context, dismiss) => const BsToast(body: Text('This toast has no header, just plain text.')),
    );
  }
}

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  BsToastController? _controller;

  void _show() {
    setState(() {
      _controller = showBsToast(
        context,
        builder: (context, dismiss) => BsToast(
          header: BsToastHeader(title: const Text('Bootstrap'), onClose: dismiss),
          body: const Text('Driven by an external BsToastController.'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        BsButton(size: BsSize.sm, onPressed: _show, child: const Text('Show toast')),
        BsButton(
          size: BsSize.sm,
          variant: BsVariant.secondary,
          onPressed: () => _controller?.hide(),
          child: const Text('Dismiss'),
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
  BsToastController? _controller;
  final _events = <String>[];

  void _log(String event) => setState(() => _events.add(event));

  void _show() {
    _controller = showBsToast(
      context,
      onShow: () => _log('show'),
      onShown: () => _log('shown'),
      onHide: () => _log('hide'),
      onHidden: () => _log('hidden'),
      builder: (context, dismiss) => BsToast(
        header: BsToastHeader(title: const Text('Bootstrap'), onClose: dismiss),
        body: const Text('Close this (or wait) to see the events logged below.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            BsButton(size: BsSize.sm, onPressed: _show, child: const Text('Show toast')),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: () => _controller?.hide(),
              child: const Text('Dismiss'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_events.isEmpty)
          Text('No events yet — show a toast above.', style: TextStyle(color: BsBody.secondaryColorOf(context)))
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
