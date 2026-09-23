import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'doc_nav.dart';
import 'doc_sidebar.dart';

/// The app shell: a dark top bar, a persistent [DocSidebar], and the
/// selected page's content — Bootstrap's docs layout (`bd-header` +
/// `bd-sidebar` + `bd-main`) without page-to-page navigation, since the
/// sidebar swaps content in place instead of routing.
class DocShell extends StatefulWidget {
  const DocShell({super.key, required this.sections});

  final List<DocNavSection> sections;

  @override
  State<DocShell> createState() => _DocShellState();
}

class _DocShellState extends State<DocShell> {
  late DocNavPage _selected = widget.sections.first.pages.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: BsColors.gray900,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: const Text(
            'opa_bootstrap_ui docs',
            style: TextStyle(color: BsColors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 260,
                child: DocSidebar(
                  sections: widget.sections,
                  selected: _selected,
                  onSelect: (page) => setState(() => _selected = page),
                ),
              ),
              Container(width: 1, color: BsBorders.color),
              Expanded(
                child: ColoredBox(
                  color: BsColors.white,
                  child: Builder(builder: _selected.builder),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
