import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// A minimal page shell shared by every component demo page: a header with
/// a back link (when there's somewhere to go back to) and a title, then a
/// scrollable, padded body. Deliberately not a Material `Scaffold` — this
/// package doesn't depend on Material/Cupertino.
class DemoPage extends StatelessWidget {
  const DemoPage({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BsColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: Navigator.of(context).pop,
                        child: const Text('< Back', style: TextStyle(color: BsColors.blue)),
                      ),
                    ),
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(height: 1, color: BsBorders.color),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A section heading + spacing, used to separate demo groups within a page.
class DemoSection extends StatelessWidget {
  const DemoSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title), const SizedBox(height: 8), child],
      ),
    );
  }
}
