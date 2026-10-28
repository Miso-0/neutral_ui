import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// An anchored calendar field with explicit field and calendar styles.
class DatePickerFieldExample extends StatefulWidget {
  /// Creates this self-contained example.
  const DatePickerFieldExample({super.key});

  @override
  State<DatePickerFieldExample> createState() => _DatePickerFieldExampleState();
}

class _DatePickerFieldExampleState extends State<DatePickerFieldExample> {
  DateTime _date = DateTime(2026, 10, 16);

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: SizedBox(
      width: 300,
      child: DatePickerField(
        style: _dateStyle(),
        fieldStyle: _field(),
        labelText: 'Project deadline',
        value: _date,
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        onChanged: (DateTime date) => setState(() => _date = date),
      ),
    ),
  );
}

const Color _ink = Color(0xFF142C2A);

const Color _muted = Color(0xFF657B77);

const Color _accent = Color(0xFF087F6D);

const Color _line = Color(0xFFCFDDD4);

const Color _white = Color(0xFFFFFFFF);

const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

BoxDecoration _surface() => BoxDecoration(
  color: _white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _line),
);

ButtonStyle _button({bool selected = false}) => ButtonStyle(
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

TextFieldStyle _field() => TextFieldStyle(
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled ? const Color(0xFFE3EAE4) : _white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(
        color: state.isError
            ? const Color(0xFFB13B3B)
            : state.isFocused
            ? _accent
            : _line,
      ),
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  contentPadding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  ),
  textStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _ink, fontSize: 14),
  ),
  hintStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _muted, fontSize: 14),
  ),
  labelStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _muted, fontSize: 12),
  ),
  errorStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: Color(0xFFB13B3B), fontSize: 12),
  ),
  iconTheme: const StateProperty<IconThemeData?>.all(
    IconThemeData(color: _accent, size: 18),
  ),
  cursorColor: const StateProperty<Color?>.all(_accent),
  selectionColor: const StateProperty<Color?>.all(Color(0x55087F6D)),
  spacing: 6,
);

DatePickerStyle _dateStyle() => DatePickerStyle(
  decoration: _surface(),
  padding: const EdgeInsets.all(12),
  dayStyle: _button().copyWith(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
  ),
  selectedDayStyle: _button(selected: true).copyWith(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
  ),
  todayStyle: _button().copyWith(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
  ),
  yearStyle: _button(),
  navigationButtonStyle: _button(),
  entryModeButtonStyle: _button(),
  rangeStartStyle: _button(selected: true).copyWith(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
  ),
  rangeEndStyle: _button(selected: true).copyWith(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.zero),
  ),
  rangeBandDecoration: const BoxDecoration(color: Color(0xFFD5EAE0)),
  headerTextStyle: const TextStyle(color: _ink, fontSize: 17),
  weekdayTextStyle: const TextStyle(color: _muted, fontSize: 12),
  dayExtent: 38,
  monthWidth: 300,
);
