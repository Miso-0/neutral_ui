import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// Gradient and image surfaces, a custom slider and a constant switch thumb. Copy assets/decoration_pattern.png into your app and declare it in pubspec.yaml.
class DecorationsExample extends StatefulWidget {
  /// Creates the direct decorations example.
  const DecorationsExample({super.key});
  @override
  State<DecorationsExample> createState() => _DecorationsExampleState();
}

class _DecorationsExampleState extends State<DecorationsExample> {
  double _value = 0.35;
  bool _enabled = true;

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
        ElevatedButton(
          style: _button(solid: true, decorated: false),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Color(0xFF087F6D), Color(0xFF20594F)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x26087F6D),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          onPressed: () {},
          child: const Text('A gradient, directly'),
        ),
        const SizedBox(height: 18),
        ListTile(
          style: _listStyle(decorated: false),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/decoration_pattern.png'),
              repeat: ImageRepeat.repeat,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.fromBorderSide(BorderSide(color: _line)),
          ),
          title: const Text('A little texture'),
          subtitle: const Text('An asset image in a widget-level decoration.'),
          trailing: const ArrowGlyph(),
          onTap: () {},
        ),
        const SizedBox(height: 18),
        Text('Custom track and thumb: ${(_value * 100).round()}%'),
        Slider(
          value: _value,
          trackDecoration: const BoxDecoration(
            color: Color(0xFFE6D9BC),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          thumbDecoration: const BoxDecoration(
            color: Color(0xFFF3D694),
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color: _ink, width: 2)),
          ),
          style: const SliderStyle(
            trackHeight: StateProperty<double?>.all(8),
            thumbSize: StateProperty<Size?>.all(Size(24, 24)),
            activeTrackDecoration: StateProperty<Decoration?>.all(
              BoxDecoration(color: _accent),
            ),
          ),
          onChanged: (double value) => setState(() => _value = value),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Switch(
              style: _toggle(isSwitch: true, customThumb: true),
              value: _enabled,
              semanticLabel: 'Decorated switch',
              thumbDecoration: const BoxDecoration(
                color: Color(0xFFF3D694),
                shape: BoxShape.circle,
                border: Border.fromBorderSide(BorderSide(color: _ink)),
              ),
              onChanged: (bool value) => setState(() => _enabled = value),
            ),
            const SizedBox(width: 8),
            const Flexible(child: Text('A constant thumb in either position')),
          ],
        ),
      ],
    ),
  );
}

ButtonStyle _button({bool solid = false, bool decorated = true}) => ButtonStyle(
  decoration: decorated
      ? StateProperty<Decoration?>.resolveWith(
          (InteractionState state) => _surface(state, solid: solid),
        )
      : null,
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

ToggleStyle _toggle({
  bool radio = false,
  bool isSwitch = false,
  bool customThumb = false,
}) => ToggleStyle(
  size: StateProperty<Size?>.all(
    isSwitch ? const Size(44, 26) : const Size(22, 22),
  ),
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : state.isSelected
          ? _accent
          : const Color(0xFFFFFFFF),
      border: Border.all(color: state.isSelected ? _accent : _line),
      borderRadius: BorderRadius.circular(radio || isSwitch ? 30 : 6),
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  thumbSize: StateProperty<Size?>.all(
    isSwitch ? const Size(20, 20) : const Size(10, 10),
  ),
  thumbDecoration: customThumb
      ? null
      : StateProperty<Decoration?>.resolveWith(
          (InteractionState state) => BoxDecoration(
            color: isSwitch && !state.isSelected
                ? _muted
                : const Color(0xFFFFFFFF),
            shape: BoxShape.circle,
          ),
        ),
  padding: isSwitch ? const EdgeInsets.all(3) : const EdgeInsets.all(4),
  indicator: radio || isSwitch
      ? null
      : const StateProperty<Widget?>.all(
          CheckGlyph(size: 12, color: Color(0xFFFFFFFF)),
        ),
  indeterminateIndicator: const StateProperty<Widget?>.all(
    SizedBox(width: 10, height: 2, child: ColoredBox(color: Color(0xFFFFFFFF))),
  ),
);

ListTileStyle _listStyle({bool decorated = true}) => ListTileStyle(
  decoration: decorated
      ? StateProperty<Decoration?>.resolveWith(
          (InteractionState state) => BoxDecoration(
            color: state.isSelected
                ? const Color(0xFFE4F1E7)
                : state.isHovered
                ? const Color(0xFFF0F5F0)
                : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            boxShadow: state.isFocused ? _focusRing : null,
          ),
        )
      : null,
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
