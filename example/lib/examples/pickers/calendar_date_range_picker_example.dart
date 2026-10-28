import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// A scrollable calendar for choosing a date range.
class CalendarDateRangePickerExample extends StatefulWidget {
  /// Creates this self-contained example.
  const CalendarDateRangePickerExample({super.key});

  @override
  State<CalendarDateRangePickerExample> createState() =>
      _CalendarDateRangePickerExampleState();
}

class _CalendarDateRangePickerExampleState
    extends State<CalendarDateRangePickerExample> {
  DateTimeRange<DateTime> _range = DateTimeRange<DateTime>(
    start: DateTime(2026, 10, 16),
    end: DateTime(2026, 10, 20),
  );

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: SizedBox(
      width: 330,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 330,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 330,
                child: CalendarDateRangePicker(
                  style: _dateStyle(),
                  firstDate: DateTime(2026, 10),
                  lastDate: DateTime(2027),
                  initialStartDate: _range.start,
                  initialEndDate: _range.end,
                  onChanged: (DateTimeRange<DateTime> range) =>
                      setState(() => _range = range),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${NeutralLocalizations.of(context).formatShortDate(_range.start)} to ${NeutralLocalizations.of(context).formatShortDate(_range.end)}',
              ),
            ],
          ),
        ),
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
