import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// A modal range calendar with a locally styled input mode.
class ModalDateRangePickerExample extends StatefulWidget {
  /// Creates this self-contained example.
  const ModalDateRangePickerExample({super.key});

  @override
  State<ModalDateRangePickerExample> createState() =>
      _ModalDateRangePickerExampleState();
}

class _ModalDateRangePickerExampleState
    extends State<ModalDateRangePickerExample> {
  DateTimeRange<DateTime> _range = DateTimeRange<DateTime>(
    start: DateTime(2026, 10, 16),
    end: DateTime(2026, 10, 20),
  );

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          style: _button(),
          onPressed: () async {
            final DateTimeRange<DateTime>? range = await showDateRangePicker(
              context: context,
              initialDateRange: _range,
              firstDate: DateTime(2025),
              lastDate: DateTime(2028, 12, 31),
              style: _dateStyle(),
              builder: _pickerChrome,
            );
            if (mounted && range != null) setState(() => _range = range);
          },
          child: const Text('Modal range picker'),
        ),
        const SizedBox(height: 12),
        Text(
          '${NeutralLocalizations.of(context).formatShortDate(_range.start)} to ${NeutralLocalizations.of(context).formatShortDate(_range.end)}',
        ),
      ],
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

DialogStyle _dialog() => DialogStyle(
  decoration: _surface(),
  padding: const EdgeInsets.all(24),
  insetPadding: const EdgeInsets.all(24),
  constraints: const BoxConstraints(maxWidth: 620),
  titleTextStyle: const TextStyle(
    color: _ink,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  ),
  contentTextStyle: const TextStyle(color: _ink, fontSize: 14),
  contentPadding: const EdgeInsets.symmetric(vertical: 18),
  actionsPadding: const EdgeInsets.only(top: 16),
  optionStyle: _button(),
  barrierColor: const Color(0x55142C2A),
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

// Picker helpers build their own dialog, action buttons and input fields.
// These local themes travel with this example, including into the modal route.
Widget _pickerChrome(BuildContext context, Widget? child) => DefaultTextStyle(
  style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
  child: DialogTheme(
    data: _dialog(),
    child: TextButtonTheme(
      data: _button(),
      child: TextFieldTheme(data: _field(), child: child!),
    ),
  ),
);
