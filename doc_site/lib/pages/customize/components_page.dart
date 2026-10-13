import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

/// "Components": the base-and-modifier approach, and building your own.
class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Components',
      lead:
          'Learn how and why nearly all the components are built with a base '
          'and with modifiers, and how to build your own the same way.',
      children: [
        const DocHeading('Base classes'),
        DocText([
          'Bootstrap\'s components are largely built with a base-modifier '
              'nomenclature. As many shared properties as possible are '
              'grouped into a base class, like ',
          DocCode('.btn'),
          ', and the individual styles for each variant into modifier '
              'classes, like ',
          DocCode('.btn-primary'),
          ' or ',
          DocCode('.btn-success'),
          '.',
        ]),
        DocText([
          'The same split exists here, in the units of Dart. The base is the ',
          DocBold('widget'),
          ', such as ',
          DocCode('BsButton'),
          ', together with the defaults of its ',
          DocBold('style class'),
          ': the values that every button shares. The modifiers are its ',
          DocBold('parameters'),
          ', whose values come from enums, such as ',
          DocCode('BsVariant'),
          ' and ',
          DocCode('BsSize'),
          '.',
        ]),
        const DocHeading('Modifiers'),
        DocText([
          'Where a class is added to the base, a value is passed to the '
              'widget:',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            ['.btn .btn-primary', 'BsButton(variant: BsVariant.primary, …)'],
            [
              '.btn-outline-danger',
              'BsButton(variant: BsVariant.danger, outline: true, …)',
            ],
            ['.btn-lg, .btn-sm', 'BsButton(size: BsSize.lg, …) and BsSize.sm'],
            ['.btn-link', 'BsButton(link: true, …)'],
            ['.btn .active', 'BsButton(active: true, …)'],
            ['.alert .alert-warning', 'BsAlert(variant: BsVariant.warning, …)'],
            [
              '.badge .rounded-pill .text-bg-info',
              'BsBadge(variant: BsVariant.info, pill: true, …)',
            ],
            [
              '.badge .bg-info-subtle .text-info-emphasis',
              'BsBadge(variant: BsVariant.info, subtle: true, …)',
            ],
          ],
        ),
        DocText([
          'Bootstrap loops over its ',
          DocCode(r'$theme-colors'),
          ' map with ',
          DocCode('@each'),
          ' to generate a modifier for every color. You do not need the '
              'loop: the enum already has the eight values, and ',
          DocCode('values'),
          ' is the list to iterate for a table of every variant, or for a '
              'test of your own that covers all of them.',
        ]),
        DocExample(
          code: '''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final variant in BsVariant.values)
      BsButton(
        variant: variant,
        onPressed: () {},
        child: Text(variant.name),
      ),
  ],
)''',
          preview: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final variant in BsVariant.values)
                BsButton(
                  variant: variant,
                  onPressed: () {},
                  child: Text(variant.name),
                ),
            ],
          ),
        ),
        DocText([
          'The modifiers are folded into a style, which the style object '
              'you pass is merged over. A button resolves ',
          DocCode('BsButtonStyle.forVariant(variant, outline: …, size: …)'),
          ', which is a public factory, and then your ',
          DocCode('style'),
          '; the fields that you leave null stay the ones of the variant. '
              'So a modifier and an override combine the way two classes '
              'do, with the override winning.',
        ]),
        DocExample(
          code: '''
BsButton(
  variant: BsVariant.success,
  size: BsSize.lg,
  onPressed: () {},
  style: const BsButtonStyle(
    borderRadius: BorderRadius.all(Radius.circular(24)),
  ),
  child: const Text('A large, green pill'),
)''',
          preview: BsButton(
            variant: BsVariant.success,
            size: BsSize.lg,
            onPressed: () {},
            style: const BsButtonStyle(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: const Text('A large, green pill'),
          ),
        ),
        const DocHeading('Responsive'),
        DocText([
          'Sass loops are not limited to color maps: Bootstrap also loops '
              'over ',
          DocCode(r'$grid-breakpoints'),
          ' to generate a responsive variant of a component, such as the '
              'alignment of a dropdown. Here the breakpoints are the ',
          DocCode('BsBreakpoint'),
          ' enum, and a value that changes with them is a ',
          DocCode('BsResponsiveValue'),
          '. It cascades mobile-first, like ',
          DocCode('min-width'),
          ' media queries: a value applies from its breakpoint up, until a '
              'larger one sets another. The breakpoint is that of the width '
              'of the window.',
        ]),
        const DocExample(
          code: '''
BsBox(
  p: BsResponsiveValue(xs: BsSpacing.s2, md: BsSpacing.s5),
  border: true,
  child: Text('Padding of 8 below md, of 48 from md up'),
)

// In a widget of your own:
final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);''',
          preview: _Responsive(),
        ),
        DocText([
          'The ones that take one are typed ',
          DocCode('BsResponsive'),
          ': on ',
          DocCode('BsBox'),
          ' the margins and paddings, the font size, the text alignment and '
              'the width and height. A plain value, such as ',
          DocCode('BsSpacing.s3'),
          ', is the same at every breakpoint. See ',
          DocLink.page('Breakpoints', 'Layout', 'Breakpoints'),
          '.',
        ]),
        const DocHeading('Creating your own'),
        DocText([
          'Adopt the same guidelines to build your own components. Bootstrap '
              'builds its callouts, in the documentation, like its own '
              'components: a ',
          DocCode('.callout'),
          ' base with ',
          DocCode('.callout-info'),
          ', ',
          DocCode('.callout-warning'),
          ' and ',
          DocCode('.callout-danger'),
          ' modifiers, which differ by a single ',
          DocCode('border-left-color'),
          '. Here is the family in Dart:',
        ]),
        DocList(ordered: true, [
          DocListItem([
            'a ',
            DocBold('style class'),
            ' for the values that the base shares, with every field '
                'nullable, a ',
            DocCode('merge'),
            ' and static defaults, as the ones of the library;',
          ]),
          DocListItem([
            'a ',
            DocBold('widget'),
            ' for the base, with a ',
            DocCode('BsVariant'),
            ' for the modifier, and a ',
            DocCode('style'),
            ' that is merged over the defaults;',
          ]),
          DocListItem([
            'colors from the ',
            DocLink.page('tokens', 'Customize', 'Tokens'),
            ', and the ambient brightness, so that it follows the color '
                'mode and RTL for free.',
          ]),
        ]),
        const DocExample(
          code: '''
class CalloutStyle {
  const CalloutStyle({this.padding, this.borderWidth});

  final EdgeInsetsGeometry? padding;
  final double? borderWidth;

  static const defaults = CalloutStyle(
    padding: EdgeInsets.all(16),
    borderWidth: 4,
  );

  CalloutStyle merge(CalloutStyle? other) => other == null
      ? this
      : CalloutStyle(
          padding: other.padding ?? padding,
          borderWidth: other.borderWidth ?? borderWidth,
        );
}

class Callout extends StatelessWidget {
  const Callout({
    super.key,
    required this.child,
    this.variant = BsVariant.info,
    this.style,
  });

  final Widget child;
  final BsVariant variant;
  final CalloutStyle? style;

  @override
  Widget build(BuildContext context) {
    final resolved = CalloutStyle.defaults.merge(style);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BsBody.tertiaryBackgroundOf(context),
        border: BorderDirectional(
          start: BorderSide(color: variant.color, width: resolved.borderWidth!),
        ),
      ),
      child: Padding(padding: resolved.padding!, child: child),
    );
  }
}

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const Callout(child: Text('This is an info callout.')),
    const SizedBox(height: 12),
    const Callout(
      variant: BsVariant.warning,
      child: Text('This is a warning callout.'),
    ),
    const SizedBox(height: 12),
    const Callout(
      variant: BsVariant.danger,
      style: CalloutStyle(borderWidth: 8),
      child: Text('This is a danger callout, with a wider border.'),
    ),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Callout(child: Text('This is an info callout.')),
              SizedBox(height: 12),
              _Callout(
                variant: BsVariant.warning,
                child: Text('This is a warning callout.'),
              ),
              SizedBox(height: 12),
              _Callout(
                variant: BsVariant.danger,
                style: _CalloutStyle(borderWidth: 8),
                child: Text('This is a danger callout, with a wider border.'),
              ),
            ],
          ),
        ),
        DocText([
          'The border is a ',
          DocCode('BorderDirectional'),
          ', so the callout is on the right in a right-to-left app, and its '
              'background follows the mode through ',
          DocCode('BsBody.tertiaryBackgroundOf'),
          '. Nothing in it had to be written twice.',
        ]),
        DocText([
          'When the base is no more than a few widgets of the library, you '
              'do not need a class of your own. A function that returns a ',
          DocCode('BsButtonStyle'),
          ' or a widget that wraps a ',
          DocCode('BsAlert'),
          ' with a ',
          DocCode('style'),
          ' is the lightest way to give them a name. See ',
          DocLink.page('Style classes', 'Customize', 'Style classes'),
          '.',
        ]),
      ],
    );
  }
}

class _Responsive extends StatelessWidget {
  const _Responsive();

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    return BsBox(
      p: const BsResponsiveValue(xs: BsSpacing.s2, md: BsSpacing.s5),
      border: true,
      child: Text(
        'Padding of ${breakpoint.index >= BsBreakpoint.md.index ? 48 : 8}: '
        'the window is at ${breakpoint.name}.',
      ),
    );
  }
}

class _CalloutStyle {
  const _CalloutStyle({this.padding, this.borderWidth});

  final EdgeInsetsGeometry? padding;
  final double? borderWidth;

  static const defaults = _CalloutStyle(
    padding: EdgeInsets.all(16),
    borderWidth: 4,
  );

  _CalloutStyle merge(_CalloutStyle? other) => other == null
      ? this
      : _CalloutStyle(
          padding: other.padding ?? padding,
          borderWidth: other.borderWidth ?? borderWidth,
        );
}

class _Callout extends StatelessWidget {
  const _Callout({
    required this.child,
    this.variant = BsVariant.info,
    this.style,
  });

  final Widget child;
  final BsVariant variant;
  final _CalloutStyle? style;

  @override
  Widget build(BuildContext context) {
    final resolved = _CalloutStyle.defaults.merge(style);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BsBody.tertiaryBackgroundOf(context),
        border: BorderDirectional(
          start: BorderSide(color: variant.color, width: resolved.borderWidth!),
        ),
      ),
      child: Padding(padding: resolved.padding!, child: child),
    );
  }
}
