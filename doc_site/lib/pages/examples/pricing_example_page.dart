import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/bootstrap_logo.dart';
import '../../src/example_top_link.dart';
import '../../src/inline_line.dart';

/// The "Pricing" example: a port of Bootstrap's own `examples/pricing` page,
/// with each element's class list as the widget's props (see
/// [HeadersExamplePage] for the convention). The page's own CSS (`.container {
/// max-width: 960px }`, `.pricing-header { max-width: 700px }`, a gradient
/// body) is [_Page].
class PricingExamplePage extends StatelessWidget {
  const PricingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Stack(
        children: [
          // body { background-image: linear-gradient(180deg, var(--bs-secondary-bg),
          //        var(--bs-body-bg) 100px, var(--bs-body-bg)) }
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BsBody.secondaryBackgroundOf(context),
                    BsBody.backgroundOf(context),
                  ],
                ),
              ),
            ),
          ),
          // .container { max-width: 960px }, `py-3`
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: BsContainer.fluid(
                py: BsSpacing.s3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(context),
                    _main(context),
                    _footer(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _rowColsOneThenThree = BsResponsiveValue<int>(xs: 1, md: 3);

  // --- <header> ---

  static Widget _header(BuildContext context) {
    // <a class="me-3 py-2 link-body-emphasis text-decoration-none">
    Widget navLink(String text, {bool last = false}) => BsBox(
      py: BsSpacing.s2,
      me: last ? null : BsSpacing.s3,
      child: BsAnchor(
        textDecorationNone: true,
        linkColor: BsTextColor.bodyEmphasis,
        child: Text(text),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <div class="d-flex flex-column flex-md-row align-items-center pb-3 mb-4 border-bottom">
        BsBox(
          pb: BsSpacing.s3,
          mb: BsSpacing.s4,
          borderBottom: true,
          child: BsFlex(
            direction: const BsResponsiveValue(
              xs: BsFlexDirection.column,
              md: BsFlexDirection.row,
            ),
            alignItems: BsAlign.center,
            children: [
              // <a class="d-flex align-items-center link-body-emphasis text-decoration-none">
              const BsAnchor(
                textDecorationNone: true,
                linkColor: BsTextColor.bodyEmphasis,
                child: BsFlex(
                  alignItems: BsAlign.center,
                  children: [
                    BsFlexItem(
                      me: BsSpacing.s2,
                      child: BootstrapIcon(
                        BootstrapIconData.bootstrap,
                        width: 40,
                        height: 32,
                      ),
                    ),
                    BsBox(fs: BsFs.fs4, child: Text('Pricing example')),
                  ],
                ),
              ),
              // <nav class="d-inline-flex mt-2 mt-md-0 ms-md-auto">
              BsFlexItem(
                mt: const BsResponsiveValue(xs: BsSpacing.s2, md: BsSpacing.s0),
                ms: const BsResponsiveValue(md: BsSpacing.auto),
                child: BsFlex(
                  inline: true,
                  children: [
                    navLink('Features'),
                    navLink('Enterprise'),
                    navLink('Support'),
                    navLink('Pricing', last: true),
                  ],
                ),
              ),
            ],
          ),
        ),
        // <div class="pricing-header p-3 pb-md-4 mx-auto text-center"> (max-width 700px)
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: BsBox(
              p: BsSpacing.s3,
              pb: const BsResponsiveValue(md: BsSpacing.s4),
              textAlign: BsTextAlign.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BsBox(
                    mb: BsSpacing.s2,
                    textColor: BsTextColor.bodyEmphasis,
                    child: BsDisplayHeading(
                      BsDisplayLevel.d4,
                      fw: BsFw.normal,
                      child: Text('Pricing'),
                    ),
                  ),
                  const BsBox(
                    fs: BsFs.fs5,
                    mb: BsSpacing.s3,
                    textColor: BsTextColor.bodySecondary,
                    child: Text(
                      'Quickly build an effective pricing table for your potential '
                      'customers with this Bootstrap example. It’s built with '
                      'default Bootstrap components and utilities with little '
                      'customization.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- <main> ---

  static Widget _main(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // <div class="row row-cols-1 row-cols-md-3 mb-3 text-center">
        BsBox(
          mb: BsSpacing.s3,
          textAlign: BsTextAlign.center,
          child: BsRow(
            rowCols: _rowColsOneThenThree,
            children: [
              _plan(
                context,
                'Free',
                r'$0',
                const [
                  '10 users included',
                  '2 GB of storage',
                  'Email support',
                  'Help center access',
                ],
                'Sign up for free',
                outline: true,
              ),
              _plan(context, 'Pro', r'$15', const [
                '20 users included',
                '10 GB of storage',
                'Priority email support',
                'Help center access',
              ], 'Get started'),
              _plan(
                context,
                'Enterprise',
                r'$29',
                const [
                  '30 users included',
                  '15 GB of storage',
                  'Phone and email support',
                  'Help center access',
                ],
                'Contact us',
                featured: true,
              ),
            ],
          ),
        ),
        // <h2 class="display-6 text-center mb-4">
        const BsBox(
          mb: BsSpacing.s4,
          textAlign: BsTextAlign.center,
          child: BsDisplayHeading(
            BsDisplayLevel.d6,
            child: Text('Compare plans'),
          ),
        ),
        // `.table { margin-bottom: 1rem }`
        BsBox(mb: BsSpacing.s3, child: _compare(context)),
      ],
    );
  }

  // <div class="card mb-4 rounded-3 shadow-sm [border-primary]">
  static Widget _plan(
    BuildContext context,
    String name,
    String price,
    List<String> features,
    String action, {
    bool outline = false,
    bool featured = false,
  }) {
    return BsBox(
      mb: BsSpacing.s4,
      child: BsCard(
        rounded: BsRounded.r3,
        shadow: BsShadow.sm,
        borderVariant: featured ? BsVariant.primary : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <div class="card-header py-3 [text-bg-primary border-primary]">
            BsCardHeader(
              py: BsSpacing.s3,
              textBg: featured ? BsVariant.primary : null,
              // <h4 class="my-0 fw-normal">
              child: BsHeading(
                BsHeadingLevel.h4,
                fw: BsFw.normal,
                mb: BsSpacing.s0,
                child: Text(name),
              ),
            ),
            // <div class="card-body">
            BsBox(
              p: BsSpacing.s3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // <h1 class="card-title pricing-card-title">$0<small class="text-body-secondary fw-light">/mo</small>
                  // (its `.5rem` margin collapses into the list's `mt-3`)
                  BsHeading(
                    BsHeadingLevel.h1,
                    mb: BsSpacing.s0,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: price),
                          TextSpan(
                            text: '/mo',
                            style: TextStyle(
                              fontSize:
                                  BsFs.fs1.sizeFor(
                                    MediaQuery.sizeOf(context).width,
                                  ) *
                                  0.875,
                              fontWeight: FontWeight.w300,
                              color: BsTextColor.bodySecondary.of(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // <ul class="list-unstyled mt-3 mb-4">
                  BsBox(
                    mt: BsSpacing.s3,
                    mb: BsSpacing.s4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [for (final f in features) Text(f)],
                    ),
                  ),
                  // <button class="w-100 btn btn-lg btn-outline-primary">
                  BsButton(
                    size: BsSize.lg,
                    outline: outline,
                    onPressed: () {},
                    child: Text(action),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // <div class="table-responsive"><table class="table text-center">
  static Widget _compare(BuildContext context) {
    // <svg class="bi" width="24" height="24">: `.bi` hangs 2px below the baseline
    Widget check() => const Center(
      child: InlineLine(
        lowered: 2,
        child: BootstrapIcon(BootstrapIconData.check2, width: 24, height: 24),
      ),
    );
    BsTableRow row(
      String label,
      List<bool> included, {
      bool groupStart = false,
    }) {
      return BsTableRow(
        groupStart: groupStart,
        cells: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: BsBox(fw: BsFw.bold, child: Text(label)),
          ),
          for (final i in included) i ? check() : const SizedBox.shrink(),
        ],
      );
    }

    return BsBox(
      textAlign: BsTextAlign.center,
      child: BsTable(
        columnWidths: const {
          0: FractionColumnWidth(0.34),
          1: FractionColumnWidth(0.22),
          2: FractionColumnWidth(0.22),
          3: FractionColumnWidth(0.22),
        },
        columns: const [
          SizedBox.shrink(),
          Text('Free'),
          Text('Pro'),
          Text('Enterprise'),
        ],
        rows: [
          row('Public', [true, true, true]),
          row('Private', [false, true, true]),
          row('Permissions', [true, true, true]),
          row('Sharing', [false, true, true]),
          row('Unlimited members', [false, true, true]),
          row('Extra security', [false, false, true]),
        ],
      ),
    );
  }

  // --- <footer class="pt-4 my-md-5 pt-md-5 border-top"> ---

  static Widget _footer(BuildContext context) {
    Widget links(String title, List<String> items) {
      return BsFlexItem(
        col: const BsResponsiveValue(xs: BsCol(6), md: BsCol.equal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsHeading(BsHeadingLevel.h5, child: Text(title)),
            // <ul class="list-unstyled"><li class="mb-1"><a class="link-secondary text-decoration-none">
            BsBox(
              mb: BsSpacing.s3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < items.length; i++)
                    BsBox(
                      // (the last `li`'s margin collapses into the `ul`'s)
                      mb: i == items.length - 1 ? null : BsSpacing.s1,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: BsAnchor(
                          // (`href="#"`: back to the top of the page)
                          onTap: () => scrollExampleToTop(context),
                          textDecorationNone: true,
                          linkColor: BsTextColor.secondary,
                          child: Text(items[i]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BsBox(
      pt: const BsResponsiveValue(xs: BsSpacing.s4, md: BsSpacing.s5),
      my: const BsResponsiveValue(md: BsSpacing.s5),
      borderTop: true,
      child: BsRow(
        children: [
          // <div class="col-12 col-md">
          BsFlexItem(
            col: const BsResponsiveValue(xs: BsCol(12), md: BsCol.equal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // <img class="mb-2" src="bootstrap-logo.svg" width="24" height="19">
                BsBox(
                  mb: BsSpacing.s2,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: BootstrapLogo(width: 24, height: 19),
                  ),
                ),
                BsBox(
                  mb: BsSpacing.s3,
                  textColor: BsTextColor.bodySecondary,
                  child: BsSmall(
                    block: true,
                    child: Text('© 2017–${DateTime.now().year}'),
                  ),
                ),
              ],
            ),
          ),
          links('Features', const [
            'Cool stuff',
            'Random feature',
            'Team feature',
            'Stuff for developers',
            'Another one',
            'Last time',
          ]),
          links('Resources', const [
            'Resource',
            'Resource name',
            'Another resource',
            'Final resource',
          ]),
          links('About', const ['Team', 'Locations', 'Privacy', 'Terms']),
        ],
      ),
    );
  }
}
