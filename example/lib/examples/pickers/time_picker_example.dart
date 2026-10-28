import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// A clock dial with locally styled time and period controls.
class TimePickerExample extends StatefulWidget {
  /// Creates this self-contained example.
  const TimePickerExample({super.key});

  @override
  State<TimePickerExample> createState() => _TimePickerExampleState();
}

class _TimePickerExampleState extends State<TimePickerExample> {
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 30);

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: SizedBox(
      width: 290,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFieldTheme(
            data: _field(),
            child: TimePicker(
              style: _timeStyle(),
              initialTime: _time,
              onTimeChanged: (TimeOfDay time) => setState(() => _time = time),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Selected: ${NeutralLocalizations.of(context).formatTimeOfDay(_time)}',
          ),
        ],
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

TimePickerStyle _timeStyle() => TimePickerStyle(
  decoration: _surface(),
  padding: const EdgeInsets.all(16),
  headerTextStyle: const TextStyle(color: _ink, fontSize: 14),
  inputTextStyle: const TextStyle(color: _ink, fontSize: 24),
  segmentStyle: _button(),
  selectedSegmentStyle: _button(selected: true),
  periodStyle: _button(),
  selectedPeriodStyle: _button(selected: true),
  entryModeButtonStyle: _button(),
  dialDecoration: const BoxDecoration(
    color: Color(0xFFE4F1E7),
    shape: BoxShape.circle,
  ),
  dialTextStyle: const TextStyle(color: _ink, fontSize: 13),
  handColor: _accent,
  dialSize: 220,
  handWidth: 2,
  handRadius: 9,
);
