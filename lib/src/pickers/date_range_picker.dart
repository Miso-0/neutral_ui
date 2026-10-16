import 'package:flutter/widgets.dart';

import '../buttons/icon_button.dart';
import '../buttons/text_button.dart';
import '../dates/date.dart';
import '../feedback/dialog.dart';
import '../foundation/glyphs.dart';
import '../foundation/motion.dart';
import '../localizations/pure_localizations.dart';
import '../menus/key_activators.dart';
import '../styles/date_picker_style.dart';
import '../theme/picker_themes.dart';
import 'date_picker.dart';
import 'picker_common.dart';

/// A lazy scrolling month list for choosing an inclusive date range.
class CalendarDateRangePicker extends StatefulWidget {
  /// Creates an inline range calendar.
  const CalendarDateRangePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialStartDate,
    this.initialEndDate,
    this.currentDate,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.onChanged,
    this.selectableDayPredicate,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.style,
    this.autofocus = false,
  });

  /// First selectable date, inclusive.
  final DateTime firstDate;

  /// Last selectable date, inclusive.
  final DateTime lastDate;

  /// Initially selected start date.
  final DateTime? initialStartDate;

  /// Initially selected end date.
  final DateTime? initialEndDate;

  /// Overrides the date marked as today.
  final DateTime? currentDate;

  /// Reports the first date of a newly selected range.
  final ValueChanged<DateTime>? onStartDateChanged;

  /// Reports the second date of a completed range.
  final ValueChanged<DateTime>? onEndDateChanged;

  /// Reports each complete range.
  final ValueChanged<DateTimeRange<DateTime>>? onChanged;

  /// Enables dates based on the currently selected range endpoints.
  final SelectableDayForRangePredicate? selectableDayPredicate;

  /// Calendar arithmetic and formatting.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Inline appearance and motion tokens.
  final DatePickerStyle? style;

  /// Whether the month list requests initial keyboard focus.
  final bool autofocus;

  @override
  State<CalendarDateRangePicker> createState() =>
      _CalendarDateRangePickerState();
}

class _RangeMoveIntent extends Intent {
  const _RangeMoveIntent(this.delta, {this.directional = false});
  final int delta;
  final bool directional;
}

class _CalendarDateRangePickerState extends State<CalendarDateRangePicker> {
  DateTime? _start;
  DateTime? _end;
  late DateTime _focused;
  ScrollController? _scroll;
  final FocusNode _focus = FocusNode(debugLabel: 'Date range grid');

  CalendarDelegate<DateTime> get _calendar => widget.calendarDelegate;
  DateTime get _first => _calendar.dateOnly(widget.firstDate);
  DateTime get _last => _calendar.dateOnly(widget.lastDate);
  DatePickerStyle get _style => (widget.style ?? const DatePickerStyle()).merge(
    DatePickerTheme.of(context),
  );
  double get _monthHeight => (_style.dayExtent ?? 40) * 7 + 40;

  @override
  void initState() {
    super.initState();
    assert(!_last.isBefore(_first));
    _start = widget.initialStartDate == null
        ? null
        : _calendar.dateOnly(widget.initialStartDate!);
    _end = widget.initialEndDate == null
        ? null
        : _calendar.dateOnly(widget.initialEndDate!);
    assert(
      _start == null || (!_start!.isBefore(_first) && !_start!.isAfter(_last)),
    );
    assert(
      _end == null ||
          (_start != null && !_end!.isBefore(_start!) && !_end!.isAfter(_last)),
    );
    assert(
      _start == null ||
          (widget.selectableDayPredicate?.call(_start!, _start, _end) ?? true),
    );
    assert(
      _end == null ||
          (widget.selectableDayPredicate?.call(_end!, _start, _end) ?? true),
    );
    final DateTime today = _calendar.dateOnly(
      widget.currentDate ?? _calendar.now(),
    );
    _focused =
        _start ??
        (today.isBefore(_first)
            ? _first
            : today.isAfter(_last)
            ? _last
            : today);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scroll ??= ScrollController(
      initialScrollOffset:
          _calendar.monthDelta(_first, _focused) * _monthHeight,
    );
  }

  @override
  void didUpdateWidget(CalendarDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStartDate != oldWidget.initialStartDate ||
        widget.initialEndDate != oldWidget.initialEndDate) {
      _start = widget.initialStartDate == null
          ? null
          : _calendar.dateOnly(widget.initialStartDate!);
      _end = widget.initialEndDate == null
          ? null
          : _calendar.dateOnly(widget.initialEndDate!);
    }
  }

  bool _enabled(DateTime date) =>
      !date.isBefore(_first) &&
      !date.isAfter(_last) &&
      (widget.selectableDayPredicate?.call(date, _start, _end) ?? true);

  void _select(DateTime date) {
    if (!_enabled(date)) return;
    final bool starting =
        _start == null || _end != null || date.isBefore(_start!);
    setState(() {
      _focused = date;
      if (starting) {
        _start = date;
        _end = null;
      } else {
        _end = date;
      }
    });
    if (starting) {
      widget.onStartDateChanged?.call(date);
    } else {
      widget.onEndDateChanged?.call(date);
      widget.onChanged?.call(
        DateTimeRange<DateTime>(start: _start!, end: date),
      );
    }
  }

  void _move(_RangeMoveIntent intent) {
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final int delta = intent.directional && rtl ? -intent.delta : intent.delta;
    DateTime candidate = _calendar.addDaysToDate(_focused, delta);
    while (!candidate.isBefore(_first) && !candidate.isAfter(_last)) {
      if (_enabled(candidate)) {
        setState(() {
          _focused = candidate;
        });
        final double target =
            (_calendar.monthDelta(_first, candidate) * _monthHeight).clamp(
              0,
              _scroll!.position.maxScrollExtent,
            );
        final Duration duration = reducedMotionDuration(
          context,
          _style.animationDuration ?? const Duration(milliseconds: 200),
        );
        if (duration == Duration.zero) {
          _scroll!.jumpTo(target);
        } else {
          _scroll!.animateTo(
            target,
            duration: duration,
            curve: _style.animationCurve ?? Curves.easeOutCubic,
          );
        }
        return;
      }
      candidate = _calendar.addDaysToDate(candidate, delta < 0 ? -1 : 1);
    }
  }

  @override
  void dispose() {
    _scroll?.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatePickerStyle style = _style;
    final PureLocalizations l = PureLocalizations.of(context);
    return Container(
      width: style.monthWidth ?? 336,
      decoration: style.decoration,
      padding: style.padding,
      child: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          menuKeyActivator(0x00100000302): const _RangeMoveIntent(
            -1,
            directional: true,
          ),
          menuKeyActivator(0x00100000303): const _RangeMoveIntent(
            1,
            directional: true,
          ),
          menuKeyActivator(0x00100000304): const _RangeMoveIntent(-7),
          menuKeyActivator(0x00100000301): const _RangeMoveIntent(7),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            _RangeMoveIntent: CallbackAction<_RangeMoveIntent>(
              onInvoke: (_RangeMoveIntent intent) {
                _move(intent);
                return null;
              },
            ),
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                _select(_focused);
                return null;
              },
            ),
            ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
              onInvoke: (ButtonActivateIntent intent) {
                _select(_focused);
                return null;
              },
            ),
          },
          child: Focus(
            focusNode: _focus,
            autofocus: widget.autofocus,
            onFocusChange: (bool focused) => setState(() {}),
            child: ListView.builder(
              controller: _scroll,
              padding: EdgeInsets.zero,
              itemExtent: _monthHeight,
              itemCount: _calendar.monthDelta(_first, _last) + 1,
              itemBuilder: (BuildContext context, int index) {
                final DateTime month = _calendar.addMonthsToMonthDate(
                  _first,
                  index,
                );
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Semantics(
                          header: true,
                          liveRegion: _calendar.isSameMonth(month, _focused),
                          child: Text(
                            _calendar.formatMonthYear(month, l),
                            style: style.headerTextStyle,
                          ),
                        ),
                      ),
                    ),
                    PickerMonthView(
                      month: month,
                      firstDate: _first,
                      lastDate: _last,
                      currentDate: widget.currentDate ?? _calendar.now(),
                      selectedDate: _start,
                      endDate: _end,
                      focusedDate: _focus.hasFocus ? _focused : null,
                      isRange: true,
                      onChanged: _select,
                      selectableDayPredicate: _enabled,
                      style: style,
                      calendarDelegate: _calendar,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A modal date-range picker with calendar and validated range input modes.
class DateRangePickerDialog extends StatefulWidget {
  /// Creates a date-range dialog.
  const DateRangePickerDialog({
    super.key,
    this.initialDateRange,
    required this.firstDate,
    required this.lastDate,
    this.currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.saveText,
    this.errorFormatText,
    this.errorInvalidText,
    this.errorInvalidRangeText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.selectableDayPredicate,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.style,
    this.restorationId,
  });

  /// Initially selected date range.
  final DateTimeRange<DateTime>? initialDateRange;

  /// First selectable date.
  final DateTime firstDate;

  /// Last selectable date.
  final DateTime lastDate;

  /// Overrides the date marked as today.
  final DateTime? currentDate;

  /// Initial calendar or input entry mode.
  final DatePickerEntryMode initialEntryMode;

  /// Overrides the localized help text.
  final String? helpText;

  /// Overrides the cancel label.
  final String? cancelText;

  /// Overrides the input confirmation label.
  final String? confirmText;

  /// Overrides the calendar save label.
  final String? saveText;

  /// Overrides the compact-date format error.
  final String? errorFormatText;

  /// Overrides the out-of-bounds date error.
  final String? errorInvalidText;

  /// Overrides the invalid-range error.
  final String? errorInvalidRangeText;

  /// Overrides the start input hint.
  final String? fieldStartHintText;

  /// Overrides the end input hint.
  final String? fieldEndHintText;

  /// Overrides the start input label.
  final String? fieldStartLabelText;

  /// Overrides the end input label.
  final String? fieldEndLabelText;

  /// Additional range-dependent date selection constraint.
  final SelectableDayForRangePredicate? selectableDayPredicate;

  /// Calendar arithmetic and formatting.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Appearance and motion tokens.
  final DatePickerStyle? style;

  /// Reserved restoration scope identifier.
  final String? restorationId;

  @override
  State<DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> {
  late DatePickerEntryMode _mode;
  DateTime? _start;
  DateTime? _end;
  String? _rangeError;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool get _input =>
      _mode == DatePickerEntryMode.input ||
      _mode == DatePickerEntryMode.inputOnly;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialEntryMode;
    _start = widget.initialDateRange == null
        ? null
        : widget.calendarDelegate.dateOnly(widget.initialDateRange!.start);
    _end = widget.initialDateRange == null
        ? null
        : widget.calendarDelegate.dateOnly(widget.initialDateRange!.end);
  }

  bool _saveInput() {
    if (!(_form.currentState?.validate() ?? false)) return false;
    _form.currentState!.save();
    final bool valid =
        _start != null &&
        _end != null &&
        !_end!.isBefore(_start!) &&
        (widget.selectableDayPredicate?.call(_start!, _start, _end) ?? true) &&
        (widget.selectableDayPredicate?.call(_end!, _start, _end) ?? true);
    setState(() {
      _rangeError = valid
          ? null
          : widget.errorInvalidRangeText ??
                PureLocalizations.of(context).invalidDateRangeLabel;
    });
    return valid;
  }

  void _confirm() {
    if (_input && !_saveInput()) return;
    if (_start == null || _end == null) return;
    Navigator.of(context)
        .pop(DateTimeRange<DateTime>(start: _start!, end: _end!));
  }

  @override
  Widget build(BuildContext context) {
    final PureLocalizations l = PureLocalizations.of(context);
    final DatePickerStyle style = (widget.style ?? const DatePickerStyle())
        .merge(DatePickerTheme.of(context));
    final bool canToggle =
        _mode != DatePickerEntryMode.inputOnly &&
        _mode != DatePickerEntryMode.calendarOnly;
    return Dialog(
      child: SizedBox(
        width: style.monthWidth ?? 336,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.helpText ?? l.dateRangePickerHelpText,
                      style: style.headerTextStyle,
                    ),
                  ),
                  if (canToggle)
                    IconButton(
                      style: style.entryModeButtonStyle,
                      tooltip: _input
                          ? l.calendarModeButtonLabel
                          : l.inputDateModeButtonLabel,
                      onPressed: () {
                        if (_input && !_saveInput()) return;
                        setState(() {
                          _mode = _input
                              ? DatePickerEntryMode.calendar
                              : DatePickerEntryMode.input;
                        });
                      },
                      icon: _input ? const CalendarGlyph() : const EditGlyph(),
                    ),
                ],
              ),
              Semantics(
                liveRegion: true,
                child: Text(
                  '${_start == null ? l.dateRangeStartLabel : widget.calendarDelegate.formatShortDate(_start!, l)}'
                  ' - ${_end == null ? l.dateRangeEndLabel : widget.calendarDelegate.formatShortDate(_end!, l)}',
                  style: style.headerTextStyle,
                ),
              ),
              if (_input)
                Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InputDatePickerFormField(
                        initialDate: _start,
                        firstDate: widget.firstDate,
                        lastDate: widget.lastDate,
                        calendarDelegate: widget.calendarDelegate,
                        errorFormatText: widget.errorFormatText,
                        errorInvalidText: widget.errorInvalidText,
                        fieldHintText: widget.fieldStartHintText,
                        fieldLabelText:
                            widget.fieldStartLabelText ?? l.dateRangeStartLabel,
                        onDateSaved: (DateTime date) {
                          _start = date;
                        },
                        autofocus: true,
                      ),
                      InputDatePickerFormField(
                        initialDate: _end,
                        firstDate: widget.firstDate,
                        lastDate: widget.lastDate,
                        calendarDelegate: widget.calendarDelegate,
                        errorFormatText: widget.errorFormatText,
                        errorInvalidText: widget.errorInvalidText,
                        fieldHintText: widget.fieldEndHintText,
                        fieldLabelText:
                            widget.fieldEndLabelText ?? l.dateRangeEndLabel,
                        onDateSaved: (DateTime date) {
                          _end = date;
                        },
                      ),
                      if (_rangeError != null)
                        Semantics(liveRegion: true, child: Text(_rangeError!)),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: (MediaQuery.sizeOf(context).height * .55).clamp(
                    160,
                    400,
                  ),
                  child: CalendarDateRangePicker(
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    initialStartDate: _start,
                    initialEndDate: _end,
                    currentDate: widget.currentDate,
                    calendarDelegate: widget.calendarDelegate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    style: style,
                    autofocus: true,
                    onStartDateChanged: (DateTime date) => setState(() {
                      _start = date;
                      _end = null;
                    }),
                    onEndDateChanged: (DateTime date) => setState(() {
                      _end = date;
                    }),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(widget.cancelText ?? l.cancelButtonLabel),
                  ),
                  TextButton(
                    onPressed: _input || (_start != null && _end != null)
                        ? _confirm
                        : null,
                    child: Text(
                      (_input ? widget.confirmText : widget.saveText) ??
                          l.saveButtonLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a range picker and returns the confirmed inclusive range.
Future<DateTimeRange<DateTime>?> showDateRangePicker({
  required BuildContext context,
  DateTimeRange<DateTime>? initialDateRange,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? saveText,
  String? errorFormatText,
  String? errorInvalidText,
  String? errorInvalidRangeText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? fieldStartLabelText,
  String? fieldEndLabelText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  Offset? anchorPoint,
  bool barrierDismissible = true,
  String? barrierLabel,
  SelectableDayForRangePredicate? selectableDayPredicate,
  CalendarDelegate<DateTime> calendarDelegate =
      const GregorianCalendarDelegate(),
  DatePickerStyle? style,
}) {
  initialDateRange = initialDateRange == null
      ? null
      : calendarDelegate.datesOnly(initialDateRange);
  firstDate = calendarDelegate.dateOnly(firstDate);
  lastDate = calendarDelegate.dateOnly(lastDate);
  currentDate = calendarDelegate.dateOnly(
    currentDate ?? calendarDelegate.now(),
  );
  assert(!lastDate.isBefore(firstDate));
  assert(
    initialDateRange == null ||
        (!initialDateRange.start.isBefore(firstDate) &&
            !initialDateRange.end.isAfter(lastDate)),
  );
  assert(
    initialDateRange == null ||
        selectableDayPredicate == null ||
        (selectableDayPredicate(
              initialDateRange.start,
              initialDateRange.start,
              initialDateRange.end,
            ) &&
            selectableDayPredicate(
              initialDateRange.end,
              initialDateRange.start,
              initialDateRange.end,
            )),
  );
  Widget dialog = DateRangePickerDialog(
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    saveText: saveText,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    errorInvalidRangeText: errorInvalidRangeText,
    fieldStartHintText: fieldStartHintText,
    fieldEndHintText: fieldEndHintText,
    fieldStartLabelText: fieldStartLabelText,
    fieldEndLabelText: fieldEndLabelText,
    selectableDayPredicate: selectableDayPredicate,
    calendarDelegate: calendarDelegate,
    style: style,
  );
  if (textDirection != null) {
    dialog = Directionality(textDirection: textDirection, child: dialog);
  }
  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }
  return showDialog<DateTimeRange<DateTime>>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    builder: (BuildContext context) => builder?.call(context, dialog) ?? dialog,
  );
}
