/// The texts of the Blog examples (`examples/blog` and `examples/blog-rtl`):
/// the English original and the Arabic translation, verbatim, as data.
library;

/// How a run of text in a [BlogParagraph] is styled.
enum BlogInlineKind { text, link, strong, em, code, abbr, cite, del, ins, sup, sub }

/// A run of inline text (`<a>`, `<strong>`, `<code>`…).
class BlogInline {
  const BlogInline(this.kind, this.text);

  final BlogInlineKind kind;
  final String text;
}

/// A block of a post's body.
sealed class BlogBlock {
  const BlogBlock();
}

class BlogParagraph extends BlogBlock {
  const BlogParagraph(this.inlines);
  final List<BlogInline> inlines;
}

class BlogHeading extends BlogBlock {
  const BlogHeading(this.level, this.text);
  final int level;
  final String text;
}

class BlogRule extends BlogBlock {
  const BlogRule();
}

/// `<blockquote class="blockquote">` ([styled]) or a plain `<blockquote>`.
class BlogQuote extends BlogBlock {
  const BlogQuote(this.styled, this.inlines);
  final bool styled;
  final List<BlogInline> inlines;
}

class BlogList extends BlogBlock {
  const BlogList(this.ordered, this.items);
  final bool ordered;
  final List<List<BlogInline>> items;
}

class BlogDefinitionList extends BlogBlock {
  const BlogDefinitionList(this.entries);

  /// `(<dt>, <dd>)`.
  final List<(List<BlogInline>, List<BlogInline>)> entries;
}

class BlogPre extends BlogBlock {
  const BlogPre(this.text);
  final String text;
}

class BlogTable extends BlogBlock {
  const BlogTable(this.head, this.body, this.foot);
  final List<List<String>> head;
  final List<List<String>> body;
  final List<List<String>> foot;
}

/// An `<article class="blog-post">`.
class BlogPost {
  const BlogPost(this.title, this.meta, this.blocks);

  final String title;

  /// `.blog-post-meta`.
  final List<BlogInline> meta;
  final List<BlogBlock> blocks;
}

/// One of the two wide featured cards.
class BlogCard {
  const BlogCard({
    required this.category,
    required this.title,
    required this.date,
    required this.text,
    required this.link,
  });

  final String category;
  final String title;
  final String date;
  final String text;
  final String link;
}

BlogInline _t(String s) => BlogInline(BlogInlineKind.text, s);
BlogInline _a(String s) => BlogInline(BlogInlineKind.link, s);
BlogInline _strong(String s) => BlogInline(BlogInlineKind.strong, s);
BlogInline _em(String s) => BlogInline(BlogInlineKind.em, s);
BlogInline _code(String s) => BlogInline(BlogInlineKind.code, s);
BlogInline _abbr(String s) => BlogInline(BlogInlineKind.abbr, s);
BlogInline _cite(String s) => BlogInline(BlogInlineKind.cite, s);
BlogInline _del(String s) => BlogInline(BlogInlineKind.del, s);
BlogInline _ins(String s) => BlogInline(BlogInlineKind.ins, s);
BlogInline _sup(String s) => BlogInline(BlogInlineKind.sup, s);
BlogInline _sub(String s) => BlogInline(BlogInlineKind.sub, s);

BlogBlock _p(List<BlogInline> i) => BlogParagraph(i);
BlogBlock _h2(String s) => BlogHeading(2, s);
BlogBlock _h3(String s) => BlogHeading(3, s);
BlogBlock _hr() => const BlogRule();
BlogBlock _blockquote(bool styled, List<BlogInline> i) => BlogQuote(styled, i);
BlogBlock _ul(List<List<BlogInline>> items) => BlogList(false, items);
BlogBlock _ol(List<List<BlogInline>> items) => BlogList(true, items);
BlogBlock _dl(List<(List<BlogInline>, List<BlogInline>)> e) => BlogDefinitionList(e);
BlogBlock _pre(String s) => BlogPre(s);
BlogBlock _table(List<List<String>> head, List<List<String>> body, List<List<String>> foot) =>
    BlogTable(head, body, foot);
BlogPost _post(String title, List<BlogInline> meta, List<BlogBlock> blocks) => BlogPost(title, meta, blocks);

class BlogContent {
  BlogContent({
    required this.subscribe,
    required this.logo,
    required this.searchLabel,
    required this.signUp,
    required this.nav,
    required this.featuredTitle,
    required this.featuredLede,
    required this.featuredLink,
    required this.cards,
    required this.thumbnail,
    required this.firehose,
    required this.posts,
    required this.older,
    required this.newer,
    required this.aboutTitle,
    required this.aboutText,
    required this.recentTitle,
    required this.recent,
    required this.archivesTitle,
    required this.archives,
    required this.elsewhereTitle,
    required this.elsewhere,
    required this.footerText,
    required this.backToTop,
  });

  final String subscribe;
  final String logo;
  final String searchLabel;
  final String signUp;
  final List<String> nav;
  final String featuredTitle;
  final String featuredLede;
  final String featuredLink;
  final List<BlogCard> cards;
  final String thumbnail;
  final String firehose;
  final List<BlogPost> posts;
  final String older;
  final String newer;
  final String aboutTitle;
  final String aboutText;
  final String recentTitle;

  /// `(title, date)`.
  final List<(String, String)> recent;
  final String archivesTitle;
  final List<String> archives;
  final String elsewhereTitle;
  final List<String> elsewhere;
  final List<BlogInline> footerText;
  final String backToTop;

  static final en = BlogContent(
    subscribe: 'Subscribe',
    logo: 'Large',
    searchLabel: 'Search',
    signUp: 'Sign up',
    nav: ['World', 'U.S.', 'Technology', 'Design', 'Culture', 'Business', 'Politics', 'Opinion', 'Science', 'Health', 'Style', 'Travel'],
    featuredTitle: 'Title of a longer featured blog post',
    featuredLede: 'Multiple lines of text that form the lede, informing new readers quickly and efficiently about what’s most interesting in this post’s contents.',
    featuredLink: 'Continue reading...',
    cards: [
      BlogCard(category: 'World', title: 'Featured post', date: 'Nov 12', text: 'This is a wider card with supporting text below as a natural lead-in to additional content.', link: 'Continue reading'),
      BlogCard(category: 'Design', title: 'Post title', date: 'Nov 11', text: 'This is a wider card with supporting text below as a natural lead-in to additional content.', link: 'Continue reading'),
    ],
    thumbnail: 'Thumbnail',
    firehose: 'From the Firehose',
    posts: [
      _post('Sample blog post', [_t('January 1, 2021 by '), _a('Mark')], [
        _p([_t('This blog post shows a few different types of content that’s supported and styled with Bootstrap. Basic typography, lists, tables, images, code, and more are all supported as expected.')]),
        _hr(),
        _p([_t('This is some additional paragraph placeholder content. It has been written to fill the available space and show how a longer snippet of text affects the surrounding content. We\'ll repeat it often to keep the demonstration flowing, so be on the lookout for this exact same string of text.')]),
        _h2('Blockquotes'),
        _p([_t('This is an example blockquote in action:')]),
        _blockquote(true, [_t('Quoted text goes here.')]),
        _p([_t('This is some additional paragraph placeholder content. It has been written to fill the available space and show how a longer snippet of text affects the surrounding content. We\'ll repeat it often to keep the demonstration flowing, so be on the lookout for this exact same string of text.')]),
        _h3('Example lists'),
        _p([_t('This is some additional paragraph placeholder content. It\'s a slightly shorter version of the other highly repetitive body text used throughout. This is an example unordered list:')]),
        _ul([[_t('First list item')], [_t('Second list item with a longer description')], [_t('Third list item to close it out')]]),
        _p([_t('And this is an ordered list:')]),
        _ol([[_t('First list item')], [_t('Second list item with a longer description')], [_t('Third list item to close it out')]]),
        _p([_t('And this is a definition list:')]),
        _dl([([_t('HyperText Markup Language (HTML)')], [_t('The language used to describe and define the content of a Web page')]), ([_t('Cascading Style Sheets (CSS)')], [_t('Used to describe the appearance of Web content')]), ([_t('JavaScript (JS)')], [_t('The programming language used to build advanced Web sites and applications')])]),
        _h2('Inline HTML elements'),
        _p([_t('HTML defines a long list of available inline tags, a complete list of which can be found on the '), _a('Mozilla Developer Network'), _t('.')]),
        _ul([[_strong('To bold text'), _t(', use '), _code('<strong>'), _t('.')], [_em('To italicize text'), _t(', use '), _code('<em>'), _t('.')], [_t('Abbreviations, like '), _abbr('HTML'), _t(' should use '), _code('<abbr>'), _t(', with an optional '), _code('title'), _t(' attribute for the full phrase.')], [_t('Citations, like '), _cite('— Mark Otto'), _t(', should use '), _code('<cite>'), _t('.')], [_del('Deleted'), _t(' text should use '), _code('<del>'), _t(' and '), _ins('inserted'), _t(' text should use '), _code('<ins>'), _t('.')], [_t('Superscript '), _sup('text'), _t(' uses '), _code('<sup>'), _t(' and subscript '), _sub('text'), _t(' uses '), _code('<sub>'), _t('.')]]),
        _p([_t('Most of these elements are styled by browsers with few modifications on our part.')]),
        _h2('Heading'),
        _p([_t('This is some additional paragraph placeholder content. It has been written to fill the available space and show how a longer snippet of text affects the surrounding content. We\'ll repeat it often to keep the demonstration flowing, so be on the lookout for this exact same string of text.')]),
        _h3('Sub-heading'),
        _p([_t('This is some additional paragraph placeholder content. It has been written to fill the available space and show how a longer snippet of text affects the surrounding content. We\'ll repeat it often to keep the demonstration flowing, so be on the lookout for this exact same string of text.')]),
        _pre('Example code block'),
        _p([_t('This is some additional paragraph placeholder content. It\'s a slightly shorter version of the other highly repetitive body text used throughout.')]),
      ]),
      _post('Another blog post', [_t('December 23, 2020 by '), _a('Jacob')], [
        _p([_t('This is some additional paragraph placeholder content. It has been written to fill the available space and show how a longer snippet of text affects the surrounding content. We\'ll repeat it often to keep the demonstration flowing, so be on the lookout for this exact same string of text.')]),
        _blockquote(false, [_t('Longer quote goes here, maybe with some '), _strong('emphasized text'), _t(' in the middle of it.')]),
        _p([_t('This is some additional paragraph placeholder content. It has been written to fill the available space and show how a longer snippet of text affects the surrounding content. We\'ll repeat it often to keep the demonstration flowing, so be on the lookout for this exact same string of text.')]),
        _h3('Example table'),
        _p([_t('And don\'t forget about tables in these posts:')]),
        _table([['Name', 'Upvotes', 'Downvotes']], [['Alice', '10', '11'], ['Bob', '4', '3'], ['Charlie', '7', '9']], [['Totals', '21', '23']]),
        _p([_t('This is some additional paragraph placeholder content. It\'s a slightly shorter version of the other highly repetitive body text used throughout.')]),
      ]),
      _post('New feature', [_t('December 14, 2020 by '), _a('Chris')], [
        _p([_t('This is some additional paragraph placeholder content. It has been written to fill the available space and show how a longer snippet of text affects the surrounding content. We\'ll repeat it often to keep the demonstration flowing, so be on the lookout for this exact same string of text.')]),
        _ul([[_t('First list item')], [_t('Second list item with a longer description')], [_t('Third list item to close it out')]]),
        _p([_t('This is some additional paragraph placeholder content. It\'s a slightly shorter version of the other highly repetitive body text used throughout.')]),
      ]),
    ],
    older: 'Older',
    newer: 'Newer',
    aboutTitle: 'About',
    aboutText: 'Customize this section to tell your visitors a little bit about your publication, writers, content, or something else entirely. Totally up to you.',
    recentTitle: 'Recent posts',
    recent: [('Example blog post title', 'January 15, 2024'), ('This is another blog post title', 'January 14, 2024'), ('Longer blog post title: This one has multiple lines!', 'January 13, 2024')],
    archivesTitle: 'Archives',
    archives: ['March 2021', 'February 2021', 'January 2021', 'December 2020', 'November 2020', 'October 2020', 'September 2020', 'August 2020', 'July 2020', 'June 2020', 'May 2020', 'April 2020'],
    elsewhereTitle: 'Elsewhere',
    elsewhere: ['GitHub', 'Social', 'Facebook'],
    footerText: [_t('Blog template built for '), _a('Bootstrap'), _t(' by '), _a('@mdo'), _t('.')],
    backToTop: 'Back to top',
  );

  static final ar = BlogContent(
    subscribe: 'الإشتراك في النشرة البريدية',
    logo: 'كبير',
    searchLabel: 'بحث',
    signUp: 'إنشاء حساب',
    nav: ['العالم', 'الولايات المتحدة', 'التقنية', 'التصميم', 'الحضارة', 'المال والأعمال', 'السياسة', 'الرأي العام', 'العلوم', 'الصحة', 'الموضة', 'السفر'],
    featuredTitle: 'عنوان تدوينة مميزة أطول',
    featuredLede: 'عدة أسطر نصية متعددة تعبر عن التدوية، وذلك لإعلام القراء الجدد بسرعة وكفاءة حول أكثر الأشياء إثارة للاهتمام في محتويات هذه التدوينة.',
    featuredLink: 'أكمل القراءة...',
    cards: [
      BlogCard(category: 'العالم', title: 'مشاركة مميزة', date: 'نوفمبر 12', text: 'هذه بطاقة أوسع مع نص داعم أدناه كمقدمة طبيعية لمحتوى إضافي.', link: 'أكمل القراءة'),
      BlogCard(category: 'التصميم', title: 'عنوان الوظيفة', date: 'نوفمبر 11', text: 'هذه بطاقة أوسع مع نص داعم أدناه كمقدمة طبيعية لمحتوى إضافي.', link: 'أكمل القراءة'),
    ],
    thumbnail: 'صورة مصغرة',
    firehose: 'من Firehose',
    posts: [
      _post('مثال على تدوينة', [_t('1 يناير 2021 بواسطة '), _a('Mark')], [
        _p([_t('تعرض مشاركة المدونة هذه بضعة أنواع مختلفة من المحتوى الذي يتم دعمه وتصميمه باستخدام Bootstrap. النصوص الأساسية، الصور، والأكواد مدعومة بشكل كامل.')]),
        _hr(),
        _p([_t('يشكِّل تأمين الغذاء في المستقبل قضية تؤرِّق حكومات العالَم والعلماء على حدٍّ سواء. فخلال القرن العشرين ازداد عدد سكان الأرض أربعة أضعاف، وتشير التقديرات إلى أن العدد سوف يصل إلى عشرة مليارات إنسان بحلول عام 2050م. وسوف تمثل هذه الزيادة الهائلة تحدياً كبيراً وضغطاً متصاعداً على قدرة الإنتاج الزراعي. الأمر الذي كان ولا بد من أن يدفع إلى تطوير تقنيات مبتكرة في تصنيع الغذاء غير الزراعة، منها تقنية مستقبلية تقوم على تصنيع الغذاء من الهواء.')]),
        _blockquote(true, [_t('تشغل الزراعة مساحات كبيرة من اليابسة، وتستهلك كميات هائلة من المياه، كما أن إنتاج الغذاء بواسطة الزراعة يسهم بنسبة عالية من انبعاثات غازات الاحتباس الحراري العالمية')]),
        _p([_t('تشغل الزراعة مساحات كبيرة من اليابسة، وتستهلك كميات هائلة من المياه. كما أن إنتاج الغذاء بواسطة الزراعة يسهم بنسبة عالية من انبعاثات غازات الاحتباس الحراري العالمية، وللمقارنة فإن هذه النسبة من الانبعاثات هي أكبر مما ينتجه قطاع النقل بكل ما فيه من سيارات وشاحنات وطائرات وقطارات.')]),
        _h2('عنوان'),
        _p([_t('تحصل النباتات على غذائها بواسطة عملية تسمى البناء الضوئي، حيث تقوم النباتات بتحويل ضوء الشمس والماء وثاني أكسيد الكربون الموجود في الغلاف الجوي إلى غذاء وتطلق الأكسجين كمنتج ثانوي لهذا التفاعل الكيميائي. وتحدث هذه العملية في "البلاستيدات الخضراء". فالنباتات تستفيد من طاقة ضوء الشمس في تقسيم الماء إلى هيدروجين وأكسجين، وتحدث تفاعلات كيميائية أخرى ينتج عنها سكر الجلكوز الذي تستخدمه كمصدر للغذاء وينطلق الأكسجين من النباتات إلى الغلاف الجوي. وهذا يعني أن النباتات تحوِّل ثاني أكسيد الكربون إلى غذاء من خلال تفاعلات كيميائية معقَّدة. ويُعد البناء الضوئي من أهم التفاعلات الكيميائية على كوكب الأرض، فقد ساعد في الماضي على تطوُّر كوكبنا وظهور الحياة عليه. فالنباتات تستخدم ثاني أكسيد الكربون لصنع غذائها، وتطلق الأكسجين لتساعد الكائنات الأخرى على التنفس!')]),
        _h3('عنوان فرعي'),
        _p([_t('ألهمت هذه العملية علماء وكالة الفضاء الأمريكية (ناسا) خلال الستينيات من القرن الماضي، لبحث فكرة إطعام روَّاد الفضاء في مهمات الفضاء الطويلة مثل السفر إلى المريخ. وكانت واحدة من الأفكار الواعدة تصنيع الغذاء عن طريق ثاني أكسيد الكربون الذي ينتجه روَّاد الفضاء، لكن ليس بواسطة النباتات بل عن طريق ميكروبات صغيرة وحيدة الخلية قادرة على حصد ثاني أكسيد الكربون لإنتاج كميات وفيرة من البروتين المغذي على شكل مسحوق عديم النكهة، كما يمكن استخدام المادة في صنع الأطعمة المألوفة لدينا.')]),
        _pre('Example code block'),
        _p([_t('وخلافاً لما هو الحال في عالم النبات، فإن هذه الميكروبات لا تستخدم الضوء كما يحدث في عملية البناء الضوئي التي تستخدمها النباتات للحصول على الغذاء، أي لأنها قادرة على النمو في الظلام. تسمى هذه البكتريا "هيدروجينوتروف" (Hydrogenotrophs)، وهي تستخدم الهيدروجين كوقود لإنتاج الغذاء من ثاني أكسيد الكربون. فعندما يُنتج روَّاد الفضاء ثاني أكسيد الكربون، تلتقطه الميكروبات، ويتحوَّل مع مدخلات أخرى إلى غذاء غني بالكربون. وبهذه الطريقة سوف نحصل على دورة كربون مغلقة الحلقة.')]),
        _h3('عنوان فرعي'),
        _p([_t('بعد مرور أكثر من نصف قرن على أبحاث ناسا، تعمل حالياً عدة شركات في قطاع البيولوجيا التركيبية من ضمنها إير بروتين (Air Protein) وسولار فودز (Solar Foods) على تطوير جيل جديد من المنتجات الغذائية المستدامة، من دون وجود بصمة كربونية. ولن تقتصر هذه المنتجات الغذائية على روَّاد الفضاء فحسب، بل سوف تمتد لتشمل جميع سكان الأرض، وسوف تُنتَج في فترة زمنية قصيرة، بدلاً من الشهور، ومن دون الاعتماد على الأراضي الزراعية. وهذا يعني الحصول على منتجات غذائية بشكل سريع جداً. كما سيصبح من الممكن تصنيع الغذاء بطريقة عمودية من خلال هذه الميكروبات، بدلاً من الطريقة الأفقية التقليدية الشبيهة بتقنية الزراعة العمودية الحديثة. وهذا يعني توفير منتجات غذائية أكبر من المساحة نفسها.')]),
        _p([_t('يتكوَّن الغذاء البشري من ثلاثة أنواع رئيسة، هي:')]),
        _ul([[_t('البروتينات')], [_t('الكربوهيدرات')], [_t('الدهون')]]),
        _p([_t('وتتكوَّن البروتينات من الأحماض الأمينية، وهي مجموعة من المركبات العضوية يبلغ عددها في جسم الإنسان عشرين حمضاً أمينياً، من بينها تسعة أساسية يحصل عليها الجسم من الغذاء. وتتكوَّن الأحماض الأمينية بشكل أساس من:')]),
        _ol([[_t('الكربون')], [_t('الهيدروجين')], [_t('الأكسجين')], [_t('النيتروجين')]]),
        _p([_t('ومن الملاحظ أن النيتروجين يشكِّل نسبة %78 من الهواء، كما أن الهيدروجين نحصل عليه من خلال التحليل الكهربائي للماء، ومن الممكن نظرياً سحب الكربون من الهواء لتشكيل هذه الأحماض، ذلك أن الكربون هو العمود الفقري للأحماض الأمينية، كما أن الحياة على كوكب الأرض قائمة على الكربون لقدرته على تكوين سلاسل كربونية طويلة، وهذا ما تفعله الميكروبات بتصنيع أحماض أمينية من ثاني أكسيد الكربون من خلال مجموعة من التفاعلات الكيميائية المعقَّدة. وإضافة إلى صنع وجبات غنية بالبروتين، فهذه الميكروبات تنتج منتجات أخرى مثل الزيوت التي لها عديد من الاستخدامات.')]),
      ]),
      _post('تدوينة أخرى', [_t('23 ديسمبر 2020 بواسطة '), _a('Jacob')], [
        _p([_t('في الوقت الحالي، تدرس عدَّة شركات هذه الميكروبات بشكل أعمق، وتستزرعها من أجل الحصول على الغذاء. ففي عام 2019م، أعلن باحثون في شركة (Air Protein) الأمريكية نجاحهم في تحويل ثاني أكسيد الكربون الموجود في الهواء إلى لحوم صناعية مصنوعة من البروتين، التي لا تتطلَّب أي أرض زراعية، بل هي معتمدة بشكل أساسي على الهواء.')]),
        _blockquote(false, [_t('تم تصنيع اللحوم بأنواع عديدة')]),
        _p([_t('إذ استخدم هؤلاء الباحثون الهواء والطاقة المتجدِّدة كمدخلات في عملية مشابهة للتخمير، لإنتاج بروتين يحتوي على الأحماض الأمينية التسعة الأساسية وغني بالفيتامينات والمعادن، كما أنه خالٍ من الهرمونات والمضادات الحيوية والمبيدات الحشرية ومبيدات الأعشاب.')]),
        _p([_t('وتم تصنيع اللحوم بأنواع عديدة بما فيها الدواجن والأبقار والمأكولات البحرية، من دون حصول انبعاثات كربونية، على عكس تربية الأبقار التي تسهم في انبعاث غاز الميثان أحد غازات الاحتباس الحراري.')]),
      ]),
      _post('ميزة جديدة', [_t('14 ديسمبر 2020 بواسطة '), _a('Jacob')], [
        _p([_t('كما أن الشركة الفنلندية (Solar Foods) طوَّرت تقنية لإنتاج البروتين من الهواء، حيث تبدأ العملية بتقسيم الماء إلى مكوناته الهيدروجين والأكسجين عن طريق الكهرباء. فالهيدروجين يوفِّر الطاقة للبكتريا لتحويل ثاني أكسيد الكربون والنيتروجين الموجودين في الهواء إلى مادة عضوية غنية بالبروتين بشكل أكفأ من نمو النباتات باستخدام البناء الضوئي. وهذا البروتين يشبه دقيق القمح وقد أطلق عليه اسم "سولين" (Solein).')]),
        _p([_t('وتقوم الشركة حالياً بجمع البيانات حول المنتج الغذائي لتقديمه إلى الاتحاد الأوروبي بهدف الحصول على ترخيص غذائي، كما أنها تخطط لبدء الإنتاج التجاري في العام المقبل 2021م. وقد أوضحت الشركة أنها مهتمة بإنتاج أطعمة صديقة للبيئة من خلال استخدام المواد الأساسية: الكهرباء وثاني أكسيد الكربون، وهذه الأطعمة سوف تجنبنا الأثر السلبي البيئي للزراعة التقليدية الذي يشمل كل شيء من استخدام الأرض والمياه إلى الانبعاثات الناتجة من تسميد المحاصيل أو تربية الحيوانات.')]),
        _p([_t('وعلى هذا، فإن البروتينات المشتقة من الميكروبات سوف:')]),
        _ul([[_t('توفر حلاً ممكناً في ظل زيادة الطلب العالمي المستقبلي على الغذاء')], [_t('تتوسع مصانع الغذاء في المستقبل لتكون أكفأ وأكثر استدامة')], [_t('تصبح قادرة على توفير الغذاء لروَّاد الفضاء في سفرهم إلى المريخ وجميع سكان كوكب الأرض في عام 2050م')]]),
        _p([_t('فتخيّل أن الميكروبات ستكون مصانع المستقبل، وأن غذاء المستقبل سيكون مصنوعاً من الهواء! وأن عام 2050م سيكون مختلفاً تماماً عن عالمنا اليوم. فهو عالم من دون زراعة ولا تربية حيوانات من أجل الغذاء! قد يبدو ذلك خيالياً لكنه ليس مستحيلاً!')]),
      ]),
    ],
    older: 'تدوينات أقدم',
    newer: 'تدوينات أحدث',
    aboutTitle: 'حول',
    aboutText: 'أقبلت، فأقبلت معك الحياة بجميع صنوفها وألوانها: فالنبات ينبت، والأشجار تورق وتزهر، والهرة تموء، والقمري يسجع، والغنم يثغو، والبقر يخور، وكل أليف يدعو أليفه. كل شيء يشعر بالحياة وينسي هموم الحياة، ولا يذكر إلا سعادة الحياة، فإن كان الزمان جسدا فأنت روحه، وإن كان عمرا فأنت شبابه.',
    recentTitle: 'المشاركات الاخيرة',
    recent: [('مثال على عنوان منشور المدونة', '15 يناير 2024'), ('هذا عنوان آخر للمدونة', '14 يناير 2024'), ('أطول عنوان منشور للمدونة: يحتوي هذا الخط على عدة أسطر!', '13 يناير 2024')],
    archivesTitle: 'الأرشيف',
    archives: ['مارس 2021', 'شباط 2021', 'يناير 2021', 'ديسمبر 2020', 'نوفمبر 2020', 'أكتوبر 2020', 'سبتمبر 2020', 'اغسطس 2020', 'يوليو 2020', 'يونيو 2020', 'مايو 2020', 'ابريل 2020'],
    elsewhereTitle: 'في مكان آخر',
    elsewhere: ['GitHub', 'Social', 'Facebook'],
    footerText: [_t('تم تصميم نموذج المدونة لـ '), _a('Bootstrap'), _t(' بواسطة '), _a('\u2066@mdo\u2069'), _t('.')],
    backToTop: 'عد إلى الأعلى',
  );
}
