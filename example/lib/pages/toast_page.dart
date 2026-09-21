import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class ToastPage extends StatelessWidget {
  const ToastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Toasts',
      children: [
        DemoSection(
          title: 'Basic',
          child: BsButton(
            onPressed: () => _showBasic(context),
            child: const Text('Show live toast'),
          ),
        ),
        DemoSection(
          title: 'Without a header',
          child: BsButton(
            onPressed: () => _showBodyOnly(context),
            child: const Text('Show headerless toast'),
          ),
        ),
        DemoSection(
          title: 'Placement',
          child: Wrap(
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
        DemoSection(
          title: 'Stacking',
          child: BsButton(
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
