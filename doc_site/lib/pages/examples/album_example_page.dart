import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/float_end_text.dart';
import '../../src/placeholder_image.dart';
import '../../src/example_top_link.dart';

/// The "Album" example: a port of Bootstrap's own `examples/album` page — a
/// dark header whose toggler reveals an "About / Contact" panel, a centred
/// intro with two buttons, a `row-cols` grid of nine thumbnail cards on a
/// tertiary background, and a footer.
class AlbumExamplePage extends StatefulWidget {
  const AlbumExamplePage({super.key, this.rtl = false});

  /// The `album-rtl` page: `dir="rtl"`, in Arabic.
  final bool rtl;

  @override
  State<AlbumExamplePage> createState() => _AlbumExamplePageState();
}

class _AlbumExamplePageState extends State<AlbumExamplePage> {
  bool _headerOpen = false;

  _Strings get _t => widget.rtl ? _Strings.ar : _Strings.en;

  @override
  Widget build(BuildContext context) {
    final page = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context),
        _intro(context),
        _album(context),
        _footer(context),
      ],
    );
    // <html dir="rtl">
    return widget.rtl
        ? Directionality(textDirection: TextDirection.rtl, child: page)
        : page;
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
                brand: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const BootstrapIcon(
                      BootstrapIconData.camera,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _t.brand,
                      style: const TextStyle(fontWeight: FontWeight.w700),
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
              BsHeading(BsHeadingLevel.h4, child: Text(_t.about)),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _t.aboutText,
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
              BsHeading(BsHeadingLevel.h4, child: Text(_t.contact)),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [for (final text in _t.contactLinks) link(text)],
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
                  BsHeading(
                    BsHeadingLevel.h1,
                    fw: BsFw.light,
                    child: Text(_t.title),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BsLead(
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: BsTextColor.bodySecondary.of(context),
                        ),
                        child: Text(_t.lead),
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
                            child: Text(_t.primaryAction),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: BsButton(
                            variant: BsVariant.secondary,
                            onPressed: () {},
                            child: Text(_t.secondaryAction),
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
          BsCardImg(
            position: BsCardImgPosition.top,
            child: PlaceholderImage(
              height: 225,
              text: _t.thumbnail,
              background: Color(0xFF55595C),
              color: Color(0xFFECEEEF),
            ),
          ),
          BsBox(
            p: BsSpacing.s3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BsBox(mb: BsSpacing.s3, child: Text(_t.cardText)),
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
                          child: Text(_t.view),
                        ),
                        BsButton(
                          variant: BsVariant.secondary,
                          outline: true,
                          size: BsSize.sm,
                          onPressed: () {},
                          child: Text(_t.edit),
                        ),
                      ],
                    ),
                    BsBox(
                      textColor: BsTextColor.bodySecondary,
                      child: BsSmall(child: Text(_t.time)),
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
              floatText: _t.backToTop,
              onFloatTap: () => scrollExampleToTop(context),
              text: _t.copyright,
              bottomMargin: 4,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: _t.newTo),
                  anchor(_t.homepage),
                  TextSpan(text: _t.orRead),
                  anchor(_t.guide),
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

/// The page's texts: the English original and the `album-rtl` Arabic one.
class _Strings {
  const _Strings({
    required this.about,
    required this.aboutText,
    required this.contact,
    required this.contactLinks,
    required this.brand,
    required this.title,
    required this.lead,
    required this.primaryAction,
    required this.secondaryAction,
    required this.thumbnail,
    required this.cardText,
    required this.view,
    required this.edit,
    required this.time,
    required this.backToTop,
    required this.copyright,
    required this.newTo,
    required this.homepage,
    required this.orRead,
    required this.guide,
  });

  final String about;
  final String aboutText;
  final String contact;
  final List<String> contactLinks;
  final String brand;
  final String title;
  final String lead;
  final String primaryAction;
  final String secondaryAction;
  final String thumbnail;
  final String cardText;
  final String view;
  final String edit;
  final String time;
  final String backToTop;
  final String copyright;
  final String newTo;
  final String homepage;
  final String orRead;
  final String guide;

  static const en = _Strings(
    about: 'About',
    aboutText:
        'Add some information about the album below, the author, or any other '
        'background context. Make it a few sentences long so folks can pick up '
        'some informative tidbits. Then, link them off to some social '
        'networking sites or contact information.',
    contact: 'Contact',
    contactLinks: ['Follow on X', 'Like on Facebook', 'Email me'],
    brand: 'Album',
    title: 'Album example',
    lead:
        'Something short and leading about the collection below—its contents, '
        'the creator, etc. Make it short and sweet, but not too short so folks '
        'don’t simply skip over it entirely.',
    primaryAction: 'Main call to action',
    secondaryAction: 'Secondary action',
    thumbnail: 'Thumbnail',
    cardText:
        'This is a wider card with supporting text below as a natural lead-in '
        'to additional content. This content is a little bit longer.',
    view: 'View',
    edit: 'Edit',
    time: '9 mins',
    backToTop: 'Back to top',
    copyright:
        'Album example is © Bootstrap, but please download and customize it '
        'for yourself!',
    newTo: 'New to Bootstrap? ',
    homepage: 'Visit the homepage',
    orRead: ' or read our ',
    guide: 'getting started guide',
  );

  static const ar = _Strings(
    about: 'حول',
    aboutText:
        'أضف بعض المعلومات حول الألبوم، المؤلف، أو أي سياق خلفية آخر. اجعلها '
        'بضع جمل حتى يتمكن الزوار من التقاط بعض التلميحات المفيدة. ثم اربطها '
        'ببعض مواقع التواصل الاجتماعي أو معلومات الاتصال.',
    contact: 'تواصل معي',
    contactLinks: [
      'تابعني على تويتر',
      'شاركني الإعجاب في فيسبوك',
      'راسلني على البريد الإلكتروني',
    ],
    brand: 'الألبوم',
    title: 'مثال الألبوم',
    lead:
        'وصف قصير حول الألبوم أدناه (محتوياته ، ومنشؤه ، وما إلى ذلك). اجعله '
        'قصير ولطيف، ولكن ليست قصير جدًا حتى لا يتخطى الناس هذا الألبوم '
        'تمامًا.',
    primaryAction: 'الدعوة الرئيسية للعمل',
    secondaryAction: 'عمل ثانوي',
    thumbnail: 'صورة مصغرة',
    cardText:
        'هذه بطاقة أوسع مع نص داعم أدناه كمقدمة طبيعية لمحتوى إضافي. هذا '
        'المحتوى أطول قليلاً.',
    view: 'عرض',
    edit: 'تعديل',
    time: '9 دقائق',
    backToTop: 'عد إلى الأعلى',
    copyright: 'مثال الألبوم هو © Bootstrap ، ولكن يرجى تنزيله وتخصيصه لنفسك!',
    newTo: 'جديد على Bootstrap؟ ',
    homepage: 'تفضل بزيارة الصفحة الرئيسية',
    orRead: ' أو اقرأ ',
    guide: 'دليل البدء',
  );
}
