import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'example_entry.dart';

/// The Examples tab's body: a gallery of [ExampleEntry]s that swaps to a
/// single example's full content (with a way back) when one is selected —
/// mirroring how Bootstrap's own site separates bite-sized component docs
/// from full, real-world page examples under `/examples`.
class ExamplesShell extends StatefulWidget {
  const ExamplesShell({super.key, required this.examples});

  final List<ExampleEntry> examples;

  @override
  State<ExamplesShell> createState() => _ExamplesShellState();
}

class _ExamplesShellState extends State<ExamplesShell> {
  ExampleEntry? _selected;

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    if (selected == null) {
      return _ExamplesIndex(examples: widget.examples, onSelect: (entry) => setState(() => _selected = entry));
    }
    return _ExampleDetail(entry: selected, onBack: () => setState(() => _selected = null));
  }
}

class _ExamplesIndex extends StatelessWidget {
  const _ExamplesIndex({required this.examples, required this.onSelect});

  final List<ExampleEntry> examples;
  final ValueChanged<ExampleEntry> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < BsBreakpoint.md.minWidth;
        final horizontalPadding = isMobile ? 16.0 : 40.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, isMobile ? 20 : 32, horizontalPadding, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Examples',
                style: TextStyle(fontSize: isMobile ? 26 : 32, fontWeight: FontWeight.w600, color: BsBody.colorOf(context)),
              ),
              const SizedBox(height: 12),
              Text(
                'Full, real-world pages built entirely from opa_bootstrap_ui widgets — the same idea as '
                "Bootstrap's own examples gallery, showing components working together rather than in isolation.",
                style: TextStyle(fontSize: 18, color: BsBody.secondaryColorOf(context), height: 1.5),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [for (final entry in examples) _ExampleCard(entry: entry, onTap: () => onSelect(entry))],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExampleCard extends StatefulWidget {
  const _ExampleCard({required this.entry, required this.onTap});

  final ExampleEntry entry;
  final VoidCallback onTap;

  @override
  State<_ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<_ExampleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 320,
          child: BsCard(
            style: BsCardStyle(borderColor: _hovered ? BsColors.blue : null),
            child: BsCardBody(
              children: [
                Text(widget.entry.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: BsBody.colorOf(context))),
                const SizedBox(height: 8),
                Text(widget.entry.description, style: TextStyle(color: BsBody.secondaryColorOf(context), height: 1.4)),
                const SizedBox(height: 12),
                Text('View example →', style: TextStyle(color: BsColors.blue, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleDetail extends StatelessWidget {
  const _ExampleDetail({required this.entry, required this.onBack});

  final ExampleEntry entry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
          child: Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onBack,
                  child: Text('← Back to examples', style: const TextStyle(color: BsColors.blue, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(width: 16),
              Text('/', style: TextStyle(color: BsBody.secondaryColorOf(context))),
              const SizedBox(width: 16),
              Text(entry.title, style: TextStyle(fontWeight: FontWeight.w600, color: BsBody.colorOf(context))),
            ],
          ),
        ),
        Expanded(child: SingleChildScrollView(child: Builder(builder: entry.builder))),
      ],
    );
  }
}
