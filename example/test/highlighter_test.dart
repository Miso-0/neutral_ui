import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui_example/library/dart_highlighter.dart';

void main() {
  test(
    'source and span text are lossless for raw, escaped and multiline Dart',
    () {
      final List<String> sources = <String>[
        '',
        "/// docs\n@override\nfinal Widget child = Text('Hello'); // end\n",
        r'''const value = r'raw\n'; final other = "escape\"d";''',
        "final text = '''first\nsecond''';\nfinal hex = 0xFF00AA;",
        '/* outer /* nested */ comment */ 12.5e-3 + 4',
        "'unterminated",
        '/* unfinished',
        'final emoji = "🙂";\r\n\t@Deprecated("old")',
      ];
      for (final String source in sources) {
        expect(
          tokenizeDart(source).map((DartToken token) => token.text).join(),
          source,
        );
        expect(highlightDart(source).toPlainText(), source);
      }
    },
  );

  test('classifies keywords, strings, comments, annotations, numbers and types', () {
    const String source =
        "/// docs\n@override\nfinal Widget child = Text(r'value'); // note\n0xAB 12.5e-3";
    final List<DartToken> tokens = tokenizeDart(source);
    DartTokenKind kind(String text) =>
        tokens.firstWhere((DartToken token) => token.text == text).kind;
    expect(kind('/// docs'), DartTokenKind.comment);
    expect(kind('// note'), DartTokenKind.comment);
    expect(kind('@override'), DartTokenKind.annotation);
    expect(kind('final'), DartTokenKind.keyword);
    expect(kind('Widget'), DartTokenKind.type);
    expect(kind("r'value'"), DartTokenKind.string);
    expect(kind('0xAB'), DartTokenKind.number);
    expect(kind('12.5e-3'), DartTokenKind.number);
    expect(kind('child'), DartTokenKind.plain);
    expect(
      highlightDart(source).children!
          .whereType<TextSpan>()
          .map((TextSpan span) => span.style!.color)
          .toSet()
          .length,
      greaterThan(4),
    );
  });
}
