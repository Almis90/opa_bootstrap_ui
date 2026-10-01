import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

class PaginationPage extends StatefulWidget {
  const PaginationPage({super.key});

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Pagination',
      lead:
          'BsPagination renders a row of BsPaginationItems, with BsPagination.numberedItems as a helper that '
          'builds the numbered-page-plus-prev/next sequence from a page count and the currently selected page.',
      examples: [
        DocExample(
          title: 'Basic (numbered, with prev/next)',
          description: 'numberedItems keeps the active page in sync with the onSelect callback and local state.',
          code: '''
BsPagination(
  items: BsPagination.numberedItems(
    pageCount: 5,
    currentPage: currentPage,
    onSelect: (page) => setState(() => currentPage = page),
  ),
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsPagination(
                items: BsPagination.numberedItems(
                  pageCount: 5,
                  currentPage: _currentPage,
                  onSelect: (page) => setState(() => _currentPage = page),
                ),
              ),
              const SizedBox(height: 12),
              Text('Current page: $_currentPage'),
            ],
          ),
        ),
        DocExample(
          title: 'Disabled and active states',
          description: 'Individual BsPaginationItems can be marked disabled or active independent of the numbered helper.',
          code: '''
BsPagination(
  items: [
    BsPaginationItem(child: Text('‹'), disabled: true),
    BsPaginationItem(child: Text('1')),
    BsPaginationItem(child: Text('2'), active: true),
    BsPaginationItem(child: Text('3')),
    BsPaginationItem(child: Text('›')),
  ],
)''',
          preview: const BsPagination(
            items: [
              BsPaginationItem(child: Text('‹'), disabled: true),
              BsPaginationItem(child: Text('1')),
              BsPaginationItem(child: Text('2'), active: true),
              BsPaginationItem(child: Text('3')),
              BsPaginationItem(child: Text('›')),
            ],
          ),
        ),
        DocExample(
          title: 'No prev/next',
          description: 'showPrevNext: false drops the leading and trailing arrow items from numberedItems.',
          code: '''
BsPagination(
  items: BsPagination.numberedItems(
    pageCount: 3,
    currentPage: 1,
    onSelect: (_) {},
    showPrevNext: false,
  ),
)''',
          preview: BsPagination(
            items: BsPagination.numberedItems(
              pageCount: 3,
              currentPage: 1,
              onSelect: (_) {},
              showPrevNext: false,
            ),
          ),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsPaginationStyle',
          defaultsNote:
              'background, borderColor, focusBackground, hoverBackground, hoverBorderColor, disabledColor, '
              'disabledBackground, and disabledBorderColor swap for their dark-theme counterparts when '
              'BsTheme.of(context) is Brightness.dark. color, focusColor, hoverColor, focusRingColor, '
              'activeColor, and activeBackground don\'t — they\'re literal primary/white values that don\'t '
              're-theme.',
          rows: [
            DocStyleRow(field: 'padding', defaultValue: 'EdgeInsets.symmetric(horizontal: 12, vertical: 6)'),
            DocStyleRow(field: 'fontSize', defaultValue: '16'),
            DocStyleRow(field: 'color', defaultValue: 'BsVariant.primary.color (BsColors.blue)'),
            DocStyleRow(field: 'background', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'borderRadius', defaultValue: '6'),
            DocStyleRow(field: 'borderWidth', defaultValue: '1'),
            DocStyleRow(field: 'borderColor', defaultValue: 'BsColors.gray300'),
            DocStyleRow(field: 'focusColor', defaultValue: 'BsColors.blue; same as color'),
            DocStyleRow(field: 'focusBackground', defaultValue: 'BsColors.gray200'),
            DocStyleRow(field: 'focusRingColor', defaultValue: 'BsColors.blue at 25% opacity'),
            DocStyleRow(field: 'focusRingWidth', defaultValue: '4'),
            DocStyleRow(field: 'hoverColor', defaultValue: 'BsColors.blue; same as color'),
            DocStyleRow(field: 'hoverBackground', defaultValue: 'BsColors.gray100'),
            DocStyleRow(field: 'hoverBorderColor', defaultValue: 'BsColors.gray300; same as borderColor'),
            DocStyleRow(field: 'activeColor', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'activeBackground', defaultValue: 'BsVariant.primary.color (BsColors.blue)'),
            DocStyleRow(field: 'activeBorderColor', defaultValue: 'BsColors.blue; same as activeBackground'),
            DocStyleRow(field: 'disabledColor', defaultValue: 'BsColors.gray600'),
            DocStyleRow(field: 'disabledBackground', defaultValue: 'BsColors.gray200'),
            DocStyleRow(field: 'disabledBorderColor', defaultValue: 'BsColors.gray300; same as borderColor'),
            DocStyleRow(field: 'transitionDuration', defaultValue: '150ms'),
          ],
        ),
      ],
    );
  }
}
