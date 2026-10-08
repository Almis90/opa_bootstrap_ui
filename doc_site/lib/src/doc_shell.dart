import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'app_section.dart';
import 'doc_nav.dart';
import 'doc_sidebar.dart';
import 'doc_header.dart';
import 'doc_search.dart';
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

class _DocShellState extends State<DocShell> {
  late DocNavPage _selected = widget.sections.first.pages.first;
  AppSection _section = AppSection.docs;

  /// True once an example's own standalone page is open — Bootstrap's real
  /// examples have no site chrome of their own, so the app bar hides to
  /// match rather than wrapping them in docs-site navigation they'd never
  /// actually have.
  bool _exampleDetailOpen = false;

  /// An example picked from the search results, opened as the Examples tab is
  /// built; [_examplesGeneration] makes a fresh tab for each pick.
  ExampleEntry? _searchedExample;
  int _examplesGeneration = 0;

  bool _searchOpen = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  /// `Ctrl+K` / `Cmd+K` opens the search, as DocSearch's own shortcut does.
  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.keyK &&
        (HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed)) {
      _openSearch();
      return true;
    }
    return false;
  }

  void _openSearch() {
    if (_searchOpen || !mounted) return;
    _searchOpen = true;
    showDocSearch(context, [
      for (final section in widget.sections)
        for (final page in section.pages)
          DocSearchHit(
            group: section.title,
            title: page.title,
            onSelect: () => setState(() {
              _selected = page;
              _section = AppSection.docs;
              _exampleDetailOpen = false;
            }),
          ),
      for (final example in widget.examples)
        DocSearchHit(
          group: 'Examples',
          title: example.title,
          keywords: example.description,
          onSelect: () => setState(() {
            _section = AppSection.examples;
            _searchedExample = example;
            _examplesGeneration++;
            _exampleDetailOpen = true;
          }),
        ),
    ]).whenComplete(() => _searchOpen = false);
  }

  void _selectSection(AppSection section) => setState(() {
    _section = section;
    _searchedExample = null;
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
        // Bootstrap's docs move the sidebar into an offcanvas below `lg`.
        final isMobile = constraints.maxWidth < BsBreakpoint.lg.minWidth;
        final header = !_exampleDetailOpen;
        // The header goes last so its shadow falls over the page below it.
        return Stack(
          children: [
            Positioned.fill(
              top: header ? docHeaderHeight : 0,
              child: _section == AppSection.examples
                  ? ColoredBox(
                      color: BsBody.backgroundOf(context),
                      child: ExamplesShell(
                        key: ValueKey(_examplesGeneration),
                        initialEntry: _searchedExample,
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
            if (header)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DocHeader(
                  section: _section,
                  onSelectSection: _selectSection,
                  themeMode: widget.themeMode,
                  onThemeModeChanged: widget.onThemeModeChanged,
                  onOpenSidebar: () => _openMobileNav(context),
                  onOpenSearch: _openSearch,
                ),
              ),
          ],
        );
      },
    );
  }
}
