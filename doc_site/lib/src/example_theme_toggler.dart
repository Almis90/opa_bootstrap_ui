import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'bootstrap_icon.dart';

/// The theme switcher fixed to the bottom-end corner of every Bootstrap
/// example page — `ThemeToggler.astro` in its `examples` layout: a violet
/// `.btn-bd-primary.dropdown-toggle` showing only the active mode's icon,
/// opening a `.dropdown-menu-end.shadow` of Light / Dark / Auto.
///
/// [mode] is Bootstrap's `data-bs-theme`: [Brightness.light],
/// [Brightness.dark], or null for `auto` (follow the OS).
class ExampleThemeToggler extends StatelessWidget {
  const ExampleThemeToggler({super.key, required this.mode, required this.onChanged});

  final Brightness? mode;
  final ValueChanged<Brightness?> onChanged;

  // `--bd-violet-bg` and the shades `.btn-bd-primary` derives from it
  // (ExamplesLayout.astro).
  static const _violet = Color(0xFF712CF9);
  static const _violetHover = Color(0xFF6528E0);
  static const _violetActive = Color(0xFF5A23C8);

  static const _modes = <(Brightness?, String, BootstrapIconData)>[
    (Brightness.light, 'Light', BootstrapIconData.sunFill),
    (Brightness.dark, 'Dark', BootstrapIconData.moonStarsFill),
    (null, 'Auto', BootstrapIconData.circleHalf),
  ];

  @override
  Widget build(BuildContext context) {
    final activeIcon = _modes.firstWhere((m) => m.$1 == mode).$3;
    return BsDropdown(
      // `.dropdown-menu-end`; sitting at the bottom of the viewport, the menu
      // flips above it on its own, as Popper does for the original.
      alignEnd: true,
      style: const BsDropdownStyle(boxShadow: BsShadows.shadow),
      items: [
        for (final (value, label, icon) in _modes)
          BsDropdownItem(
            active: value == mode,
            onTap: () => onChanged(value),
            child: Row(
              children: [
                Opacity(opacity: 0.5, child: BootstrapIcon(icon)),
                const SizedBox(width: 8),
                Expanded(child: Text(label)),
                if (value == mode) const BootstrapIcon(BootstrapIconData.check2),
              ],
            ),
          ),
      ],
      toggleBuilder: (context, toggle, isOpen) => BsButton(
        onPressed: toggle,
        active: isOpen,
        style: const BsButtonStyle(
          color: BsColors.white,
          background: _violet,
          borderColor: _violet,
          hoverColor: BsColors.white,
          hoverBackground: _violetHover,
          hoverBorderColor: _violetHover,
          activeColor: BsColors.white,
          activeBackground: _violetActive,
          activeBorderColor: _violetActive,
          focusRingColor: Color(0xFF712CF9),
          // `.py-2`: .5rem vertically over `.btn`'s .75rem horizontally.
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // `.my-1` on the icon.
            Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: BootstrapIcon(activeIcon)),
            // `.dropdown-toggle::after`: margin-left .255em, then a
            // .3em-border triangle (.6em wide, .3em tall).
            const SizedBox(width: BsDropdownCaret.marginStart),
            const BsDropdownCaret(),
          ],
        ),
      ),
    );
  }
}
