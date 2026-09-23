import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'doc_nav.dart';

/// The persistent left-hand navigation, grouped by section.
///
/// Mirrors `DocsSidebar.astro`: a scrollable list of section headings, each
/// followed by its pages, with the active page highlighted.
class DocSidebar extends StatelessWidget {
  const DocSidebar({super.key, required this.sections, required this.selected, required this.onSelect});

  final List<DocNavSection> sections;
  final DocNavPage selected;
  final ValueChanged<DocNavPage> onSelect;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BsColors.gray100,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          for (final section in sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: Text(
                section.title.toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: BsColors.gray600, letterSpacing: 0.5),
              ),
            ),
            for (final page in section.pages) _SidebarLink(page: page, active: page == selected, onTap: () => onSelect(page)),
          ],
        ],
      ),
    );
  }
}

class _SidebarLink extends StatelessWidget {
  const _SidebarLink({required this.page, required this.active, required this.onTap});

  final DocNavPage page;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: active ? BsColors.blue.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(BsBorders.radiusSm),
          ),
          child: Text(
            page.title,
            style: TextStyle(
              fontSize: 14,
              color: active ? BsColors.blue : BsColors.gray700,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
