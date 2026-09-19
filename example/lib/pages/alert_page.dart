import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Alert',
      children: [
        DemoSection(
          title: 'Variants',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final variant in BsVariant.values)
                BsAlert(
                  variant: variant,
                  child: Text('A simple ${variant.name} alert — check it out!'),
                ),
            ],
          ),
        ),
        DemoSection(
          title: 'Additional content',
          child: BsAlert(
            variant: BsVariant.success,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Well done!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                const Text(
                  "Aww yeah, you successfully read this important alert message. This "
                  "example text is going to run a bit longer so that you can see how "
                  'spacing within an alert works with this kind of content.',
                ),
                Container(height: 1, color: BsVariant.success.borderSubtle, margin: const EdgeInsets.symmetric(vertical: 12)),
                const Text(
                  'Whenever you need to, be sure to use margin utilities to keep '
                  'things nice and tidy.',
                ),
              ],
            ),
          ),
        ),
        DemoSection(title: 'Dismissible', child: _DismissibleDemo()),
        DemoSection(
          title: 'Custom style',
          child: const BsAlert(
            style: BsAlertStyle(
              color: BsColors.white,
              background: Color(0xFF5C2D91),
              borderColor: Color(0xFF381A59),
            ),
            child: Text('A custom-styled alert using a brand color instead of a theme variant.'),
          ),
        ),
        DemoSection(title: 'Events', child: _EventsDemo()),
      ],
    );
  }
}

class _EventsDemo extends StatefulWidget {
  @override
  State<_EventsDemo> createState() => _EventsDemoState();
}

class _EventsDemoState extends State<_EventsDemo> {
  bool _visible = true;
  final List<String> _log = [];

  void _logEvent(String message) {
    setState(() {
      _log.insert(0, message);
      if (_log.length > 4) _log.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_visible)
          BsAlert(
            dismissible: true,
            onClose: () => _logEvent('close.bs.alert'),
            onDismissed: () {
              _logEvent('closed.bs.alert');
              setState(() => _visible = false);
            },
            child: const Text('Watch the log below as you close this alert.'),
          )
        else
          BsButton(
            size: BsSize.sm,
            onPressed: () => setState(() => _visible = true),
            child: const Text('Show alert again'),
          ),
        const SizedBox(height: 12),
        for (final entry in _log) Text(entry, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
      ],
    );
  }
}

class _DismissibleDemo extends StatefulWidget {
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
