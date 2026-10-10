import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_navbar_page.dart';
import '../../src/float_end_text.dart';
import '../../src/placeholder_image.dart';
import '../../src/example_top_link.dart';

/// The "Carousel" example: a port of Bootstrap's own `examples/carousel`
/// page — a `fixed-top` dark navbar (see [fixed]) over a 32rem carousel of
/// three slides with captions, three columns of marketing text with round
/// placeholders, three alternating featurettes and a footer. The page's CSS
/// (`carousel.css`) is translated where it is used.
class CarouselExamplePage extends StatelessWidget {
  const CarouselExamplePage({super.key, this.rtl = false});

  /// The `carousel-rtl` page: `dir="rtl"`, in Arabic.
  final bool rtl;

  static const _expand = BsBreakpoint.md;

  /// The `position: fixed; top: 0; right: 0; left: 0` navbar.
  static Widget fixed(BuildContext context, {bool rtl = false}) {
    final t = rtl ? _Strings.ar : _Strings.en;
    final bar = Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: NavbarExampleBar(
        brand: t.brand,
        expandBreakpoint: _expand,
        items: navbarExampleItems(
          home: t.home,
          link: t.link,
          disabled: t.disabled,
        ),
        trailing: [NavbarSearchForm(label: t.search)],
      ),
    );
    return rtl
        ? Positioned.fill(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(children: [bar]),
            ),
          )
        : bar;
  }

  _Strings get _t => rtl ? _Strings.ar : _Strings.en;

  @override
  Widget build(BuildContext context) {
    // body { padding: 3rem 0 } (and `color: rgb(var(--bs-tertiary-color-rgb))`,
    // which is the body color: its rgb without the alpha)
    final page = Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _carousel(context),
          BsContainer(child: _marketing(context)),
          BsContainer(child: _footer(context)),
        ],
      ),
    );
    // <html dir="rtl">
    return rtl
        ? Directionality(textDirection: TextDirection.rtl, child: page)
        : page;
  }

  // --- <div id="myCarousel" class="carousel slide"> ---

  Widget _carousel(BuildContext context) {
    // `@media (min-width: 40em)`: a bigger caption paragraph.
    final wide = MediaQuery.sizeOf(context).width >= 640;
    final secondary = BsTextColor.bodySecondary.of(context);

    Widget caption(
      String title,
      String text,
      String button, {
      TextAlign align = TextAlign.center,
      bool faded = false,
    }) {
      Widget paragraph(Widget child) => Padding(
        padding: EdgeInsets.only(bottom: wide ? 20 : 16),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: wide ? 20 : null,
            height: wide ? 1.4 : null,
          ),
          child: child,
        ),
      );
      return DefaultTextStyle.merge(
        textAlign: align,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsHeading(BsHeadingLevel.h1, child: Text(title)),
            paragraph(Opacity(opacity: faded ? 0.75 : 1, child: Text(text))),
            paragraph(
              Align(
                alignment: switch (align) {
                  TextAlign.start => AlignmentDirectional.centerStart,
                  TextAlign.end => AlignmentDirectional.centerEnd,
                  _ => Alignment.center,
                },
                child: BsButton(
                  size: BsSize.lg,
                  onPressed: () {},
                  child: Text(button),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final placeholder = ColoredBox(color: secondary);
    return Padding(
      // .carousel { margin-bottom: 4rem }
      padding: const EdgeInsets.only(bottom: 64),
      child: SizedBox(
        // .carousel-item { height: 32rem }
        height: 512,
        child: BsCarousel(
          style: const BsCarouselStyle(captionSpacer: 48),
          items: [
            BsCarouselItem(
              child: placeholder,
              caption: caption(
                _t.headline1,
                _t.text1,
                _t.button1,
                align: TextAlign.start,
                faded: true,
              ),
            ),
            BsCarouselItem(
              child: placeholder,
              caption: caption(_t.headline2, _t.text2, _t.button2),
            ),
            BsCarouselItem(
              child: placeholder,
              caption: caption(
                _t.headline3,
                _t.text3,
                _t.button3,
                align: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- <div class="container marketing"> ---

  Widget _marketing(BuildContext context) {
    final secondary = BsTextColor.bodySecondary.of(context);
    Widget column(String title, String text) {
      return BsFlexItem(
        col: const BsResponsiveValue(xs: BsCol(12), lg: BsCol(4)),
        // .marketing .col-lg-4 { margin-bottom: 1.5rem; text-align: center }
        mb: BsSpacing.s4,
        child: BsBox(
          textAlign: BsTextAlign.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // <svg width="140" height="140" class="rounded-circle">
              Align(
                alignment: Alignment.topCenter,
                child: ClipOval(
                  child: PlaceholderImage(
                    width: 140,
                    height: 140,
                    background: secondary,
                  ),
                ),
              ),
              BsHeading(BsHeadingLevel.h2, fw: BsFw.normal, child: Text(title)),
              // .marketing .col-lg-4 p { margin: 0 .75rem 1rem }
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Text(text),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: BsButton(
                    variant: BsVariant.secondary,
                    onPressed: () {},
                    child: Text(_t.details),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget divider() => const Padding(
      // .featurette-divider { margin: 5rem 0 }
      padding: EdgeInsets.symmetric(vertical: 80),
      child: BsHr(my: BsSpacing.s0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsRow(
          children: [
            column(_t.heading1, _t.column1),
            column(_t.heading2, _t.column2),
            column(_t.heading3, _t.column3),
          ],
        ),
        divider(),
        _featurette(
          context,
          _t.featurette1,
          _t.muted1,
          _t.lead1,
          imageFirst: false,
        ),
        divider(),
        _featurette(
          context,
          _t.featurette2,
          _t.muted2,
          _t.lead2,
          imageFirst: true,
        ),
        divider(),
        _featurette(
          context,
          _t.featurette3,
          _t.muted3,
          _t.lead3,
          imageFirst: false,
        ),
        divider(),
      ],
    );
  }

  /// `<div class="row featurette">`: a `col-md-7` heading and lead, and a
  /// `col-md-5` placeholder (first, from `md`, with `order-md-1`/`2`).
  Widget _featurette(
    BuildContext context,
    String heading,
    String muted,
    String lead, {
    required bool imageFirst,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final md = width >= BsBreakpoint.md.minWidth;
    final lg = width >= BsBreakpoint.lg.minWidth;
    final secondary = BsTextColor.bodySecondary.of(context);
    return BsRow(
      direction: BsResponsiveValue(
        xs: BsFlexDirection.row,
        md: imageFirst ? BsFlexDirection.rowReverse : BsFlexDirection.row,
      ),
      children: [
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(7)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // .featurette-heading { letter-spacing: -.05rem; font-size: 50px
              // from 40em; margin-top: 7rem from 62em }
              Padding(
                padding: EdgeInsets.only(top: lg ? 112 : 0),
                child: _featuretteHeading(
                  width >= 640,
                  heading,
                  muted,
                  secondary,
                  rtl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BsLead(child: Text(lead)),
              ),
            ],
          ),
        ),
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12), md: BsCol(5)),
          child: Align(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) => PlaceholderImage(
                  height: constraints.maxHeight,
                  text: '500x500',
                  fontSize: md ? 56 : 18,
                  background: BsBody.secondaryBackgroundOf(context),
                  color: secondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// `<h2 class="featurette-heading fw-normal lh-1">`: `50px` from `40em`,
  /// `letter-spacing: -.05rem`.
  static Widget _featuretteHeading(
    bool wide,
    String heading,
    String muted,
    Color secondary,
    bool rtl,
  ) {
    final text = Text.rich(
      TextSpan(
        // (`rtl:remove`: Arabic keeps its letter-spacing)
        style: TextStyle(letterSpacing: rtl ? null : -0.8),
        children: [
          TextSpan(text: heading),
          TextSpan(
            text: muted,
            style: TextStyle(color: secondary),
          ),
        ],
      ),
    );
    if (!wide) {
      return BsHeading(
        BsHeadingLevel.h2,
        fw: BsFw.normal,
        lh: BsLh.lh1,
        child: text,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w400,
          height: 1,
        ),
        child: text,
      ),
    );
  }

  // --- <footer class="container"> ---

  Widget _footer(BuildContext context) {
    final link = BsLink.colorOf(context);
    // (every link is `href="#"`: back to the top of the page)
    return ExampleTopLinks(
      builder: (context, recognizer) {
        TextSpan anchor(String text) => TextSpan(
          text: text,
          style: TextStyle(color: link, decoration: TextDecoration.underline),
          recognizer: recognizer,
          mouseCursor: SystemMouseCursors.click,
        );
        return FloatEndText(
          floatText: _t.backToTop,
          floatStyle: TextStyle(
            color: link,
            decoration: TextDecoration.underline,
          ),
          onFloatTap: () => scrollExampleToTop(context),
          floatMarginBottom: 16,
          bottomMargin: 16,
          span: TextSpan(
            children: [
              TextSpan(text: '© 2017–${DateTime.now().year} Company, Inc. · '),
              anchor(_t.privacy),
              const TextSpan(text: ' · '),
              anchor(_t.terms),
            ],
          ),
        );
      },
    );
  }
}

/// The page's texts: the English original and the `carousel-rtl` Arabic one.
class _Strings {
  const _Strings({
    required this.brand,
    required this.home,
    required this.link,
    required this.disabled,
    required this.search,
    required this.headline1,
    required this.text1,
    required this.button1,
    required this.headline2,
    required this.text2,
    required this.button2,
    required this.headline3,
    required this.text3,
    required this.button3,
    required this.heading1,
    required this.column1,
    required this.heading2,
    required this.column2,
    required this.heading3,
    required this.column3,
    required this.details,
    required this.featurette1,
    required this.muted1,
    required this.lead1,
    required this.featurette2,
    required this.muted2,
    required this.lead2,
    required this.featurette3,
    required this.muted3,
    required this.lead3,
    required this.backToTop,
    required this.privacy,
    required this.terms,
  });

  final String brand, home, link, disabled, search;
  final String headline1, text1, button1;
  final String headline2, text2, button2;
  final String headline3, text3, button3;
  final String heading1, column1, heading2, column2, heading3, column3;
  final String details;
  final String featurette1, muted1, lead1;
  final String featurette2, muted2, lead2;
  final String featurette3, muted3, lead3;
  final String backToTop, privacy, terms;

  static const en = _Strings(
    brand: 'Carousel',
    home: 'Home',
    link: 'Link',
    disabled: 'Disabled',
    search: 'Search',
    headline1: 'Example headline.',
    text1:
        'Some representative placeholder content for the first slide of the '
        'carousel.',
    button1: 'Sign up today',
    headline2: 'Another example headline.',
    text2:
        'Some representative placeholder content for the second slide of the '
        'carousel.',
    button2: 'Learn more',
    headline3: 'One more for good measure.',
    text3:
        'Some representative placeholder content for the third slide of this '
        'carousel.',
    button3: 'Browse gallery',
    heading1: 'Heading',
    column1:
        'Some representative placeholder content for the three columns of text '
        'below the carousel. This is the first column.',
    heading2: 'Heading',
    column2:
        'Another exciting bit of representative placeholder content. This '
        "time, we've moved on to the second column.",
    heading3: 'Heading',
    column3:
        'And lastly this, the third column of representative placeholder '
        'content.',
    details: 'View details »',
    featurette1: 'First featurette heading. ',
    muted1: 'It’ll blow your mind.',
    lead1:
        'Some great placeholder content for the first featurette here. '
        'Imagine some exciting prose here.',
    featurette2: 'Oh yeah, it’s that good. ',
    muted2: 'See for yourself.',
    lead2:
        'Another featurette? Of course. More placeholder content here to give '
        'you an idea of how this layout would work with some actual '
        'real-world content in place.',
    featurette3: 'And lastly, this one. ',
    muted3: 'Checkmate.',
    lead3:
        'And yes, this is the last block of representative placeholder '
        'content. Again, not really intended to be actually read, simply here '
        'to give you a better view of what this would look like with some '
        'actual content. Your content.',
    backToTop: 'Back to top',
    privacy: 'Privacy',
    terms: 'Terms',
  );

  static const ar = _Strings(
    brand: 'شرائح العرض',
    home: 'الصفحة الرئيسية',
    link: 'حلقة الوصل',
    disabled: 'رابط غير مفعل',
    search: 'بحث',
    headline1: 'عنوان المثال.',
    text1:
        'تشير الدراسات الإحصائية حسب الجمعية الأمريكية للغات بأن الإقبال على '
        'العربية زاد %126 في الولايات المتحدة الأمريكية وحدها بين عامي 2002 '
        'و2009م.',
    button1: 'سجل اليوم',
    headline2: 'عنوان مثال آخر.',
    text2:
        'حسب المجلس الثقافي البريطاني فإن تعليم الإنجليزية داخل بريطانيا يسهم '
        'في تعزيز اقتصادها بما يتجاوز ملياري جنيه سنوياً، كما أنه وفر أكثر من '
        '26 ألف وظيفة.',
    button2: 'أعرف أكثر',
    headline3: 'واحد أكثر لقياس جيد.',
    text3:
        'الإحصاءات لحجم الاستثمار اللغوي خارج بريطانيا تتفاوت من سنة لأخرى إلا '
        'أن المدير التنفيذي للمجلس الثقافي البريطاني إدي بايرز يرى أن استثمار '
        'تعليم الإنجليزية في الخارج لا يحسب على المستوى المالي فحسب بل على '
        'المستوى السياسي أيضاً.',
    button3: 'تصفح المعرض',
    heading1: 'عنوان',
    column1:
        'تذكر دائماً أن الحاسوب لا يمتلك ذكاءً، ولكنه يكتسب الذكاء الاصطناعي '
        'من خلال ثلاثة عناصر وظيفية رئيسة، هي: القدرة على التحليل، والقدرة '
        'على التأليف، والاستدلال المنطقي.',
    heading2: 'عنوان آخر',
    column2:
        'إذا أردنا استخدام الحاسوب الذكي في معالجة اللغة العربية فإننا نجد '
        'أنفسنا أمام تحدٍّ كبير، خاصة وأن لغتنا تمتاز بتماسك منظوماتها '
        'وتداخلها، ومع ذلك فإن الذكاء الاصطناعي يمكّننا من الحصول على أربعة '
        'أنواع من المعالجة، هي: المعالجة الصوتية، والمعالجة الصرفية، '
        'والمعالجة النحوية، والمعالجة الدلالية.',
    heading3: 'عنوان ثالث لتأكيد المعلومة',
    column3:
        'بفضل بحوث الذكاء الاصطناعي وتقنياته استطعنا الانتقال من مرحلة '
        'التعامل مع الفيزيائي إلى مرحلة التعامل مع المنطقي، وقد انعكس هذا '
        'الانتقال بصورة إيجابية على الكيفية التي تتعامل بها الشعوب مع لغاتها '
        'الحيَّة، وهذا يعني أنه يجب أن ينعكس بصورة إيجابية على كيفية تعاملنا '
        'مع لغتنا العربية.',
    details: 'عرض التفاصيل',
    featurette1: 'العنوان الأول المميز. ',
    muted1: 'سيذهل عقلك.',
    lead1:
        'وجه الإنسان هو جزء معقَّد ومتميِّز للغاية من جسمه. وفي الواقع، إنه '
        'أحد أكثر أنظمة الإشارات المتاحة تعقيداً لدينا؛ فهو يتضمَّن أكثر من '
        '40 عضلة مستقلة هيكلياً ووظيفياً، بحيث يمكن تشغيل كل منها بشكل مستقل '
        'عن البعض الآخر؛ وتشكِّل أحد أقوى مؤشرات العواطف.',
    featurette2: 'أوه نعم، هذا جيد. ',
    muted2: 'شاهد بنفسك.',
    lead2:
        'عندما نضحك أو نبكي، فإننا نعرض عواطفنا، مما يسمح للآخرين بإلقاء نظرة '
        'خاطفة على أذهاننا أثناء "قراءة" وجوهنا بناءً على التغييرات في '
        'مكوّنات الوجه الرئيسة، مثل: العينين والحاجبين والجفنين والأنف '
        'والشفتين.',
    featurette3: 'وأخيرًا، هذا. ',
    muted3: 'كش ملك.',
    lead3:
        'إن جميع العضلات في أجسامنا مدعمة بالأعصاب المتصلة من كافة أنحاء '
        'الجسم بالنخاع الشوكي والدماغ. وهذا الاتصال العصبي هو ثنائي الاتجاه، '
        'أي إن العصب يتسبَّب في تقلصات العضلات بناءً على إشارات الدماغ، ويقوم '
        'في الوقت نفسه بإرسال معلومات عن حالة العضلات إلى الدماغ',
    backToTop: 'عد إلى الأعلى',
    privacy: 'سياسة الخصوصية',
    terms: 'شروط الاستخدام',
  );
}
