import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'bootstrap_icon.dart';
import 'example_theme_toggler.dart';

/// The navbar's theme switcher (`ThemeToggler.astro` in the docs layout): a
/// `.nav-link.dropdown-toggle` showing the active mode's icon, opening a
/// `.dropdown-menu-end.shadow` of Light / Dark / Auto.
///
/// [mode] is Bootstrap's `data-bs-theme`: [Brightness.light],
/// [Brightness.dark], or null for `auto` (follow the OS).
class DocThemeMenu extends StatelessWidget {
  const DocThemeMenu({super.key, required this.mode, required this.onChanged});

  final Brightness? mode;
  final ValueChanged<Brightness?> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = ExampleThemeToggler.modes.firstWhere((m) => m.$1 == mode).$3;
    return BsDropdown(
      alignEnd: true,
      style: const BsDropdownStyle(boxShadow: BsShadows.shadow),
      items: [
        for (final (value, label, icon) in ExampleThemeToggler.modes)
          BsDropdownItem(
            active: value == mode,
            onTap: () => onChanged(value),
            child: Row(
              children: [
                Opacity(opacity: 0.5, child: BootstrapIcon(icon)),
                const SizedBox(width: 8),
                Expanded(child: Text(label)),
                if (value == mode)
                  const BootstrapIcon(BootstrapIconData.check2),
              ],
            ),
          ),
      ],
      toggleBuilder: (context, toggle, isOpen) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          key: const Key('doc-shell-theme-menu'),
          behavior: HitTestBehavior.opaque,
          onTap: toggle,
          // A `.nav-link`'s `.5rem` all round.
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: BsColors.white),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BootstrapIcon(active, color: BsColors.white),
                  const SizedBox(width: BsDropdownCaret.marginStart),
                  const BsDropdownCaret(color: BsColors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
