import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'bootstrap_icon.dart';
import 'doc_nav.dart';

/// The persistent left-hand navigation: a heading with an icon for each group,
/// followed by its pages, with the current page highlighted. A link that stands
/// on its own (a [DocNavSection.link]) comes last, below a rule.
class DocSidebar extends StatelessWidget {
  const DocSidebar({
    super.key,
    required this.sections,
    required this.selected,
    required this.onSelect,
    this.shrinkWrap = false,
  });

  final List<DocNavSection> sections;
  final DocNavPage selected;
  final ValueChanged<DocNavPage> onSelect;

  /// True when nested inside another scrollable (the mobile offcanvas body,
  /// which is already a `SingleChildScrollView`) instead of filling a fixed
  /// height itself.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 16),
      children: [
        for (final section in sections)
          if (section.link case final link?) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              height: 1,
              color: BsBorders.colorOf(context),
            ),
            _SidebarLink(
              page: link,
              active: link == selected,
              onTap: () => onSelect(link),
            ),
          ] else
            _SidebarGroup(
              section: section,
              selected: selected,
              onSelect: onSelect,
            ),
      ],
    );
  }
}

/// A group: its heading (icon and title), then its links.
class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({
    required this.section,
    required this.selected,
    required this.onSelect,
  });

  final DocNavSection section;
  final DocNavPage selected;
  final ValueChanged<DocNavPage> onSelect;

  @override
  Widget build(BuildContext context) {
    final icon = section.icon;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: BsTextColor.bodyEmphasis.of(context),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  BootstrapIcon(icon, color: section.iconColor),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Text(section.title)),
              ],
            ),
          ),
          for (final page in section.pages)
            _SidebarLink(
              page: page,
              active: page == selected,
              onTap: () => onSelect(page),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// A page link: indented under its group's heading, filled with a violet tint
/// when current or under the pointer.
class _SidebarLink extends StatefulWidget {
  const _SidebarLink({
    required this.page,
    required this.active,
    required this.onTap,
  });

  final DocNavPage page;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_SidebarLink> createState() => _SidebarLinkState();
}

class _SidebarLinkState extends State<_SidebarLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dark = BsTheme.of(context) == Brightness.dark;
    final highlighted = widget.active || _hovered;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 2, start: 18),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: BsDecoratedBox(
              decoration: BoxDecoration(
                color: highlighted
                    ? (dark ? const Color(0x805521BB) : const Color(0x1A712CF9))
                    : null,
                borderRadius: BorderRadius.circular(BsBorders.radius),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  widget.page.title,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: widget.active
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: highlighted
                        ? BsTextColor.bodyEmphasis.of(context)
                        : BsBody.colorOf(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
