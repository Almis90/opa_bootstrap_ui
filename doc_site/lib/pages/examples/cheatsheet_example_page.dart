import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_sticky.dart';
import 'cheatsheet_components.dart';
import 'cheatsheet_content.dart';
import 'cheatsheet_env.dart';
import 'cheatsheet_forms.dart';

/// The "Cheatsheet" example: a port of Bootstrap's own `examples/cheatsheet`
/// page — every component and content style on one page, with a dark header,
/// an "On this page" table of contents and, from `xl`, a three-column layout
/// (headings in the first, the examples in the second, the TOC in the last).
class CheatsheetExamplePage extends StatefulWidget {
  const CheatsheetExamplePage({super.key, this.rtl = false});

  /// The `cheatsheet-rtl` page: `dir="rtl"`, in Arabic.
  final bool rtl;

  /// The `.bd-header`, `position: fixed` from `xl` up.
  static Widget fixed(BuildContext context, {bool rtl = false}) {
    // (Below `xl` the header is in the flow. A non-positioned child here would
    // make the Stack — and the page — as small as it is.)
    if (MediaQuery.sizeOf(context).width < _xl) {
      return const Positioned(width: 0, height: 0, child: SizedBox.shrink());
    }
    final header = _Header(env: CsEnv(rtl: rtl));
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: rtl
          ? Directionality(textDirection: TextDirection.rtl, child: header)
          : header,
    );
  }

  static const double _xl = 1200;

  @override
  State<CheatsheetExamplePage> createState() => _CheatsheetExamplePageState();
}

/// One `<article>`: its id, and its examples.
class _Article {
  const _Article(this.id, this.build, {this.trailing = 0, this.last = false});

  final String id;
  final List<Widget> Function(BuildContext, CsEnv) build;

  /// The `margin-bottom` of the last example's last block (a `p`, a `table`…):
  /// from `xl` the examples' `div` is a grid item, so it stays inside the
  /// article instead of collapsing out of it.
  final double trailing;

  /// `mt-3 mb-5 pb-5`: the page's last article.
  final bool last;
}

/// One `<section>`: its articles (the headings come from [CsEnv.chrome]).
class _Section {
  const _Section(this.id, this.articles);

  final String id;
  final List<_Article> articles;
}

final _sections = [
  _Section('content', [
    _Article('typography', cheatsheetTypography, trailing: 16),
    _Article('images', cheatsheetImages),
    _Article('tables', cheatsheetTables, trailing: 16),
    _Article('figures', cheatsheetFigures),
  ]),
  _Section('forms', [
    _Article('overview', cheatsheetOverview),
    _Article('disabled-forms', cheatsheetDisabledForms),
    _Article('sizing', cheatsheetSizing, trailing: 16),
    _Article('input-group', cheatsheetInputGroup),
    _Article('floating-labels', cheatsheetFloatingLabels),
    _Article('validation', cheatsheetValidation),
  ]),
  _Section('components', [
    _Article('accordion', cheatsheetAccordion),
    _Article('alerts', cheatsheetAlerts, trailing: 16),
    _Article('badge', cheatsheetBadge),
    _Article('breadcrumb', cheatsheetBreadcrumb),
    _Article('buttons', cheatsheetButtons),
    _Article('button-group', cheatsheetButtonGroup),
    _Article('card', cheatsheetCard),
    _Article('carousel', cheatsheetCarousel),
    _Article('dropdowns', cheatsheetDropdowns),
    _Article('list-group', cheatsheetListGroup),
    _Article('modal', cheatsheetModal),
    _Article('navs', cheatsheetNavs),
    _Article('navbar', cheatsheetNavbar),
    _Article('pagination', cheatsheetPagination, trailing: 16),
    _Article('popovers', cheatsheetPopovers),
    _Article('progress', cheatsheetProgress),
    _Article('scrollspy', cheatsheetScrollspy),
    _Article('spinners', cheatsheetSpinners),
    _Article('toasts', cheatsheetToasts),
    _Article('tooltips', cheatsheetTooltips, last: true),
  ]),
];

class _CheatsheetExamplePageState extends State<CheatsheetExamplePage> {
  final _keys = <String, GlobalKey>{};
  String? _active;

  CsEnv get _env => CsEnv(rtl: widget.rtl);

  GlobalKey _key(String id) => _keys.putIfAbsent(id, GlobalKey.new);

  /// The boxes the sticky parts are held within (their containing blocks):
  /// the page's grid, and each article's.
  final _blocks = <String, GlobalKey>{};
  GlobalKey _block(String id) => _blocks.putIfAbsent(id, GlobalKey.new);

  void _goTo(String id) {
    setState(() => _active = id);
    final context = _key(id).currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final xl = MediaQuery.sizeOf(context).width >= CheatsheetExamplePage._xl;
    final page = BsBox(
      bg: BsBg.bodyTertiary,
      child: xl ? _wide(context) : _narrow(context),
    );
    return widget.rtl
        ? Directionality(textDirection: TextDirection.rtl, child: page)
        : page;
  }

  // --- below xl: one column ---

  Widget _narrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(env: _env),
        // <aside … mb-3>
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _Aside(
            env: _env,
            active: _active,
            onSelect: _goTo,
            trimBottom: true,
          ),
        ),
        _main(context, xl: false),
      ],
    );
  }

  // --- xl: grid 1fr 4fr 1fr, the header fixed above ---

  Widget _wide(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fr = (constraints.maxWidth - 32) / 6;
        return Row(
          key: _block('page'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: fr * 5 + 16, child: _main(context, xl: true)),
            const SizedBox(width: 16),
            SizedBox(
              width: fr,
              // `<aside class="bd-aside sticky-xl-top …">`: `position: sticky;
              // top: 0`, held for the whole page (under the fixed header, by
              // its own 4rem of padding).
              child: ExampleSticky(
                top: 0,
                within: _block('page'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: _Aside(
                    env: _env,
                    active: _active,
                    onSelect: _goTo,
                    trimBottom: false,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- <main class="bd-cheatsheet container-fluid bg-body"> ---

  Widget _main(BuildContext context, {required bool xl}) {
    final chrome = _env.chrome;
    var article = 0;
    final sections = <Widget>[];
    for (var s = 0; s < _sections.length; s++) {
      final section = _sections[s];
      final articles = <Widget>[];
      for (final a in section.articles) {
        articles.add(
          _articleBox(
            context,
            a,
            title: chrome.articles[article],
            docs: chrome.docs[article],
            xl: xl,
          ),
        );
        article++;
      }
      sections.add(
        KeyedSubtree(
          key: _key(section.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionHeading(chrome.sections[s], xl, section.id),
              ...articles,
            ],
          ),
        ),
      );
    }
    return BsBox(
      bg: BsBg.body,
      child: Padding(
        // `container-fluid` (`padding-inline: .75rem`), and `padding-top: 4rem`
        // under the fixed header.
        padding: EdgeInsets.fromLTRB(12, xl ? 64 : 0, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < sections.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              sections[i],
            ],
          ],
        ),
      ),
    );
  }

  /// `<h2 class="fw-bold pt-3 pt-xl-5 pb-2 pb-xl-3">`
  Widget _sectionHeading(String text, bool xl, String sectionId) {
    final heading = BsHeading(
      BsHeadingLevel.h2,
      fw: BsFw.bold,
      mb: BsSpacing.s0,
      child: Text(text),
    );
    if (!xl) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: heading,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: 0.2,
          // `sticky-xl-top` with `top: 2rem`: it stays while its section does.
          child: ExampleSticky(
            top: 32,
            within: _key(sectionId),
            child: Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 16),
              child: heading,
            ),
          ),
        ),
      ),
    );
  }

  Widget _articleBox(
    BuildContext context,
    _Article a, {
    required String title,
    required String docs,
    required bool xl,
  }) {
    final built = a.build(context, _env);
    final examples = csExamples([
      for (var i = 0; i < built.length; i++)
        CsProbe(label: '${a.id}#$i', child: built[i]),
    ]);
    final heading = _ArticleHeading(title: title, docs: docs);
    if (!xl) {
      return KeyedSubtree(
        key: _key(a.id),
        child: Padding(
          padding: EdgeInsets.only(top: 48, bottom: a.last ? 96 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [heading, const SizedBox(height: 16), examples],
          ),
        ),
      );
    }
    // `.bd-cheatsheet article { display: grid; grid-template-columns: 1fr 4fr }`
    return KeyedSubtree(
      key: _key(a.id),
      child: Padding(
        // `my-3` and the grid's `gap: 1rem`.
        padding: EdgeInsets.fromLTRB(0, 32, 0, a.last ? 96 : 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final col = (constraints.maxWidth - 16) / 5;
            return Row(
              key: _block(a.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: col,
                  // `.bd-heading.sticky-xl-top` with `top: 8rem`: it stays while
                  // its article does, then the next article's takes its place.
                  child: ExampleSticky(
                    top: 128,
                    within: _block(a.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: heading,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: a.trailing),
                    child: examples,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// `<header class="bd-header bg-dark py-3 d-flex align-items-stretch
/// border-bottom border-dark">`
class _Header extends StatelessWidget {
  const _Header({required this.env});

  final CsEnv env;

  @override
  Widget build(BuildContext context) {
    final link = BsColors.gray100;
    return BsDecoratedBox(
      decoration: BoxDecoration(
        color: BsColors.gray900,
        border: Border(bottom: BorderSide(color: BsColors.gray900)),
      ),
      child: Padding(
        // (the 1px bottom border takes room of its own)
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 17),
        child: Row(
          children: [
            // <h1 class="d-flex align-items-center fs-4 text-white mb-0">
            const BootstrapIcon(
              BootstrapIconData.bootstrapLogo,
              width: 38,
              height: 30,
              color: Color(0xFFFFFFFF),
            ),
            const SizedBox(width: 16),
            BsHeading(
              BsHeadingLevel.h1,
              fs: BsFs.fs4,
              mb: BsSpacing.s0,
              child: Text(
                env.chrome.header[0],
                style: const TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
            const Spacer(),
            // <a class="ms-auto link-light">
            Text(
              env.chrome.header[1],
              style: TextStyle(
                color: link,
                decoration: TextDecoration.underline,
                decorationColor: link,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `<div class="bd-heading sticky-xl-top align-self-start mt-5 mb-3 mt-xl-0
/// mb-xl-2">`: the article's `h3` and its "Documentation" link.
class _ArticleHeading extends StatelessWidget {
  const _ArticleHeading({required this.title, required this.docs});

  final String title;
  final String docs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsHeading(BsHeadingLevel.h3, child: Text(title)),
        // <a class="d-flex align-items-center">: the journal icon, then the text
        BsFlex(
          alignItems: BsAlign.center,
          children: [
            const BootstrapIcon(
              BootstrapIconData.journalCode,
              width: 16,
              height: 16,
              color: Color(0xFF999999),
            ),
            const SizedBox(width: 4),
            Text(
              docs,
              style: TextStyle(
                color: BsLink.colorOf(context),
                decoration: TextDecoration.underline,
                decorationColor: BsLink.colorOf(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// `<aside class="bd-aside … text-body-secondary px-2">`: "On this page" and
/// its three collapsible groups.
class _Aside extends StatelessWidget {
  const _Aside({
    required this.env,
    required this.active,
    required this.onSelect,
    required this.trimBottom,
  });

  final CsEnv env;
  final String? active;
  final ValueChanged<String> onSelect;

  /// Below `xl` the list's `margin-bottom` collapses into the aside's.
  final bool trimBottom;

  static const _ids = [
    ['typography', 'images', 'tables', 'figures'],
    [
      'overview',
      'disabled-forms',
      'sizing',
      'input-group',
      'floating-labels',
      'validation',
    ],
    [
      'accordion',
      'alerts',
      'badge',
      'breadcrumb',
      'buttons',
      'button-group',
      'card',
      'carousel',
      'dropdowns',
      'list-group',
      'modal',
      'navs',
      'navbar',
      'pagination',
      'popovers',
      'progress',
      'scrollspy',
      'spinners',
      'toasts',
      'tooltips',
    ],
  ];

  static const _groupIds = ['content', 'forms', 'components'];

  @override
  Widget build(BuildContext context) {
    final texts = env.chrome.aside;
    // [On this page, Contents, …4, Forms, …6, Components, …20]
    var at = 1;
    final groups = <Widget>[];
    for (var g = 0; g < _ids.length; g++) {
      final title = texts[at++];
      final items = texts.sublist(at, at + _ids[g].length);
      at += _ids[g].length;
      groups.add(
        _TocGroup(
          title: title,
          groupId: _groupIds[g],
          ids: _ids[g],
          items: items,
          active: active,
          onSelect: onSelect,
        ),
      );
    }
    return BsBox(
      px: BsSpacing.s2,
      textColor: BsTextColor.bodySecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <h2 class="h6 pt-4 pb-3 mb-4 border-bottom">
          BsBox(
            pt: BsSpacing.s4,
            pb: BsSpacing.s3,
            mb: BsSpacing.s4,
            borderBottom: true,
            child: BsHeading(
              BsHeadingLevel.h6,
              mb: BsSpacing.s0,
              child: Text(texts[0]),
            ),
          ),
          // <nav class="small" id="toc"><ul class="list-unstyled">
          DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 14),
            child: Padding(
              padding: EdgeInsets.only(bottom: trimBottom ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // `li.my-2`: the margins of neighbours collapse into 8px.
                children: [
                  for (var i = 0; i < groups.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    groups[i],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `<li class="my-2"><button class="btn … collapsed border-0">` and the
/// `ul.collapse` of links it reveals.
class _TocGroup extends StatefulWidget {
  const _TocGroup({
    required this.title,
    required this.groupId,
    required this.ids,
    required this.items,
    required this.active,
    required this.onSelect,
  });

  final String title;
  final String groupId;
  final List<String> ids;
  final List<String> items;
  final String? active;
  final ValueChanged<String> onSelect;

  @override
  State<_TocGroup> createState() => _TocGroupState();
}

class _TocGroupState extends State<_TocGroup> {
  bool _expanded = false;
  bool _hovered = false;
  bool _focused = false;
  late final FocusNode _focus = FocusNode(onKeyEvent: _onKey);

  static const _hoverColor = Color(0x1A7952B3); // rgba(121, 82, 179, .1)
  static const _focusRing = Color(0xB37952B3); // rgba(121, 82, 179, .7)

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _toggle() => setState(() => _expanded = !_expanded);

  /// A `<button>`: Enter and Space press it.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space)) {
      _toggle();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final body = BsTextColor.body.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Focus(
            focusNode: _focus,
            onFocusChange: (focused) => setState(() => _focused = focused),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // (a clicked button is focused: `.btn:focus` stays after it)
                _focus.requestFocus();
                _toggle();
              },
              child: BsDecoratedBox(
                decoration: BoxDecoration(
                  color: _hovered || _focused ? _hoverColor : null,
                  borderRadius: BorderRadius.circular(BsRounded.r2.radius),
                  // `box-shadow: 0 0 0 1px rgba(121, 82, 179, .7)`
                  boxShadow: _focused
                      ? const [BoxShadow(color: _focusRing, spreadRadius: 1)]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: body,
                    ),
                    child: BsFlex(
                      inline: true,
                      alignItems: BsAlign.center,
                      children: [
                        // `::before`: a 1.25em box with the chevron, turning
                        // a quarter when expanded.
                        SizedBox(
                          width: 20,
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: AnimatedRotation(
                              turns: _expanded
                                  ? (rtl ? -0.25 : 0.25)
                                  : (rtl ? 0.5 : 0),
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.ease,
                              child: const BootstrapIcon(
                                BootstrapIconData.chevronToggle,
                                width: 16,
                                height: 16,
                                color: Color(0xFFCCCCCC),
                              ),
                            ),
                          ),
                        ),
                        Text(widget.title),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // <ul class="list-unstyled ps-3 collapse">
        BsCollapse(
          isExpanded: _expanded,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < widget.ids.length; i++)
                  _TocLink(
                    text: widget.items[i],
                    active: widget.active == widget.ids[i],
                    onTap: () => widget.onSelect(widget.ids[i]),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// `<a class="d-inline-flex align-items-center rounded text-decoration-none">`
class _TocLink extends StatefulWidget {
  const _TocLink({
    required this.text,
    required this.active,
    required this.onTap,
  });

  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_TocLink> createState() => _TocLinkState();
}

class _TocLinkState extends State<_TocLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // `margin-top: .125rem; margin-left: .3125rem`
      padding: const EdgeInsetsDirectional.only(top: 2, start: 5),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: BsDecoratedBox(
            decoration: BoxDecoration(
              color: _hovered ? _TocGroupState._hoverColor : null,
              borderRadius: BorderRadius.circular(BsRounded.r2.radius),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: BsTextColor.body.of(context),
                  fontWeight: widget.active ? FontWeight.w700 : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
