import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'doc_nav.dart';
import 'doc_sidebar.dart';

/// The app shell: a dark top bar plus the selected page's content —
/// Bootstrap's docs layout (`bd-header` + `bd-sidebar` + `bd-main`) without
/// page-to-page navigation, since the sidebar swaps content in place instead
/// of routing.
///
/// Below [BsBreakpoint.md] the persistent [DocSidebar] doesn't fit, so it
/// moves into a [BsOffcanvas] opened from a hamburger button in the header —
/// the same collapse Bootstrap's own docs site does on mobile.
class DocShell extends StatefulWidget {
  const DocShell({super.key, required this.sections});

  final List<DocNavSection> sections;

  @override
  State<DocShell> createState() => _DocShellState();
}

class _DocShellState extends State<DocShell> {
  late DocNavPage _selected = widget.sections.first.pages.first;

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
                  if (isMobile) ...[
                    _HamburgerButton(key: const Key('doc-shell-hamburger'), onTap: () => _openMobileNav(context)),
                    const SizedBox(width: 16),
                  ],
                  const Expanded(
                    child: Text(
                      'opa_bootstrap_ui docs',
                      style: TextStyle(color: BsColors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isMobile
                  ? ColoredBox(color: BsColors.white, child: Builder(builder: _selected.builder))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 260,
                          child: DocSidebar(sections: widget.sections, selected: _selected, onSelect: _select),
                        ),
                        Container(width: 1, color: BsBorders.color),
                        Expanded(
                          child: ColoredBox(color: BsColors.white, child: Builder(builder: _selected.builder)),
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
              (_) => Container(height: 2, decoration: BoxDecoration(color: BsColors.white, borderRadius: BorderRadius.circular(1))),
            ),
          ),
        ),
      ),
    );
  }
}
