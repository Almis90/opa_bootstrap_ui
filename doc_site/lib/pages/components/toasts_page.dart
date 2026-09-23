import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

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
          preview: BsButton(
            onPressed: () => _showBasic(context),
            child: const Text('Show live toast'),
          ),
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
          preview: BsButton(
            onPressed: () => _showBodyOnly(context),
            child: const Text('Show headerless toast'),
          ),
        ),
        DocExample(
          title: 'Placement',
          description: 'position picks which screen corner (or top/bottom center) the toast stack anchors to.',
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
      ],
    );
  }

  void _showBasic(BuildContext context, {BsToastPosition position = BsToastPosition.bottomEnd, String? title}) {
    showBsToast(
      context,
      position: position,
      builder: (context, dismiss) => BsToast(
        header: BsToastHeader(
          title: Text(title ?? 'Bootstrap'),
          meta: const Text('11 mins ago'),
          onClose: dismiss,
        ),
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
