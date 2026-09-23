import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ScrollspyPage extends StatelessWidget {
  const ScrollspyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Scrollspy',
      lead:
          'BsScrollspyController is a plain ChangeNotifier, not a widget: attach it to a ScrollController and a '
          'list of section GlobalKeys, and it tracks which section is currently at the top of the viewport so a '
          'BsNav (or any other widget) can highlight the matching item via a ListenableBuilder.',
      examples: [
        DocExample(
          title: 'Nav synced to scroll position',
          description:
              'Scroll the right-hand pane — the vertical pill nav on the left highlights whichever section is '
              'current, and tapping a nav item scrolls straight to its section.',
          code: '''
final scrollController = ScrollController();
final sectionKeys = List.generate(sections.length, (_) => GlobalKey());
final scrollspy = BsScrollspyController(
  scrollController: scrollController,
  sectionKeys: sectionKeys,
  offset: 16,
);

Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ListenableBuilder(
      listenable: scrollspy,
      builder: (context, _) => BsNav(
        variant: BsNavVariant.pills,
        vertical: true,
        items: [
          for (var i = 0; i < sections.length; i++)
            BsNavItem(
              child: Text(sections[i]),
              active: i == scrollspy.activeIndex,
              onTap: () => scrollspy.scrollToSection(i),
            ),
        ],
      ),
    ),
    Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            for (var i = 0; i < sections.length; i++)
              Container(key: sectionKeys[i], child: sectionContent(i)),
          ],
        ),
      ),
    ),
  ],
)''',
          preview: const SizedBox(height: 320, child: _ScrollspyDemo()),
        ),
      ],
    );
  }
}

class _ScrollspyDemo extends StatefulWidget {
  const _ScrollspyDemo();

  @override
  State<_ScrollspyDemo> createState() => _ScrollspyDemoState();
}

class _ScrollspyDemoState extends State<_ScrollspyDemo> {
  static const _sections = ['Introduction', 'Approach', 'Content', 'Summary'];

  final _scrollController = ScrollController();
  late final _sectionKeys = List.generate(_sections.length, (_) => GlobalKey());
  late final _scrollspy = BsScrollspyController(
    scrollController: _scrollController,
    sectionKeys: _sectionKeys,
    offset: 16,
  );

  @override
  void dispose() {
    _scrollspy.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListenableBuilder(
          listenable: _scrollspy,
          builder: (context, _) => BsNav(
            variant: BsNavVariant.pills,
            vertical: true,
            items: [
              for (var i = 0; i < _sections.length; i++)
                BsNavItem(
                  child: Text(_sections[i]),
                  active: i == _scrollspy.activeIndex,
                  onTap: () => _scrollspy.scrollToSection(i),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (var i = 0; i < _sections.length; i++) _buildSection(i)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(int index) {
    return Padding(
      key: _sectionKeys[index],
      padding: const EdgeInsets.only(bottom: 24),
      child: SizedBox(
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_sections[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              'Scroll this pane — the nav on the left highlights whichever section '
              'is currently at the top of the viewport.',
            ),
          ],
        ),
      ),
    );
  }
}
