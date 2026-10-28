import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// A native radio group coordinates keyboard navigation and selection.
class RadioGroupExample extends StatefulWidget {
  /// Creates the radiogroup example.
  const RadioGroupExample({super.key});
  @override
  State<RadioGroupExample> createState() => _RadioGroupExampleState();
}

class _RadioGroupExampleState extends State<RadioGroupExample> {
  int? _selected = 1;

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: RadioGroup<int>(
      groupValue: _selected,
      onChanged: (int? value) => setState(() => _selected = value),
      child: Wrap(
        spacing: 20,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<int>(style: _toggle(radio: true), value: 1),
              const Text('Personal'),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<int>(style: _toggle(radio: true), value: 2),
              const Text('Team'),
            ],
          ),
        ],
      ),
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
