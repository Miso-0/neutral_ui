import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// Local component themes can merge inherited styles or replace a tile style.
class LocalThemesExample extends StatelessWidget {
  /// Creates the local component themes example.
  const LocalThemesExample({super.key});
  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElevatedButtonTheme(
          data: _button(solid: true),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: <Widget>[
              ElevatedButtonTheme.merge(
                data: const ButtonStyle(
                  decoration: StateProperty<Decoration?>.all(
                    BoxDecoration(
                      color: Color(0xFF85553B),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Local button theme'),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Themed sibling'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListTileTheme(
          data: _listStyle().copyWith(
            contentPadding: const EdgeInsets.all(16),
            decoration: const StateProperty<Decoration?>.all(
              BoxDecoration(
                color: Color(0xFFF4EDDF),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          child: ListTile(
            title: const Text('A local tile theme'),
            subtitle: const Text('Only this subtree uses these tokens.'),
            onTap: () {},
          ),
        ),
      ],
    ),
  );
}

ButtonStyle _button({bool solid = false}) => ButtonStyle(
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => _surface(state, solid: solid),
  ),
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 18, vertical: 13),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),
  spacing: 9,
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      size: 16,
    ),
  ),
);

ListTileStyle _listStyle() => ListTileStyle(
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isSelected
          ? const Color(0xFFE4F1E7)
          : state.isHovered
          ? const Color(0xFFF0F5F0)
          : const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(12),
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  titleTextStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _ink, fontSize: 15, fontWeight: FontWeight.w600),
  ),
  subtitleTextStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _muted, fontSize: 13, height: 1.5),
  ),
  iconTheme: const StateProperty<IconThemeData?>.all(
    IconThemeData(color: _muted, size: 16),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  horizontalTitleGap: 14,
  minVerticalPadding: 4,
  subtitleSpacing: 4,
  minTileHeight: 54,
  minTwoLineTileHeight: 72,
  minThreeLineTileHeight: 92,
);

Decoration _surface(InteractionState state, {bool solid = false}) =>
    BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : solid
          ? (state.isPressed
                ? const Color(0xFF065F53)
                : state.isHovered
                ? const Color(0xFF0A927E)
                : _accent)
          : (state.isPressed
                ? const Color(0xFFD5EAE0)
                : state.isHovered
                ? const Color(0xFFE9F2EB)
                : const Color(0xFFFFFFFF)),
      borderRadius: BorderRadius.circular(12),
      // A constant border width keeps content still; focus adds a ring.
      border: Border.all(
        color: state.isFocused
            ? _accent
            : solid
            ? const Color(0x00000000)
            : _line,
      ),
      boxShadow: state.isFocused ? _focusRing : null,
    );
