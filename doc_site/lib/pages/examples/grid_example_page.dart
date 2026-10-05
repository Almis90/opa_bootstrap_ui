import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// The "Grid" example: a port of Bootstrap's own `examples/grid` page — grid
/// layouts shown with themed columns: the five tiers, equal, unequal and
/// nested columns, mixed breakpoints, gutters and the container variants. The
/// page's CSS (`grid.css`: `.themed-grid-col`, `.themed-container`) is
/// translated where it is used.
class GridExamplePage extends StatelessWidget {
  const GridExamplePage({super.key});

  static final _fill = Color.from(
    alpha: 0.15,
    red: 112.520718 / 255,
    green: 44.062154 / 255,
    blue: 249.437846 / 255,
  );
  static final _line = Color.from(
    alpha: 0.3,
    red: 112.520718 / 255,
    green: 44.062154 / 255,
    blue: 249.437846 / 255,
  );

  /// `.themed-grid-col`: `.75rem` of vertical padding, the row's half gutter on
  /// the sides, a tinted background and a `1px` tinted border.
  static Widget _themed(Widget child, {double gutter = 24}) {
    return BsDecoratedContainer(
      padding: EdgeInsets.symmetric(horizontal: gutter / 2, vertical: 12),
      decoration: BoxDecoration(
        color: _fill,
        border: Border.all(color: _line),
      ),
      child: child,
    );
  }

  /// A `.col-*` child of a row with a [_themed] box in it.
  static BsFlexItem _col(
    BsResponsive<BsCol> col,
    Widget child, {
    double gutter = 24,
  }) {
    return BsFlexItem(
      col: col,
      p: BsSpacing.s0,
      child: _themed(child, gutter: gutter),
    );
  }

  static BsResponsive<BsCol> _c(
    int xs, {
    int? sm,
    int? md,
    int? lg,
    int? xl,
    int? xxl,
  }) => BsResponsiveValue<BsCol>(
    xs: BsCol(xs),
    sm: sm == null ? null : BsCol(sm),
    md: md == null ? null : BsCol(md),
    lg: lg == null ? null : BsCol(lg),
    xl: xl == null ? null : BsCol(xl),
    xxl: xxl == null ? null : BsCol(xxl),
  );

  /// `.col-{breakpoint}-N` alone: full width below it.
  static BsResponsive<BsCol> _from(BsBreakpoint at, int n) {
    final col = BsCol(n);
    return BsResponsiveValue<BsCol>(
      xs: const BsCol(12),
      sm: at.index <= BsBreakpoint.sm.index ? col : null,
      md: at.index <= BsBreakpoint.md.index ? col : null,
      lg: at.index <= BsBreakpoint.lg.index ? col : null,
      xl: at.index <= BsBreakpoint.xl.index ? col : null,
      xxl: at.index <= BsBreakpoint.xxl.index ? col : null,
    );
  }

  /// `<code>`: monospaced, pink, `.875em`.
  static TextSpan _code(String text) => TextSpan(
    text: text,
    style: TextStyle(
      fontFamily: BsTypography.fontFamilyMonospace.first,
      fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
      fontSize: 14,
      color: BsCodeStyle.defaultCodeColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Block margins collapse: each block says its own top and bottom margin
    // and the gap between two is the larger of the one's bottom and the next's
    // top.
    final blocks = <(double, double, Widget)>[];
    void add(Widget w, {double mt = 0, double mb = 0}) =>
        blocks.add((mt, mb, w));
    void h2(String text) => add(
      BsHeading(BsHeadingLevel.h2, mb: BsSpacing.s0, child: Text(text)),
      mt: 24,
      mb: 8,
    );
    void p(List<InlineSpan> spans) =>
        add(Text.rich(TextSpan(children: spans)), mb: 16);
    void row(Widget w) =>
        add(BsBox(textAlign: BsTextAlign.center, child: w), mb: 16);
    void hr() => add(const BsHr(my: BsSpacing.s0), mt: 24, mb: 24);
    TextSpan t(String s) => TextSpan(text: s);
    TextSpan strong(String s) => TextSpan(
      text: s,
      style: const TextStyle(fontWeight: FontWeight.w700),
    );

    add(
      const BsHeading(
        BsHeadingLevel.h1,
        mb: BsSpacing.s0,
        child: Text('Bootstrap grid examples'),
      ),
      mb: 8,
    );
    add(
      const BsLead(
        child: Text(
          'Basic grid layouts to get you familiar with building within the '
          'Bootstrap grid system.',
        ),
      ),
      mb: 16,
    );
    p([
      t('In these examples the '),
      _code('.themed-grid-col'),
      t(
        ' class is added to the columns to add some theming. This is not a '
        'class that is available in Bootstrap by default.',
      ),
    ]);

    h2('Five grid tiers');
    p([
      t(
        'There are five tiers to the Bootstrap grid system, one for each range '
        'of devices we support. Each tier starts at a minimum viewport size and '
        'automatically applies to the larger devices unless overridden.',
      ),
    ]);
    for (final (label, tier) in [
      ('.col-4', null),
      ('.col-sm-4', BsBreakpoint.sm),
      ('.col-md-4', BsBreakpoint.md),
      ('.col-lg-4', BsBreakpoint.lg),
      ('.col-xl-4', BsBreakpoint.xl),
      ('.col-xxl-4', BsBreakpoint.xxl),
    ]) {
      final col = tier == null ? _c(4) : _from(tier, 4);
      row(
        BsRow(children: [for (var i = 0; i < 3; i++) _col(col, Text(label))]),
      );
    }

    h2('Three equal columns');
    p([
      t('Get three equal-width columns '),
      strong('starting at desktops and scaling to large desktops'),
      t(
        '. On mobile devices, tablets and below, the columns will automatically '
        'stack.',
      ),
    ]);
    row(
      BsRow(
        children: [
          for (var i = 0; i < 3; i++)
            _col(_from(BsBreakpoint.md, 4), const Text('.col-md-4')),
        ],
      ),
    );

    h2('Three equal columns alternative');
    p([
      t('By using the '),
      _code('.row-cols-*'),
      t(' classes, you can easily create a grid with equal columns.'),
    ]);
    // (`.col` children of `.row-cols-md-3`: equal columns, three to a line from md)
    row(
      BsRow(
        children: [
          for (var i = 0; i < 3; i++)
            _col(
              const BsResponsiveValue<BsCol>(xs: BsCol.equal, md: BsCol(4)),
              Text.rich(
                TextSpan(
                  children: [
                    _code('.col'),
                    t(' child of '),
                    _code('.row-cols-md-3'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    h2('Three unequal columns');
    p([
      t('Get three columns '),
      strong('starting at desktops and scaling to large desktops'),
      t(
        ' of various widths. Remember, grid columns should add up to twelve for '
        'a single horizontal block. More than that, and columns start stacking '
        'no matter the viewport.',
      ),
    ]);
    row(
      BsRow(
        children: [
          _col(_from(BsBreakpoint.md, 3), const Text('.col-md-3')),
          _col(_from(BsBreakpoint.md, 6), const Text('.col-md-6')),
          _col(_from(BsBreakpoint.md, 3), const Text('.col-md-3')),
        ],
      ),
    );

    h2('Two columns');
    p([
      t('Get two columns '),
      strong('starting at desktops and scaling to large desktops'),
      t('.'),
    ]);
    row(
      BsRow(
        children: [
          _col(_from(BsBreakpoint.md, 8), const Text('.col-md-8')),
          _col(_from(BsBreakpoint.md, 4), const Text('.col-md-4')),
        ],
      ),
    );

    h2('Full width, single column');
    add(
      Text(
        'No grid classes are necessary for full-width elements.',
        style: TextStyle(color: BsVariant.warning.color),
      ),
      mb: 16,
    );
    hr();

    h2('Two columns with two nested columns');
    p([
      t(
        'Per the documentation, nesting is easy—just put a row of columns '
        'within an existing column. This gives you two columns ',
      ),
      strong('starting at desktops and scaling to large desktops'),
      t(', with another two (equal widths) within the larger column.'),
    ]);
    p([
      t(
        'At mobile device sizes, tablets and down, these columns and their '
        'nested columns will stack.',
      ),
    ]);
    row(
      BsRow(
        children: [
          _col(
            _from(BsBreakpoint.md, 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('.col-md-8'),
                ),
                BsRow(
                  children: [
                    _col(_from(BsBreakpoint.md, 6), const Text('.col-md-6')),
                    _col(_from(BsBreakpoint.md, 6), const Text('.col-md-6')),
                  ],
                ),
              ],
            ),
          ),
          _col(_from(BsBreakpoint.md, 4), const Text('.col-md-4')),
        ],
      ),
    );
    hr();

    h2('Mixed: mobile and desktop');
    p([
      t(
        'The Bootstrap v5 grid system has six tiers of classes: xs (extra small, '
        'this class infix is not used), sm (small), md (medium), lg (large), xl '
        '(x-large), and xxl (xx-large). You can use nearly any combination of '
        'these classes to create more dynamic and flexible layouts.',
      ),
    ]);
    p([
      t(
        'Each tier of classes scales up, meaning if you plan on setting the same '
        'widths for md, lg, xl and xxl, you only need to specify md.',
      ),
    ]);
    row(
      BsRow(
        children: [
          _col(_from(BsBreakpoint.md, 8), const Text('.col-md-8')),
          _col(_c(6, md: 4), const Text('.col-6 .col-md-4')),
        ],
      ),
    );
    row(
      BsRow(
        children: [
          for (var i = 0; i < 3; i++)
            _col(_c(6, md: 4), const Text('.col-6 .col-md-4')),
        ],
      ),
    );
    row(
      BsRow(
        children: [
          for (var i = 0; i < 2; i++) _col(_c(6), const Text('.col-6')),
        ],
      ),
    );
    hr();

    h2('Mixed: mobile, tablet, and desktop');
    row(
      BsRow(
        children: [
          _col(
            const BsResponsiveValue<BsCol>(
              xs: BsCol(12),
              sm: BsCol(6),
              lg: BsCol(8),
            ),
            const Text('.col-sm-6 .col-lg-8'),
          ),
          _col(_c(6, lg: 4), const Text('.col-6 .col-lg-4')),
        ],
      ),
    );
    row(
      BsRow(
        children: [
          for (var i = 0; i < 3; i++)
            _col(_c(6, sm: 4), const Text('.col-6 .col-sm-4')),
        ],
      ),
    );
    hr();

    h2('Gutters');
    p([
      t('With '),
      _code('.gx-*'),
      t(' classes, the horizontal gutters can be adjusted.'),
    ]);
    Widget gutterRow(
      String cls, {
      BsSpacing? gx,
      BsSpacing? gy,
      BsSpacing? g,
      double padding = 12,
    }) {
      return BsBox(
        textAlign: BsTextAlign.center,
        child: BsRow(
          rowCols: const BsResponsiveValue<int>(xs: 1, md: 3),
          gx: gx,
          gy: gy,
          g: g,
          children: [
            for (var i = 0; i < 6; i++)
              BsFlexItem(
                p: BsSpacing.s0,
                child: _themed(
                  Text.rich(
                    TextSpan(
                      children: [
                        _code('.col'),
                        t(' with '),
                        _code(cls),
                        t(' gutters'),
                      ],
                    ),
                  ),
                  gutter: padding * 2,
                ),
              ),
          ],
        ),
      );
    }

    add(gutterRow('.gx-4', gx: BsSpacing.s4));
    p([
      t('Use the '),
      _code('.gy-*'),
      t(' classes to control the vertical gutters.'),
    ]);
    // (the paragraph above carries `mt-4`)
    blocks.insert(blocks.length - 1, (
      24,
      blocks[blocks.length - 1].$2,
      blocks[blocks.length - 1].$3,
    ));
    blocks.removeLast();
    add(gutterRow('.gy-4', gy: BsSpacing.s4));
    p([
      t('With '),
      _code('.g-*'),
      t(' classes, the gutters in both directions can be adjusted.'),
    ]);
    blocks.insert(blocks.length - 1, (
      24,
      blocks[blocks.length - 1].$2,
      blocks[blocks.length - 1].$3,
    ));
    blocks.removeLast();
    add(gutterRow('.g-3', g: BsSpacing.s3, padding: 8));

    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      final (mt, mb, widget) = blocks[i];
      if (i > 0) {
        final gap = mt > blocks[i - 1].$2 ? mt : blocks[i - 1].$2;
        if (gap > 0) children.add(SizedBox(height: gap));
      }
      children.add(widget);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
          BsContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BsHr(my: BsSpacing.s4),
                BsHeading(
                  BsHeadingLevel.h2,
                  mb: BsSpacing.s0,
                  child: const Text('Containers'),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      t(
                        'Additional classes added in Bootstrap v4.4 allow '
                        'containers that are 100% wide until a particular '
                        'breakpoint. v5 adds a new ',
                      ),
                      _code('xxl'),
                      t(' breakpoint.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _container('.container', null),
          _container('.container-sm', BsBreakpoint.sm),
          _container('.container-md', BsBreakpoint.md),
          _container('.container-lg', BsBreakpoint.lg),
          _container('.container-xl', BsBreakpoint.xl),
          _container('.container-xxl', BsBreakpoint.xxl),
          _container('.container-fluid', null, fluid: true),
        ],
      ),
    );
  }

  /// `.container-*.themed-container.text-center`: `.75rem` of padding, a tinted
  /// background and border, `1.5rem` below.
  static Widget _container(
    String label,
    BsBreakpoint? at, {
    bool fluid = false,
  }) {
    final box = BsDecoratedContainer(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _fill,
        border: Border.all(color: _line),
      ),
      child: Center(child: Text(label)),
    );
    final Widget container = fluid
        ? BsContainer.fluid(px: BsSpacing.s0, child: box)
        : at == null
        ? BsContainer(px: BsSpacing.s0, child: box)
        : BsContainer.responsiveFrom(at, px: BsSpacing.s0, child: box);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: container,
    );
  }
}
