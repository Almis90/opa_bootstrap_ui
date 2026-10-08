import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'app_section.dart';
import 'doc_nav.dart';
import 'doc_sidebar.dart';
import 'doc_theme_menu.dart';
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
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final List<DocNavSection> sections;

  /// The Examples tab's gallery.
  final List<ExampleEntry> examples;

  /// [BsApp.brightness] as set, where null is `auto` (follow the OS): the
  /// theme menus show the mode, not the brightness it resolves to.
  final Brightness? themeMode;
  final ValueChanged<Brightness?> onThemeModeChanged;

  @override
  State<DocShell> createState() => _DocShellState();
}

/// Bootstrap's own violet (`--bd-violet-bg`, the docs' `.btn-bd-primary`).
const _headerColor = Color(0xFF712CF9);

class _DocShellState extends State<DocShell> {
  late DocNavPage _selected = widget.sections.first.pages.first;
  AppSection _section = AppSection.docs;

  /// True once an example's own standalone page is open — Bootstrap's real
  /// examples have no site chrome of their own, so the app bar hides to
  /// match rather than wrapping them in docs-site navigation they'd never
  /// actually have.
  bool _exampleDetailOpen = false;

  void _selectSection(AppSection section) => setState(() {
    _section = section;
    _exampleDetailOpen = false;
  });

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
            if (!_exampleDetailOpen)
              // `<nav class="navbar navbar-expand-md bg-… " data-bs-theme="dark">`
              BsTheme(
                brightness: Brightness.dark,
                child: BsDecoratedBox(
                  decoration: const BoxDecoration(color: _headerColor),
                  child: BsContainer.fluid(
                    child: BsNavbar(
                      colorScheme: BsNavbarColorScheme.dark,
                      expandBreakpoint: BsBreakpoint.md,
                      brand: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // The docs sidebar's own toggle, below `md`.
                          if (isMobile && _section == AppSection.docs) ...[
                            _HamburgerButton(
                              key: const Key('doc-shell-hamburger'),
                              onTap: () => _openMobileNav(context),
                            ),
                            const SizedBox(width: 16),
                          ],
                          // The package's logo, at Bootstrap's own 40x32.
                          Image.asset(
                            'assets/brand/logo.png',
                            height: 32,
                            filterQuality: FilterQuality.high,
                          ),
                        ],
                      ),
                      items: [
                        BsNavbarItem(
                          active: _section == AppSection.docs,
                          onTap: () => _selectSection(AppSection.docs),
                          child: const Text('Docs'),
                        ),
                        BsNavbarItem(
                          active: _section == AppSection.examples,
                          onTap: () => _selectSection(AppSection.examples),
                          child: const Text('Examples'),
                        ),
                      ],
                      trailing: [
                        DocThemeMenu(
                          mode: widget.themeMode,
                          onChanged: widget.onThemeModeChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: _section == AppSection.examples
                  ? ColoredBox(
                      color: BsBody.backgroundOf(context),
                      child: ExamplesShell(
                        examples: widget.examples,
                        themeMode: widget.themeMode,
                        onThemeModeChanged: widget.onThemeModeChanged,
                        onDetailChanged: (open) =>
                            setState(() => _exampleDetailOpen = open),
                      ),
                    )
                  : isMobile
                  ? ColoredBox(
                      color: BsBody.backgroundOf(context),
                      child: Builder(builder: _selected.builder),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 260,
                          child: DocSidebar(
                            sections: widget.sections,
                            selected: _selected,
                            onSelect: _select,
                          ),
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
              (_) => Container(
                height: 2,
                decoration: BoxDecoration(
                  color: BsColors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
