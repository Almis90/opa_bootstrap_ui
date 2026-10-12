import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_navbar_page.dart';
import '../../src/placeholder_image.dart';
import 'cheatsheet_env.dart';
import 'cheatsheet_strings.dart';

/// The "Components" section of the Cheatsheet (examples 22-57).

/// The eight theme colors, in the order of `getData('theme-colors')`.
const _theme = [
  BsVariant.primary,
  BsVariant.secondary,
  BsVariant.success,
  BsVariant.danger,
  BsVariant.warning,
  BsVariant.info,
  BsVariant.light,
  BsVariant.dark,
];

/// `<code>`: `font-size: .875em`, in the code color.
TextSpan _code(BuildContext context, String text) {
  final dark = BsTheme.of(context) == Brightness.dark;
  return TextSpan(
    text: text,
    style: TextStyle(
      fontFamily: BsTypography.fontFamilyMonospace.first,
      fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
      fontSize: BsCodeStyle.defaultCodeFontSize,
      color: dark
          ? BsCodeStyle.defaultDarkCodeColor
          : BsCodeStyle.defaultCodeColor,
    ),
  );
}

/// An inline widget on the text baseline (a badge, a button…).
WidgetSpan _inline(Widget child) => WidgetSpan(
  alignment: PlaceholderAlignment.baseline,
  baseline: TextBaseline.alphabetic,
  child: child,
);

/// Accordion (`#accordion`, example 22).
List<Widget> cheatsheetAccordion(BuildContext context, CsEnv env) {
  final s = env.s(22);
  // English: title, <strong>, text, <code>, tail; Arabic: title, <strong>, text.
  final per = env.rtl ? 3 : 5;
  Widget body(int item) {
    final at = item * per;
    final spans = <InlineSpan>[
      TextSpan(
        text: s[at + 1],
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      TextSpan(text: ' ${s[at + 2]}'),
      if (!env.rtl) ...[
        const TextSpan(text: ' '),
        _code(context, s[at + 3]),
        TextSpan(text: s[at + 4]),
      ],
    ];
    return Text.rich(TextSpan(children: spans));
  }

  return [
    BsAccordion(
      initiallyExpanded: const {0},
      items: [
        for (var i = 0; i < 3; i++)
          BsAccordionItem(header: Text(s[i * per]), body: body(i)),
      ],
    ),
  ];
}

/// Alerts (`#alerts`, examples 23-24).
List<Widget> cheatsheetAlerts(BuildContext context, CsEnv env) {
  final s = env.s(23);
  final heading = env.s(24);
  // (`.alert { margin-bottom: 1rem }`, which BsAlert includes; the last one's
  // collapses out of the example)
  return [
    CsTrimBottom(
      by: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < 8; i++)
            BsAlert(
              variant: _theme[i],
              dismissible: true,
              child: Builder(
                builder: (context) => Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${s[i * 3]} '),
                      TextSpan(
                        text: s[i * 3 + 1],
                        style: BsAlertLink.styleOf(context),
                      ),
                      TextSpan(text: s[i * 3 + 2]),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    // <div class="alert alert-success"><h4 class="alert-heading">…
    CsTrimBottom(
      by: 16,
      child: BsAlert(
        variant: BsVariant.success,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsHeading(BsHeadingLevel.h4, child: Text(heading[0])),
            Text(heading[1]),
            // (the paragraph's margin and the rule's collapse into one)
            const SizedBox(height: 16),
            const BsHr(my: BsResponsiveValue.all(BsSpacing.s0)),
            const SizedBox(height: 16),
            Text(heading[2]),
          ],
        ),
      ),
    ),
  ];
}

/// Badge (`#badge`, examples 25-26).
List<Widget> cheatsheetBadge(BuildContext context, CsEnv env) {
  final s = env.s(25);
  const levels = [
    BsHeadingLevel.h1,
    BsHeadingLevel.h2,
    BsHeadingLevel.h3,
    BsHeadingLevel.h4,
    BsHeadingLevel.h5,
    BsHeadingLevel.h6,
    BsHeadingLevel.h6,
    BsHeadingLevel.h6,
  ];
  final pills = env.s(26);
  return [
    csBlocks([
      for (var i = 0; i < 8; i++)
        BsHeading(
          levels[i],
          mb: BsSpacing.s0,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${s[i * 2]} '),
                _inline(BsBadge(variant: _theme[i], child: Text(s[i * 2 + 1]))),
              ],
            ),
          ),
        ),
    ], gap: 8),
    // (inline: they sit on the baseline of a 24px line, a space apart)
    Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < 8; i++) ...[
            if (i > 0) const TextSpan(text: ' '),
            _inline(
              BsBadge(variant: _theme[i], pill: true, child: Text(pills[i])),
            ),
          ],
        ],
      ),
    ),
  ];
}

/// Breadcrumb (`#breadcrumb`, example 27).
List<Widget> cheatsheetBreadcrumb(BuildContext context, CsEnv env) {
  final s = env.s(27);
  return [
    CsTrimBottom(
      by: 16,
      child: BsBreadcrumb(
        items: [
          BsBreadcrumbItem(label: Text(s[0]), onTap: () {}),
          BsBreadcrumbItem(label: Text(s[1]), onTap: () {}),
          BsBreadcrumbItem(label: Text(s[2])),
        ],
      ),
    ),
  ];
}

/// Buttons (`#buttons`, examples 28-30). `[id="buttons"] .bd-example .btn {
/// margin: 0 1rem 1rem 0 }`: each button has its own margins, on top of the
/// space between inline-blocks.
List<Widget> cheatsheetButtons(BuildContext context, CsEnv env) {
  Widget buttons(List<Widget> children) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Wrap(spacing: 16 + 3.92, runSpacing: 16, children: children),
  );
  final solid = env.s(28);
  final outline = env.s(29);
  final sizes = env.s(30);
  return [
    buttons([
      for (var i = 0; i < 8; i++)
        BsButton(variant: _theme[i], onPressed: () {}, child: Text(solid[i])),
      BsButton(link: true, onPressed: () {}, child: Text(solid[8])),
    ]),
    buttons([
      for (var i = 0; i < 8; i++)
        BsButton(
          variant: _theme[i],
          outline: true,
          onPressed: () {},
          child: Text(outline[i]),
        ),
    ]),
    // `btn-sm`, standard and `btn-lg` on the baseline of one line — or, when
    // they do not all fit, of as many as they need.
    LayoutBuilder(
      builder: (context, constraints) {
        final buttons = [
          BsButton(size: BsSize.sm, onPressed: () {}, child: Text(sizes[0])),
          BsButton(onPressed: () {}, child: Text(sizes[1])),
          BsButton(size: BsSize.lg, onPressed: () {}, child: Text(sizes[2])),
        ];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: constraints.maxWidth >= 480
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buttons[0],
                    const SizedBox(width: 16 + 3.92),
                    buttons[1],
                    const SizedBox(width: 16 + 3.92),
                    buttons[2],
                  ],
                )
              : Wrap(
                  spacing: 16 + 3.92,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: buttons,
                ),
        );
      },
    ),
  ];
}

/// Button group (`#button-group`, example 31).
List<Widget> cheatsheetButtonGroup(BuildContext context, CsEnv env) {
  final s = env.s(31);
  Widget group(List<int> numbers) => BsButtonGroup(
    children: [
      for (final n in numbers)
        BsButton(
          variant: BsVariant.secondary,
          onPressed: () {},
          child: Text(s[n]),
        ),
    ],
  );
  // <div class="btn-toolbar">: `.btn-group.me-2` ×2 and the last one.
  return [
    BsFlex(
      wrap: true,
      gap: BsSpacing.s2,
      children: [
        group([0, 1, 2, 3]),
        group([4, 5, 6]),
        group([7]),
      ],
    ),
  ];
}

/// Card (`#card`, example 32): `row row-cols-1 row-cols-md-2 g-4` of four
/// cards.
List<Widget> cheatsheetCard(BuildContext context, CsEnv env) {
  final s = env.s(32);
  // [placeholder title, "Image cap", title, text, button] — then, per card,
  // see the markup: card 2 has a header and footer, card 3 a list group.
  var i = 0;
  String next() => s[i++];
  final secondary = BsTextColor.bodySecondary.of(context);
  Widget p(String text, {bool last = false}) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 16),
    child: BsCardText(child: Text(text)),
  );
  // <h5 class="card-title">
  Widget heading5(String text) =>
      BsHeading(BsHeadingLevel.h5, mb: BsSpacing.s0, child: Text(text));
  Widget button(String label) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: BsButton(onPressed: () {}, child: Text(label)),
  );

  // Card 1: [Placeholder, Image cap, Card title, text, Go somewhere]
  next();
  final imageCap = next();
  final card1 = BsCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsCardImg(child: PlaceholderImage(height: 180, text: imageCap)),
        BsCardBody(
          children: [
            BsCardTitle(child: heading5(next())),
            p(next()),
            button(next()),
          ],
        ),
      ],
    ),
  );
  // Card 2: [Featured, Card title, text, Go somewhere, 2 days ago]
  final featured = next();
  final card2 = BsCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsCardHeader(child: Text(featured)),
        BsCardBody(
          children: [
            BsCardTitle(child: heading5(next())),
            p(next()),
            button(next()),
          ],
        ),
        BsCardFooter(
          child: Text(next(), style: TextStyle(color: secondary)),
        ),
      ],
    ),
  );
  // Card 3: [Card title, text, An item, A second item, A third item,
  //          Card link, Another link]
  final card3 = BsCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsCardBody(
          children: [
            BsCardTitle(child: heading5(next())),
            p(next(), last: true),
          ],
        ),
        // (`.card > .list-group { border-top: inherit; border-bottom: inherit }`)
        BsDecoratedContainer(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: BsBorders.colorOf(context)),
              bottom: BorderSide(color: BsBorders.colorOf(context)),
            ),
          ),
          child: BsListGroup(
            flush: true,
            items: [
              for (var k = 0; k < 3; k++) BsListGroupItem(child: Text(next())),
            ],
          ),
        ),
        BsCardBody(
          children: [
            Wrap(
              spacing: 16,
              children: [
                BsCardLink(onTap: () {}, child: Text(next())),
                BsCardLink(onTap: () {}, child: Text(next())),
              ],
            ),
          ],
        ),
      ],
    ),
  );
  // Card 4: [Placeholder, Image, Card title, text, Last updated…]
  next();
  final image = next();
  final card4 = BsCard(
    child: BsRow(
      g: BsSpacing.s0,
      children: [
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(4)),
          child: PlaceholderImage(height: 250, text: image),
        ),
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(8)),
          child: BsCardBody(
            children: [
              BsCardTitle(child: heading5(next())),
              p(next()),
              BsCardText(
                child: BsSmall(
                  child: Text(next(), style: TextStyle(color: secondary)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  return [
    BsRow(
      rowCols: const BsResponsiveValue(xs: 1, md: 2),
      g: BsSpacing.s4,
      children: [
        for (final card in [card1, card2, card3, card4])
          // (`.col > .card`: the card keeps its own height in the column)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [card],
          ),
      ],
    ),
  ];
}

/// Carousel (`#carousel`, example 33).
List<Widget> cheatsheetCarousel(BuildContext context, CsEnv env) {
  final s = env.s(33);
  final width = MediaQuery.sizeOf(context).width;
  const backgrounds = [Color(0xFF777777), Color(0xFF666666), Color(0xFF555555)];
  const colors = [Color(0xFF555555), Color(0xFF444444), Color(0xFF333333)];
  return [
    SizedBox(
      height: 400,
      child: BsCarousel(
        items: [
          for (var i = 0; i < 3; i++)
            BsCarouselItem(
              child: PlaceholderImage(
                height: 400,
                text: s[i * 4 + 1],
                fontSize: width >= 768 ? 56 : 18,
                background: backgrounds[i],
                color: colors[i],
              ),
              // `.carousel-caption.d-none.d-md-block`
              caption: width >= 768
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BsHeading(BsHeadingLevel.h5, child: Text(s[i * 4 + 2])),
                        // (`<p>`: `margin-bottom: 1rem`)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(s[i * 4 + 3]),
                        ),
                      ],
                    )
                  : null,
            ),
        ],
      ),
    ),
  ];
}

/// A caret pointing sideways (`.dropend`/`.dropstart`): `border-top` and
/// `border-bottom` of `.3em` transparent, and `.3em` solid on one side.
class _SideCaret extends StatelessWidget {
  const _SideCaret({required this.right, required this.fontSize});

  final bool right;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final border = BsDropdownCaret.heightFor(context, fontSize: fontSize);
    return CustomPaint(
      size: Size(border, border * 2),
      painter: _SideCaretPainter(
        DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000),
        right,
      ),
    );
  }
}

class _SideCaretPainter extends CustomPainter {
  _SideCaretPainter(this.color, this.right);

  final Color color;
  final bool right;

  @override
  void paint(Canvas canvas, Size size) {
    final path = right
        ? (Path()
            ..moveTo(0, 0)
            ..lineTo(size.width, size.height / 2)
            ..lineTo(0, size.height)
            ..close())
        : (Path()
            ..moveTo(size.width, 0)
            ..lineTo(0, size.height / 2)
            ..lineTo(size.width, size.height)
            ..close());
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SideCaretPainter old) =>
      old.color != color || old.right != right;
}

/// The baseline of a line of [lineHeight] in Roboto at [fontSize]: ascent
/// .927em, descent .244em, centred in the half-leading.
double _baseline(double fontSize, double lineHeight) =>
    (lineHeight - 1.171 * fontSize) / 2 + 0.927 * fontSize;

/// A `.btn.dropdown-toggle`'s content: the label and the caret
/// (`::after` — `::before` for `.dropstart`), with the space the markup's
/// line break leaves between them.
Widget _toggleLabel(
  BuildContext context,
  String label, {
  BsSize size = BsSize.normal,
  BsDropdownDirection direction = BsDropdownDirection.down,
}) {
  final fontSize = switch (size) {
    BsSize.sm => 14.0,
    BsSize.normal => 16.0,
    BsSize.lg => 20.0,
  };
  final lineHeight = fontSize * 1.5;
  final baseline = _baseline(fontSize, lineHeight);
  final gap = 0.255 * fontSize;
  final space = 0.245 * fontSize;
  final border = BsDropdownCaret.heightFor(context, fontSize: fontSize);
  final side =
      direction == BsDropdownDirection.end ||
      direction == BsDropdownDirection.start;
  // `vertical-align: .255em` for the vertical carets, `0` for the others.
  final top = side ? baseline - 2 * border : baseline - gap - border;
  final caret = Padding(
    padding: EdgeInsets.only(top: top),
    child: side
        ? _SideCaret(
            right: direction == BsDropdownDirection.end,
            fontSize: fontSize,
          )
        : BsDropdownCaret(
            fontSize: fontSize,
            up: direction == BsDropdownDirection.up,
          ),
  );
  final before = direction == BsDropdownDirection.start;
  return BsFlex(
    inline: true,
    alignItems: BsAlign.start,
    children: [
      if (before) ...[caret, SizedBox(width: gap + space), Text(label)],
      if (!before) ...[Text(label), SizedBox(width: space + gap), caret],
    ],
  );
}

/// The menu of the dropdown examples: an optional header, then the links
/// (with a divider before the last one when [divider]).
List<BsDropdownEntry> _menu(
  List<String> texts, {
  bool header = true,
  bool divider = true,
}) {
  final links = texts.sublist(header ? 1 : 0);
  return [
    if (header) BsDropdownHeader(child: Text(texts.first)),
    for (var i = 0; i < links.length; i++) ...[
      if (divider && i == links.length - 1) const BsDropdownDivider(),
      BsDropdownItem(child: Text(links[i]), onTap: () {}),
    ],
  ];
}

/// `[id="dropdowns"] .bd-example .dropdown { margin: 0 1rem 1rem 0 }`.
Widget _dropMargin(Widget child) => Padding(
  padding: const EdgeInsetsDirectional.only(end: 16, bottom: 16),
  child: child,
);

/// Dropdowns (`#dropdowns`, examples 34-37).
List<Widget> cheatsheetDropdowns(BuildContext context, CsEnv env) {
  // The examples 34 and 36: three dropdowns spread over a `btn-group w-100`.
  Widget three(List<String> s, List<(BsSize, BsDropdownDirection)> kinds) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BsFlex(
        wrap: true,
        justifyContent: BsJustify.between,
        alignItems: BsAlign.center,
        children: [
          for (var k = 0; k < 3; k++)
            _dropMargin(
              BsDropdown(
                direction: kinds[k].$2,
                toggleBuilder: (context, toggle, isOpen) => BsButton(
                  variant: BsVariant.secondary,
                  size: kinds[k].$1,
                  onPressed: toggle,
                  child: _toggleLabel(
                    context,
                    s[k * 6],
                    size: kinds[k].$1,
                    direction: kinds[k].$2,
                  ),
                ),
                items: _menu(s.sublist(k * 6 + 1, k * 6 + 6)),
              ),
            ),
        ],
      ),
    );
  }

  // Example 35: split buttons.
  Widget split() {
    final s = env.s(35);
    Widget group(int g) {
      final variant =
          _theme[g == 0
              ? 0
              : g == 1
              ? 1
              : g == 2
              ? 2
              : g == 3
              ? 5
              : g == 4
              ? 4
              : 3];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BsButton(
              variant: variant,
              style: BsButtonStyle(
                borderRadius: BorderRadiusDirectional.horizontal(
                  start: Radius.circular(BsButtonStyle.borderRadiusBase),
                ),
              ),
              onPressed: () {},
              child: Text(s[g * 5]),
            ),
            CsPullStart(
              by: 1,
              child: BsDropdown(
                toggleBuilder: (context, toggle, isOpen) => BsButton(
                  variant: variant,
                  style: BsButtonStyle(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    borderRadius: BorderRadiusDirectional.horizontal(
                      end: Radius.circular(BsButtonStyle.borderRadiusBase),
                    ),
                  ),
                  onPressed: toggle,
                  child: SizedBox(
                    height: 24,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top:
                            _baseline(16, 24) -
                            0.255 * 16 -
                            BsDropdownCaret.heightFor(context),
                      ),
                      child: const Align(
                        alignment: AlignmentDirectional.topStart,
                        child: BsDropdownCaret(),
                      ),
                    ),
                  ),
                ),
                items: _menu(
                  s.sublist(g * 5 + 2, g * 5 + 5),
                  header: false,
                  divider: false,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 16 + 3.92,
      children: [for (var g = 0; g < 6; g++) group(g)],
    );
  }

  final s37 = env.s(37);
  return [
    three(env.s(34), const [
      (BsSize.sm, BsDropdownDirection.down),
      (BsSize.normal, BsDropdownDirection.down),
      (BsSize.lg, BsDropdownDirection.down),
    ]),
    split(),
    three(env.s(36), const [
      (BsSize.normal, BsDropdownDirection.end),
      (BsSize.normal, BsDropdownDirection.up),
      (BsSize.normal, BsDropdownDirection.start),
    ]),
    // <div class="btn-group"><div class="dropdown"> … dropdown-menu-end
    _dropMargin(
      Padding(
        padding: const EdgeInsetsDirectional.only(end: 0, bottom: 16),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: BsDropdown(
            alignEnd: true,
            toggleBuilder: (context, toggle, isOpen) => BsButton(
              variant: BsVariant.secondary,
              onPressed: toggle,
              child: _toggleLabel(context, s37[0]),
            ),
            items: [
              BsDropdownHeader(child: Text(s37[1])),
              BsDropdownItem(child: Text(s37[2]), onTap: () {}),
              BsDropdownItem(child: Text(s37[3]), onTap: () {}),
              const BsDropdownDivider(),
              BsDropdownItem(child: Text(s37[4]), onTap: () {}),
            ],
          ),
        ),
      ),
    ),
  ];
}

/// List group (`#list-group`, examples 38-40).
List<Widget> cheatsheetListGroup(BuildContext context, CsEnv env) {
  final a = env.s(38);
  final b = env.s(39);
  final c = env.s(40);
  return [
    BsListGroup(
      items: [
        BsListGroupItem(child: Text(a[0]), disabled: true),
        for (var i = 1; i < 5; i++) BsListGroupItem(child: Text(a[i])),
      ],
    ),
    BsListGroup(
      flush: true,
      items: [for (final text in b) BsListGroupItem(child: Text(text))],
    ),
    BsListGroup(
      items: [
        BsListGroupItem(child: Text(c[0]), onTap: () {}),
        for (var i = 0; i < 8; i++)
          BsListGroupItem(
            child: Text(c[i + 1]),
            variant: _theme[i],
            onTap: () {},
          ),
      ],
    ),
  ];
}

/// Modal (`#modal`, example 41): four buttons that open a modal.
List<Widget> cheatsheetModal(BuildContext context, CsEnv env) {
  final s = env.s(41);
  final modals = env.rtl ? cheatsheetModalsAr : cheatsheetModalsEn;
  void open(int i) {
    final m = modals[i];
    showBsModal<void>(
      context: context,
      barrierDismissible: i != 1,
      builder: (context) => BsModalDialog(
        child: BsModal(
          header: BsModalHeader(
            onClose: () => Navigator.of(context).pop(),
            child: Text(m[0]),
          ),
          body: BsModalBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (var k = 1; k < (i == 2 ? 3 : 2); k++) Text(m[k])],
            ),
          ),
          footer: BsModalFooter(
            children: [
              BsButton(
                variant: BsVariant.secondary,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(m[i == 2 ? 3 : 2]),
              ),
              if (i != 3) BsButton(onPressed: () {}, child: Text(m.last)),
            ],
          ),
        ),
      ),
    );
  }

  // `[id="modal"] .bd-example .btn { margin: 0 1rem 1rem 0 }`
  Widget button(int i) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 16, bottom: 16),
    child: BsButton(onPressed: () => open(i), child: Text(s[i])),
  );
  return [
    BsFlex(
      wrap: true,
      justifyContent: BsJustify.between,
      children: [for (var i = 0; i < s.length; i++) button(i)],
    ),
  ];
}

/// Navs (`#navs`, examples 42-44).
List<Widget> cheatsheetNavs(BuildContext context, CsEnv env) {
  final a = env.s(42);
  final c = env.s(44);
  return [
    BsNav(
      items: [
        BsNavItem(child: Text(a[0]), active: true, onTap: () {}),
        BsNavItem(child: Text(a[1]), onTap: () {}),
        BsNavItem(child: Text(a[2]), onTap: () {}),
        BsNavItem(child: Text(a[3]), disabled: true),
      ],
    ),
    _CsTabs(env: env),
    BsNav(
      variant: BsNavVariant.pills,
      items: [
        BsNavItem(child: Text(c[0]), active: true, onTap: () {}),
        BsNavItem(child: Text(c[1]), onTap: () {}),
        BsNavItem(child: Text(c[2]), onTap: () {}),
        BsNavItem(child: Text(c[3]), disabled: true),
      ],
    ),
  ];
}

/// `<div class="nav nav-tabs mb-3">` and its `.tab-content` (example 43).
class _CsTabs extends StatefulWidget {
  const _CsTabs({required this.env});

  final CsEnv env;

  @override
  State<_CsTabs> createState() => _CsTabsState();
}

class _CsTabsState extends State<_CsTabs> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final env = widget.env;
    final s = env.s(43);
    // English: label ×3, then per pane: text, <strong>, text, <code>, tail;
    // Arabic: label ×3, then the three paragraphs.
    Widget pane(int i) {
      if (env.rtl) return Text(s[3 + i]);
      final at = 3 + i * 5;
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${s[at]} '),
            TextSpan(
              text: s[at + 1],
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: ' ${s[at + 2]} '),
            _code(context, s[at + 3]),
            TextSpan(text: s[at + 4]),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BsNav(
            variant: BsNavVariant.tabs,
            items: [
              for (var i = 0; i < 3; i++)
                BsNavItem(
                  child: Text(s[i]),
                  active: _tab == i,
                  onTap: () => setState(() => _tab = i),
                ),
            ],
          ),
        ),
        // `.tab-content` of `.tab-pane.fade`s: the old pane fades out, then the
        // new one fades in.
        BsTabView(
          activeIndex: _tab,
          children: [for (var i = 0; i < 3; i++) pane(i)],
        ),
      ],
    );
  }
}

/// Navbar (`#navbar`, example 45): a light and a primary navbar, both
/// `navbar-expand-lg`.
List<Widget> cheatsheetNavbar(BuildContext context, CsEnv env) {
  final s = env.s(45);
  Widget bar({required int at, required bool dark}) {
    final logo = BootstrapIcon(
      BootstrapIconData.bootstrapLogo,
      width: 38,
      height: 30,
      // (`filter: invert(1) …` turns the white logo black on the light bar)
      color: dark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
    );
    final navbar = BsNavbar(
      colorScheme: dark ? BsNavbarColorScheme.dark : BsNavbarColorScheme.light,
      expandBreakpoint: BsBreakpoint.lg,
      brand: logo,
      items: [
        BsNavbarItem(child: Text(s[at]), active: true, onTap: () {}),
        BsNavbarItem(child: Text(s[at + 1]), onTap: () {}),
        navbarDropdownItem(
          s[at + 2],
          expandBreakpoint: BsBreakpoint.lg,
          divider: true,
          spaceBeforeCaret: true,
          menu: s.sublist(at + 3, at + 6),
          colorScheme: dark
              ? BsNavbarColorScheme.dark
              : BsNavbarColorScheme.light,
        ),
        BsNavbarItem(child: Text(s[at + 6]), disabled: true),
      ],
      trailing: [
        NavbarSearchForm(
          label: s[at + 8],
          placeholder: s[at + 7],
          buttonVariant: dark ? BsVariant.light : BsVariant.dark,
        ),
      ],
    );
    // (`navbar-dark bg-primary`, as in v5.3.8: dark bar colours, light menu and input)
    return dark
        ? BsBox(
            bg: BsBg.primary,
            child: BsContainer.fluid(child: navbar),
          )
        : BsBox(
            bg: BsBg.bodyTertiary,
            child: BsContainer.fluid(child: navbar),
          );
  }

  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        bar(at: 0, dark: false),
        // `mt-5`
        const SizedBox(height: 48),
        bar(at: 9, dark: true),
      ],
    ),
  ];
}

/// Pagination (`#pagination`, examples 46-48).
List<Widget> cheatsheetPagination(BuildContext context, CsEnv env) {
  List<BsPaginationItem> items(
    List<String> texts, {
    int? active,
    int? disabled,
  }) => [
    for (var i = 0; i < texts.length; i++)
      BsPaginationItem(
        child: Text(texts[i]),
        active: i == active,
        disabled: i == disabled,
        onTap: i == disabled ? null : () {},
      ),
  ];
  final small = BsPaginationStyle(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    fontSize: 14,
    borderRadius: BsRounded.r1.radius,
  );
  final large = BsPaginationStyle(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    fontSize: 20,
    borderRadius: BsRounded.r3.radius,
  );
  return [
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: BsPagination(style: small, items: items(env.s(46), active: 1)),
    ),
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: BsPagination(items: items(env.s(47))),
    ),
    Align(
      alignment: AlignmentDirectional.centerStart,
      child: BsPagination(
        wrap: true,
        style: large,
        items: items(env.s(48), active: 2, disabled: 0),
      ),
    ),
  ];
}

/// `[id="popovers"] .bd-example .btn { margin: 0 1rem 1rem 0 }`: the buttons'
/// own margins, on top of the space between inline-blocks.
Widget _spaced(List<Widget> buttons) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: Wrap(spacing: 16 + 3.92, runSpacing: 16, children: buttons),
);

/// Popovers (`#popovers`, examples 49-50).
List<Widget> cheatsheetPopovers(BuildContext context, CsEnv env) {
  final texts = env.rtl ? cheatsheetPopoversAr : cheatsheetPopoversEn;
  final rtl = env.rtl;
  final s = env.s(50);
  // `data-bs-placement`: top, right, bottom, left (physical).
  final placements = [
    BsPopoverPlacement.top,
    rtl ? BsPopoverPlacement.start : BsPopoverPlacement.end,
    BsPopoverPlacement.bottom,
    rtl ? BsPopoverPlacement.end : BsPopoverPlacement.start,
  ];
  return [
    _spaced([
      BsPopover(
        title: Text(texts.title),
        content: Text(texts.content),
        triggerBuilder: (context, toggle, isOpen) => BsButton(
          variant: BsVariant.danger,
          size: BsSize.lg,
          onPressed: toggle,
          child: Text(env.s(49)[0]),
        ),
      ),
    ]),
    _spaced([
      for (var i = 0; i < 4; i++)
        BsPopover(
          placement: placements[i],
          content: Text(texts.side),
          triggerBuilder: (context, toggle, isOpen) => BsButton(
            variant: BsVariant.secondary,
            onPressed: toggle,
            child: Text(s[i]),
          ),
        ),
    ]),
  ];
}

/// Progress (`#progress`, examples 51-52).
List<Widget> cheatsheetProgress(BuildContext context, CsEnv env) {
  final s = env.s(51);
  const variants = [
    null,
    BsVariant.success,
    BsVariant.info,
    BsVariant.warning,
    BsVariant.danger,
  ];
  // <div class="progress-bar">0%</div>: no width of its own, so as wide as
  // its label.
  final zero = BsClipRRect(
    borderRadius: BorderRadius.circular(BsRounded.r2.radius),
    child: BsDecoratedBox(
      decoration: BoxDecoration(color: BsProgressStyle.defaults.background),
      child: SizedBox(
        height: 16,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: BsDecoratedBox(
            decoration: BoxDecoration(color: BsVariant.primary.color),
            child: Text(
              s[0],
              style: const TextStyle(
                fontSize: 12,
                height: 16 / 12,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  return [
    csBlocks([
      zero,
      for (var i = 1; i < 5; i++)
        BsProgress(value: i * 25.0, variant: variants[i], label: Text(s[i])),
    ]),
    const BsProgress.stacked(
      bars: [
        BsProgressBar(value: 15),
        BsProgressBar(
          value: 40,
          variant: BsVariant.success,
          striped: true,
          animated: true,
        ),
      ],
    ),
  ];
}

/// Scrollspy (`#scrollspy`, example 53).
class _CsScrollspy extends StatefulWidget {
  const _CsScrollspy({required this.env});

  final CsEnv env;

  @override
  State<_CsScrollspy> createState() => _CsScrollspyState();
}

class _CsScrollspyState extends State<_CsScrollspy> {
  final _scroll = ScrollController();
  late final _keys = List.generate(5, (_) => GlobalKey());
  late final _spy = BsScrollspyController(
    scrollController: _scroll,
    sectionKeys: _keys,
  );

  @override
  void dispose() {
    _spy.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final env = widget.env;
    final s = env.s(53);
    // English: Navbar, First, Second, Dropdown, Third, Fourth, Fifth, then a
    // heading and a paragraph for each of the five. Arabic: the same nav, then
    // five headings with their paragraphs and one paragraph more.
    final nav = s.sublist(0, 7);
    final body = s.sublist(7);
    final secondary = BsTextColor.bodySecondary.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <nav class="navbar bg-body-tertiary px-3">
        BsBox(
          bg: BsBg.bodyTertiary,
          px: BsSpacing.s3,
          py: BsSpacing.s2,
          child: ListenableBuilder(
            listenable: _spy,
            builder: (context, _) {
              final active = _spy.activeIndex;
              return Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // `.navbar-brand`: 1.25rem, `padding-block: .3125rem`
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      nav[0],
                      style: TextStyle(
                        fontSize: 20,
                        color: BsTextColor.bodyEmphasis.of(context),
                      ),
                    ),
                  ),
                  BsNav(
                    variant: BsNavVariant.pills,
                    items: [
                      BsNavItem(
                        child: Text(nav[1]),
                        active: active == 0,
                        onTap: () => _spy.scrollToSection(0),
                      ),
                      BsNavItem(
                        child: Text(nav[2]),
                        active: active == 1,
                        onTap: () => _spy.scrollToSection(1),
                      ),
                      BsNavItem(
                        active: active >= 2,
                        child: BsDropdown(
                          toggleBuilder: (context, toggle, isOpen) =>
                              GestureDetector(
                                onTap: toggle,
                                child: _toggleLabel(context, nav[3]),
                              ),
                          items: [
                            BsDropdownItem(
                              child: Text(nav[4]),
                              onTap: () => _spy.scrollToSection(2),
                            ),
                            BsDropdownItem(
                              child: Text(nav[5]),
                              onTap: () => _spy.scrollToSection(3),
                            ),
                            const BsDropdownDivider(),
                            BsDropdownItem(
                              child: Text(nav[6]),
                              onTap: () => _spy.scrollToSection(4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        // <div class="scrollspy-example position-relative mt-2 overflow-auto">
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < 5; i++) ...[
                  KeyedSubtree(
                    key: _keys[i],
                    child: BsHeading(
                      BsHeadingLevel.h4,
                      child: Text(body[i * 2]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(body[i * 2 + 1]),
                  ),
                ],
                if (body.length > 10)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(body[10], style: TextStyle(color: secondary)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Widget> cheatsheetScrollspy(BuildContext context, CsEnv env) => [
  _CsScrollspy(env: env),
];

/// Spinners (`#spinners`, examples 54-55): `.spinner-border`/`-grow` in each
/// theme color, inline.
List<Widget> cheatsheetSpinners(BuildContext context, CsEnv env) {
  Widget row(Widget Function(Color color) spinner) {
    // (`vertical-align: -.125em`: 2px under the baseline, in a 24px line)
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Wrap(
        spacing: 3.92,
        children: [for (final v in _theme) spinner(v.color)],
      ),
    );
  }

  return [
    row((color) => BsSpinnerBorder(color: color)),
    row((color) => BsSpinnerGrow(color: color)),
  ];
}

/// Toasts (`#toasts`, example 56): a toast shown on a dark `p-5` box.
List<Widget> cheatsheetToasts(BuildContext context, CsEnv env) {
  final s = env.s(56);
  return [
    BsBox(
      bg: BsBg.dark,
      p: BsSpacing.s5,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        // (`.toast { font-size: .875rem }`: the header too)
        child: DefaultTextStyle.merge(
          style: const TextStyle(fontSize: 14),
          child: BsToast(
            header: BsToastHeader(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BsBox(
                    rounded: BsRounded.r2,
                    overflowHidden: true,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: ColoredBox(color: Color(0xFF007AFF)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s[0],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              meta: Text(
                s[1],
                style: TextStyle(color: BsTextColor.bodySecondary.of(context)),
              ),
              onClose: () {},
            ),
            body: Text(s[2]),
          ),
        ),
      ),
    ),
  ];
}

/// Tooltips (`#tooltips`, example 57).
List<Widget> cheatsheetTooltips(BuildContext context, CsEnv env) {
  final s = env.s(57);
  final rtl = env.rtl;
  final texts = rtl ? cheatsheetPopoversAr : cheatsheetPopoversEn;
  final placements = [
    BsTooltipPlacement.top,
    rtl ? BsTooltipPlacement.start : BsTooltipPlacement.end,
    BsTooltipPlacement.bottom,
    rtl ? BsTooltipPlacement.end : BsTooltipPlacement.start,
    BsTooltipPlacement.top,
  ];
  // `title="<em>Tooltip</em> <u>with</u> <b>HTML</b>"`
  final html = RegExp(r'<(\w)>([^<]*)</\1>')
      .allMatches(texts.tooltipHtml)
      .map((m) => (m[1]!, m[2]!))
      .toList();
  Widget message(int i) {
    if (i < 4) return Text(s[i]);
    final spans = <InlineSpan>[];
    for (final (tag, text) in html) {
      if (spans.isNotEmpty) spans.add(const TextSpan(text: ' '));
      spans.add(
        TextSpan(
          text: text,
          style: TextStyle(
            fontStyle: tag == 'em' ? FontStyle.italic : null,
            decoration: tag == 'u' ? TextDecoration.underline : null,
            fontWeight: tag == 'b' ? FontWeight.w700 : null,
          ),
        ),
      );
    }
    return Text.rich(TextSpan(children: spans));
  }

  return [
    _spaced([
      for (var i = 0; i < 5; i++)
        BsTooltip(
          placement: placements[i],
          message: message(i),
          child: BsButton(
            variant: BsVariant.secondary,
            onPressed: () {},
            child: Text(s[i]),
          ),
        ),
    ]),
  ];
}
