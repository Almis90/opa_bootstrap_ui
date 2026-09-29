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
        DocExample(
          title: 'Events and refresh',
          description:
              "onActivate fires whenever the active section changes, mirroring Bootstrap's activate.bs.scrollspy "
              "— separate from the ChangeNotifier's own generic notification, so it only fires for an actual "
              "section change rather than every rebuild-triggering update. refresh() recalculates the active "
              'section immediately instead of waiting for the next scroll — call it after content changes that '
              'could move a tracked section, like the height toggle below.',
          code: '''
final scrollspy = BsScrollspyController(
  scrollController: scrollController,
  sectionKeys: sectionKeys,
  onActivate: (index) => log('activate \$index'),
);

// After changing content that could move a section (e.g. expanding one):
scrollspy.refresh();''',
          preview: const SizedBox(height: 440, child: _EventsDemo()),
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

class _EventsDemo extends StatefulWidget {
  const _EventsDemo();

  @override
  State<_EventsDemo> createState() => _EventsDemoState();
}

class _EventsDemoState extends State<_EventsDemo> {
  static const _sections = ['Introduction', 'Approach', 'Content', 'Summary'];

  final _scrollController = ScrollController();
  late final _sectionKeys = List.generate(_sections.length, (_) => GlobalKey());
  late final _scrollspy = BsScrollspyController(
    scrollController: _scrollController,
    sectionKeys: _sectionKeys,
    offset: 16,
    onActivate: (index) => _log('activate $index'),
  );

  bool _expanded = false;
  final _events = <String>[];

  void _log(String event) => setState(() => _events.add(event));

  @override
  void dispose() {
    _scrollspy.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            BsButton(
              size: BsSize.sm,
              onPressed: () => setState(() {
                _expanded = !_expanded;
                // The first section just changed height, which can shift
                // which section is active without any scrolling — refresh()
                // recalculates that immediately instead of waiting for the
                // next scroll event.
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollspy.refresh());
              }),
              child: Text(_expanded ? 'Shrink first section' : 'Expand first section'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
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
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: _events.isEmpty
              ? Text('No events yet — scroll the pane.', style: TextStyle(color: BsBody.secondaryColorOf(context)))
              : SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final event in _events) BsBadge(variant: BsVariant.secondary, child: Text(event))],
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
        height: index == 0 && _expanded ? 260 : 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_sections[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Section content.'),
          ],
        ),
      ),
    );
  }
}
