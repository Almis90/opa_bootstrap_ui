import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';
import '../../src/inline_line.dart';

/// The "Buttons" example: a port of Bootstrap's own `examples/buttons` page —
/// pill buttons in every color, a pair of full-width buttons in a `d-grid`,
/// buttons with a trailing icon, disabled buttons with a spinner and circular
/// icon buttons.
class ButtonsExamplePage extends StatelessWidget {
  const ButtonsExamplePage({super.key});

  /// `<div class="d-flex gap-2 justify-content-center …">`.
  static Widget _row(List<Widget> buttons, {BsSpacing? pt, BsSpacing? pb}) {
    return BsBox(
      pt: pt ?? BsSpacing.s5,
      pb: pb ?? BsSpacing.s5,
      child: BsFlex(
        gap: BsSpacing.s2,
        justifyContent: BsJustify.center,
        // (`.btn { white-space: nowrap }`: they keep their width)
        children: [
          for (final button in buttons)
            BsFlexItem(flexShrink: false, child: button),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _pills(),
        const ExampleDivider(),
        _grid(),
        const ExampleDivider(),
        _icons(),
        const ExampleDivider(),
        _loading(),
        const ExampleDivider(),
        // pt-5 pb-4, then pb-5
        _row(_circles(16, 17), pb: BsSpacing.s4),
        _row(_circles(24, 25), pt: BsSpacing.s0),
        const ExampleDivider(),
      ],
    );
  }

  static const _variants = [
    (BsVariant.primary, 'Primary'),
    (BsVariant.secondary, 'Secondary'),
    (BsVariant.success, 'Success'),
    (BsVariant.danger, 'Danger'),
    (BsVariant.warning, 'Warning'),
    (BsVariant.info, 'Info'),
    (BsVariant.light, 'Light'),
    (BsVariant.dark, 'Dark'),
  ];

  /// `btn btn-* rounded-pill px-3`, then `btn-link`.
  static Widget _pills() {
    return _row([
      for (final (variant, label) in _variants)
        BsButton(
          variant: variant,
          rounded: BsRounded.pill,
          px: BsSpacing.s3,
          onPressed: () {},
          child: Text(label),
        ),
      BsButton(
        link: true,
        rounded: BsRounded.pill,
        px: BsSpacing.s3,
        onPressed: () {},
        child: const Text('Link'),
      ),
    ]);
  }

  /// `<div class="col-lg-6 col-xxl-4 my-5 mx-auto"><div class="d-grid gap-2">`.
  static Widget _grid() {
    return BsBox(
      col: const BsResponsiveValue(lg: BsCol(6), xxl: BsCol(4)),
      my: BsSpacing.s5,
      mx: BsSpacing.auto,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsButton(
            variant: BsVariant.secondary,
            outline: true,
            onPressed: () {},
            child: const Text('Secondary action'),
          ),
          const SizedBox(height: 8),
          BsButton(onPressed: () {}, child: const Text('Primary action')),
        ],
      ),
    );
  }

  /// `btn d-inline-flex align-items-center`: the label and a 20px arrow (`ms-1`).
  static Widget _icons() {
    Widget content(String label) => BsFlex(
      inline: true,
      alignItems: BsAlign.center,
      children: [
        Text(label),
        const BsFlexItem(
          ms: BsSpacing.s1,
          child: BootstrapIcon(
            BootstrapIconData.arrowRightShort,
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
    return _row([
      BsButton(onPressed: () {}, child: content('Primary icon')),
      BsButton(
        variant: BsVariant.secondary,
        outline: true,
        onPressed: () {},
        child: content('Secondary icon'),
      ),
    ]);
  }

  /// Disabled buttons holding a `.spinner-border-sm`, alone and before the
  /// label.
  static Widget _loading() {
    // `<span class="spinner-border spinner-border-sm">`: inline, on the baseline
    const spinner = InlineBox(
      size: 16,
      child: BsSpinnerBorder(size: BsSpinnerSize.small, semanticsLabel: null),
    );
    return _row([
      const BsButton(onPressed: null, child: spinner),
      const BsButton(
        onPressed: null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            spinner,
            SizedBox(width: InlineIconLabel.inlineSpace),
            Text('Loading...'),
          ],
        ),
      ),
    ]);
  }

  /// `btn rounded-circle p-N lh-1`: an N-px close icon (the line is one pixel
  /// taller than the icon, which hangs 2px below the baseline).
  static List<Widget> _circles(double size, double line) {
    final padding = size == 16 ? BsSpacing.s2 : BsSpacing.s3;
    final icon = SizedBox(
      width: size,
      height: line,
      child: Align(
        alignment: Alignment.topLeft,
        child: BootstrapIcon(BootstrapIconData.xLg, width: size, height: size),
      ),
    );
    return [
      BsButton(
        rounded: BsRounded.circle,
        px: padding,
        py: padding,
        onPressed: () {},
        child: icon,
      ),
      BsButton(
        outline: true,
        rounded: BsRounded.circle,
        px: padding,
        py: padding,
        onPressed: () {},
        child: icon,
      ),
    ];
  }
}
