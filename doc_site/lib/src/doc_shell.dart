import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'app_section.dart';
import 'doc_nav.dart';
import 'doc_sidebar.dart';
import 'example_entry.dart';
import 'examples_shell.dart';

/// The app shell: a dark top bar plus the selected page's content —
/// Bootstrap's docs layout (`bd-header` + `bd-sidebar` + `bd-main`) without
/// page-to-page navigation, since the sidebar swaps content in place instead
/// of routing.
///
/// Below [BsBreakpoint.md] the persistent [DocSidebar] doesn't fit, so it
/// moves into a [BsOffcanvas] opened from a hamburger button in the header —
/// the same collapse Bootstrap's own docs site does on mobile.
class DocShell extends StatefulWidget {
  const DocShell({
    super.key,
    required this.sections,
    required this.examples,
    required this.brightness,
    required this.onToggleBrightness,
  });

  final List<DocNavSection> sections;

  /// The Examples tab's gallery.
  final List<ExampleEntry> examples;

  /// The app's current [BsTheme] brightness, mirrored from [BsApp.brightness]
  /// so the header toggle can show the right icon/label.
  final Brightness brightness;

  /// Flips [brightness] between light and dark.
  final VoidCallback onToggleBrightness;

  @override
  State<DocShell> createState() => _DocShellState();
}

class _DocShellState extends State<DocShell> {
  late DocNavPage _selected = widget.sections.first.pages.first;
  AppSection _section = AppSection.docs;

  void _selectSection(AppSection section) => setState(() => _section = section);

  void _select(DocNavPage page) => setState(() => _selected = page);

  void _openMobileNav(BuildContext context) {
    showBsOffcanvas<void>(
      context: context,
      builder: (context) => BsOffcanvas(
        header: BsOffcanvasHeader(
          child: const Text('opa_bootstrap_ui docs'),
          onClose: () => Navigator.of(context).pop(),
        ),
        body: BsOffcanvasBody(
          child: DocSidebar(
            sections: widget.sections,
            selected: _selected,
            shrinkWrap: true,
            onSelect: (page) {
              Navigator.of(context).pop();
              _select(page);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < BsBreakpoint.md.minWidth;
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: BsColors.gray900,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  if (isMobile && _section == AppSection.docs) ...[
                    _HamburgerButton(key: const Key('doc-shell-hamburger'), onTap: () => _openMobileNav(context)),
                    const SizedBox(width: 16),
                  ],
                  if (!isMobile) ...[
                    const Text(
                      'opa_bootstrap_ui',
                      style: TextStyle(color: BsColors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 24),
                  ],
                  _SectionTab(
                    key: const Key('doc-shell-tab-docs'),
                    label: 'Docs',
                    selected: _section == AppSection.docs,
                    onTap: () => _selectSection(AppSection.docs),
                  ),
                  const SizedBox(width: 8),
                  _SectionTab(
                    key: const Key('doc-shell-tab-examples'),
                    label: 'Examples',
                    selected: _section == AppSection.examples,
                    onTap: () => _selectSection(AppSection.examples),
                  ),
                  const Spacer(),
                  _BrightnessToggle(
                    key: const Key('doc-shell-brightness-toggle'),
                    brightness: widget.brightness,
                    showLabel: !isMobile,
                    onTap: widget.onToggleBrightness,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _section == AppSection.examples
                  ? ColoredBox(color: BsBody.backgroundOf(context), child: ExamplesShell(examples: widget.examples))
                  : isMobile
                  ? ColoredBox(color: BsBody.backgroundOf(context), child: Builder(builder: _selected.builder))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 260,
                          child: DocSidebar(sections: widget.sections, selected: _selected, onSelect: _select),
                        ),
                        Container(width: 1, color: BsBorders.colorOf(context)),
                        Expanded(
                          child: ColoredBox(
                            color: BsBody.backgroundOf(context),
                            child: Builder(builder: _selected.builder),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// A "Docs"/"Examples" tab in the header, underlined when [selected].
class _SectionTab extends StatelessWidget {
  const _SectionTab({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: selected ? BsColors.white : const Color(0x00FFFFFF), width: 2)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? BsColors.white : BsColors.gray400,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

/// A sun/moon toggle in the header that flips the app's [BsTheme]
/// brightness — Bootstrap's docs site has the same control in its navbar.
class _BrightnessToggle extends StatelessWidget {
  const _BrightnessToggle({super.key, required this.brightness, required this.onTap, this.showLabel = true});

  final Brightness brightness;
  final VoidCallback onTap;

  /// Hides the "Light"/"Dark" text, leaving just the icon — used on mobile
  /// where the header has no room to spare.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: BsColors.gray700),
            borderRadius: BorderRadius.circular(BsBorders.radiusPill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isDark ? '☀' : '☽', style: const TextStyle(color: BsColors.white, fontSize: 14)),
              if (showLabel) ...[
                const SizedBox(width: 6),
                Text(
                  isDark ? 'Light' : 'Dark',
                  style: const TextStyle(color: BsColors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HamburgerButton extends StatelessWidget {
  const _HamburgerButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 24,
          height: 24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => Container(height: 2, decoration: BoxDecoration(color: BsColors.white, borderRadius: BorderRadius.circular(1))),
            ),
          ),
        ),
      ),
    );
  }
}
