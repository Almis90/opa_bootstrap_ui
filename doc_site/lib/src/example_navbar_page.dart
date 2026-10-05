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
  const NavbarSearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BsFlex(
      inline: true,
      children: [
        const BsFlexItem(
          me: BsSpacing.s2,
          child: SizedBox(
            width: 193,
            child: BsFormControl(placeholder: 'Search'),
          ),
        ),
        BsButton(
          variant: BsVariant.success,
          outline: true,
          onPressed: () {},
          child: const Text('Search'),
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
List<BsNavbarItem> navbarExampleItems() => [
  BsNavbarItem(child: const Text('Home'), active: true, onTap: () {}),
  BsNavbarItem(child: const Text('Link'), onTap: () {}),
  const BsNavbarItem(child: Text('Disabled'), disabled: true),
];
