import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

/// "Containers": `BsContainer` and its three forms.
class ContainersPage extends StatelessWidget {
  const ContainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Containers',
      lead:
          'Containers are a fundamental building block of opa_bootstrap_ui '
          'that contain, pad, and align your content within a given device or '
          'viewport.',
      children: [
        const DocHeading('How they work'),
        DocText([
          'Containers are the most basic layout element: ',
          DocCode('BsContainer'),
          ' contains, pads and (sometimes) centers the content within it. '
              'Wrap the grid of a page in one, since it is what gives the '
              'page its margins, as it does in Bootstrap. While containers ',
          DocBold('can'),
          ' be nested, most layouts do not require a nested container.',
        ]),
        DocText(['There are three forms, as there are three classes:']),
        DocList([
          DocListItem([
            DocCode('BsContainer()'),
            ' (',
            DocCode('.container'),
            '), which sets a maximum width at each breakpoint from ',
            DocCode('sm'),
            ' up.',
          ]),
          DocListItem([
            DocCode('BsContainer.responsiveFrom(breakpoint)'),
            ' (',
            DocCode('.container-{breakpoint}'),
            '), which is full width until the breakpoint, and has the '
                'maximum widths from it up.',
          ]),
          DocListItem([
            DocCode('BsContainer.fluid()'),
            ' (',
            DocCode('.container-fluid'),
            '), which is full width at every breakpoint.',
          ]),
        ]),
        DocText([
          'The table shows the maximum width of each, and how it compares to '
              'the others at each breakpoint. The breakpoint is the one of '
              'the window, as for media queries (see ',
          DocLink.page('Breakpoints', 'Layout', 'Breakpoints'),
          '), so a container in a narrow column of a wide window still has '
              'the width that the window gives it.',
        ]),
        const _ContainerTable(),
        DocText([
          'The examples below show the maximum width that applies to your '
              'window, and the width the content really gets. They sit in a '
              'column narrower than the larger containers, so the content is '
              'limited by the column too.',
        ]),
        const DocHeading('Default container'),
        DocText([
          'The default container is a responsive, fixed-width one: its '
              'maximum width changes at each breakpoint.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: content,
)''',
          preview: _Contained(
            container: (child) => BsContainer(child: child),
            label: 'BsContainer',
            from: BsBreakpoint.sm,
          ),
        ),
        const DocHeading('Responsive containers'),
        DocText([
          'Responsive containers are full width until the breakpoint you '
              'name is reached, after which each of the higher breakpoints '
              'has its maximum width. For example, ',
          DocCode('BsContainer.responsiveFrom(BsBreakpoint.sm)'),
          ' is full width to start with until ',
          DocCode('sm'),
          ' is reached, where it scales up with ',
          DocCode('md'),
          ', ',
          DocCode('lg'),
          ', ',
          DocCode('xl'),
          ' and ',
          DocCode('xxl'),
          '.',
        ]),
        DocExample(
          code: '''
BsContainer.responsiveFrom(BsBreakpoint.md, child: content)
BsContainer.responsiveFrom(BsBreakpoint.lg, child: content)
BsContainer.responsiveFrom(BsBreakpoint.xl, child: content)
BsContainer.responsiveFrom(BsBreakpoint.xxl, child: content)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final breakpoint in const [
                BsBreakpoint.md,
                BsBreakpoint.lg,
                BsBreakpoint.xl,
                BsBreakpoint.xxl,
              ])
                _Contained(
                  container: (child) =>
                      BsContainer.responsiveFrom(breakpoint, child: child),
                  label: 'responsiveFrom(${breakpoint.name})',
                  from: breakpoint,
                ),
            ],
          ),
        ),
        const DocHeading('Fluid containers'),
        DocText([
          'Use ',
          DocCode('BsContainer.fluid'),
          ' for a full-width container, spanning the entire width of the '
              'viewport. It still has the padding.',
        ]),
        DocExample(
          code: '''
BsContainer.fluid(
  child: content,
)''',
          preview: _Contained(
            container: (child) => BsContainer.fluid(child: child),
            label: 'BsContainer.fluid',
            from: null,
          ),
        ),
        const DocHeading('Options'),
        DocText([
          'The three forms take the same options. They are the ones that '
              'Bootstrap\'s classes give you on the container itself:',
        ]),
        DocTable(
          headers: ['Parameter', 'Bootstrap', 'Description'],
          rows: [
            [
              'px, py',
              'px-*, py-*',
              'The padding, as a BsSpacing that can be responsive. The '
                  'default horizontal padding is 12, half of the gutter.',
            ],
            [
              'padding',
              'style="padding: …"',
              'A complete EdgeInsetsGeometry, which wins over px and py.',
            ],
            ['my', 'my-*', 'The vertical margin.'],
            [
              'col',
              'col-*',
              'The width of the container as a share of 12 columns of its '
                  'parent, still capped by its maximum width.',
            ],
            [
              'alignment',
              'mx-auto, ms-0',
              'Where the container sits when it is narrower than its parent. '
                  'It is centered at the top by default.',
            ],
          ],
        ),
        DocText([
          'The container is a plain widget. It can be a child of a ',
          DocCode('Column'),
          ' or a ',
          DocCode('ListView'),
          ', and it fills the width that it is given, up to its maximum.',
        ]),
        const DocHeading('Customize'),
        const DocHeading('Maximum widths', sub: true),
        DocText([
          'Bootstrap lets you change its Sass map of container widths. Here '
              'they are the constants of ',
          DocCode('BsGrid.containerMaxWidths'),
          ', which are read by the library and cannot be reassigned (see ',
          DocLink.page('Tokens', 'Customize', 'Tokens'),
          '). The map has an entry for every breakpoint but ',
          DocCode('xs'),
          ', and ',
          DocCode('BsGrid.containerMaxWidthFor'),
          ' reads it. The same goes for the padding, ',
          DocCode('BsGrid.containerPaddingX'),
          '.',
        ]),
        const DocHeading('Your own container', sub: true),
        DocText([
          'In place of the ',
          DocCode('make-container'),
          ' mixin, compose one. This one is capped at a width of your own '
              'at every size:',
        ]),
        const DocCodeSnippet('''
class ReadingColumn extends StatelessWidget {
  const ReadingColumn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BsGrid.containerPaddingX,
          ),
          child: child,
        ),
      ),
    );
  }
}'''),
      ],
    );
  }
}

String _width(double? maxWidth) =>
    maxWidth == null ? '100%' : '${maxWidth.toStringAsFixed(0)}px';

class _ContainerTable extends StatelessWidget {
  const _ContainerTable();

  @override
  Widget build(BuildContext context) {
    final current = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    String width(BsBreakpoint from, BsBreakpoint at) => at.index >= from.index
        ? _width(BsGrid.containerMaxWidthFor(at))
        : '100%';

    return DocTable(
      headers: [
        '',
        for (final breakpoint in BsBreakpoint.values)
          '${breakpoint.name} ${breakpoint == BsBreakpoint.xs ? '<${BsBreakpoint.sm.minWidth.toStringAsFixed(0)}' : '≥${breakpoint.minWidth.toStringAsFixed(0)}'}'
              '${breakpoint == current ? ' (you)' : ''}',
      ],
      rows: [
        [
          'BsContainer()',
          for (final breakpoint in BsBreakpoint.values)
            width(BsBreakpoint.sm, breakpoint),
        ],
        for (final from in BsBreakpoint.values.skip(1))
          [
            'responsiveFrom(${from.name})',
            for (final breakpoint in BsBreakpoint.values)
              width(from, breakpoint),
          ],
        ['BsContainer.fluid()', for (final _ in BsBreakpoint.values) '100%'],
      ],
    );
  }
}

/// A container around a box that reports the width it is given.
class _Contained extends StatelessWidget {
  const _Contained({
    required this.container,
    required this.label,
    required this.from,
  });

  final Widget Function(Widget child) container;
  final String label;

  /// The breakpoint from which a maximum width applies, or null for none.
  final BsBreakpoint? from;

  @override
  Widget build(BuildContext context) {
    final at = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final cap = from == null || at.index < from!.index
        ? '100%'
        : _width(BsGrid.containerMaxWidthFor(at));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: BsColors.gray100),
        child: container(
          LayoutBuilder(
            builder: (context, constraints) => DecoratedBox(
              decoration: BoxDecoration(
                color: BsVariant.primary.bgSubtle,
                border: Border.all(color: BsVariant.primary.borderSubtle),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    '$label: $cap, '
                    '${constraints.maxWidth.toStringAsFixed(0)}px of content '
                    'here',
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
