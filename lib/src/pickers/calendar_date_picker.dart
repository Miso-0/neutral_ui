import 'package:flutter/widgets.dart';

import '../buttons/icon_button.dart';
import '../buttons/text_button.dart';
import '../dates/date.dart';
import '../foundation/decoration_override.dart';
import '../foundation/glyphs.dart';
import '../foundation/motion.dart';
import '../localizations/pure_localizations.dart';
import '../menus/key_activators.dart';
import '../styles/date_picker_style.dart';
import '../styles/button_style.dart';
import '../theme/picker_themes.dart';
import 'picker_common.dart';

/// A lazily paged calendar with day and year selection.
class CalendarDatePicker extends StatefulWidget {
  /// Creates an inline date picker within inclusive date bounds.
  CalendarDatePicker({
    super.key,
    required DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required this.onDateChanged,
    this.currentDate,
    this.onDisplayedMonthChanged,
    this.initialCalendarMode = DatePickerMode.day,
    this.selectableDayPredicate,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.style,
    this.decoration,
    this.autofocus = false,
  }) : initialDate = initialDate == null
           ? null
           : calendarDelegate.dateOnly(initialDate),
       firstDate = calendarDelegate.dateOnly(firstDate),
       lastDate = calendarDelegate.dateOnly(lastDate),
       assert(
         !calendarDelegate
             .dateOnly(lastDate)
             .isBefore(calendarDelegate.dateOnly(firstDate)),
       ),
       assert(
         initialDate == null ||
             !calendarDelegate
                 .dateOnly(initialDate)
                 .isBefore(calendarDelegate.dateOnly(firstDate)),
       ),
       assert(
         initialDate == null ||
             !calendarDelegate
                 .dateOnly(initialDate)
                 .isAfter(calendarDelegate.dateOnly(lastDate)),
       ),
       assert(
         initialDate == null ||
             selectableDayPredicate == null ||
             selectableDayPredicate(calendarDelegate.dateOnly(initialDate)),
       );

  /// Initially selected date, or null for an unselected calendar.
  final DateTime? initialDate;

  /// First selectable date, inclusive.
  final DateTime firstDate;

  /// Last selectable date, inclusive.
  final DateTime lastDate;

  /// Called when a day is selected.
  final ValueChanged<DateTime> onDateChanged;

  /// Overrides the date marked as today.
  final DateTime? currentDate;

  /// Called when swiping or keyboard navigation changes the displayed month.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Initial day or year selection mode.
  final DatePickerMode initialCalendarMode;

  /// Additional date selection constraint.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Calendar arithmetic and localized formatting.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Inline appearance and motion overrides.
  final DatePickerStyle? style;

  /// Overrides the calendar surface decoration.
  final BoxDecoration? decoration;

  /// Whether the day grid requests initial keyboard focus.
  final bool autofocus;

  @override
  State<CalendarDatePicker> createState() => _CalendarDatePickerState();
}

class _MoveDateIntent extends Intent {
  const _MoveDateIntent(this.delta, {this.directional = false});
  final int delta;
  final bool directional;
}

class _CalendarDatePickerState extends State<CalendarDatePicker> {
  late DateTime _month;
  DateTime? _selected;
  late DateTime _focused;
  late DatePickerMode _mode;
  late final PageController _pages;
  late int _targetPage;
  bool _userPaging = false;
  final FocusNode _gridFocus = FocusNode(debugLabel: 'Calendar day grid');

  CalendarDelegate<DateTime> get _calendar => widget.calendarDelegate;
  DateTime get _first => _calendar.dateOnly(widget.firstDate);
  DateTime get _last => _calendar.dateOnly(widget.lastDate);
  DatePickerStyle get _style => (widget.style ?? const DatePickerStyle()).merge(
    DatePickerTheme.of(context),
  );

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate == null
        ? null
        : _calendar.dateOnly(widget.initialDate!);
    final DateTime today = _calendar.dateOnly(
      widget.currentDate ?? _calendar.now(),
    );
    _focused =
        _selected ??
        (today.isBefore(_first)
            ? _first
            : today.isAfter(_last)
            ? _last
            : today);
    _month = _calendar.getMonth(_focused.year, _focused.month);
    _mode = widget.initialCalendarMode;
    _targetPage = _calendar.monthDelta(_first, _month);
    _pages = PageController(initialPage: _targetPage);
  }

  @override
  void didUpdateWidget(CalendarDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool changedDate = widget.initialDate != oldWidget.initialDate;
    final bool changedCalendar =
        widget.calendarDelegate != oldWidget.calendarDelegate ||
        widget.firstDate != oldWidget.firstDate ||
        widget.lastDate != oldWidget.lastDate;
    if (changedDate) {
      _selected = widget.initialDate;
      if (_selected != null) _focused = _selected!;
    }
    if (changedDate || changedCalendar) {
      _focused = _calendar.dateOnly(_focused);
      if (_selected != null && !_enabled(_selected!)) _selected = null;
      if (_focused.isBefore(_first)) _focused = _first;
      if (_focused.isAfter(_last)) _focused = _last;
      _month = _calendar.getMonth(_focused.year, _focused.month);
      _targetPage = _calendar.monthDelta(_first, _month);
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted && _pages.hasClients) _pages.jumpToPage(_targetPage);
      });
    }
  }

  DateTime _focusInMonth(DateTime month) {
    DateTime date = _calendar.getDay(
      month.year,
      month.month,
      _focused.day.clamp(1, _calendar.getDaysInMonth(month.year, month.month)),
    );
    if (date.isBefore(_first)) date = _first;
    if (date.isAfter(_last)) date = _last;
    if (_enabled(date)) return date;
    DateTime next = date;
    DateTime previous = date;
    for (
      int i = 0;
      i < _calendar.getDaysInMonth(month.year, month.month);
      i++
    ) {
      next = _calendar.addDaysToDate(next, 1);
      if (_calendar.isSameMonth(next, month) && _enabled(next)) return next;
      previous = _calendar.addDaysToDate(previous, -1);
      if (_calendar.isSameMonth(previous, month) && _enabled(previous)) {
        return previous;
      }
    }
    return date;
  }

  bool _enabled(DateTime date) =>
      !date.isBefore(_first) &&
      !date.isAfter(_last) &&
      (widget.selectableDayPredicate?.call(date) ?? true);

  void _select(DateTime date) {
    if (!_enabled(date)) return;
    setState(() {
      _selected = date;
      _focused = date;
    });
    widget.onDateChanged(date);
  }

  void _showMonth(DateTime date) {
    final int page = _calendar.monthDelta(_first, date);
    final int count = _calendar.monthDelta(_first, _last) + 1;
    if (page < 0 || page >= count || !_pages.hasClients) return;
    _targetPage = page;
    _userPaging = false;
    final Duration duration = reducedMotionDuration(
      context,
      _style.animationDuration ?? const Duration(milliseconds: 200),
    );
    if (duration == Duration.zero) {
      _pages.jumpToPage(page);
    } else {
      _pages.animateToPage(
        page,
        duration: duration,
        curve: _style.animationCurve ?? Curves.easeOutCubic,
      );
    }
  }

  void _move(_MoveDateIntent intent) {
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final int delta = intent.directional && rtl ? -intent.delta : intent.delta;
    DateTime candidate = _calendar.addDaysToDate(_focused, delta);
    final int step = delta < 0 ? -1 : 1;
    while (!candidate.isBefore(_first) && !candidate.isAfter(_last)) {
      if (_enabled(candidate)) {
        setState(() {
          _focused = candidate;
        });
        _showMonth(candidate);
        return;
      }
      candidate = _calendar.addDaysToDate(candidate, step);
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    _gridFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatePickerStyle style = _style;
    assert(
      debugCheckDecorationOverride(
        widget: 'CalendarDatePicker',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: widget.decoration,
        styleValue: widget.style?.decoration,
      ),
    );
    final PureLocalizations l = PureLocalizations.of(context);
    final Duration duration = reducedMotionDuration(
      context,
      style.animationDuration ?? const Duration(milliseconds: 200),
    );
    final int page = _calendar.monthDelta(_first, _month);
    final int count = _calendar.monthDelta(_first, _last) + 1;
    final double extent = style.dayExtent ?? 40;
    return Container(
      decoration: widget.decoration ?? style.decoration,
      padding: style.padding,
      width: style.monthWidth ?? 336,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  style: style.navigationButtonStyle,
                  onPressed: () => setState(() {
                    _mode = _mode == DatePickerMode.day
                        ? DatePickerMode.year
                        : DatePickerMode.day;
                  }),
                  trailing: AnimatedRotation(
                    turns: _mode == DatePickerMode.year ? .5 : 0,
                    duration: duration,
                    child: const ChevronGlyph(direction: GlyphDirection.down),
                  ),
                  child: Semantics(
                    liveRegion: true,
                    label: _mode == DatePickerMode.day
                        ? null
                        : l.selectYearSemanticsLabel,
                    child: AnimatedSwitcher(
                      duration: duration,
                      child: Text(
                        _calendar.formatMonthYear(_month, l),
                        key: ValueKey<DateTime>(_month),
                        style: style.headerTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: page > 0
                    ? () => _showMonth(
                        _calendar.addMonthsToMonthDate(_first, _targetPage - 1),
                      )
                    : null,
                style: style.navigationButtonStyle,
                tooltip: l.previousMonthTooltip,
                icon: const ChevronGlyph(direction: GlyphDirection.start),
              ),
              IconButton(
                onPressed: page < count - 1
                    ? () => _showMonth(
                        _calendar.addMonthsToMonthDate(_first, _targetPage + 1),
                      )
                    : null,
                style: style.navigationButtonStyle,
                tooltip: l.nextMonthTooltip,
                icon: const ChevronGlyph(direction: GlyphDirection.end),
              ),
            ],
          ),
          SizedBox(
            height: extent * 7,
            child: _mode == DatePickerMode.year
                ? YearPicker(
                    firstDate: _first,
                    lastDate: _last,
                    selectedDate: _selected ?? _focused,
                    currentDate: widget.currentDate,
                    calendarDelegate: _calendar,
                    style: style,
                    onChanged: (DateTime date) {
                      final int day = _focused.day.clamp(
                        1,
                        _calendar.getDaysInMonth(date.year, _focused.month),
                      );
                      DateTime next = _calendar.getDay(
                        date.year,
                        _focused.month,
                        day,
                      );
                      if (next.isBefore(_first)) next = _first;
                      if (next.isAfter(_last)) next = _last;
                      setState(() {
                        _focused = next;
                        _mode = DatePickerMode.day;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((
                        Duration _,
                      ) {
                        if (mounted) {
                          _showMonth(next);
                          _gridFocus.requestFocus();
                        }
                      });
                    },
                  )
                : Shortcuts(
                    shortcuts: <ShortcutActivator, Intent>{
                      menuKeyActivator(0x00100000302): const _MoveDateIntent(
                        -1,
                        directional: true,
                      ),
                      menuKeyActivator(0x00100000303): const _MoveDateIntent(
                        1,
                        directional: true,
                      ),
                      menuKeyActivator(0x00100000304): const _MoveDateIntent(
                        -7,
                      ),
                      menuKeyActivator(0x00100000301): const _MoveDateIntent(7),
                    },
                    child: Actions(
                      actions: <Type, Action<Intent>>{
                        _MoveDateIntent: CallbackAction<_MoveDateIntent>(
                          onInvoke: (_MoveDateIntent intent) {
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
                        ButtonActivateIntent:
                            CallbackAction<ButtonActivateIntent>(
                              onInvoke: (ButtonActivateIntent intent) {
                                _select(_focused);
                                return null;
                              },
                            ),
                      },
                      child: Focus(
                        focusNode: _gridFocus,
                        autofocus: widget.autofocus,
                        onFocusChange: (bool focused) => setState(() {}),
                        child: Listener(
                          onPointerDown: (PointerDownEvent event) {
                            _userPaging = true;
                          },
                          child: NotificationListener<ScrollEndNotification>(
                            onNotification:
                                (ScrollEndNotification notification) {
                                  _userPaging = false;
                                  if (_pages.hasClients) {
                                    _targetPage = _pages.page!.round();
                                  }
                                  return false;
                                },
                            child: PageView.builder(
                              controller: _pages,
                              itemCount: count,
                              onPageChanged: (int index) {
                                final DateTime month = _calendar
                                    .addMonthsToMonthDate(_first, index);
                                setState(() {
                                  _month = month;
                                  if (_userPaging) _targetPage = index;
                                  if ((_userPaging || _targetPage == index) &&
                                      !_calendar.isSameMonth(_focused, month)) {
                                    _focused = _focusInMonth(month);
                                  }
                                });
                                widget.onDisplayedMonthChanged?.call(month);
                              },
                              itemBuilder: (BuildContext context, int index) =>
                                  PickerMonthView(
                                    month: _calendar.addMonthsToMonthDate(
                                      _first,
                                      index,
                                    ),
                                    firstDate: _first,
                                    lastDate: _last,
                                    selectedDate: _selected,
                                    focusedDate: _gridFocus.hasFocus
                                        ? _focused
                                        : null,
                                    currentDate: _calendar.dateOnly(
                                      widget.currentDate ?? _calendar.now(),
                                    ),
                                    onChanged: _select,
                                    selectableDayPredicate:
                                        widget.selectableDayPredicate,
                                    style: style,
                                    calendarDelegate: _calendar,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// A lazy year grid which initially scrolls to the selected year.
class YearPicker extends StatefulWidget {
  /// Creates a year picker within inclusive date bounds.
  const YearPicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.currentDate,
    this.initialDate,
    this.calendarDelegate = const GregorianCalendarDelegate(),
    this.style,
  });

  /// First selectable year.
  final DateTime firstDate;

  /// Last selectable year.
  final DateTime lastDate;

  /// The date whose year is selected.
  final DateTime selectedDate;

  /// Called when a year is chosen.
  final ValueChanged<DateTime> onChanged;

  /// Date whose year is marked as current.
  final DateTime? currentDate;

  /// Optional initial scroll target.
  final DateTime? initialDate;

  /// Calendar arithmetic and formatting.
  final CalendarDelegate<DateTime> calendarDelegate;

  /// Inline appearance tokens.
  final DatePickerStyle? style;

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  ScrollController? _scroll;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scroll != null) return;
    final DatePickerStyle style = (widget.style ?? const DatePickerStyle())
        .merge(DatePickerTheme.of(context));
    final int index =
        ((widget.initialDate ?? widget.selectedDate).year -
                widget.firstDate.year)
            .clamp(0, widget.lastDate.year - widget.firstDate.year);
    _scroll = ScrollController(
      initialScrollOffset:
          (index ~/ 3 - 1).clamp(0, 100000) * (style.yearExtent ?? 48),
    );
  }

  @override
  void dispose() {
    _scroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatePickerStyle style = (widget.style ?? const DatePickerStyle())
        .merge(DatePickerTheme.of(context));
    final PureLocalizations l = PureLocalizations.of(context);
    return GridView.builder(
      controller: _scroll,
      padding: EdgeInsets.zero,
      itemCount: widget.lastDate.year - widget.firstDate.year + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: style.yearExtent ?? 48,
      ),
      itemBuilder: (BuildContext context, int index) {
        final int year = widget.firstDate.year + index;
        return PickerCell(
          key: ValueKey<int>(year),
          selected: year == widget.selectedDate.year,
          today:
              year ==
              (widget.currentDate ?? widget.calendarDelegate.now()).year,
          label: widget.calendarDelegate.formatYear(year, l),
          styles: <ButtonStyle?>[style.yearStyle],
          onPressed: () => widget.onChanged(
            widget.calendarDelegate.getDay(
              year,
              widget.selectedDate.month,
              widget.selectedDate.day.clamp(
                1,
                widget.calendarDelegate.getDaysInMonth(
                  year,
                  widget.selectedDate.month,
                ),
              ),
            ),
          ),
          child: Text(widget.calendarDelegate.formatYear(year, l)),
        );
      },
    );
  }
}
