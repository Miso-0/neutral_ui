import 'package:flutter/widgets.dart';

/// The lexical classes used by the code panel.
enum DartTokenKind {
  /// Whitespace, punctuation and ordinary identifiers.
  plain,

  /// Line or block comments.
  comment,

  /// Quoted, raw or multiline strings.
  string,

  /// Numeric literals.
  number,

  /// Dart language keywords.
  keyword,

  /// An annotation introduced by an at sign.
  annotation,

  /// An identifier beginning with a capital letter.
  type,
}

/// A lossless source fragment with a lexical classification.
class DartToken {
  /// Creates a classified source fragment.
  const DartToken(this.text, this.kind);

  /// The exact source text.
  final String text;

  /// The lexical classification.
  final DartTokenKind kind;
}

const Set<String> _keywords = <String>{
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

final RegExp _identifier = RegExp(r'[a-zA-Z_$][a-zA-Z0-9_$]*');
final RegExp _number = RegExp(
  r'0[xX][0-9a-fA-F]+|\d+(?:\.\d+)?(?:[eE][+-]?\d+)?',
);

/// Tokenizes Dart without discarding any source characters.
List<DartToken> tokenizeDart(String source) {
  final List<DartToken> tokens = <DartToken>[];
  int i = 0;
  while (i < source.length) {
    final int start = i;
    DartTokenKind kind = DartTokenKind.plain;
    if (source.startsWith('//', i)) {
      final int end = source.indexOf('\n', i);
      i = end < 0 ? source.length : end;
      kind = DartTokenKind.comment;
    } else if (source.startsWith('/*', i)) {
      int depth = 1;
      i += 2;
      while (i < source.length && depth > 0) {
        if (source.startsWith('/*', i)) {
          depth++;
          i += 2;
        } else if (source.startsWith('*/', i)) {
          depth--;
          i += 2;
        } else {
          i++;
        }
      }
      kind = DartTokenKind.comment;
    } else {
      final bool raw =
          source[i] == 'r' &&
          i + 1 < source.length &&
          (source[i + 1] == "'" || source[i + 1] == '"');
      if (raw || source[i] == "'" || source[i] == '"') {
        if (raw) i++;
        final String quote = source[i];
        final String delimiter = source.startsWith(quote * 3, i)
            ? quote * 3
            : quote;
        i += delimiter.length;
        while (i < source.length) {
          if (source.startsWith(delimiter, i)) {
            i += delimiter.length;
            break;
          }
          if (!raw && source[i] == '\\' && i + 1 < source.length) {
            i += 2;
          } else {
            i++;
          }
        }
        kind = DartTokenKind.string;
      } else if (source[i] == '@') {
        i++;
        final Match? name = _identifier.matchAsPrefix(source, i);
        if (name != null) i = name.end;
        kind = DartTokenKind.annotation;
      } else {
        final Match? number = _number.matchAsPrefix(source, i);
        final Match? name = _identifier.matchAsPrefix(source, i);
        if (number != null) {
          i = number.end;
          kind = DartTokenKind.number;
        } else if (name != null) {
          i = name.end;
          final String value = name.group(0)!;
          kind = _keywords.contains(value)
              ? DartTokenKind.keyword
              : RegExp(r'^_?[A-Z]').hasMatch(value)
              ? DartTokenKind.type
              : DartTokenKind.plain;
        } else {
          i++;
        }
      }
    }
    tokens.add(DartToken(source.substring(start, i), kind));
  }
  return tokens;
}

/// Highlights Dart source as a lossless tree of text spans.
TextSpan highlightDart(String source) => TextSpan(
  children: <TextSpan>[
    for (final DartToken token in tokenizeDart(source))
      TextSpan(
        text: token.text,
        style: TextStyle(
          color: switch (token.kind) {
            DartTokenKind.comment => const Color(0xFF718477),
            DartTokenKind.string => const Color(0xFF94602A),
            DartTokenKind.number => const Color(0xFF9B4F63),
            DartTokenKind.keyword => const Color(0xFF7354A0),
            DartTokenKind.annotation => const Color(0xFF947728),
            DartTokenKind.type => const Color(0xFF087F6D),
            DartTokenKind.plain => const Color(0xFF243C36),
          },
        ),
      ),
  ],
);
