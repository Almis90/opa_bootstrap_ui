import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';
import '../../src/github_avatar.dart';
import '../../src/inline_line.dart';

/// The "Headers" example: a port of Bootstrap's own `examples/headers` page.
///
/// Like the original it builds every header from utility classes rather than
/// the `.navbar` component, and the code reads the same way: each Bootstrap
/// class list in `vendor/bootstrap/site/src/assets/examples/headers/index.astro`
/// is the matching widget's props here, under the classes' own names —
/// `d-flex flex-wrap justify-content-center` is
/// `BsFlex(wrap: true, justifyContent: BsJustify.center)`, `py-3 mb-4
/// border-bottom` is `BsBox(py: BsSpacing.s3, mb: BsSpacing.s4, borderBottom:
/// true)`, `mb-3 mb-md-0` is `mb: BsResponsiveValue(xs: s3, md: s0)`.
class HeadersExamplePage extends StatelessWidget {
  const HeadersExamplePage({super.key});

  static const _mainLabels = ['Home', 'Features', 'Pricing', 'FAQs', 'About'];
  static const _dashboardLabels = [
    'Overview',
    'Inventory',
    'Customers',
    'Products',
  ];

  // Responsive values the original repeats across its markup.
  static const _col12ThenAutoLg = BsResponsiveValue(
    xs: BsCol(12),
    lg: BsCol.auto,
  );
  static const _meAutoFromLg = BsResponsiveValue(lg: BsSpacing.auto);
  static const _centerThenStartLg = BsResponsiveValue(
    xs: BsJustify.center,
    lg: BsJustify.start,
  );
  static const _mb2ThenNoneLg = BsResponsiveValue(
    xs: BsSpacing.s2,
    lg: BsSpacing.s0,
  );
  static const _mb2ThenNoneMd = BsResponsiveValue(
    xs: BsSpacing.s2,
    md: BsSpacing.s0,
  );
  static const _mb3ThenNoneLg = BsResponsiveValue(
    xs: BsSpacing.s3,
    lg: BsSpacing.s0,
  );
  static const _mb3ThenNoneMd = BsResponsiveValue(
    xs: BsSpacing.s3,
    md: BsSpacing.s0,
  );
  static const _my2ThenNoneLg = BsResponsiveValue(
    xs: BsSpacing.s2,
    lg: BsSpacing.s0,
  );
  static const _my2ThenNoneMd = BsResponsiveValue(
    xs: BsSpacing.s2,
    md: BsSpacing.s0,
  );

  /// A `<input type="search" class="form-control">` in a `.col-lg-auto` form:
  /// its width is the browser's intrinsic one for `size=20`, which depends on
  /// the font — 193px in Roboto (201px in San Francisco).
  static const _searchWidth = 193.0;

  /// The space character the markup leaves between adjacent inline elements
  /// (two `<button>`s, an `<img>` and its `::after` caret): 3.92px in Roboto
  /// at 16px.
  static const _inlineSpace = 3.92;

  /// `headers.css`' `.text-small` (not a Bootstrap class): `font-size: 85%`.
  static const _textSmall = 13.6;

  /// `.dropdown-menu.text-small.shadow`.
  static const _menuStyle = BsDropdownStyle(
    boxShadow: BsShadows.shadow,
    fontSize: _textSmall,
  );

  /// `.dropdown-menu.text-small` (header 5's menus have no `.shadow`).
  static const _menuStyleNoShadow = BsDropdownStyle(fontSize: _textSmall);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _simpleHeader(context),
        const ExampleDivider(),
        _centeredNav(),
        const ExampleDivider(),
        _ctaHeader(context),
        const ExampleDivider(),
        _darkSearchHeader(context),
        const ExampleDivider(),
        _dropdownHeader(context),
        const ExampleDivider(),
        _gridDropdownSection(context),
        const ExampleDivider(),
        _doubleHeader(context),
        const ExampleDivider(),
        _iconNavHeader(context),
        const ExampleDivider(),
      ],
    );
  }

  // --- 1. <header class="d-flex flex-wrap justify-content-center py-3 mb-4 border-bottom"> ---

  static Widget _simpleHeader(BuildContext context) {
    return BsContainer(
      child: BsBox(
        py: BsSpacing.s3,
        mb: BsSpacing.s4,
        borderBottom: true,
        child: BsFlex(
          wrap: true,
          justifyContent: BsJustify.center,
          children: [
            // <a class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-body-emphasis text-decoration-none">
            BsFlexItem(
              mb: _mb3ThenNoneMd,
              me: const BsResponsiveValue(md: BsSpacing.auto),
              child: _brandLink(
                BsTextColor.bodyEmphasis,
                children: const [
                  BsFlexItem(me: BsSpacing.s2, child: _Logo()),
                  BsBox(fs: BsFs.fs4, child: Text('Simple header')),
                ],
              ),
            ),
            BsNav(
              variant: BsNavVariant.pills,
              items: _pillNavItems(_mainLabels),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. <header class="d-flex justify-content-center py-3"> ---

  static Widget _centeredNav() {
    return BsContainer(
      child: BsBox(
        py: BsSpacing.s3,
        child: BsFlex(
          justifyContent: BsJustify.center,
          children: [
            BsNav(
              variant: BsNavVariant.pills,
              items: _pillNavItems(_mainLabels),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. <header class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3 mb-4 border-bottom"> ---

  static Widget _ctaHeader(BuildContext context) {
    return BsContainer(
      child: BsBox(
        py: BsSpacing.s3,
        mb: BsSpacing.s4,
        borderBottom: true,
        child: BsFlex(
          wrap: true,
          alignItems: BsAlign.center,
          justifyContent: const BsResponsiveValue(
            xs: BsJustify.center,
            md: BsJustify.between,
          ),
          children: [
            // <div class="col-md-3 mb-2 mb-md-0"><a class="d-inline-flex link-body-emphasis text-decoration-none">
            const BsFlexItem(
              col: BsResponsiveValue(md: BsCol(3)),
              mb: _mb2ThenNoneMd,
              // (a block's inline content sits at its start, at its natural size)
              child: BsBox(
                textAlign: BsTextAlign.start,
                child: InlineLine(
                  child: BsAnchor(
                    textDecorationNone: true,
                    linkColor: BsTextColor.bodyEmphasis,
                    child: _Logo(),
                  ),
                ),
              ),
            ),
            // <ul class="nav col-12 col-md-auto mb-2 justify-content-center mb-md-0">
            BsFlexItem(
              col: const BsResponsiveValue(xs: BsCol(12), md: BsCol.auto),
              mb: _mb2ThenNoneMd,
              child: BsNav(
                justifyContent: BsJustify.center,
                style: _px2,
                items: _plainNavItems(
                  _mainLabels,
                  firstColor: BsTextColor.secondary.of(context),
                ),
              ),
            ),
            // <div class="col-md-3 text-end">
            BsFlexItem(
              col: const BsResponsiveValue(md: BsCol(3)),
              child: BsBox(
                textAlign: BsTextAlign.end,
                child: _buttons(
                  first: BsButton(
                    variant: BsVariant.primary,
                    outline: true,
                    onPressed: () {},
                    child: const Text('Login'),
                  ),
                  second: BsButton(
                    variant: BsVariant.primary,
                    onPressed: () {},
                    child: const Text('Sign-up'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. <header class="p-3 text-bg-dark"> ---

  static Widget _darkSearchHeader(BuildContext context) {
    return BsBox(
      p: BsSpacing.s3,
      textBg: BsVariant.dark,
      child: BsContainer(
        child: BsFlex(
          wrap: true,
          alignItems: BsAlign.center,
          justifyContent: _centerThenStartLg,
          children: [
            // <a class="d-flex align-items-center mb-2 mb-lg-0 text-white text-decoration-none">
            BsFlexItem(
              mb: _mb2ThenNoneLg,
              child: _brandLink(
                BsTextColor.white,
                children: const [BsFlexItem(me: BsSpacing.s2, child: _Logo())],
              ),
            ),
            // <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
            BsFlexItem(
              col: _col12ThenAutoLg,
              me: _meAutoFromLg,
              mb: _mb2ThenNoneMd,
              child: BsNav(
                justifyContent: BsJustify.center,
                style: _px2,
                items: _plainNavItems(
                  _mainLabels,
                  firstColor: BsTextColor.secondary.of(context),
                  restColor: BsColors.white,
                ),
              ),
            ),
            // <form class="col-12 col-lg-auto mb-3 mb-lg-0 me-lg-3">
            BsFlexItem(
              col: _col12ThenAutoLg,
              mb: _mb3ThenNoneLg,
              me: const BsResponsiveValue(lg: BsSpacing.s3),
              child: SizedBox(
                width: _searchWidth,
                child: BsFormControl(
                  placeholder: 'Search...',
                  style: _darkFormStyle(context),
                ),
              ),
            ),
            // <div class="text-end">
            _buttons(
              first: BsButton(
                variant: BsVariant.light,
                outline: true,
                onPressed: () {},
                child: const Text('Login'),
              ),
              second: BsButton(
                variant: BsVariant.warning,
                onPressed: () {},
                child: const Text('Sign-up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. <header class="p-3 mb-3 border-bottom"> ---

  static Widget _dropdownHeader(BuildContext context) {
    return BsBox(
      p: BsSpacing.s3,
      mb: BsSpacing.s3,
      borderBottom: true,
      child: BsContainer(
        child: BsFlex(
          wrap: true,
          alignItems: BsAlign.center,
          justifyContent: _centerThenStartLg,
          children: [
            // <a class="d-flex align-items-center mb-2 mb-lg-0 link-body-emphasis text-decoration-none">
            BsFlexItem(
              mb: _mb2ThenNoneLg,
              child: _brandLink(
                BsTextColor.bodyEmphasis,
                children: const [BsFlexItem(me: BsSpacing.s2, child: _Logo())],
              ),
            ),
            // <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
            BsFlexItem(
              col: _col12ThenAutoLg,
              me: _meAutoFromLg,
              mb: _mb2ThenNoneMd,
              child: BsNav(
                justifyContent: BsJustify.center,
                style: _px2,
                items: _plainNavItems(
                  _dashboardLabels,
                  firstColor: BsTextColor.secondary.of(context),
                  restColor: BsTextColor.bodyEmphasis.of(context),
                ),
              ),
            ),
            // <form class="col-12 col-lg-auto mb-3 mb-lg-0 me-lg-3">
            const BsFlexItem(
              col: _col12ThenAutoLg,
              mb: _mb3ThenNoneLg,
              me: BsResponsiveValue(lg: BsSpacing.s3),
              child: SizedBox(
                width: _searchWidth,
                child: BsFormControl(placeholder: 'Search...'),
              ),
            ),
            // <div class="dropdown text-end">
            _avatarDropdown(_menuStyleNoShadow),
          ],
        ),
      ),
    );
  }

  // --- 6. <header class="py-3 mb-3 border-bottom"> + two placeholder blocks ---

  static Widget _gridDropdownSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsBox(
          py: BsSpacing.s3,
          mb: BsSpacing.s3,
          borderBottom: true,
          // <div class="container-fluid d-grid gap-3 align-items-center"
          //      style="grid-template-columns: 1fr 2fr;"> — the inline style is
          // CSS grid, which isn't a Bootstrap utility; a Row of 1:2 Expandeds is
          // the same layout.
          child: BsContainer.fluid(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // <div class="dropdown"><a class="d-flex align-items-center col-lg-4 mb-2 mb-lg-0 ...">
                Expanded(
                  child: BsBox(
                    mb: _mb2ThenNoneLg,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: BsDropdown(
                        style: _menuStyle,
                        toggleBuilder: (context, toggle, isOpen) => BsAnchor(
                          onTap: toggle,
                          textDecorationNone: true,
                          linkColor: BsTextColor.bodyEmphasis,
                          child: BsFlex(
                            alignItems: BsAlign.center,
                            children: const [
                              BsFlexItem(me: BsSpacing.s2, child: _Logo()),
                              // `.dropdown-toggle::after` as a flex item
                              SizedBox(width: BsDropdownCaret.marginStart),
                              BsDropdownCaret(),
                            ],
                          ),
                        ),
                        items: _logoMenuItems(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // gap-3
                Expanded(
                  flex: 2,
                  // <div class="d-flex align-items-center">
                  child: BsFlex(
                    alignItems: BsAlign.center,
                    children: [
                      // <form class="w-100 me-3">
                      const BsFlexItem(
                        w: BsWidth.w100,
                        me: BsSpacing.s3,
                        child: BsFormControl(placeholder: 'Search...'),
                      ),
                      // <div class="flex-shrink-0 dropdown">
                      BsFlexItem(
                        flexShrink: false,
                        child: _avatarDropdown(_menuStyle),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // <div class="container-fluid pb-3"><div class="d-grid gap-3" style="grid-template-columns: 1fr 2fr;">
        BsContainer.fluid(
          child: BsBox(
            pb: BsSpacing.s3,
            child: Row(
              children: [
                Expanded(child: _placeholderBlock()),
                const SizedBox(width: 16), // gap-3
                Expanded(flex: 2, child: _placeholderBlock()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// `<div class="bg-body-tertiary border rounded-3">` holding ten `<br>`s.
  static Widget _placeholderBlock() {
    return const BsBox(
      bg: BsBg.bodyTertiary,
      border: true,
      rounded: BsRounded.r3,
      child: SizedBox(height: 10 * 24, width: double.infinity),
    );
  }

  // --- 7. <nav class="py-2 bg-body-tertiary border-bottom"> + <header class="py-3 mb-4 border-bottom"> ---

  static Widget _doubleHeader(BuildContext context) {
    final emphasis = BsTextColor.bodyEmphasis.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsBox(
          py: BsSpacing.s2,
          bg: BsBg.bodyTertiary,
          borderBottom: true,
          // <div class="container d-flex flex-wrap">
          child: BsContainer(
            child: BsFlex(
              wrap: true,
              children: [
                BsFlexItem(
                  me: BsSpacing.auto,
                  child: BsNav(
                    style: _px2,
                    items: _plainNavItems(
                      _mainLabels,
                      firstColor: emphasis,
                      restColor: emphasis,
                    ),
                  ),
                ),
                BsNav(
                  style: _px2,
                  items: [
                    for (final label in ['Login', 'Sign up'])
                      BsNavItem(
                        child: Text(label, style: TextStyle(color: emphasis)),
                        onTap: () {},
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        BsBox(
          py: BsSpacing.s3,
          mb: BsSpacing.s4,
          borderBottom: true,
          // <div class="container d-flex flex-wrap justify-content-center">
          child: BsContainer(
            child: BsFlex(
              wrap: true,
              justifyContent: BsJustify.center,
              children: [
                // <a class="d-flex align-items-center mb-3 mb-lg-0 me-lg-auto link-body-emphasis text-decoration-none">
                BsFlexItem(
                  mb: _mb3ThenNoneLg,
                  me: _meAutoFromLg,
                  child: _brandLink(
                    BsTextColor.bodyEmphasis,
                    children: const [
                      BsFlexItem(me: BsSpacing.s2, child: _Logo()),
                      BsBox(fs: BsFs.fs4, child: Text('Double header')),
                    ],
                  ),
                ),
                // <form class="col-12 col-lg-auto mb-3 mb-lg-0">
                const BsFlexItem(
                  col: _col12ThenAutoLg,
                  mb: _mb3ThenNoneLg,
                  child: SizedBox(
                    width: _searchWidth,
                    child: BsFormControl(placeholder: 'Search...'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 8. <header> with two bars: an icon nav, and a search + buttons row ---

  static Widget _iconNavHeader(BuildContext context) {
    const icons = [
      (BootstrapIconData.home, 'Home'),
      (BootstrapIconData.speedometer2, 'Dashboard'),
      (BootstrapIconData.table, 'Orders'),
      (BootstrapIconData.grid, 'Products'),
      (BootstrapIconData.peopleCircle, 'Customers'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <div class="px-3 py-2 text-bg-dark border-bottom">
        BsBox(
          px: BsSpacing.s3,
          py: BsSpacing.s2,
          textBg: BsVariant.dark,
          borderBottom: true,
          child: BsContainer(
            child: BsFlex(
              wrap: true,
              alignItems: BsAlign.center,
              justifyContent: _centerThenStartLg,
              children: [
                // <a class="d-flex align-items-center my-2 my-lg-0 me-lg-auto text-white text-decoration-none">
                BsFlexItem(
                  my: _my2ThenNoneLg,
                  me: _meAutoFromLg,
                  child: _brandLink(
                    BsTextColor.white,
                    children: const [
                      BsFlexItem(me: BsSpacing.s2, child: _Logo()),
                    ],
                  ),
                ),
                // <ul class="nav col-12 col-lg-auto my-2 justify-content-center my-md-0 text-small">
                BsFlexItem(
                  col: _col12ThenAutoLg,
                  my: _my2ThenNoneMd,
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: _textSmall),
                    child: BsNav(
                      justifyContent: BsJustify.center,
                      items: [
                        for (final (icon, label) in icons)
                          BsNavItem(
                            onTap: () {},
                            child: _IconLink(
                              icon,
                              label,
                              color: label == 'Home'
                                  ? BsTextColor.secondary
                                  : BsTextColor.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // <div class="px-3 py-2 border-bottom mb-3">
        BsBox(
          px: BsSpacing.s3,
          py: BsSpacing.s2,
          mb: BsSpacing.s3,
          borderBottom: true,
          child: BsContainer(
            child: BsFlex(
              wrap: true,
              justifyContent: BsJustify.center,
              children: [
                // <form class="col-12 col-lg-auto mb-2 mb-lg-0 me-lg-auto">
                const BsFlexItem(
                  col: _col12ThenAutoLg,
                  mb: _mb2ThenNoneLg,
                  me: _meAutoFromLg,
                  child: SizedBox(
                    width: _searchWidth,
                    child: BsFormControl(placeholder: 'Search...'),
                  ),
                ),
                // <div class="text-end"> <button class="btn btn-light text-dark me-2">
                _buttons(
                  first: BsButton(
                    variant: BsVariant.light,
                    onPressed: () {},
                    child: const Text('Login'),
                  ),
                  second: BsButton(
                    variant: BsVariant.primary,
                    onPressed: () {},
                    child: const Text('Sign-up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- shared pieces ---

  /// `<a href="/" class="d-flex align-items-center … text-decoration-none">`
  /// around a brand: [color] is its `link-*`/`text-*` class.
  static Widget _brandLink(
    BsTextColor color, {
    required List<Widget> children,
  }) {
    return BsAnchor(
      textDecorationNone: true,
      linkColor: color,
      child: BsFlex(alignItems: BsAlign.center, children: children),
    );
  }

  /// `<button class="… me-2">…</button> <button>…</button>`: two inline
  /// buttons, the first with `me-2`, with the markup's whitespace between them.
  static Widget _buttons({required Widget first, required Widget second}) {
    return BsFlex(
      inline: true,
      children: [
        BsFlexItem(me: BsSpacing.s2, child: first),
        const SizedBox(width: _inlineSpace),
        second,
      ],
    );
  }

  /// `<div class="dropdown text-end"><a class="d-block link-body-emphasis
  /// text-decoration-none dropdown-toggle"><img … class="rounded-circle">`
  static Widget _avatarDropdown(BsDropdownStyle style) {
    return BsDropdown(
      style: style,
      toggleBuilder: (context, toggle, isOpen) => BsAnchor(
        onTap: toggle,
        textDecorationNone: true,
        linkColor: BsTextColor.bodyEmphasis,
        child: const _AvatarToggle(),
      ),
      items: const [
        BsDropdownItem(child: Text('New project...')),
        BsDropdownItem(child: Text('Settings')),
        BsDropdownItem(child: Text('Profile')),
        BsDropdownDivider(),
        BsDropdownItem(child: Text('Sign out')),
      ],
    );
  }

  static List<BsDropdownEntry> _logoMenuItems() => const [
    BsDropdownItem(child: Text('Overview'), active: true),
    BsDropdownItem(child: Text('Inventory')),
    BsDropdownItem(child: Text('Customers')),
    BsDropdownItem(child: Text('Products')),
    BsDropdownDivider(),
    BsDropdownItem(child: Text('Reports')),
    BsDropdownItem(child: Text('Analytics')),
  ];

  /// `.px-2` on each `.nav-link`.
  static const _px2 = BsNavStyle(
    linkPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  );

  static List<BsNavItem> _pillNavItems(List<String> labels) => [
    for (var i = 0; i < labels.length; i++)
      BsNavItem(child: Text(labels[i]), active: i == 0, onTap: () {}),
  ];

  static List<BsNavItem> _plainNavItems(
    List<String> labels, {
    Color? firstColor,
    Color? restColor,
  }) => [
    for (var i = 0; i < labels.length; i++)
      BsNavItem(
        child: Text(
          labels[i],
          style: TextStyle(color: i == 0 ? firstColor : restColor),
        ),
        active: i == 0,
        onTap: () {},
      ),
  ];

  /// `.form-control.form-control-dark.text-bg-dark`: white text on the
  /// header's own `#212529`, a `--bs-gray` border that turns white (with a
  /// translucent white ring) on focus. The placeholder keeps the page theme's
  /// `--bs-secondary-color` — which is why it vanishes into the dark field in
  /// light mode, exactly as in the original.
  static BsFormStyle _darkFormStyle(BuildContext context) => BsFormStyle(
    inputColor: BsColors.white,
    inputBackground: BsColors.gray900,
    inputBorderColor: BsColors.gray600,
    inputPlaceholderColor: BsBody.secondaryColorOf(context),
    inputFocusBorderColor: BsColors.white,
    inputFocusBoxShadow: const [
      BoxShadow(color: Color(0x40FFFFFF), spreadRadius: 4),
    ],
  );
}

/// `<svg class="bi" width="40" height="32">` Bootstrap's logo, in `currentColor`.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) =>
      const BootstrapIcon(BootstrapIconData.bootstrap, width: 40, height: 32);
}

/// `<a class="nav-link text-*"><svg class="bi d-block mx-auto mb-1" width="24"
/// height="24"> Label</a>`
class _IconLink extends StatelessWidget {
  const _IconLink(this.icon, this.label, {required this.color});

  final BootstrapIconData icon;
  final String label;
  final BsTextColor color;

  @override
  Widget build(BuildContext context) {
    final resolved = color.of(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BootstrapIcon(icon, width: 24, height: 24, color: resolved),
        // mb-1 — plus the fraction by which a CSS line of the 13.6px
        // `.text-small` (20.39px at 1x) is taller than Flutter's whole-pixel
        // one (20px).
        SizedBox(
          height: 4 + (13.6 * 1.5 * dpr * 64).floorToDouble() / 64 / dpr - 20,
        ),
        Text(label, style: TextStyle(color: resolved)),
      ],
    );
  }
}

/// `<img … class="rounded-circle">` then the `.dropdown-toggle::after` caret,
/// inline: the image (vertical-align: middle) rests a space and the caret's own
/// margin from the caret, which sits level with the image's centre line.
class _AvatarToggle extends StatelessWidget {
  const _AvatarToggle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GithubAvatar(),
        const SizedBox(
          width: BsDropdownCaret.marginStart + HeadersExamplePage._inlineSpace,
        ),
        // Bottom padding equal to the caret's height puts the caret's bottom
        // edge on the avatar's midline.
        Padding(
          padding: EdgeInsets.only(bottom: BsDropdownCaret.heightFor(context)),
          child: const BsDropdownCaret(),
        ),
      ],
    );
  }
}
