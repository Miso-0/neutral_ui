import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('foundation glyphs inherit icon size, opacity and color', (
    WidgetTester tester,
  ) async {
    const Color color = Color(0xFF087F6D);
    await pumpNeutral(
      tester,
      const IconTheme(
        data: IconThemeData(size: 20, color: color, opacity: 0.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CloseGlyph(),
            SearchGlyph(),
            CalendarGlyph(),
            ClockGlyph(),
            EditGlyph(),
            ArrowGlyph(),
          ],
        ),
      ),
    );
    for (final Type glyph in <Type>[
      CloseGlyph,
      SearchGlyph,
      CalendarGlyph,
      ClockGlyph,
      EditGlyph,
      ArrowGlyph,
    ]) {
      expect(tester.getSize(find.byType(glyph)), const Size(20, 20));
      final Finder paint = find.descendant(
        of: find.byType(glyph),
        matching: find.byType(CustomPaint),
      );
      expect(
        tester.renderObject(paint),
        paints..path(color: color.withValues(alpha: 0.5)),
      );
      expect(
        find.descendant(
          of: find.byType(glyph),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
    }
  });

  for (final bool arrow in <bool>[false, true]) {
    testWidgets(
      '${arrow ? 'arrow' : 'chevron'} mirrors directional edges only',
      (WidgetTester tester) async {
        Widget glyph(GlyphDirection direction) => arrow
            ? ArrowGlyph(direction: direction)
            : ChevronGlyph(direction: direction);
        CustomPainter painter(GlyphDirection direction) => tester
            .widget<CustomPaint>(
              find.descendant(
                of: find.byKey(ValueKey<GlyphDirection>(direction)),
                matching: find.byType(CustomPaint),
              ),
            )
            .painter!;
        Future<void> pump(TextDirection textDirection) => pumpNeutral(
          tester,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final GlyphDirection direction in GlyphDirection.values)
                KeyedSubtree(
                  key: ValueKey<GlyphDirection>(direction),
                  child: glyph(direction),
                ),
            ],
          ),
          textDirection: textDirection,
        );
        await pump(TextDirection.ltr);
        final CustomPainter startLtr = painter(GlyphDirection.start);
        final CustomPainter leftLtr = painter(GlyphDirection.left);
        final CustomPainter endLtr = painter(GlyphDirection.end);
        expect(startLtr.shouldRepaint(leftLtr), isFalse);
        await pump(TextDirection.rtl);
        expect(painter(GlyphDirection.start).shouldRepaint(startLtr), isTrue);
        expect(painter(GlyphDirection.start).shouldRepaint(endLtr), isFalse);
        expect(painter(GlyphDirection.left).shouldRepaint(leftLtr), isFalse);
      },
    );
  }
}
