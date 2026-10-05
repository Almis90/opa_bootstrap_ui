import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';
import '../../src/example_icon_link.dart';
import '../../src/example_sticky_footer.dart';

/// The "Features" example: a port of Bootstrap's own `examples/features` page —
/// five feature layouts in `.container.px-4.py-5` sections: columns with
/// gradient icons, hanging icons, custom photo cards, an icon grid and a
/// features-with-title block. The page's CSS (`features.css`) is translated
/// where it is used.
class FeaturesExamplePage extends StatelessWidget {
  const FeaturesExamplePage({super.key});

  static const _text =
      "Paragraph of text beneath the heading to explain the heading. We'll "
      'add onto it with another sentence and probably just keep going until we '
      'run out of words.';
  static const _short =
      'Paragraph of text beneath the heading to explain the heading.';

  /// `<div class="container px-4 py-5"><h2 class="pb-2 border-bottom">…`
  static Widget _section(String title, Widget body) {
    return BsContainer(
      px: BsSpacing.s4,
      py: BsSpacing.s5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsBox(
            pb: BsSpacing.s2,
            borderBottom: true,
            child: BsHeading(
              BsHeadingLevel.h2,
              mb: BsSpacing.s0,
              child: Text(title),
            ),
          ),
          // (the heading's own `margin-bottom`, under its border)
          const SizedBox(height: 8),
          body,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _section('Columns with icons', _columns(context)),
        const ExampleDivider(),
        _section('Hanging icons', _hanging(context)),
        const ExampleDivider(),
        _section('Custom cards', _cards(context)),
        const ExampleDivider(),
        _section('Icon grid', _grid(context)),
        const ExampleDivider(),
        _section('Features with title', _withTitle(context)),
      ],
    );
  }

  static const _rows13 = BsResponsiveValue<int>(xs: 1, lg: 3);

  /// `<h3 class="fs-2 text-body-emphasis">Featured title</h3>`
  static Widget _h3fs2(BuildContext context, {String text = 'Featured title'}) {
    final width = MediaQuery.sizeOf(context).width;
    final size = BsFs.fs2.sizeFor(width);
    return DefaultTextStyle.merge(
      style: TextStyle(color: BsTextColor.bodyEmphasis.of(context)),
      child: BsHeading(
        BsHeadingLevel.h3,
        fs: BsFs.fs2,
        child: Text(text, style: TextStyle(fontSize: size)),
      ),
    );
  }

  /// `.text-bg-primary.bg-gradient`: the primary color with a white fade over it
  /// (`linear-gradient(180deg, rgba(255,255,255,.15), rgba(255,255,255,0))`).
  static Widget _gradientIcon(
    BuildContext context, {
    required BootstrapIconData icon,
    required double box,
    required double radius,
    required BsFs fs,
  }) {
    final size = fs.sizeFor(MediaQuery.sizeOf(context).width);
    return SizedBox(
      width: box,
      height: box,
      child: BsDecoratedBox(
        decoration: BoxDecoration(
          color: BsVariant.primary.color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x26FFFFFF), Color(0x00FFFFFF)],
            ),
          ),
          child: Center(
            child: BootstrapIcon(
              icon,
              width: size,
              height: size,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  // --- 1. columns with icons ---

  Widget _columns(BuildContext context) {
    Widget feature(BootstrapIconData icon) {
      return BsFlexItem(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _gradientIcon(
                context,
                icon: icon,
                box: 64,
                radius: 12,
                fs: BsFs.fs2,
              ),
            ),
            _h3fs2(context),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(_text),
            ),
            ExampleIconLink(
              text: 'Call to action',
              icon: BootstrapIconData.chevronRight,
              onTap: () {},
            ),
          ],
        ),
      );
    }

    return BsBox(
      py: BsSpacing.s5,
      child: BsRow(
        g: BsSpacing.s4,
        rowCols: _rows13,
        children: [
          feature(BootstrapIconData.collection),
          feature(BootstrapIconData.peopleCircle),
          feature(BootstrapIconData.toggles2),
        ],
      ),
    );
  }

  // --- 2. hanging icons ---

  Widget _hanging(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final iconSize = BsFs.fs4.sizeFor(width);
    Widget item(BootstrapIconData icon) {
      return BsFlexItem(
        child: BsFlex(
          alignItems: BsAlign.start,
          children: [
            BsFlexItem(
              flexShrink: false,
              me: BsSpacing.s3,
              child: SizedBox(
                width: 48,
                height: 48,
                child: BsDecoratedBox(
                  decoration: BoxDecoration(
                    color: BsBody.secondaryBackgroundOf(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: BootstrapIcon(
                      icon,
                      width: iconSize,
                      height: iconSize,
                      color: BsTextColor.bodyEmphasis.of(context),
                    ),
                  ),
                ),
              ),
            ),
            BsFlexItem(
              flexGrow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _h3fs2(context),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(_text),
                  ),
                  BsButton(
                    onPressed: () {},
                    child: const Text('Primary button'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BsBox(
      py: BsSpacing.s5,
      child: BsRow(
        g: BsSpacing.s4,
        rowCols: _rows13,
        children: [
          item(BootstrapIconData.toggles2),
          item(BootstrapIconData.cpuFill),
          item(BootstrapIconData.tools),
        ],
      ),
    );
  }

  // --- 3. custom cards ---

  Widget _cards(BuildContext context) {
    Widget card(String photo, String title, String place, String days) {
      return BsFlexItem(
        child: _CoverCard(photo: photo, title: title, place: place, days: days),
      );
    }

    return BsBox(
      py: BsSpacing.s5,
      child: BsRow(
        g: BsSpacing.s4,
        rowCols: _rows13,
        alignItems: BsAlign.stretch,
        children: [
          card(
            'unsplash-photo-1.jpg',
            'Short title, long jacket',
            'Earth',
            '3d',
          ),
          card(
            'unsplash-photo-2.jpg',
            'Much longer title that wraps to multiple lines',
            'Pakistan',
            '4d',
          ),
          card(
            'unsplash-photo-3.jpg',
            'Another longer title belongs here',
            'California',
            '5d',
          ),
        ],
      ),
    );
  }

  // --- 4. icon grid ---

  Widget _grid(BuildContext context) {
    Widget item(BootstrapIconData icon) {
      return BsFlexItem(
        child: BsFlex(
          alignItems: BsAlign.start,
          children: [
            BsFlexItem(
              flexShrink: false,
              me: BsSpacing.s3,
              child: BootstrapIcon(
                icon,
                width: 28,
                height: 28,
                color: BsTextColor.bodySecondary.of(context),
              ),
            ),
            BsFlexItem(
              flexGrow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DefaultTextStyle.merge(
                    style: TextStyle(
                      color: BsTextColor.bodyEmphasis.of(context),
                    ),
                    child: const BsHeading(
                      BsHeadingLevel.h3,
                      fs: BsFs.fs4,
                      fw: BsFw.bold,
                      mb: BsSpacing.s0,
                      child: Text('Featured title'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(_short),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BsBox(
      py: BsSpacing.s5,
      child: BsRow(
        g: BsSpacing.s4,
        rowCols: const BsResponsiveValue<int>(xs: 1, sm: 2, md: 3, lg: 4),
        children: [
          for (final icon in [
            BootstrapIconData.bootstrap,
            BootstrapIconData.cpuFill,
            BootstrapIconData.calendar3,
            BootstrapIconData.home,
            BootstrapIconData.speedometer2,
            BootstrapIconData.toggles2,
            BootstrapIconData.geoFill,
            BootstrapIconData.tools,
          ])
            item(icon),
        ],
      ),
    );
  }

  // --- 5. features with title ---

  Widget _withTitle(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    Widget small(BootstrapIconData icon, {double ignored = 0}) {
      return BsFlexItem(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gradientIcon(
              context,
              icon: icon,
              box: 48,
              radius: 8,
              fs: BsFs.fs4,
            ),
            const SizedBox(height: 8),
            DefaultTextStyle.merge(
              style: TextStyle(color: BsTextColor.bodyEmphasis.of(context)),
              child: const BsHeading(
                BsHeadingLevel.h4,
                fw: BsFw.semibold,
                mb: BsSpacing.s0,
                child: Text('Featured title'),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_short, style: TextStyle(color: secondary)),
            ),
          ],
        ),
      );
    }

    return BsBox(
      py: BsSpacing.s5,
      child: BsRow(
        g: BsSpacing.s5,
        rowCols: const BsResponsiveValue<int>(xs: 1, md: 2),
        alignItems: null,
        children: [
          BsFlexItem(
            alignSelf: MediaQuery.sizeOf(context).width >= 768
                ? BsAlign.center
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle.merge(
                  style: TextStyle(color: BsTextColor.bodyEmphasis.of(context)),
                  child: const BsHeading(
                    BsHeadingLevel.h2,
                    fw: BsFw.bold,
                    child: Text(
                      'Left-aligned title explaining these awesome features',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_text, style: TextStyle(color: secondary)),
                ),
                const SizedBox(height: 8),
                BsButton(
                  size: BsSize.lg,
                  onPressed: () {},
                  child: const Text('Primary button'),
                ),
              ],
            ),
          ),
          BsFlexItem(
            alignSelf: MediaQuery.sizeOf(context).width >= 768
                ? BsAlign.center
                : null,
            child: BsRow(
              g: BsSpacing.s4,
              rowCols: const BsResponsiveValue<int>(xs: 1, sm: 2),
              children: [
                small(BootstrapIconData.collection),
                small(BootstrapIconData.gearFill),
                small(BootstrapIconData.speedometer),
                small(BootstrapIconData.table),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `.card.card-cover.h-100.overflow-hidden.text-bg-dark.rounded-4.shadow-lg`: a
/// photo for the background, with `p-5 pb-3` content: a bold `display-6` title
/// pushed down by `pt-5 mt-5`, an avatar and two icon-and-text items at the
/// bottom, all in white with a soft text shadow.
class _CoverCard extends StatelessWidget {
  const _CoverCard({
    required this.photo,
    required this.title,
    required this.place,
    required this.days,
  });

  final String photo;
  final String title;
  final String place;
  final String days;

  static const _shadow = Shadow(
    color: Color(0x40000000),
    offset: Offset(0, 2),
    blurRadius: 4,
  );

  @override
  Widget build(BuildContext context) {
    const white = Color(0xFFFFFFFF);
    final shape = BorderRadius.circular(16);
    Widget item(BootstrapIconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BootstrapIcon(icon, color: white),
        const SizedBox(width: 8),
        BsSmall(child: Text(text)),
      ],
    );
    return BsDecoratedContainer(
      decoration: BoxDecoration(
        color: BsVariant.dark.color,
        border: Border.all(color: BsBorders.colorTranslucent),
        borderRadius: shape,
        boxShadow: BsShadow.lg.shadows,
        image: DecorationImage(
          image: AssetImage('assets/examples/features/$photo'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: white, shadows: [_shadow]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 48, 48, 16),
          // (`d-flex flex-column h-100`, the `ul` last with `mt-auto`)
          child: ExampleStickyFooter(
            fillParent: true,
            main: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // <h3 class="pt-5 mt-5 mb-4 display-6 lh-1 fw-bold">
                const SizedBox(height: 96),
                BsDisplayHeading(
                  BsDisplayLevel.d6,
                  fw: BsFw.bold,
                  lh: BsLh.lh1,
                  child: Text(title),
                ),
                const SizedBox(height: 24),
              ],
            ),
            footer: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    // <li class="me-auto"><img … class="rounded-circle border border-white">
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://avatars.githubusercontent.com/u/2918581?v=4',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    const Spacer(),
                    item(BootstrapIconData.geoFill, place),
                    const SizedBox(width: 16),
                    item(BootstrapIconData.calendar3, days),
                  ],
                ),
                // (the `ul`'s `margin-bottom: 1rem`)
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
