import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_icon_link.dart';

/// The "Starter template" example: a port of Bootstrap's own
/// `examples/starter-template` page — a `col-lg-8 mx-auto p-4 py-md-5`
/// container with a bordered header, an intro and two `row g-5` columns of
/// icon links, and a `border-top` footer.
class StarterTemplateExamplePage extends StatelessWidget {
  const StarterTemplateExamplePage({super.key});

  static const _starters = [
    'Bootstrap npm starter',
    'Bootstrap Parcel starter',
    'Bootstrap Vite starter',
    'Bootstrap Webpack starter',
  ];

  static const _guides = [
    'Bootstrap quick start guide',
    'Bootstrap Webpack guide',
    'Bootstrap Parcel guide',
    'Bootstrap Vite guide',
    'Contributing to Bootstrap',
  ];

  @override
  Widget build(BuildContext context) {
    return BsBox(
      col: const BsResponsiveValue(lg: BsCol(8)),
      mx: BsSpacing.auto,
      p: BsSpacing.s4,
      py: const BsResponsiveValue(xs: BsSpacing.s4, md: BsSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_header(context), _main(context), _footer(context)],
      ),
    );
  }

  /// `<header class="d-flex align-items-center pb-3 mb-5 border-bottom">`.
  Widget _header(BuildContext context) {
    return BsBox(
      pb: BsSpacing.s3,
      mb: BsSpacing.s5,
      borderBottom: true,
      child: BsFlex(
        alignItems: BsAlign.center,
        children: [
          BsBox(
            textColor: BsTextColor.bodyEmphasis,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BootstrapIcon(
                  BootstrapIconData.bootstrap,
                  width: 40,
                  height: 32,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: BsBox(
                    fs: BsFs.fs4,
                    child: const Text('Starter template'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _main(BuildContext context) {
    final emphasis = BsTextColor.bodyEmphasis.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultTextStyle.merge(
          style: TextStyle(color: emphasis),
          child: const BsHeading(
            BsHeadingLevel.h1,
            child: Text('Get started with Bootstrap'),
          ),
        ),
        // <p class="fs-5 col-md-8">
        BsBox(
          fs: BsFs.fs5,
          col: const BsResponsiveValue(md: BsCol(8)),
          mb: BsSpacing.s3,
          child: const Text(
            "Quickly and easily get started with Bootstrap's compiled, "
            'production-ready files with this barebones example featuring some '
            'basic HTML and helpful links. Download all our examples to get '
            'started.',
          ),
        ),
        // <div class="mb-5"><a class="btn btn-primary btn-lg px-4">
        BsBox(
          mb: BsSpacing.s5,
          child: Align(
            alignment: Alignment.topLeft,
            child: BsButton(
              size: BsSize.lg,
              px: BsSpacing.s4,
              onPressed: () {},
              child: const Text('Download examples'),
            ),
          ),
        ),
        // <hr class="col-3 col-md-2 mb-5"> (its `1rem` top margin is swallowed
        // by the `mb-5` above, and the row's negative top margin cancels its
        // bottom one)
        BsBox(
          col: const BsResponsiveValue(xs: BsCol(3), md: BsCol(2)),
          child: const BsHr(my: BsSpacing.s0),
        ),
        // (`row g-5`: each column has the gutter's `3rem` as a top margin, which
        // the row's own negative margin only takes back around the row)
        Padding(
          padding: const EdgeInsets.only(top: 48),
          child: BsRow(
            g: BsSpacing.s5,
            children: [
              BsFlexItem(
                col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(6)),
                child: _links(
                  context,
                  'Starter projects',
                  'Ready to go beyond the starter template? Check out these open '
                      'source projects that you can quickly duplicate to a new '
                      'GitHub repository.',
                  _starters,
                ),
              ),
              BsFlexItem(
                col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(6)),
                child: _links(
                  context,
                  'Guides',
                  'Read more detailed instructions and documentation on using or '
                      'contributing to Bootstrap.',
                  _guides,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _links(
    BuildContext context,
    String title,
    String text,
    List<String> links,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultTextStyle.merge(
          style: TextStyle(color: BsTextColor.bodyEmphasis.of(context)),
          child: BsHeading(BsHeadingLevel.h2, child: Text(title)),
        ),
        Padding(padding: const EdgeInsets.only(bottom: 16), child: Text(text)),
        // <ul class="list-unstyled ps-0"> (mb-3) <li><a class="icon-link mb-1">
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: ExampleIconLink(
                text: link,
                icon: BootstrapIconData.arrowRightCircle,
                iconFirst: true,
                onTap: () {},
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// `<footer class="pt-5 my-5 text-body-secondary border-top">`.
  Widget _footer(BuildContext context) {
    return BsBox(
      pt: BsSpacing.s5,
      my: BsSpacing.s5,
      borderTop: true,
      textColor: BsTextColor.bodySecondary,
      child: Text('Created by the Bootstrap team · © ${DateTime.now().year}'),
    );
  }
}
