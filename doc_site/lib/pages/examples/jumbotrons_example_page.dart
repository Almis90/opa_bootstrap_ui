import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_code.dart';
import '../../src/example_divider.dart';
import '../../src/inline_line.dart';

/// The "Jumbotrons" example: a port of Bootstrap's own `examples/jumbotrons`
/// page, with each element's class list as the widget's props (see
/// [HeadersExamplePage] for the convention).
///
/// An `<svg>` or `<button>` among text is inline content, placed by the
/// surrounding `text-center`: `BsBox(inlineBlock: true)`.
class JumbotronsExamplePage extends StatelessWidget {
  const JumbotronsExamplePage({super.key});

  static const _col8FromLg = BsResponsiveValue(lg: BsCol(8));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _withIcon(context),
        const ExampleDivider(),
        _placeholder(context),
        const ExampleDivider(),
        _fullWidth(context),
        const ExampleDivider(),
        _basic(context),
        const ExampleDivider(),
      ],
    );
  }

  // <div class="container my-5"><div class="p-5 text-center bg-body-tertiary rounded-3">
  static Widget _withIcon(BuildContext context) {
    return BsContainer(
      my: BsSpacing.s5,
      child: BsBox(
        p: BsSpacing.s5,
        textAlign: BsTextAlign.center,
        bg: BsBg.bodyTertiary,
        rounded: BsRounded.r3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <svg class="bi mt-4 mb-3" style="color: var(--bs-indigo);" width="100" height="100">
            const BsBox(
              inlineBlock: true,
              mt: BsSpacing.s4,
              mb: BsSpacing.s3,
              child: InlineLine(
                lowered: 2, // .bi: vertical-align -.125em
                child: BootstrapIcon(
                  BootstrapIconData.bootstrap,
                  width: 100,
                  height: 100,
                  color: BsColors.indigo,
                ),
              ),
            ),
            const BsBox(
              textColor: BsTextColor.bodyEmphasis,
              child: BsHeading(
                BsHeadingLevel.h1,
                child: Text('Jumbotron with icon'),
              ),
            ),
            // <p class="col-lg-8 mx-auto fs-5 text-body-secondary">
            BsBox(
              col: _col8FromLg,
              mx: BsSpacing.auto,
              fs: BsFs.fs5,
              mb: BsSpacing.s3,
              textColor: BsTextColor.bodySecondary,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          'This is a custom jumbotron featuring an SVG image at '
                          'the top, some longer text that wraps early thanks to '
                          'a responsive ',
                    ),
                    codeSpan(context, '.col-*', parentFontSize: 20),
                    const TextSpan(
                      text: ' class, and a customized call to action.',
                    ),
                  ],
                ),
              ),
            ),
            // <div class="d-inline-flex gap-2 mb-5">
            BsBox(
              inlineBlock: true,
              mb: BsSpacing.s5,
              child: BsFlex(
                inline: true,
                gap: BsSpacing.s2,
                children: [
                  // <button class="d-inline-flex align-items-center btn btn-primary btn-lg px-4 rounded-pill">
                  BsButton(
                    size: BsSize.lg,
                    px: BsSpacing.s4,
                    rounded: BsRounded.pill,
                    onPressed: () {},
                    child: const BsFlex(
                      inline: true,
                      alignItems: BsAlign.center,
                      children: [
                        Text('Call to action'),
                        // <svg class="bi ms-2" width="24" height="24">
                        BsFlexItem(
                          ms: BsSpacing.s2,
                          child: BootstrapIcon(
                            BootstrapIconData.arrowRightShort,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // <button class="btn btn-outline-secondary btn-lg px-4 rounded-pill">
                  BsButton(
                    variant: BsVariant.secondary,
                    outline: true,
                    size: BsSize.lg,
                    px: BsSpacing.s4,
                    rounded: BsRounded.pill,
                    onPressed: () {},
                    child: const Text('Secondary link'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // <div class="container my-5"><div class="position-relative p-5 text-center text-body-secondary bg-body border border-dashed rounded-5">
  static Widget _placeholder(BuildContext context) {
    return BsContainer(
      my: BsSpacing.s5,
      child: BsBox(
        textAlign: BsTextAlign.center,
        textColor: BsTextColor.bodySecondary,
        bg: BsBg.body,
        border: true,
        borderStyle: BsBorderStyle.dashed,
        rounded: BsRounded.r5,
        // position-relative: the close button is placed against this box.
        child: Stack(
          children: [
            BsBox(
              p: BsSpacing.s5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // <svg class="bi mt-5 mb-3" width="48" height="48">
                  const BsBox(
                    inlineBlock: true,
                    mt: BsSpacing.s5,
                    mb: BsSpacing.s3,
                    child: InlineLine(
                      lowered: 2,
                      child: BootstrapIcon(
                        BootstrapIconData.check2Circle,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                  const BsBox(
                    textColor: BsTextColor.bodyEmphasis,
                    child: BsHeading(
                      BsHeadingLevel.h1,
                      child: Text('Placeholder jumbotron'),
                    ),
                  ),
                  // <p class="col-lg-6 mx-auto mb-4">
                  const BsBox(
                    col: BsResponsiveValue(lg: BsCol(6)),
                    mx: BsSpacing.auto,
                    mb: BsSpacing.s4,
                    child: Text(
                      "This faded back jumbotron is useful for placeholder "
                      "content. It's also a great way to add a bit of context "
                      "to a page or section when no content is available and "
                      "to encourage visitors to take a specific action.",
                    ),
                  ),
                  // <button class="btn btn-primary px-5 mb-5">
                  BsBox(
                    inlineBlock: true,
                    mb: BsSpacing.s5,
                    child: BsButton(
                      px: BsSpacing.s5,
                      onPressed: () {},
                      child: const Text('Call to action'),
                    ),
                  ),
                ],
              ),
            ),
            // <button class="position-absolute top-0 end-0 p-3 m-3 btn-close bg-secondary bg-opacity-10 rounded-pill">
            PositionedDirectional(
              top: 0,
              end: 0,
              child: BsBox(
                m: BsSpacing.s3,
                child: BsCloseButton(
                  onPressed: () {},
                  style: BsCloseButtonStyle(
                    padding: EdgeInsets.all(BsSpacing.s3.size),
                    background: BsVariant.secondary.color.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(BsRounded.pill.radius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // <div class="my-5"><div class="p-5 text-center bg-body-tertiary"><div class="container py-5">
  static Widget _fullWidth(BuildContext context) {
    return BsBox(
      my: BsSpacing.s5,
      child: BsBox(
        p: BsSpacing.s5,
        textAlign: BsTextAlign.center,
        bg: BsBg.bodyTertiary,
        child: BsContainer(
          py: BsSpacing.s5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BsBox(
                textColor: BsTextColor.bodyEmphasis,
                child: BsHeading(
                  BsHeadingLevel.h1,
                  child: Text('Full-width jumbotron'),
                ),
              ),
              // <p class="col-lg-8 mx-auto lead">
              BsBox(
                col: _col8FromLg,
                mx: BsSpacing.auto,
                mb: BsSpacing.s3,
                child: BsLead(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              'This takes the basic jumbotron above and makes '
                              'its background edge-to-edge with a ',
                        ),
                        codeSpan(context, '.container', parentFontSize: 20),
                        const TextSpan(
                          text:
                              ' inside to align content. Similar to above, '
                              "it's been recreated with built-in grid and "
                              'utility classes.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // <div class="container my-5"><div class="p-5 text-center bg-body-tertiary rounded-3">
  static Widget _basic(BuildContext context) {
    return BsContainer(
      my: BsSpacing.s5,
      child: BsBox(
        p: BsSpacing.s5,
        textAlign: BsTextAlign.center,
        bg: BsBg.bodyTertiary,
        rounded: BsRounded.r3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BsBox(
              textColor: BsTextColor.bodyEmphasis,
              child: BsHeading(
                BsHeadingLevel.h1,
                child: Text('Basic jumbotron'),
              ),
            ),
            BsBox(
              mb: BsSpacing.s3,
              child: BsLead(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'This is a simple Bootstrap jumbotron that sits '
                            'within a ',
                      ),
                      codeSpan(context, '.container', parentFontSize: 20),
                      const TextSpan(
                        text: ', recreated with built-in utility classes.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
