import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';

/// The "Footers" example: a port of Bootstrap's own `examples/footers` page —
/// five footers in `.container`s: a logo between a copyright and a nav, a
/// copyright with social icons, a centred nav over a copyright, columns of
/// links, and links with a newsletter form.
class FootersExamplePage extends StatelessWidget {
  const FootersExamplePage({super.key});

  static const _links = ['Home', 'Features', 'Pricing', 'FAQs', 'About'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsContainer(child: _first(context)),
        const ExampleDivider(),
        BsContainer(child: _second(context)),
        const ExampleDivider(),
        BsContainer(child: _third(context)),
        const ExampleDivider(),
        BsContainer(child: _fourth(context)),
        const ExampleDivider(),
        BsContainer(child: _fifth(context)),
        const ExampleDivider(),
      ],
    );
  }

  static const _md4 = BsResponsiveValue<BsCol>(md: BsCol(4));

  /// `<ul class="nav …">` of `.nav-link.px-2.text-body-secondary`.
  static Widget _nav(
    BuildContext context,
    BsJustify justify, {
    bool inline = false,
  }) {
    final secondary = BsTextColor.bodySecondary.of(context);
    return BsFlex(
      wrap: true,
      inline: inline,
      justifyContent: inline ? null : justify,
      children: [
        for (final text in _links)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(text, style: TextStyle(color: secondary)),
          ),
      ],
    );
  }

  static String get _year => DateTime.now().year.toString();

  // --- 1. `d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top` ---

  Widget _first(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: BsBox(
        py: BsSpacing.s3,
        borderTop: true,
        child: BsFlex(
          wrap: true,
          justifyContent: BsJustify.between,
          alignItems: BsAlign.center,
          children: [
            BsFlexItem(
              col: _md4,
              child: Text(
                '© $_year Company, Inc',
                style: TextStyle(color: secondary),
              ),
            ),
            // <a class="col-md-4 d-flex align-items-center justify-content-center
            // mb-3 mb-md-0 me-md-auto link-body-emphasis">
            BsFlexItem(
              col: _md4,
              mb: const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
              me: const BsResponsiveValue(md: BsSpacing.auto),
              child: BsBox(
                textColor: BsTextColor.bodyEmphasis,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    BootstrapIcon(
                      BootstrapIconData.bootstrap,
                      width: 40,
                      height: 32,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            BsFlexItem(
              col: _md4,
              // (from `md` the `ul` is a third of the row; before, its links)
              child: _nav(
                context,
                BsJustify.end,
                inline: MediaQuery.sizeOf(context).width < 768,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. a copyright with icons ---

  Widget _second(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    final mb = const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: BsBox(
        py: BsSpacing.s3,
        borderTop: true,
        child: BsFlex(
          wrap: true,
          justifyContent: BsJustify.between,
          alignItems: BsAlign.center,
          children: [
            BsFlexItem(
              col: _md4,
              child: BsFlex(
                inline: MediaQuery.sizeOf(context).width < 768,
                alignItems: BsAlign.center,
                children: [
                  // <a class="mb-3 me-2 mb-md-0 text-body-secondary lh-1">
                  BsFlexItem(
                    mb: mb,
                    me: BsSpacing.s2,
                    // (the inline svg's line is 25px tall)
                    child: SizedBox(
                      width: 30,
                      height: 25,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: BootstrapIcon(
                          BootstrapIconData.bootstrap,
                          width: 30,
                          height: 24,
                          color: secondary,
                        ),
                      ),
                    ),
                  ),
                  BsFlexItem(
                    mb: mb,
                    child: Text(
                      '© $_year Company, Inc',
                      style: TextStyle(color: secondary),
                    ),
                  ),
                ],
              ),
            ),
            BsFlexItem(
              col: _md4,
              child: BsFlex(
                // (from `md` the `ul` is a third of the row; before, its icons)
                inline: MediaQuery.sizeOf(context).width < 768,
                justifyContent: MediaQuery.sizeOf(context).width < 768
                    ? null
                    : BsJustify.end,
                children: [
                  for (final icon in [
                    BootstrapIconData.instagram,
                    BootstrapIconData.facebook,
                  ])
                    // (each `li` holds an inline svg: a 29px line)
                    BsFlexItem(
                      ms: BsSpacing.s3,
                      child: SizedBox(
                        width: 24,
                        height: 29,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: BootstrapIcon(
                            icon,
                            width: 24,
                            height: 24,
                            color: secondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. a centred nav over a copyright ---

  Widget _third(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: BsBox(
        py: BsSpacing.s3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsBox(
              borderBottom: true,
              pb: BsSpacing.s3,
              mb: BsSpacing.s3,
              child: _nav(context, BsJustify.center),
            ),
            BsBox(
              textAlign: BsTextAlign.center,
              mb: BsSpacing.s3,
              textColor: BsTextColor.bodySecondary,
              child: Text('© $_year Company, Inc'),
            ),
          ],
        ),
      ),
    );
  }

  // --- 4. columns of links ---

  Widget _section(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BsHeading(BsHeadingLevel.h5, child: Text('Section')),
        for (final text in _links)
          // <li class="nav-item mb-2"><a class="nav-link p-0 text-body-secondary">
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(text, style: TextStyle(color: secondary)),
          ),
      ],
    );
  }

  Widget _fourth(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: BsRow(
        py: BsSpacing.s5,
        borderTop: true,
        rowCols: const BsResponsiveValue<int>(xs: 1, sm: 2, md: 5),
        children: [
          BsFlexItem(
            mb: BsSpacing.s3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // <a class="d-flex align-items-center mb-3 link-body-emphasis">
                BsBox(
                  mb: BsSpacing.s3,
                  textColor: BsTextColor.bodyEmphasis,
                  child: Row(
                    children: const [
                      BootstrapIcon(
                        BootstrapIconData.bootstrap,
                        width: 40,
                        height: 32,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('© $_year', style: TextStyle(color: secondary)),
                ),
              ],
            ),
          ),
          const BsFlexItem(mb: BsSpacing.s3, child: SizedBox.shrink()),
          for (var i = 0; i < 3; i++)
            BsFlexItem(mb: BsSpacing.s3, child: _section(context)),
        ],
      ),
    );
  }

  // --- 5. links and a newsletter form ---

  Widget _fifth(BuildContext context) {
    final sm = MediaQuery.sizeOf(context).width >= BsBreakpoint.sm.minWidth;
    const half = BsResponsiveValue<BsCol>(xs: BsCol(6), md: BsCol(2));
    final emphasis = BsTextColor.bodyEmphasis.of(context);
    return BsBox(
      py: BsSpacing.s5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsRow(
            children: [
              for (var i = 0; i < 3; i++)
                BsFlexItem(
                  col: half,
                  mb: BsSpacing.s3,
                  child: _section(context),
                ),
              // <div class="col-md-5 offset-md-1 mb-3">
              BsFlexItem(
                col: const BsResponsiveValue<BsCol>(md: BsCol(5)),
                offset: const BsResponsiveValue<BsCol>(md: BsCol(1)),
                mb: BsSpacing.s3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BsHeading(
                      BsHeadingLevel.h5,
                      child: Text('Subscribe to our newsletter'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Monthly digest of what's new and exciting from us.",
                      ),
                    ),
                    // <div class="d-flex flex-column flex-sm-row w-100 gap-2">
                    BsFlex(
                      direction: const BsResponsiveValue(
                        xs: BsFlexDirection.column,
                        sm: BsFlexDirection.row,
                      ),
                      gap: BsSpacing.s2,
                      children: [
                        BsFlexItem(
                          flexGrow: sm,
                          child: const BsFormControl(
                            placeholder: 'Email address',
                          ),
                        ),
                        BsFlexItem(
                          flexShrink: false,
                          child: BsButton(
                            onPressed: () {},
                            child: const Text('Subscribe'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // <div class="d-flex flex-column flex-sm-row justify-content-between py-4 my-4 border-top">
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: BsBox(
              py: BsSpacing.s4,
              borderTop: true,
              child: BsFlex(
                direction: const BsResponsiveValue(
                  xs: BsFlexDirection.column,
                  sm: BsFlexDirection.row,
                ),
                justifyContent: BsJustify.between,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('© $_year Company, Inc. All rights reserved.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BsFlex(
                      inline: true,
                      children: [
                        for (final icon in [
                          BootstrapIconData.instagram,
                          BootstrapIconData.facebook,
                        ])
                          BsFlexItem(
                            ms: BsSpacing.s3,
                            child: BootstrapIcon(
                              icon,
                              width: 24,
                              height: 24,
                              color: emphasis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
