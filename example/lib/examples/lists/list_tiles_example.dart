import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// One, two and three-line tiles, a trailing switch, and a disabled row.
class ListTilesExample extends StatefulWidget {
  /// Creates the list tiles example.
  const ListTilesExample({super.key});
  @override
  State<ListTilesExample> createState() => _ListTilesExampleState();
}

class _ListTilesExampleState extends State<ListTilesExample> {
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
      children: <Widget>[
        ListTile(
          style: _listStyle(),
          leading: const Text('01', style: TextStyle(color: _accent)),
          title: const Text('Your workspace'),
          trailing: const ArrowGlyph(),
          onTap: () {},
        ),
        ListTile(
          style: _listStyle(),
          selected: true,
          leading: const Text('02', style: TextStyle(color: _accent)),
          title: const Text('Stay in the loop'),
          subtitle: const Text('Updates delivered on your terms.'),
          trailing: Switch(
            style: _toggle(isSwitch: true),
            value: _enabled,
            onChanged: (bool value) => setState(() => _enabled = value),
          ),
        ),
        ListTile(
          style: _listStyle(),
          isThreeLine: true,
          leading: const Text('03', style: TextStyle(color: _accent)),
          title: const Text('Room for more'),
          subtitle: const Text(
            'Longer descriptions flow naturally.\nThe style controls spacing and minimum height.',
          ),
        ),
        ListTile(
          style: _listStyle(),
          enabled: false,
          title: const Text('An unavailable item'),
          subtitle: const Text('Disabled controls retain their structure.'),
        ),
      ],
    ),
  );
}

ToggleStyle _toggle({bool radio = false, bool isSwitch = false}) => ToggleStyle(
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
  thumbDecoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: isSwitch && !state.isSelected ? _muted : const Color(0xFFFFFFFF),
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
