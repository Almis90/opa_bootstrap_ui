import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// The languages the docs highlight.
enum DocLanguage { dart, yaml, bash }

/// Syntax highlighting of the docs' code snippets, in the colors of Bootstrap's
/// own snippets (a light and a dark palette).
///
/// A small scanner, not a parser: comments, strings, numbers, keywords, types
/// (capitalized names) and calls are told apart, and everything else is plain.
class DocSyntax {
  const DocSyntax._(
    this.comment,
    this.plain,
    this.number,
    this.string,
    this.keyword,
    this.function,
    this.type,
    this.property,
  );

  final Color comment;
  final Color plain;
  final Color number;
  final Color string;
  final Color keyword;
  final Color function;
  final Color type;
  final Color property;

  static final light = DocSyntax._(
    const Color(0xFF565C64),
    const Color(0xFF333333),
    BsColorUtils.shade(BsColors.cyan, 0.4),
    BsColorUtils.shade(BsColors.blue, 0.4),
    BsColorUtils.shade(const Color(0xFFD63384), 0.2),
    BsColorUtils.shade(BsColors.blue, 0.4),
    BsColorUtils.shade(BsColors.teal, 0.4),
    const Color(0xFF6F42C1),
  );

  static final dark = DocSyntax._(
    const Color(0xFF868E96),
    const Color(0xFFABB2BF),
    BsColorUtils.tint(BsColors.orange, 0.4),
    BsColorUtils.tint(BsColors.teal, 0.4),
    BsColorUtils.tint(BsColors.indigo, 0.6),
    BsColorUtils.tint(BsColors.blue, 0.4),
    BsColorUtils.tint(BsColors.yellow, 0.6),
    BsColorUtils.tint(BsColors.blue, 0.4),
  );

  static const _dartKeywords = {
    'abstract',
    'as',
    'async',
    'await',
    'class',
    'const',
    'else',
    'enum',
    'extends',
    'factory',
    'false',
    'final',
    'for',
    'if',
    'implements',
    'import',
    'in',
    'is',
    'late',
    'new',
    'null',
    'required',
    'return',
    'static',
    'super',
    'this',
    'true',
    'var',
    'void',
    'with',
  };

  /// The spans of [code], colored for [language].
  TextSpan highlight(String code, DocLanguage language) {
    final spans = <TextSpan>[];
    void add(String text, Color color) {
      if (text.isEmpty) return;
      spans.add(TextSpan(text: text, style: TextStyle(color: color)));
    }

    switch (language) {
      case DocLanguage.dart:
        _scan(code, add, comment: '//', keywords: _dartKeywords, types: true);
      case DocLanguage.yaml:
        _scanYaml(code, add);
      case DocLanguage.bash:
        _scanBash(code, add);
    }
    return TextSpan(
      children: spans,
      style: TextStyle(color: plain),
    );
  }

  void _scan(
    String code,
    void Function(String, Color) add, {
    required String comment,
    required Set<String> keywords,
    required bool types,
  }) {
    final token = RegExp(
      r'''(\/\/[^\n]*)|(\'\'\'[\s\S]*?\'\'\'|'(?:\\.|[^'\\\n])*'|"(?:\\.|[^"\\\n])*")|(\b\d+(?:\.\d+)?\b)|(@[A-Za-z_]\w*)|([A-Za-z_]\w*)(\s*\()?''',
    );
    var end = 0;
    for (final m in token.allMatches(code)) {
      add(code.substring(end, m.start), plain);
      end = m.end;
      if (m[1] != null) {
        add(m[1]!, this.comment);
      } else if (m[2] != null) {
        add(m[2]!, string);
      } else if (m[3] != null) {
        add(m[3]!, number);
      } else if (m[4] != null) {
        add(m[4]!, function);
      } else {
        final word = m[5]!;
        final call = m[6];
        if (keywords.contains(word)) {
          add(word, keyword);
        } else if (types && RegExp(r'^[A-Z]').hasMatch(word)) {
          add(word, type);
        } else if (call != null) {
          add(word, function);
        } else {
          add(word, plain);
        }
        if (call != null) add(call, plain);
      }
    }
    add(code.substring(end), plain);
  }

  void _scanYaml(String code, void Function(String, Color) add) {
    final lines = code.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final hash = line.indexOf('#');
      final body = hash < 0 ? line : line.substring(0, hash);
      final key = RegExp(r'^(\s*)([A-Za-z_][\w-]*)(:)(.*)$').firstMatch(body);
      if (key != null) {
        add(key[1]!, plain);
        add(key[2]!, property);
        add(key[3]!, plain);
        final value = key[4]!;
        add(value, RegExp(r'^\s*[\^\d]').hasMatch(value) ? number : plain);
      } else {
        add(body, plain);
      }
      if (hash >= 0) add(line.substring(hash), comment);
      if (i < lines.length - 1) add('\n', plain);
    }
  }

  void _scanBash(String code, void Function(String, Color) add) {
    final lines = code.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final words = RegExp(r'(\s+)|(\S+)').allMatches(lines[i]);
      var first = true;
      for (final w in words) {
        if (w[1] != null) {
          add(w[1]!, plain);
          continue;
        }
        final text = w[2]!;
        add(text, first ? function : (text.startsWith('-') ? keyword : plain));
        first = false;
      }
      if (i < lines.length - 1) add('\n', plain);
    }
  }
}
