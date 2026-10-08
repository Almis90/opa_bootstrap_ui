import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'bootstrap_icon.dart';

/// Bootstrap's own violet (`--docsearch-primary-color`).
const _violet = Color(0xFF712CF9);

/// One searchable page: a [title] under a [group] heading. [keywords] are
/// matched too but not shown.
class DocSearchHit {
  const DocSearchHit({
    required this.group,
    required this.title,
    required this.onSelect,
    this.keywords = '',
  });

  final String group;
  final String title;
  final String keywords;
  final VoidCallback onSelect;
}

/// The key the search shortcut is announced with.
String get _shortcutModifier =>
    defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.iOS
    ? '⌘'
    : 'Ctrl';

/// Opens the search modal over the current page (`DocSearch-Container`).
Future<void> showDocSearch(BuildContext context, List<DocSearchHit> hits) {
  final dark = BsTheme.of(context) == Brightness.dark;
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    // `--docsearch-container-background`
    barrierColor: dark ? const Color(0xCC090A11) : const Color(0xCC656C85),
    transitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (context, _, _) => _DocSearchModal(hits: hits),
    transitionBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// `.bd-search > .DocSearch-Button`: from `lg` up a 38px field centered in the
/// bar (200 wide, 280 from `xl`) showing "Search" and the shortcut; below it
/// just the magnifier.
class DocSearchButton extends StatefulWidget {
  const DocSearchButton({super.key, required this.onTap, required this.field});

  final VoidCallback onTap;

  /// Whether to show the bordered field rather than only the icon.
  final bool field;

  @override
  State<DocSearchButton> createState() => _DocSearchButtonState();
}

class _DocSearchButtonState extends State<DocSearchButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final icon = BootstrapIcon(
      BootstrapIconData.docSearch,
      width: 20,
      height: 20,
      color: BsColors.white.withValues(alpha: _hovered ? 1 : .65),
    );
    final Widget content;
    if (widget.field) {
      const muted = Color(0xA6FFFFFF);
      content = DecoratedBox(
        decoration: BoxDecoration(
          // `--docsearch-searchbox-background` / `-focus-background`
          color: BsColors.black.withValues(alpha: _hovered ? .25 : .1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            // `rgba($white, .4)`, `$bd-accent` once hovered
            color: _hovered ? const Color(0xFFFFE484) : const Color(0x66FFFFFF),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(left: 0, right: 12),
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: muted,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),
              // `.DocSearch-Button-Keys`
              DecoratedBox(
                decoration: BoxDecoration(
                  color: BsColors.black.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final key in [_shortcutModifier, 'K'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            key,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 20 / 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(child: icon),
      );
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        key: const Key('doc-search-button'),
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: SizedBox(height: 38, child: content),
      ),
    );
  }
}

/// The colors `docsearch.css` derives for the page's theme.
class _Palette {
  _Palette(BuildContext context)
    : dark = BsTheme.of(context) == Brightness.dark,
      muted = BsBody.secondaryColorOf(context),
      border = BsBorders.colorOf(context);

  final bool dark;
  final Color muted;
  final Color border;

  Color get modal => dark ? const Color(0xFF15172A) : const Color(0xFFF5F6F7);
  Color get box => dark ? const Color(0xFF090A11) : BsColors.white;
  Color get boxFocus => dark ? BsColors.black : BsColors.white;
  Color get text => dark ? const Color(0xFFF5F6F7) : const Color(0xFF1C1E21);
  Color get hit => dark ? const Color(0xFFBEC3C9) : const Color(0xFF444950);
  Color get footer => dark ? const Color(0xFF1E2136) : BsColors.white;
  Color get key => dark ? const Color(0xFF31355B) : const Color(0x1A000000);
}

class _Result {
  const _Result(this.hit, this.key);

  final DocSearchHit hit;
  final GlobalKey key;
}

class _DocSearchModal extends StatefulWidget {
  const _DocSearchModal({required this.hits});

  final List<DocSearchHit> hits;

  @override
  State<_DocSearchModal> createState() => _DocSearchModalState();
}

class _DocSearchModalState extends State<_DocSearchModal> {
  /// `maxResultsPerGroup`
  static const _perGroup = 5;

  final _controller = TextEditingController();
  late final _focus = FocusNode(onKeyEvent: _onKey);
  final _keys = <DocSearchHit, GlobalKey>{};
  int _active = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  List<String> get _terms => _controller.text
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();

  /// The matching hits, in sidebar order, at most [_perGroup] a group.
  List<DocSearchHit> get _results {
    final terms = _terms;
    if (terms.isEmpty) return const [];
    final counts = <String, int>{};
    return [
      for (final hit in widget.hits)
        if (terms.every(
              (t) => '${hit.group} ${hit.title} ${hit.keywords}'
                  .toLowerCase()
                  .contains(t),
            ) &&
            (counts[hit.group] = (counts[hit.group] ?? 0) + 1) <= _perGroup)
          hit,
    ];
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final results = _results;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown && results.isNotEmpty) {
      _move((_active + 1) % results.length, results);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp && results.isNotEmpty) {
      _move((_active - 1 + results.length) % results.length, results);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter && results.isNotEmpty) {
      _select(results[_active.clamp(0, results.length - 1)]);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _move(int index, List<DocSearchHit> results) {
    setState(() => _active = index);
    final context = _keys[results[index]]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: Duration.zero);
    }
  }

  void _select(DocSearchHit hit) {
    Navigator.of(context).pop();
    hit.onSelect();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _Palette(context);
    final size = MediaQuery.sizeOf(context);
    // `@media (max-width: 768px)`: the modal takes the whole screen.
    final mobile = size.width <= 768;
    final top = mobile ? 0.0 : (size.width >= 992 ? 124.0 : 60.0);
    final results = _results;
    final active = results.isEmpty ? 0 : _active.clamp(0, results.length - 1);

    final form = _Form(
      controller: _controller,
      focus: _focus,
      palette: palette,
      onChanged: () => _active = 0,
    );
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            mobile ? 10 : 12,
            mobile ? 10 : 12,
            mobile ? 10 : 12,
            0,
          ),
          child: mobile
              ? Row(
                  children: [
                    Expanded(child: form),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: _violet,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : form,
        ),
        Flexible(
          fit: mobile ? FlexFit.tight : FlexFit.loose,
          child: _terms.isEmpty || results.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Text(
                    _terms.isEmpty
                        ? 'No recent searches'
                        : 'No results for "${_controller.text.trim()}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: palette.muted,
                      fontSize: 14.4,
                      height: 1.33,
                    ),
                  ),
                )
              : _Hits(
                  results: [
                    for (final hit in results)
                      _Result(hit, _keys.putIfAbsent(hit, GlobalKey.new)),
                  ],
                  active: active,
                  terms: _terms,
                  palette: palette,
                  horizontal: mobile ? 10 : 12,
                  onHover: (i) => setState(() => _active = i),
                  onSelect: _select,
                ),
        ),
        if (!mobile) _Footer(palette: palette),
      ],
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: top),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: mobile ? double.infinity : 560,
            maxHeight: mobile ? size.height : 600,
          ),
          child: SizedBox(
            width: double.infinity,
            height: mobile ? size.height : null,
            // (A touch inside the modal must not reach the barrier.)
            child: GestureDetector(
              onTap: () {},
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.modal,
                  borderRadius: BorderRadius.circular(mobile ? 0 : 6),
                  boxShadow: mobile
                      ? null
                      : [
                          BoxShadow(
                            color: palette.dark
                                ? const Color(0xFF000309)
                                : const Color(0xFF555A64),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                          ),
                        ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mobile ? 0 : 6),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: palette.text),
                    child: body,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.DocSearch-Form`: the 56px field with a violet 2px border.
class _Form extends StatelessWidget {
  const _Form({
    required this.controller,
    required this.focus,
    required this.palette,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focus;
  final _Palette palette;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: palette.text,
      fontSize: 19.2,
      fontWeight: FontWeight.w400,
      height: 1.2,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.boxFocus,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _violet, width: 2),
      ),
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const BootstrapIcon(
                BootstrapIconData.docSearch,
                width: 20,
                height: 20,
                color: _violet,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      if (controller.text.isEmpty)
                        IgnorePointer(
                          child: Text(
                            'Search docs',
                            style: style.copyWith(color: palette.muted),
                          ),
                        ),
                      EditableText(
                        key: const Key('doc-search-input'),
                        controller: controller,
                        focusNode: focus,
                        autofocus: true,
                        style: style,
                        cursorColor: _violet,
                        backgroundCursorColor: const Color(0xFF9E9E9E),
                        onChanged: (_) => onChanged(),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.text.isNotEmpty)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    key: const Key('doc-search-clear'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.clear();
                      onChanged();
                      focus.requestFocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: BootstrapIcon(
                        BootstrapIconData.docSearchClear,
                        width: 20,
                        height: 20,
                        color: palette.text,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `.DocSearch-Dropdown`: the results, each group under a violet heading.
class _Hits extends StatelessWidget {
  const _Hits({
    required this.results,
    required this.active,
    required this.terms,
    required this.palette,
    required this.horizontal,
    required this.onHover,
    required this.onSelect,
  });

  final List<_Result> results;
  final int active;
  final List<String> terms;
  final _Palette palette;
  final double horizontal;
  final ValueChanged<int> onHover;
  final ValueChanged<DocSearchHit> onSelect;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < results.length; i++) {
      final hit = results[i].hit;
      final first = i == 0 || results[i - 1].hit.group != hit.group;
      final last =
          i == results.length - 1 || results[i + 1].hit.group != hit.group;
      if (first) {
        // `.DocSearch-Hit-source`
        children.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              hit.group,
              style: const TextStyle(
                color: _violet,
                fontSize: 13.6,
                fontWeight: FontWeight.w600,
                height: 32 / 13.6,
              ),
            ),
          ),
        );
      }
      children.add(
        KeyedSubtree(
          key: results[i].key,
          child: _HitRow(
            hit: hit,
            terms: terms,
            palette: palette,
            active: i == active,
            first: first,
            last: last,
            onHover: () => onHover(i),
            onTap: () => onSelect(hit),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _HitRow extends StatelessWidget {
  const _HitRow({
    required this.hit,
    required this.terms,
    required this.palette,
    required this.active,
    required this.first,
    required this.last,
    required this.onHover,
    required this.onTap,
  });

  final DocSearchHit hit;
  final List<String> terms;
  final _Palette palette;
  final bool active;
  final bool first;
  final bool last;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? BsColors.white : palette.hit;
    final side = BorderSide(color: palette.border);
    final radius = BorderRadius.vertical(
      top: Radius.circular(first ? 6 : 0),
      bottom: Radius.circular(last ? 6 : 0),
    );
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => onHover(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: active ? _violet : palette.box,
            borderRadius: radius,
            // `border-width: 0 1px 1px`, the first hit also on top
            border: Border(
              left: side,
              right: side,
              bottom: side,
              top: first ? side : BorderSide.none,
            ),
          ),
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  BootstrapIcon(
                    BootstrapIconData.docSearchDoc,
                    width: 20,
                    height: 20,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text.rich(
                        _highlight(hit.title, terms, color, active),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (active)
                    BootstrapIcon(
                      BootstrapIconData.docSearchEnter,
                      width: 20,
                      height: 20,
                      color: color,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// [title] with every occurrence of a search term in violet (`mark`).
TextSpan _highlight(
  String title,
  List<String> terms,
  Color color,
  bool active,
) {
  final base = TextStyle(
    color: color,
    fontSize: 14.4,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );
  final lower = title.toLowerCase();
  final marked = List<bool>.filled(title.length, false);
  for (final term in terms) {
    for (
      var at = lower.indexOf(term);
      at >= 0;
      at = lower.indexOf(term, at + 1)
    ) {
      for (var i = at; i < at + term.length; i++) {
        marked[i] = true;
      }
    }
  }
  final spans = <TextSpan>[];
  var start = 0;
  for (var i = 1; i <= title.length; i++) {
    if (i == title.length || marked[i] != marked[start]) {
      spans.add(
        TextSpan(
          text: title.substring(start, i),
          style: marked[start] && !active
              ? const TextStyle(color: _violet)
              : null,
        ),
      );
      start = i;
    }
  }
  return TextSpan(style: base, children: spans);
}

/// `.DocSearch-Footer`: the keyboard commands.
class _Footer extends StatelessWidget {
  const _Footer({required this.palette});

  final _Palette palette;

  @override
  Widget build(BuildContext context) {
    Widget key(Widget child) => Container(
      width: 20,
      height: 18,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 0),
      decoration: BoxDecoration(
        color: palette.key,
        borderRadius: BorderRadius.circular(2),
      ),
      child: child,
    );
    Widget glyph(String text) => Text(
      text,
      style: TextStyle(color: palette.muted, fontSize: 12, height: 1),
    );
    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(left: 8, right: 16),
      child: Text(
        text,
        style: TextStyle(color: palette.muted, fontSize: 12.8, height: 1.5),
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.footer,
        boxShadow: [
          BoxShadow(
            color: palette.dark
                ? const Color(0x33000000)
                : const Color(0x1F45629B),
            offset: const Offset(0, -3),
            blurRadius: 6,
          ),
        ],
        border: Border(
          top: BorderSide(
            color: palette.dark
                ? const Color(0x80494C6A)
                : const Color(0xFFE0E3E8),
          ),
        ),
      ),
      child: SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              key(glyph('↵')),
              label('to select'),
              key(glyph('↓')),
              const SizedBox(width: 4),
              key(glyph('↑')),
              label('to navigate'),
              Container(
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.key,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  'esc',
                  style: TextStyle(
                    color: palette.muted,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ),
              label('to close'),
            ],
          ),
        ),
      ),
    );
  }
}
