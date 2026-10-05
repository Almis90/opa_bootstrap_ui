import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_code.dart';

/// The "Jumbotron" example: a port of Bootstrap's own `examples/jumbotron`
/// page, with each element's class list as the widget's props (see
/// [HeadersExamplePage] for the convention).
class JumbotronExamplePage extends StatelessWidget {
  const JumbotronExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    // <div class="container py-4">
    return BsContainer(
      py: BsSpacing.s4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_header(), _custom(), _columns(context), _footer()],
      ),
    );
  }

  // <header class="pb-3 mb-4 border-bottom">
  static Widget _header() {
    return const BsBox(
      pb: BsSpacing.s3,
      mb: BsSpacing.s4,
      borderBottom: true,
      // <a class="d-flex align-items-center text-body-emphasis text-decoration-none">
      child: BsAnchor(
        textDecorationNone: true,
        linkColor: BsTextColor.bodyEmphasis,
        child: BsFlex(
          alignItems: BsAlign.center,
          children: [
            // <svg class="me-2" width="40" height="32" viewBox="0 0 118 94">
            BsFlexItem(
              me: BsSpacing.s2,
              child: BootstrapIcon(
                BootstrapIconData.bootstrap,
                width: 40,
                height: 32,
              ),
            ),
            BsBox(fs: BsFs.fs4, child: Text('Jumbotron example')),
          ],
        ),
      ),
    );
  }

  // <div class="p-5 mb-4 bg-body-tertiary rounded-3">
  static Widget _custom() {
    return BsBox(
      p: BsSpacing.s5,
      mb: BsSpacing.s4,
      bg: BsBg.bodyTertiary,
      rounded: BsRounded.r3,
      // <div class="container-fluid py-5">
      child: BsContainer.fluid(
        py: BsSpacing.s5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <h1 class="display-5 fw-bold"> (an h1's own margin: .5rem)
            const BsBox(
              mb: BsSpacing.s2,
              child: BsDisplayHeading(
                BsDisplayLevel.d5,
                fw: BsFw.bold,
                child: Text('Custom jumbotron'),
              ),
            ),
            // <p class="col-md-8 fs-4">
            const BsBox(
              col: BsResponsiveValue(md: BsCol(8)),
              fs: BsFs.fs4,
              mb: BsSpacing.s3,
              child: Text(
                'Using a series of utilities, you can create this jumbotron, '
                'just like the one in previous versions of Bootstrap. Check '
                'out the examples below for how you can remix and restyle it '
                'to your liking.',
              ),
            ),
            // <button class="btn btn-primary btn-lg">
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: BsButton(
                size: BsSize.lg,
                onPressed: () {},
                child: const Text('Example button'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // <div class="row align-items-md-stretch">
  static Widget _columns(BuildContext context) {
    return BsRow(
      alignItems: const BsResponsiveValue(md: BsAlign.stretch),
      children: [
        // <div class="col-md-6"><div class="h-100 p-5 text-bg-dark rounded-3">
        BsFlexItem(
          col: const BsResponsiveValue(md: BsCol(6)),
          child: BsBox(
            h: BsHeight.h100,
            p: BsSpacing.s5,
            textBg: BsVariant.dark,
            rounded: BsRounded.r3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BsHeading(
                  BsHeadingLevel.h2,
                  child: Text('Change the background'),
                ),
                BsBox(
                  mb: BsSpacing.s3,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Swap the background-color utility and add a ',
                        ),
                        codeSpan(context, '.text-*'),
                        const TextSpan(
                          text:
                              ' color utility to mix up the jumbotron look. '
                              'Then, mix and match with additional component '
                              'themes and more.',
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: BsButton(
                    variant: BsVariant.light,
                    outline: true,
                    onPressed: () {},
                    child: const Text('Example button'),
                  ),
                ),
              ],
            ),
          ),
        ),
        // <div class="col-md-6"><div class="h-100 p-5 bg-body-tertiary border rounded-3">
        BsFlexItem(
          col: const BsResponsiveValue(md: BsCol(6)),
          child: BsBox(
            h: BsHeight.h100,
            p: BsSpacing.s5,
            bg: BsBg.bodyTertiary,
            border: true,
            rounded: BsRounded.r3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BsHeading(BsHeadingLevel.h2, child: Text('Add borders')),
                const BsBox(
                  mb: BsSpacing.s3,
                  child: Text(
                    'Or, keep it light and add a border for some added '
                    'definition to the boundaries of your content. Be sure to '
                    "look under the hood at the source HTML here as we've "
                    "adjusted the alignment and sizing of both column's "
                    'content for equal-height.',
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: BsButton(
                    variant: BsVariant.secondary,
                    outline: true,
                    onPressed: () {},
                    child: const Text('Example button'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // <footer class="pt-3 mt-4 text-body-secondary border-top">
  static Widget _footer() {
    return BsBox(
      pt: BsSpacing.s3,
      mt: BsSpacing.s4,
      textColor: BsTextColor.bodySecondary,
      borderTop: true,
      child: Text('© ${DateTime.now().year}'),
    );
  }
}
