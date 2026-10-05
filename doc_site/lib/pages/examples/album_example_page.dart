import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/float_end_text.dart';
import '../../src/placeholder_image.dart';

/// The "Album" example: a port of Bootstrap's own `examples/album` page — a
/// dark header whose toggler reveals an "About / Contact" panel, a centred
/// intro with two buttons, a `row-cols` grid of nine thumbnail cards on a
/// tertiary background, and a footer.
class AlbumExamplePage extends StatefulWidget {
  const AlbumExamplePage({super.key});

  @override
  State<AlbumExamplePage> createState() => _AlbumExamplePageState();
}

class _AlbumExamplePageState extends State<AlbumExamplePage> {
  bool _headerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context),
        _intro(context),
        _album(context),
        _footer(context),
      ],
    );
  }

  // --- <header data-bs-theme="dark"> ---

  Widget _header(BuildContext context) {
    return BsTheme(
      brightness: Brightness.dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <div class="collapse text-bg-dark" id="navbarHeader">
          BsCollapse(
            isExpanded: _headerOpen,
            child: BsBox(
              textBg: BsVariant.dark,
              // (a Builder: the colors are the dark theme's)
              child: BsContainer(child: Builder(builder: _headerPanel)),
            ),
          ),
          // <div class="navbar bg-dark shadow-sm">
          BsBox(
            bg: BsBg.dark,
            shadow: BsShadow.sm,
            child: BsContainer(
              child: BsNavbar(
                colorScheme: BsNavbarColorScheme.dark,
                expandBreakpoint: null,
                onToggle: () => setState(() => _headerOpen = !_headerOpen),
                // <a class="navbar-brand d-flex align-items-center">
                brand: const Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BootstrapIcon(
                      BootstrapIconData.camera,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Album',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerPanel(BuildContext context) {
    final white = BsTextColor.white.of(context);
    Widget link(String text) => Padding(
      padding: EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(color: white, decoration: TextDecoration.underline),
      ),
    );
    return BsRow(
      children: [
        // <div class="col-sm-8 col-md-7 py-4">
        BsFlexItem(
          col: const BsResponsiveValue(
            xs: BsCol(12),
            sm: BsCol(8),
            md: BsCol(7),
          ),
          py: BsSpacing.s4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BsHeading(BsHeadingLevel.h4, child: Text('About')),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Add some information about the album below, the author, or '
                  'any other background context. Make it a few sentences long '
                  'so folks can pick up some informative tidbits. Then, link '
                  'them off to some social networking sites or contact '
                  'information.',
                  style: TextStyle(
                    color: BsTextColor.bodySecondary.of(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        // <div class="col-sm-4 offset-md-1 py-4">
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12), sm: BsCol(4)),
          offset: const BsResponsiveValue(md: BsCol(1)),
          py: BsSpacing.s4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BsHeading(BsHeadingLevel.h4, child: Text('Contact')),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    link('Follow on X'),
                    link('Like on Facebook'),
                    link('Email me'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- <section class="py-5 text-center container"> ---

  Widget _intro(BuildContext context) {
    return BsContainer(
      py: BsSpacing.s5,
      child: BsBox(
        textAlign: BsTextAlign.center,
        child: BsRow(
          py: const BsResponsiveValue(lg: BsSpacing.s5),
          children: [
            // <div class="col-lg-6 col-md-8 mx-auto">
            BsFlexItem(
              col: const BsResponsiveValue(
                xs: BsCol(12),
                md: BsCol(8),
                lg: BsCol(6),
              ),
              mx: BsSpacing.auto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BsHeading(
                    BsHeadingLevel.h1,
                    fw: BsFw.light,
                    child: Text('Album example'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BsLead(
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: BsTextColor.bodySecondary.of(context),
                        ),
                        child: const Text(
                          'Something short and leading about the collection '
                          'below—its contents, the creator, etc. Make it short '
                          'and sweet, but not too short so folks don’t simply '
                          'skip over it entirely.',
                        ),
                      ),
                    ),
                  ),
                  // <p><a class="btn btn-primary my-2"> <a class="btn btn-secondary my-2">
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    // (inline-blocks: they wrap like words)
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 3.92,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: BsButton(
                            onPressed: () {},
                            child: const Text('Main call to action'),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: BsButton(
                            variant: BsVariant.secondary,
                            onPressed: () {},
                            child: const Text('Secondary action'),
                          ),
                        ),
                      ],
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

  // --- <div class="album py-5 bg-body-tertiary"> ---

  Widget _album(BuildContext context) {
    return BsBox(
      py: BsSpacing.s5,
      bg: BsBg.bodyTertiary,
      child: BsContainer(
        child: BsRow(
          g: BsSpacing.s3,
          rowCols: const BsResponsiveValue<int>(xs: 1, sm: 2, md: 3),
          children: [for (var i = 0; i < 9; i++) _card(context)],
        ),
      ),
    );
  }

  Widget _card(BuildContext context) {
    return BsCard(
      shadow: BsShadow.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BsCardImg(
            position: BsCardImgPosition.top,
            child: PlaceholderImage(
              height: 225,
              text: 'Thumbnail',
              background: Color(0xFF55595C),
              color: Color(0xFFECEEEF),
            ),
          ),
          BsBox(
            p: BsSpacing.s3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BsBox(
                  mb: BsSpacing.s3,
                  child: Text(
                    'This is a wider card with supporting text below as a '
                    'natural lead-in to additional content. This content is a '
                    'little bit longer.',
                  ),
                ),
                BsFlex(
                  justifyContent: BsJustify.between,
                  alignItems: BsAlign.center,
                  children: [
                    BsButtonGroup(
                      children: [
                        BsButton(
                          variant: BsVariant.secondary,
                          outline: true,
                          size: BsSize.sm,
                          onPressed: () {},
                          child: const Text('View'),
                        ),
                        BsButton(
                          variant: BsVariant.secondary,
                          outline: true,
                          size: BsSize.sm,
                          onPressed: () {},
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                    BsBox(
                      textColor: BsTextColor.bodySecondary,
                      child: const BsSmall(child: Text('9 mins')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- <footer class="text-body-secondary py-5"> ---

  Widget _footer(BuildContext context) {
    final link = BsLink.colorOf(context);
    TextSpan anchor(String text) => TextSpan(
      text: text,
      style: TextStyle(color: link, decoration: TextDecoration.underline),
    );
    final linkStyle = TextStyle(
      color: link,
      decoration: TextDecoration.underline,
    );
    return BsBox(
      textColor: BsTextColor.bodySecondary,
      py: BsSpacing.s5,
      child: BsContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <p class="float-end mb-1"><a href="#">Back to top</a></p>
            // <p class="mb-1">Album example is …
            FloatEndText(
              floatText: 'Back to top',
              floatStyle: linkStyle,
              text:
                  'Album example is © Bootstrap, but please download and '
                  'customize it for yourself!',
              bottomMargin: 4,
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'New to Bootstrap? '),
                  anchor('Visit the homepage'),
                  const TextSpan(text: ' or read our '),
                  anchor('getting started guide'),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
