import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class PaginationPage extends StatefulWidget {
  const PaginationPage({super.key});

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Pagination',
      children: [
        DemoSection(
          title: 'Basic (numbered, with prev/next)',
          child: BsPagination(
            items: BsPagination.numberedItems(
              pageCount: 5,
              currentPage: _currentPage,
              onSelect: (page) => setState(() => _currentPage = page),
            ),
          ),
        ),
        Text('Current page: $_currentPage'),
        const SizedBox(height: 24),
        const DemoSection(
          title: 'Disabled and active states',
          child: BsPagination(
            items: [
              BsPaginationItem(child: Text('‹'), disabled: true),
              BsPaginationItem(child: Text('1')),
              BsPaginationItem(child: Text('2'), active: true),
              BsPaginationItem(child: Text('3')),
              BsPaginationItem(child: Text('›')),
            ],
          ),
        ),
        DemoSection(
          title: 'No prev/next',
          child: BsPagination(
            items: BsPagination.numberedItems(
              pageCount: 3,
              currentPage: 1,
              onSelect: (_) {},
              showPrevNext: false,
            ),
          ),
        ),
      ],
    );
  }
}
