import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'bootstrap_icon.dart';
import 'doc_navigation.dart';
import 'doc_syntax.dart';
import 'example_code.dart';
import 'open_url.dart';

/// A section heading of a docs page (an `h2`), or a sub-heading (`h3`), set
/// apart from what precedes it.
class DocHeading extends StatelessWidget {
  const DocHeading(
    this.text, {
    super.key,
    this.sub = false,
    this.first = false,
  });

  final String text;

  /// A sub-heading, one level down.
  final bool sub;

  /// The first thing on the page: no space above it.
  final bool first;

  @override
  Widget build(BuildContext context) {
    return BsBox(
      mt: first ? null : (sub ? BsSpacing.s4 : BsSpacing.s5),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: BsTextColor.bodyEmphasis.of(context)),
        child: BsHeading(
          sub ? BsHeadingLevel.h3 : BsHeadingLevel.h2,
          child: Text(text),
        ),
      ),
    );
  }
}

/// Bold text inside a [DocText]: a string or a list of parts.
class DocBold {
  const DocBold(this.content);

  final Object content;
}

/// Inline code inside a [DocText].
class DocCode {
  const DocCode(this.text);

  final String text;
}

/// A link inside a [DocText]: to another page of the docs, to the examples,
/// or to a web address.
class DocLink {
  const DocLink.page(this.text, String this.group, String this.title)
    : url = null,
      examples = false;

  const DocLink.examples(this.text)
    : group = null,
      title = null,
      url = null,
      examples = true;

  const DocLink.url(this.text, String this.url)
    : group = null,
      title = null,
      examples = false;

  final String text;
  final String? group;
  final String? title;
  final String? url;
  final bool examples;
}

/// A paragraph made of [parts]: plain strings, [DocBold], [DocCode] and
/// [DocLink].
class DocText extends StatelessWidget {
  const DocText(this.parts, {super.key, this.bottom = 16});

  final List<Object> parts;

  /// The space below the paragraph.
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return BsInlineAnchors(
      builder: (context, anchor) => Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Text.rich(
          TextSpan(children: _spans(context, anchor, parts, null)),
        ),
      ),
    );
  }

  static List<InlineSpan> _spans(
    BuildContext context,
    BsAnchorSpanBuilder anchor,
    List<Object> parts,
    TextStyle? style,
  ) {
    final navigation = DocNavigation.maybeOf(context);
    return [
      for (final part in parts)
        switch (part) {
          String() => TextSpan(text: part, style: style),
          DocBold() => TextSpan(
            style: const TextStyle(fontWeight: FontWeight.w700),
            children: _spans(
              context,
              anchor,
              part.content is List<Object>
                  ? part.content as List<Object>
                  : [part.content],
              style,
            ),
          ),
          DocCode() => codeSpan(context, part.text),
          DocLink() => anchor(
            part.text,
            onTap: () {
              if (part.url != null) {
                openUrl(part.url!);
              } else if (part.examples) {
                navigation?.openExamples();
              } else {
                navigation?.openPage(part.group!, part.title!);
              }
            },
          ),
          _ => throw ArgumentError('Not a part of a paragraph: $part'),
        },
    ];
  }
}

/// An item of a [DocList]: its paragraph [parts], then any [children] (a code
/// snippet, say) below it.
class DocListItem {
  const DocListItem(this.parts, {this.children = const []});

  final List<Object> parts;
  final List<Widget> children;
}

/// A bulleted or numbered list.
class DocList extends StatelessWidget {
  const DocList(this.items, {super.key, this.ordered = false});

  final List<DocListItem> items;
  final bool ordered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: items[i].children.isEmpty ? 4 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 32,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Text(ordered ? '${i + 1}.' : '•'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DocText(
                          items[i].parts,
                          bottom: items[i].children.isEmpty ? 0 : 16,
                        ),
                        ...items[i].children,
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A code snippet in the look of Bootstrap's own: a tinted panel, syntax
/// colors, and a button that copies the code.
class DocCodeSnippet extends StatelessWidget {
  const DocCodeSnippet(
    this.code, {
    super.key,
    this.language = DocLanguage.dart,
  });

  final String code;
  final DocLanguage language;

  @override
  Widget build(BuildContext context) {
    final dark = BsTheme.of(context) == Brightness.dark;
    final syntax = dark ? DocSyntax.dark : DocSyntax.light;
    final borderRadius = BorderRadius.circular(BsBorders.radius);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BsDecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: BsBorders.colorOf(context)),
          borderRadius: borderRadius,
        ),
        // (the border takes room: the panel sits inside it)
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: BsClipRRect(
            borderRadius: BorderRadius.circular(BsBorders.radius - 1),
            child: ColoredBox(
              color: BsBody.tertiaryBackgroundOf(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 13 + 4, 30, 14),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text.rich(
                          syntax.highlight(code, language),
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: BsTypography.fontFamilyMonospace.first,
                            fontFamilyFallback: BsTypography.fontFamilyMonospace
                                .skip(1)
                                .toList(),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 8,
                      end: -8,
                      child: _CopyButton(code: code),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The corner button of a [DocCodeSnippet]: copies the code to the clipboard.
class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code});

  final String code;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _hovered = false;
  bool _copied = false;
  Timer? _reset;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    _reset?.cancel();
    setState(() => _copied = true);
    _reset = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _hovered
        ? BsLink.hoverColorOf(context)
        : BsBody.colorOf(context);
    return BsTooltip(
      message: Text(_copied ? 'Copied!' : 'Copy to clipboard'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _copy,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: BootstrapIcon(
              _copied ? BootstrapIconData.check2 : BootstrapIconData.clipboard,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// A call-to-action button of a docs page, in the docs' violet, that opens a
/// web address.
class DocButton extends StatelessWidget {
  const DocButton(this.label, this.url, {super.key});

  final String label;
  final String url;

  static const _violet = Color(0xFF712CF9);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: BsButton(
          onPressed: () => openUrl(url),
          style: BsButtonStyle(
            color: BsColors.white,
            background: _violet,
            borderColor: _violet,
            hoverColor: BsColors.white,
            hoverBackground: BsColorUtils.shade(_violet, 0.1),
            hoverBorderColor: BsColorUtils.shade(_violet, 0.1),
            activeColor: BsColors.white,
            activeBackground: BsColorUtils.shade(_violet, 0.2),
            activeBorderColor: BsColorUtils.shade(_violet, 0.2),
            focusRingColor: _violet.withValues(alpha: 0.5),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
