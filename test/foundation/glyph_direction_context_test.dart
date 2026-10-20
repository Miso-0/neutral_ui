import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

void main() {
  testWidgets('physical glyph directions do not require Directionality', (
    WidgetTester tester,
  ) async {
    for (final GlyphDirection direction in <GlyphDirection>[
      GlyphDirection.up,
      GlyphDirection.down,
      GlyphDirection.left,
      GlyphDirection.right,
    ]) {
      await tester.pumpWidget(
        IconTheme(
          data: const IconThemeData(size: 24, color: Color(0xFF123456)),
          child: Column(
            children: <Widget>[
              ChevronGlyph(direction: direction),
              ArrowGlyph(direction: direction),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull, reason: '$direction');
    }
  });
}
