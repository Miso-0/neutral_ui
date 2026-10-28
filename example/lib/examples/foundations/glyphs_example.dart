import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _accent = Color(0xFF087F6D);

/// Painted glyphs follow the icon theme and directional arrows mirror in RTL.
class GlyphsExample extends StatelessWidget {
  /// Creates the library glyphs example.
  const GlyphsExample({super.key});
  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: const IconTheme(
      data: IconThemeData(color: _accent, size: 28),
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        children: <Widget>[
          CheckGlyph(),
          DotsGlyph(),
          ChevronGlyph(direction: GlyphDirection.start),
          ChevronGlyph(direction: GlyphDirection.end),
          CloseGlyph(),
          SearchGlyph(),
          CalendarGlyph(),
          ClockGlyph(),
          EditGlyph(),
          ArrowGlyph(direction: GlyphDirection.start),
          ArrowGlyph(),
          EyeGlyph(),
        ],
      ),
    ),
  );
}
