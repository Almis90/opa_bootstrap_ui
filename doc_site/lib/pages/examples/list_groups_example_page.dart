import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';

/// The "List groups" example: a port of Bootstrap's own `examples/list-groups`
/// page, with each element's class list as the widget's props (see
/// [HeadersExamplePage] for the convention).
///
/// The page's own CSS (`list-groups.css`) is what the private widgets below
/// translate: `.list-group { width: 100%; max-width: 460px; margin-inline:
/// 1.5rem }` is [_group], `.list-group-item-check` and `.list-group-radio` are
/// [_CheckableGroup] and [_RadioGrid].
class ListGroupsExamplePage extends StatelessWidget {
  const ListGroupsExamplePage({super.key});

  static const _columnThenRowMd = BsResponsiveValue(
    xs: BsFlexDirection.column,
    md: BsFlexDirection.row,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _section([_group(_linkItems())]),
        const ExampleDivider(),
        _section([
          _group(const _Checks(radio: false)),
          _group(const _Checks(radio: true)),
        ]),
        const ExampleDivider(),
        _section([_group(const _Tasks())]),
        const ExampleDivider(),
        _section([_group(const _CheckableGroup())]),
        const ExampleDivider(),
        _section([_group(const _RadioGrid())]),
      ],
    );
  }

  // <div class="d-flex flex-column flex-md-row p-4 gap-4 py-md-5 align-items-center justify-content-center">
  static Widget _section(List<Widget> groups) {
    return BsBox(
      p: BsSpacing.s4,
      py: const BsResponsiveValue(md: BsSpacing.s5),
      child: BsFlex(
        direction: _columnThenRowMd,
        gap: BsSpacing.s4,
        alignItems: BsAlign.center,
        justifyContent: BsJustify.center,
        children: groups,
      ),
    );
  }

  /// `.list-group { width: 100%; max-width: 460px; margin-inline: 1.5rem }`.
  static Widget _group(Widget child) {
    return BsFlexItem(
      w: BsWidth.w100,
      maxWidth: 460,
      mx: BsSpacing.s4,
      child: child,
    );
  }

  // --- 1. <a class="list-group-item list-group-item-action d-flex gap-3 py-3"> ---

  static Widget _linkItems() {
    BsListGroupItem item(String title, String text, String when) {
      return BsListGroupItem(
        onTap: () {},
        py: BsSpacing.s3,
        child: BsFlex(
          gap: BsSpacing.s3,
          children: [
            // <img src="https://github.com/twbs.png" width="32" height="32" class="rounded-circle flex-shrink-0">
            // (an `<img height="32">` has a height, so a flex line doesn't
            // stretch it: align-self-start)
            const BsFlexItem(
              flexShrink: false,
              alignSelf: BsAlign.start,
              child: BsImage(
                image: NetworkImage(
                  'https://avatars.githubusercontent.com/u/2918581?v=4',
                ),
                width: 32,
                block: true,
                rounded: BsRounded.circle,
              ),
            ),
            // <div class="d-flex gap-2 w-100 justify-content-between">
            BsFlexItem(
              w: BsWidth.w100,
              child: BsFlex(
                gap: BsSpacing.s2,
                justifyContent: BsJustify.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // <h6 class="mb-0">
                      BsHeading(
                        BsHeadingLevel.h6,
                        mb: BsSpacing.s0,
                        child: Text(title),
                      ),
                      // <p class="mb-0 opacity-75">
                      BsBox(opacity: BsOpacity.o75, child: Text(text)),
                    ],
                  ),
                  // <small class="opacity-50 text-nowrap">
                  BsFlexItem(
                    flexShrink: false,
                    child: BsBox(
                      opacity: BsOpacity.o50,
                      textNoWrap: true,
                      child: BsSmall(block: true, child: Text(when)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BsListGroup(
      items: [
        item(
          'List group item heading',
          'Some placeholder content in a paragraph.',
          'now',
        ),
        item(
          'Another title here',
          'Some placeholder content in a paragraph that goes a little longer '
              'so it wraps to a new line.',
          '3d',
        ),
        item('Third heading', 'Some placeholder content in a paragraph.', '1w'),
      ],
    );
  }
}

/// `<label class="list-group-item d-flex gap-2"><input class="form-check-input
/// flex-shrink-0" type="checkbox"> <span>…<small class="d-block
/// text-body-secondary">…`: a list group of three checkboxes or radios.
class _Checks extends StatefulWidget {
  const _Checks({required this.radio});

  final bool radio;

  @override
  State<_Checks> createState() => _ChecksState();
}

class _ChecksState extends State<_Checks> {
  static const _titles = ['First', 'Second', 'Third'];
  static const _details = [
    'With support text underneath to add more detail',
    'Some other text goes here',
    'And we end with another snippet of text',
  ];

  late final List<bool> _checked = [true, false, false];

  void _toggle(int i) {
    setState(() {
      if (widget.radio) {
        for (var j = 0; j < _checked.length; j++) {
          _checked[j] = j == i;
        }
      } else {
        _checked[i] = !_checked[i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.radio ? 'radio' : 'checkbox';
    return BsListGroup(
      items: [
        for (var i = 0; i < 3; i++)
          BsListGroupItem(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _toggle(i),
              child: BsFlex(
                gap: BsSpacing.s2,
                children: [
                  // margin-top: .25em
                  BsFlexItem(
                    flexShrink: false,
                    mt: BsSpacing.s1,
                    child: BsFormCheckInput(
                      type: widget.radio
                          ? BsFormCheckType.radio
                          : BsFormCheckType.checkbox,
                      value: _checked[i],
                      onChanged: (_) => _toggle(i),
                    ),
                  ),
                  // <span>First checkbox <small class="d-block text-body-secondary">
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('${_titles[i]} $kind'),
                      BsBox(
                        textColor: BsTextColor.bodySecondary,
                        child: BsSmall(block: true, child: Text(_details[i])),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// `<label class="list-group-item d-flex gap-3">` with a 1.375em checkbox and
/// a `.form-checked-content` that fades once it's checked.
class _Tasks extends StatefulWidget {
  const _Tasks();

  @override
  State<_Tasks> createState() => _TasksState();
}

class _TasksState extends State<_Tasks> {
  static const _titles = [
    'Finish sales report',
    'Weekly All Hands',
    'Out of office',
  ];
  static const _whens = ['1:00–2:00pm', '2:00–2:30pm', 'Tomorrow'];
  static const _icons = [
    BootstrapIconData.calendarEvent,
    BootstrapIconData.calendarEvent,
    BootstrapIconData.alarm,
  ];

  final _checked = [true, false, false];

  // <small class="d-block text-body-secondary"><svg class="bi me-1" width="1em" height="1em"> …
  Widget _small(BootstrapIconData icon, String text) {
    return BsBox(
      textColor: BsTextColor.bodySecondary,
      child: BsSmall(
        block: true,
        child: BsFlex(
          alignItems: BsAlign.start,
          children: [
            // `.bi`'s svg hangs 2px below the baseline of the 21px line.
            Padding(
              padding: const EdgeInsets.only(top: 2.75),
              child: BootstrapIcon(icon, width: 14, height: 14),
            ),
            // me-1, and the space the markup leaves after the <svg>
            const SizedBox(width: 4 + 3.47),
            Text(text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BsListGroup(
      items: [
        for (var i = 0; i < 3; i++)
          BsListGroupItem(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _checked[i] = !_checked[i]),
              child: BsFlex(
                gap: BsSpacing.s3,
                children: [
                  // style="font-size: 1.375em;" → margin-top: .25em of that.
                  BsFlexItem(
                    flexShrink: false,
                    mt: BsSpacing.s1,
                    child: BsFormCheckInput(
                      value: _checked[i],
                      fontSize: 22,
                      onChanged: (v) => setState(() => _checked[i] = v),
                    ),
                  ),
                  // <span class="pt-1 form-checked-content">
                  BsBox(
                    pt: BsSpacing.s1,
                    opacity: _checked[i] ? BsOpacity.o50 : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // <strong> (bolder)
                        BsBox(fw: BsFw.bold, child: Text(_titles[i])),
                        _small(_icons[i], _whens[i]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        // <label class="list-group-item d-flex gap-3 bg-body-tertiary"> with a
        // disabled, dashed placeholder checkbox.
        BsListGroupItem(
          bg: BsBg.bodyTertiary,
          child: BsFlex(
            gap: BsSpacing.s3,
            children: [
              BsFlexItem(
                flexShrink: false,
                mt: BsSpacing.s1,
                child: BsFormCheckInput(
                  value: false,
                  fontSize: 22,
                  dashed: true,
                  background: BsBg.bodyTertiary.of(context),
                  onChanged: null,
                ),
              ),
              BsBox(
                pt: BsSpacing.s1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Add new task...'),
                    _small(BootstrapIconData.listCheck, 'Choose list...'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A group of `.list-group-item-check` radios: separate bordered, rounded
/// labels in a `d-grid gap-2`, the checked one turning primary.
class _CheckableGroup extends StatefulWidget {
  const _CheckableGroup();

  @override
  State<_CheckableGroup> createState() => _CheckableGroupState();
}

class _CheckableGroupState extends State<_CheckableGroup> {
  static const _titles = [
    'First radio',
    'Second radio',
    'Third radio',
    'Fourth disabled radio',
  ];
  static const _details = [
    'With support text underneath to add more detail',
    'Some other text goes here',
    'And we end with another snippet of text',
    'This option is disabled',
  ];

  int _selected = 0;
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final primary = BsVariant.primary.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(height: 8), // gap-2
          MouseRegion(
            cursor: i == 3 ? MouseCursor.defer : SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = i),
            onExit: (_) => setState(() => _hovered = null),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: i == 3 ? null : () => setState(() => _selected = i),
              // <label class="list-group-item rounded-3 py-3">
              child: Opacity(
                opacity: i == 3 ? 0.5 : 1,
                child: BsDecoratedContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _selected == i
                        ? primary
                        : (_hovered == i && i != 3
                              ? BsBody.secondaryBackgroundOf(context)
                              : BsBody.backgroundOf(context)),
                    border: Border.all(
                      color: _selected == i
                          ? primary
                          : BsBorders.colorOf(context),
                    ),
                    borderRadius: BorderRadius.circular(BsRounded.r3.radius),
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      color: _selected == i
                          ? BsColors.white
                          : BsBody.colorOf(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(_titles[i]),
                        // <span class="d-block small opacity-50">
                        BsBox(
                          opacity: BsOpacity.o50,
                          child: BsSmall(block: true, child: Text(_details[i])),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// `.list-group-radio`: labels with a radio at the end (`position-absolute
/// top-50 end-0 me-3 fs-5`); the chosen one gets a primary 2px ring.
class _RadioGrid extends StatefulWidget {
  const _RadioGrid();

  @override
  State<_RadioGrid> createState() => _RadioGridState();
}

class _RadioGridState extends State<_RadioGrid> {
  static const _titles = [
    'First radio',
    'Second radio',
    'Third radio',
    'Fourth disabled radio',
  ];
  static const _details = [
    'With support text underneath to add more detail',
    'Some other text goes here',
    'And we end with another snippet of text',
    'This option is disabled',
  ];

  int _selected = 0;
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final primary = BsVariant.primary.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(height: 8), // gap-2
          MouseRegion(
            cursor: i == 3 ? MouseCursor.defer : SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = i),
            onExit: (_) => setState(() => _hovered = null),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: i == 3 ? null : () => setState(() => _selected = i),
              // <div class="position-relative">
              child: Stack(
                children: [
                  // <label class="list-group-item py-3 pe-5">
                  Opacity(
                    opacity: i == 3 ? 0.5 : 1,
                    child: BsDecoratedContainer(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        16,
                        48,
                        16,
                      ),
                      decoration: BoxDecoration(
                        color: _selected == i
                            ? BsBody.backgroundOf(context)
                            : (_hovered == i && i != 3
                                  ? BsBody.secondaryBackgroundOf(context)
                                  : BsBody.backgroundOf(context)),
                        border: Border.all(
                          color: _selected == i
                              ? primary
                              : BsBorders.colorOf(context),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _selected == i
                            ? [BoxShadow(color: primary, spreadRadius: 2)]
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // <strong class="fw-semibold">
                          BsBox(fw: BsFw.semibold, child: Text(_titles[i])),
                          // <span class="d-block small opacity-75">
                          BsBox(
                            opacity: BsOpacity.o75,
                            child: BsSmall(
                              block: true,
                              child: Text(_details[i]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // <input class="form-check-input position-absolute top-50 end-0 me-3 fs-5" type="radio">
                  Positioned.fill(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 16),
                        child: BsFormCheckInput(
                          type: BsFormCheckType.radio,
                          value: _selected == i,
                          fontSize: 20,
                          onChanged: i == 3
                              ? null
                              : (_) => setState(() => _selected = i),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
