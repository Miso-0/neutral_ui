import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// A capped count badge and a simple status dot.
class BadgeExample extends StatelessWidget {
  /// Creates this self-contained example.
  const BadgeExample({super.key});

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: const Wrap(
      spacing: 32,
      runSpacing: 20,
      children: <Widget>[
        Badge.count(
          count: 125,
          style: BadgeStyle(
            decoration: StateProperty<Decoration?>.all(
              BoxDecoration(color: _accent, shape: BoxShape.circle),
            ),
            textStyle: StateProperty<TextStyle?>.all(
              TextStyle(color: _white, fontSize: 11),
            ),
            padding: EdgeInsets.all(5),
          ),
          child: SearchGlyph(size: 30, color: _ink),
        ),
        Badge(
          style: BadgeStyle(
            decoration: StateProperty<Decoration?>.all(
              BoxDecoration(color: _accent, shape: BoxShape.circle),
            ),
          ),
          child: CalendarGlyph(size: 30, color: _ink),
        ),
      ],
    ),
  );
}

const Color _ink = Color(0xFF142C2A);

const Color _accent = Color(0xFF087F6D);

const Color _white = Color(0xFFFFFFFF);
