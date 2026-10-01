import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

class TooltipsPage extends StatelessWidget {
  const TooltipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Tooltips',
      lead:
          'BsTooltip wraps any child and shows a small message bubble on hover (or long-press on touch devices), '
          'positioning it toward a BsTooltipPlacement side of the child without requiring any external state.',
      examples: [
        DocExample(
          title: 'Basic (hover, or long-press on touch)',
          description: 'Wrapping a BsButton in BsTooltip attaches a message bubble to it.',
          code: '''
BsTooltip(
  message: Text('Tooltip text'),
  child: BsButton(onPressed: () {}, child: Text('Hover over me')),
)''',
          preview: BsTooltip(
            message: const Text('Tooltip text'),
            child: BsButton(onPressed: () {}, child: const Text('Hover over me')),
          ),
        ),
        DocExample(
          title: 'Placements',
          description: 'placement controls which side of the child the tooltip bubble appears on.',
          code: '''
BsTooltip(
  placement: BsTooltipPlacement.top,
  message: Text('Tooltip on top'),
  child: BsButton(onPressed: () {}, child: Text('Top')),
)''',
          preview: Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              BsTooltip(
                placement: BsTooltipPlacement.top,
                message: const Text('Tooltip on top'),
                child: BsButton(onPressed: () {}, child: const Text('Top')),
              ),
              BsTooltip(
                placement: BsTooltipPlacement.bottom,
                message: const Text('Tooltip on bottom'),
                child: BsButton(onPressed: () {}, child: const Text('Bottom')),
              ),
              BsTooltip(
                placement: BsTooltipPlacement.start,
                message: const Text('Tooltip on start'),
                child: BsButton(onPressed: () {}, child: const Text('Start')),
              ),
              BsTooltip(
                placement: BsTooltipPlacement.end,
                message: const Text('Tooltip on end'),
                child: BsButton(onPressed: () {}, child: const Text('End')),
              ),
            ],
          ),
        ),
        DocExample(
          title: 'On plain text',
          description: 'BsTooltip works on any widget, not just buttons — here it wraps underlined text.',
          code: '''
BsTooltip(
  message: Text('This is an example tooltip.'),
  child: Text(
    'I have a tooltip.',
    style: TextStyle(decoration: TextDecoration.underline),
  ),
)''',
          // DocExample's preview area stretches to the full example width
          // (so full-width children like the "Basic" button above size
          // correctly); without Align here, the underlined Text itself
          // would inherit that full width, and BsTooltip's target anchor
          // (which tracks its child's actual layout box, not just the
          // glyphs painted inside it) would center over the whole card
          // instead of the short run of text.
          preview: const Align(
            alignment: Alignment.centerLeft,
            child: BsTooltip(
              message: Text('This is an example tooltip.'),
              child: Text('I have a tooltip.', style: TextStyle(decoration: TextDecoration.underline)),
            ),
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsTooltipController lets code outside the tooltip show(), hide(), toggle(), enable()/disable() '
              'it, and override its message or placement with setContent()/setPlacement() — all independent of '
              "the tooltip's own hover/long-press triggers.",
          code: '''
final controller = BsTooltipController();

Column(
  children: [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        BsButton(onPressed: controller.show, child: Text('Show')),
        BsButton(onPressed: controller.hide, child: Text('Hide')),
        BsButton(onPressed: controller.toggle, child: Text('Toggle')),
        BsButton(onPressed: controller.disable, child: Text('Disable')),
        BsButton(onPressed: controller.enable, child: Text('Enable')),
        BsButton(
          onPressed: () => controller.setContent(Text('Updated message')),
          child: Text('Change content'),
        ),
        BsButton(
          onPressed: () => controller.setPlacement(BsTooltipPlacement.bottom),
          child: Text('Change placement'),
        ),
      ],
    ),
    BsTooltip(
      controller: controller,
      message: Text('Original message'),
      child: BsButton(onPressed: () {}, child: Text('Hover, or use the buttons above')),
    ),
  ],
)''',
          preview: const _ControllerDemo(),
        ),
        DocExample(
          title: 'Events',
          description:
              'onShow/onHide fire immediately once a show or hide is triggered; onShown/onHidden fire once the '
              'fade animation actually finishes — mirroring Bootstrap\'s show.bs.tooltip/shown.bs.tooltip/'
              'hide.bs.tooltip/hidden.bs.tooltip.',
          code: '''
BsTooltip(
  message: Text('Hover over me'),
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
  child: BsButton(onPressed: () {}, child: Text('Hover over me')),
)''',
          preview: const _EventsDemo(),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsTooltipStyle',
          defaultsNote:
              'color and background swap for their dark-theme counterparts when BsTheme.of(context) is '
              "Brightness.dark — and background doesn't just lighten, it inverts: a light-page tooltip is a dark "
              'chip, but a dark-page tooltip becomes a light chip, so color and background effectively swap roles.',
          rows: [
            DocStyleRow(field: 'fontSize', defaultValue: '14'),
            DocStyleRow(field: 'maxWidth', defaultValue: '200'),
            DocStyleRow(field: 'color', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'background', defaultValue: 'BsColors.black'),
            DocStyleRow(field: 'borderRadius', defaultValue: '6'),
            DocStyleRow(field: 'opacity', defaultValue: '0.9'),
            DocStyleRow(field: 'padding', defaultValue: 'EdgeInsets.symmetric(horizontal: 8, vertical: 4)'),
            DocStyleRow(field: 'arrowWidth', defaultValue: '12.8'),
            DocStyleRow(field: 'arrowHeight', defaultValue: '6.4'),
          ],
        ),
      ],
    );
  }
}

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  late final BsTooltipController _controller = BsTooltipController();
  bool _contentChanged = false;
  int _placementIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleContent() {
    _contentChanged = !_contentChanged;
    _controller.setContent(_contentChanged ? const Text('Updated message') : null);
  }

  void _cyclePlacement() {
    _placementIndex = (_placementIndex + 1) % BsTooltipPlacement.values.length;
    _controller.setPlacement(BsTooltipPlacement.values[_placementIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            BsButton(size: BsSize.sm, onPressed: _controller.show, child: const Text('Show')),
            BsButton(size: BsSize.sm, onPressed: _controller.hide, child: const Text('Hide')),
            BsButton(size: BsSize.sm, onPressed: _controller.toggle, child: const Text('Toggle')),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _controller.disable,
              child: const Text('Disable'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _controller.enable,
              child: const Text('Enable'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _toggleContent,
              child: const Text('Change content'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _cyclePlacement,
              child: const Text('Change placement'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BsTooltip(
          controller: _controller,
          message: const Text('Original message'),
          child: BsButton(onPressed: () {}, child: const Text('Hover, or use the buttons above')),
        ),
      ],
    );
  }
}

class _EventsDemo extends StatefulWidget {
  const _EventsDemo();

  @override
  State<_EventsDemo> createState() => _EventsDemoState();
}

class _EventsDemoState extends State<_EventsDemo> {
  final _events = <String>[];

  void _log(String event) => setState(() => _events.add(event));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsTooltip(
          message: const Text('Hover over me'),
          onShow: () => _log('show'),
          onShown: () => _log('shown'),
          onHide: () => _log('hide'),
          onHidden: () => _log('hidden'),
          child: BsButton(onPressed: () {}, child: const Text('Hover over me')),
        ),
        const SizedBox(height: 16),
        if (_events.isEmpty)
          Text('No events yet — hover the button above.', style: TextStyle(color: BsBody.secondaryColorOf(context)))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final event in _events) BsBadge(variant: BsVariant.secondary, child: Text(event))],
          ),
      ],
    );
  }
}
