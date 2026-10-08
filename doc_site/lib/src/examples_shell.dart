import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'example_entry.dart';
import 'example_theme_toggler.dart';

/// The Examples tab's body: a gallery of [ExampleEntry]s that swaps to a
/// single example's full content (with a way back) when one is selected —
/// mirroring how Bootstrap's own site separates bite-sized component docs
/// from full, real-world page examples under `/examples`.
class ExamplesShell extends StatefulWidget {
  const ExamplesShell({
    super.key,
    required this.examples,
    required this.themeMode,
    required this.onThemeModeChanged,
    this.onDetailChanged,
    this.initialEntry,
  });

  final List<ExampleEntry> examples;

  /// Mirrored from [BsApp.brightness] (null = `auto`) so a selected example's
  /// own floating theme dropdown (Bootstrap's real examples each have a fixed
  /// bottom-end one, `.bd-mode-toggle`, since the page has no site navbar to
  /// hold it) shows the active mode.
  final Brightness? themeMode;
  final ValueChanged<Brightness?> onThemeModeChanged;

  /// Called with `true` once an example is open (its real page has no
  /// site chrome of its own, so [DocShell] hides its app bar) and `false`
  /// back at the gallery.
  final ValueChanged<bool>? onDetailChanged;

  /// An example to open straight away (from a search hit), skipping the
  /// gallery.
  final ExampleEntry? initialEntry;

  @override
  State<ExamplesShell> createState() => _ExamplesShellState();
}

class _ExamplesShellState extends State<ExamplesShell> {
  late ExampleEntry? _selected = widget.initialEntry;

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
      themeMode: widget.themeMode,
      onThemeModeChanged: widget.onThemeModeChanged,
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
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            isMobile ? 20 : 32,
            horizontalPadding,
            48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Examples',
                style: TextStyle(
                  fontSize: isMobile ? 26 : 32,
                  fontWeight: FontWeight.w600,
                  color: BsBody.colorOf(context),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Full, real-world pages built entirely from opa_bootstrap_ui widgets — the same idea as '
                "Bootstrap's own examples gallery, showing components working together rather than in isolation.",
                style: TextStyle(
                  fontSize: 18,
                  color: BsBody.secondaryColorOf(context),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  for (final entry in examples)
                    _ExampleCard(entry: entry, onTap: () => onSelect(entry)),
                ],
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
                Text(
                  widget.entry.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: BsBody.colorOf(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.entry.description,
                  style: TextStyle(
                    color: BsBody.secondaryColorOf(context),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'View example →',
                  style: TextStyle(
                    color: BsColors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
/// `<body>` with just a fixed-position mode toggle in the corner). Unlike the
/// real site this app has no URL per example, so [onBack] is bound to the
/// Escape key rather than a visible control the original doesn't have.
class _ExampleDetail extends StatefulWidget {
  const _ExampleDetail({
    required this.entry,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onBack,
  });

  final ExampleEntry entry;
  final Brightness? themeMode;
  final ValueChanged<Brightness?> onThemeModeChanged;
  final VoidCallback onBack;

  @override
  State<_ExampleDetail> createState() => _ExampleDetailState();
}

class _ExampleDetailState extends State<_ExampleDetail>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The browser's back button (or the system back gesture): back to the
  /// gallery. The app's Navigator is asked first, so an open dialog or
  /// modal closes before this does.
  @override
  Future<bool> didPopRoute() async {
    widget.onBack();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): widget.onBack,
      },
      child: Focus(
        autofocus: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Builder(builder: widget.entry.builder),
              ),
            ),
            if (widget.entry.fixed != null)
              Builder(builder: widget.entry.fixed!),
            // `.position-fixed.bottom-0.end-0.mb-3.me-3.bd-mode-toggle`
            Positioned(
              bottom: 16,
              right: 16,
              child: ExampleThemeToggler(
                mode: widget.themeMode,
                onChanged: widget.onThemeModeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
