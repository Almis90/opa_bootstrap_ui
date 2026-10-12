import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// The `<main class="container">` shared by Bootstrap's three navbar examples:
/// a `bg-body-tertiary p-5 rounded` jumbotron with a `.btn-lg` link to the docs.
///
/// ```html
/// <main class="container">
///   <div class="bg-body-tertiary p-5 rounded [mt-3]">
///     <h1>…</h1><p class="lead">…</p>
///     <a class="btn btn-lg btn-primary" role="button">View navbar docs &raquo;</a>
/// ```
class NavbarExampleMain extends StatelessWidget {
  const NavbarExampleMain({
    super.key,
    required this.title,
    required this.lead,
    this.mt,
  });

  final String title;
  final String lead;

  /// `mt-3` on the jumbotron (`BsSpacing.s3`), if any.
  final BsSpacing? mt;

  @override
  Widget build(BuildContext context) {
    return BsContainer(
      child: BsBox(
        p: BsSpacing.s5,
        mt: mt,
        bg: BsBg.bodyTertiary,
        rounded: BsRounded.r2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsHeading(BsHeadingLevel.h1, child: Text(title)),
            BsBox(
              mb: BsSpacing.s3,
              child: BsLead(child: Text(lead)),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: BsButton(
                size: BsSize.lg,
                onPressed: () {},
                child: const Text('View navbar docs »'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `body { min-height: 75rem }`, as the examples' own CSS puts it.
class NavbarExampleBody extends StatelessWidget {
  const NavbarExampleBody({
    super.key,
    this.paddingTop = 0,
    required this.child,
  });

  /// `body { padding-top: 4.5rem }` under a fixed navbar.
  final double paddingTop;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 1200),
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop),
        child: child,
      ),
    );
  }
}

/// `<form class="d-flex"><input class="form-control me-2" type="search"> <button
/// class="btn btn-outline-success">Search</button></form>`.
class NavbarSearchForm extends StatelessWidget {
  const NavbarSearchForm({
    super.key,
    this.fill = false,
    this.label = 'Search',
    this.placeholder,
    this.buttonVariant = BsVariant.success,
  });

  /// A form as wide as its container (the input takes what the button leaves),
  /// not the input's own width.
  final bool fill;

  /// The button's text (and the input's placeholder, unless [placeholder]).
  final String label;

  /// The input's placeholder, when it is not the [label].
  final String? placeholder;

  /// `btn-outline-*`.
  final BsVariant buttonVariant;

  @override
  Widget build(BuildContext context) {
    final input = BsFormControl(placeholder: placeholder ?? label);
    return BsFlex(
      inline: !fill,
      children: [
        BsFlexItem(
          me: BsSpacing.s2,
          flexGrow: fill,
          child: fill ? input : SizedBox(width: 193, child: input),
        ),
        BsFlexItem(
          flexShrink: false,
          child: BsButton(
            variant: buttonVariant,
            outline: true,
            onPressed: () {},
            child: Text(label),
          ),
        ),
      ],
    );
  }
}

/// `<nav class="navbar navbar-expand-* bg-dark" data-bs-theme="dark"><div
/// class="container-fluid">…`: the dark bar all three examples use.
class NavbarExampleBar extends StatelessWidget {
  const NavbarExampleBar({
    super.key,
    required this.brand,
    required this.expandBreakpoint,
    required this.items,
    this.trailing = const [],
  });

  final String brand;
  final BsBreakpoint expandBreakpoint;
  final List<BsNavbarItem> items;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return BsTheme(
      brightness: Brightness.dark,
      child: BsBox(
        bg: BsBg.dark,
        child: BsContainer.fluid(
          child: BsNavbar(
            colorScheme: BsNavbarColorScheme.dark,
            expandBreakpoint: expandBreakpoint,
            brand: Text(brand),
            items: items,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}

/// The nav links the examples share: Home (active), Link, Disabled.
List<BsNavbarItem> navbarExampleItems({
  String home = 'Home',
  String link = 'Link',
  String disabled = 'Disabled',
}) => [
  BsNavbarItem(child: Text(home), active: true, onTap: () {}),
  BsNavbarItem(child: Text(link), onTap: () {}),
  BsNavbarItem(child: Text(disabled), disabled: true),
];

/// `<li class="nav-item dropdown">` (or `dropup`): a `.nav-link.dropdown-toggle`
/// whose menu opens from the whole item. It pads itself like a nav link —
/// `.5rem` each side once the navbar has expanded at [expandBreakpoint], none
/// before — hence the item's `padded: false`.
BsNavbarItem navbarDropdownItem(
  String label, {
  required BsBreakpoint? expandBreakpoint,
  bool up = false,
  bool divider = false,
  List<String> menu = const ['Action', 'Another action', 'Something else here'],
  // The markup puts the label on a line of its own, so a space (3.92px)
  // separates it from the caret.
  bool spaceBeforeCaret = false,
}) {
  return BsNavbarItem(
    onTap: () {},
    padded: false,
    child: Builder(
      builder: (context) {
        final expanded =
            expandBreakpoint != null &&
            MediaQuery.sizeOf(context).width >= expandBreakpoint.minWidth;
        return BsDropdown(
          direction: up ? BsDropdownDirection.up : BsDropdownDirection.down,
          toggleBuilder: (context, toggle, isOpen) => NavbarDropdownToggle(
            onToggle: toggle,
            isOpen: isOpen,
            // The whole `.nav-item`, link padding included, so the menu opens
            // from its edge.
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 8 : 0,
              vertical: 8,
            ),
            // `.navbar-nav .nav-link.show`: the link of an open menu takes the
            // active colour.
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: isOpen
                    ? (BsTheme.of(context) == Brightness.dark
                          ? BsNavbarStyle.darkActiveColor
                          : BsNavbarStyle.lightActiveColor)
                    : null,
              ),
              child: BsFlex(
                inline: true,
                alignItems: BsAlign.start,
                children: [
                  Text(label),
                  // `.dropdown-toggle::after`: .255em from the text, raised
                  // .255em off the baseline of the 24px line.
                  Padding(
                    padding: EdgeInsets.only(
                      left:
                          BsDropdownCaret.marginStart +
                          (spaceBeforeCaret ? 3.92 : 0),
                      top: 17 - 4.08 - BsDropdownCaret.heightFor(context),
                    ),
                    child: BsDropdownCaret(up: up),
                  ),
                ],
              ),
            ),
          ),
          items: [
            BsDropdownItem(child: Text(menu[0]), onTap: () {}),
            BsDropdownItem(child: Text(menu[1]), onTap: () {}),
            if (divider) const BsDropdownDivider(),
            BsDropdownItem(child: Text(menu[2]), onTap: () {}),
          ],
        );
      },
    ),
  );
}

/// `<form role="search"><input class="form-control" type="search"
/// placeholder="Search">`: as wide as the bar lets it once expanded
/// (the input's own width), the full width of the collapse before.
class NavbarSearchInput extends StatelessWidget {
  const NavbarSearchInput({super.key, required this.expandBreakpoint});

  final BsBreakpoint? expandBreakpoint;

  @override
  Widget build(BuildContext context) {
    final expanded =
        expandBreakpoint != null &&
        MediaQuery.sizeOf(context).width >= expandBreakpoint!.minWidth;
    const input = BsFormControl(placeholder: 'Search');
    // (Its width is the input's own, but the `<form>` around it can shrink.)
    return expanded
        ? ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 193),
            child: input,
          )
        : input;
  }
}

/// A navbar's `<a class="nav-link dropdown-toggle" href="#" role="button">`: it
/// takes the keyboard focus (Tab), shows `.nav-link:focus-visible`'s ring only
/// when focused that way, and Enter or Space open the menu like a click (Escape
/// closes it, see [BsDropdown]). Opening the menu with a click also rings it,
/// as in Safari: Bootstrap's dropdown plugin calls `focus()` on the toggle from
/// script when it shows the menu, and that counts as keyboard focus there.
class NavbarDropdownToggle extends StatefulWidget {
  const NavbarDropdownToggle({
    super.key,
    required this.onToggle,
    required this.isOpen,
    required this.padding,
    required this.child,
  });

  final VoidCallback onToggle;
  final bool isOpen;
  final EdgeInsets padding;
  final Widget child;

  @override
  State<NavbarDropdownToggle> createState() => _NavbarDropdownToggleState();
}

class _NavbarDropdownToggleState extends State<NavbarDropdownToggle> {
  final _focusNode = FocusNode(debugLabel: 'NavbarDropdownToggle');

  /// Set when a click opened the menu (Bootstrap's `focus()` on show), until
  /// the toggle loses focus.
  bool _scriptFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _scriptFocused) {
        setState(() => _scriptFocused = false);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final key = event.logicalKey;
    if (event is KeyDownEvent &&
        (key == LogicalKeyboardKey.enter ||
            key == LogicalKeyboardKey.numpadEnter ||
            key == LogicalKeyboardKey.space)) {
      widget.onToggle();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: _onKey,
        child: BsFocusableBuilder(
          focusNode: _focusNode,
          // `.nav-link:focus-visible`
          focusVisibleOnly: true,
          builder: (context, focused) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _focusNode.requestFocus(),
            onTap: () {
              if (!widget.isOpen) setState(() => _scriptFocused = true);
              widget.onToggle();
            },
            child: BsDecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  if (focused || (_scriptFocused && _focusNode.hasFocus))
                    BoxShadow(
                      color: BsFocusRing.color(),
                      spreadRadius: BsFocusRing.width,
                    ),
                ],
              ),
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
