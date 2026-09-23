import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Alerts',
      lead:
          'BsAlert wraps content in a tinted, bordered banner keyed off a BsVariant, and can optionally render its '
          'own close button and drive itself out with dismissible: true.',
      examples: [
        DocExample(
          title: 'Variants',
          description: 'Every BsVariant maps to a matching background tint, text color, and border.',
          code: '''
Column(
  children: [
    for (final variant in BsVariant.values)
      BsAlert(
        variant: variant,
        child: Text('A simple \${variant.name} alert — check it out!'),
      ),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final variant in BsVariant.values)
                BsAlert(variant: variant, child: Text('A simple ${variant.name} alert — check it out!')),
            ],
          ),
        ),
        DocExample(
          title: 'Additional content',
          description: 'Since child accepts any widget, an alert can hold a heading, a divider, and multiple paragraphs.',
          code: '''
BsAlert(
  variant: BsVariant.success,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Well done!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      SizedBox(height: 8),
      Text('Aww yeah, you successfully read this important alert message.'),
      Container(height: 1, color: BsVariant.success.borderSubtle),
      Text('Whenever you need to, be sure to use margin utilities.'),
    ],
  ),
)''',
          preview: BsAlert(
            variant: BsVariant.success,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Well done!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                const Text(
                  'Aww yeah, you successfully read this important alert message. This example text is going '
                  'to run a bit longer so that you can see how spacing within an alert works with this kind of content.',
                ),
                Container(
                  height: 1,
                  color: BsVariant.success.borderSubtle,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                ),
                const Text('Whenever you need to, be sure to use margin utilities to keep things nice and tidy.'),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Dismissible',
          description: 'dismissible: true adds a close control; onDismissed fires once the alert has finished removing itself.',
          code: '''
BsAlert(
  variant: BsVariant.warning,
  dismissible: true,
  onDismissed: () => setState(() => _dismissed = true),
  child: Text('Holy guacamole! You should check in on some of those fields below.'),
)''',
          preview: const _DismissibleDemo(),
        ),
        DocExample(
          title: 'Custom style',
          description: 'style overrides color, background, and borderColor directly, bypassing the BsVariant palette entirely.',
          code: '''
BsAlert(
  style: BsAlertStyle(
    color: BsColors.white,
    background: Color(0xFF5C2D91),
    borderColor: Color(0xFF381A59),
  ),
  child: Text('A custom-styled alert using a brand color instead of a theme variant.'),
)''',
          preview: const BsAlert(
            style: BsAlertStyle(color: BsColors.white, background: Color(0xFF5C2D91), borderColor: Color(0xFF381A59)),
            child: Text('A custom-styled alert using a brand color instead of a theme variant.'),
          ),
        ),
      ],
    );
  }
}

class _DismissibleDemo extends StatefulWidget {
  const _DismissibleDemo();

  @override
  State<_DismissibleDemo> createState() => _DismissibleDemoState();
}

class _DismissibleDemoState extends State<_DismissibleDemo> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) {
      return BsButton(
        size: BsSize.sm,
        onPressed: () => setState(() => _dismissed = false),
        child: const Text('Show alert again'),
      );
    }
    return BsAlert(
      variant: BsVariant.warning,
      dismissible: true,
      onDismissed: () => setState(() => _dismissed = true),
      child: const Text('Holy guacamole! You should check in on some of those fields below.'),
    );
  }
}
