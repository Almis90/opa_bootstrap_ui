import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'example_entry.dart';

/// The Examples tab's body: a gallery of [ExampleEntry]s that swaps to a
/// single example's full content (with a way back) when one is selected —
/// mirroring how Bootstrap's own site separates bite-sized component docs
/// from full, real-world page examples under `/examples`.
class ExamplesShell extends StatefulWidget {
  const ExamplesShell({
    super.key,
    required this.examples,
    required this.brightness,
    required this.onToggleBrightness,
    this.onDetailChanged,
  });

  final List<ExampleEntry> examples;

  /// Mirrored from [BsApp.brightness] so a selected example's own floating
  /// toggle (Bootstrap's real examples each have a fixed bottom-end one,
  /// `.bd-mode-toggle`, since the page has no site navbar to hold it) shows
  /// the right icon.
  final Brightness brightness;
  final VoidCallback onToggleBrightness;

  /// Called with `true` once an example is open (its real page has no
  /// site chrome of its own, so [DocShell] hides its app bar) and `false`
  /// back at the gallery.
  final ValueChanged<bool>? onDetailChanged;

  @override
  State<ExamplesShell> createState() => _ExamplesShellState();
}

class _ExamplesShellState extends State<ExamplesShell> {
  ExampleEntry? _selected;

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    if (selected == null) {
      return _ExamplesIndex(
        examples: widget.examples,
        onSelect: (entry) {
          setState(() => _selected = entry);
          widget.onDetailChanged?.call(true);
        },
      );
    }
    return _ExampleDetail(
      entry: selected,
      brightness: widget.brightness,
      onToggleBrightness: widget.onToggleBrightness,
      onBack: () {
        setState(() => _selected = null);
        widget.onDetailChanged?.call(false);
      },
    );
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

/// An example's own full-bleed page — no breadcrumb, no title, no site
/// chrome, matching how Bootstrap's real `examples/*` pages render (a bare
/// `<body>` with just a fixed-position mode toggle in the corner). [onBack]
/// still needs a way in since, unlike the real site, this app has no URL
/// per example to navigate back from with the browser's own back button —
/// a small floating control fills that gap without adding visible page
/// content the original doesn't have.
class _ExampleDetail extends StatelessWidget {
  const _ExampleDetail({
    required this.entry,
    required this.brightness,
    required this.onToggleBrightness,
    required this.onBack,
  });

  final ExampleEntry entry;
  final Brightness brightness;
  final VoidCallback onToggleBrightness;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: SingleChildScrollView(child: Builder(builder: entry.builder))),
        Positioned(top: 12, left: 12, child: _FloatingIconButton(icon: '←', onTap: onBack)),
        Positioned(
          bottom: 12,
          right: 12,
          child: _FloatingIconButton(
            icon: brightness == Brightness.dark ? '☀' : '☽',
            onTap: onToggleBrightness,
          ),
        ),
      ],
    );
  }
}

/// A small, semi-transparent circular button — mirrors the fixed-position
/// corner controls Bootstrap's real example pages use (`.bd-mode-toggle`
/// for the theme switch) without competing with the example content itself.
class _FloatingIconButton extends StatelessWidget {
  const _FloatingIconButton({required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xCC212529), shape: BoxShape.circle),
          child: Text(icon, style: const TextStyle(color: BsColors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
