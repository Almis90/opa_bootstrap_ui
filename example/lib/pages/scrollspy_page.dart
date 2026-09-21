import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

class ScrollspyPage extends StatefulWidget {
  const ScrollspyPage({super.key});

  @override
  State<ScrollspyPage> createState() => _ScrollspyPageState();
}

class _ScrollspyPageState extends State<ScrollspyPage> {
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
    return ColoredBox(
      color: BsColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: Navigator.of(context).pop,
                        child: const Text('< Back', style: TextStyle(color: BsColors.blue)),
                      ),
                    ),
                  const Text('Scrollspy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(height: 1, color: BsBorders.color),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ListenableBuilder(
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
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [for (var i = 0; i < _sections.length; i++) _buildSection(i)],
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

  Widget _buildSection(int index) {
    return Padding(
      key: _sectionKeys[index],
      padding: const EdgeInsets.only(bottom: 32),
      child: SizedBox(
        height: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_sections[index], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Scroll this pane — the nav on the left highlights whichever '
              'section is currently at the top of the viewport, and tapping '
              'a nav item scrolls straight to its section.',
            ),
          ],
        ),
      ),
    );
  }
}
