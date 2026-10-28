import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const Color _white = Color(0xFFFFFFFF);

/// A focus ring drawn outside the control, so showing it never moves content.
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

ButtonStyle _control({bool selected = false}) => ButtonStyle(
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 12, vertical: 9),
  ),
  spacing: 8,
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : state.isSelected || selected
          ? _accent
          : state.isHovered
          ? const Color(0xFFE4F1E7)
          : _white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: state.isFocused ? _accent : _line),
      // The ring stays visible on selected, accent-filled controls.
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isSelected || selected
          ? _white
          : state.isDisabled
          ? _muted
          : _ink,
      fontSize: 14,
    ),
  ),
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      size: 18,
      color: state.isSelected || selected ? _white : _accent,
    ),
  ),
);

ChipStyle _chipStyle() => ChipStyle(
  buttonStyle: _control(),
  deleteButtonStyle: _control().copyWith(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(4)),
  ),
  spacing: 7,
  avatarSize: 20,
);

/// An independently deletable input chip and an action to restore it.
class InputChipExample extends StatefulWidget {
  /// Creates the example.
  const InputChipExample({super.key});

  @override
  State<InputChipExample> createState() => _InputChipExampleState();
}

class _InputChipExampleState extends State<InputChipExample> {
  bool _visible = true;
  bool _selected = false;
  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: Color(0xFF142C2A), fontSize: 14),
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        if (_visible)
          InputChip(
            style: _chipStyle(),
            label: const Text('Remove me'),
            selected: _selected,
            onSelected: (bool value) => setState(() => _selected = value),
            onDeleted: () => setState(() => _visible = false),
          ),
        ActionChip(
          style: _chipStyle(),
          label: const Text('Add a label'),
          onPressed: () => setState(() => _visible = true),
        ),
      ],
    ),
  );
}
