import 'package:flutter/widgets.dart';

import '../dates/date.dart';
import '../foundation/animated_surface.dart';
import '../foundation/interaction_detector.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/style_resolution.dart';
import '../foundation/tap_target.dart';
import '../localizations/pure_localizations.dart';
import '../styles/button_style.dart';
import '../styles/date_picker_style.dart';

/// An independently animated cell shared by calendars, years and segments.
class PickerCell extends StatelessWidget {
  /// Creates a keyboard-independent interactive cell.
  const PickerCell({
    super.key,
    required this.child,
    required this.onPressed,
    this.styles = const <ButtonStyle?>[],
    this.selected = false,
    this.focused = false,
    this.label,
    this.today = false,
    this.canRequestFocus = true,
  });

  /// Content centered in the cell.
  final Widget child;

  /// Null disables selection.
  final VoidCallback? onPressed;

  /// Appearance tokens in precedence order.
  final List<ButtonStyle?> styles;

  /// Whether this cell represents a selected value.
  final bool selected;

  /// Whether the calendar's virtual focus is here.
  final bool focused;

  /// Full accessibility label.
  final String? label;

  /// Whether to paint the current date indicator.
  final bool today;

  /// Whether this cell participates in ordinary focus traversal.
  final bool canRequestFocus;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    selected: selected,
    focused: focused ? true : null,
    liveRegion: focused,
    button: true,
    enabled: onPressed != null,
    excludeSemantics: label != null,
    onTap: onPressed,
    child: InteractionDetector(
      enabled: onPressed != null,
      isSelected: selected,
      isFocused: focused ? true : null,
      canRequestFocus: canRequestFocus,
      onTap: onPressed,
      excludeFromSemantics: true,
      builder: (BuildContext context, InteractionState state) {
        final Duration duration = reducedMotionDuration(
          context,
          resolvePlain(styles, (ButtonStyle s) => s.animationDuration) ??
              const Duration(milliseconds: 150),
        );
        final TextStyle textStyle = DefaultTextStyle.of(context).style.merge(
          resolveStateful(state, styles, (ButtonStyle s) => s.textStyle),
        );
        Widget content = AnimatedDefaultTextStyle(
          style: textStyle,
          duration: duration,
          child: Center(child: child),
        );
        final Decoration? decoration = resolveStateful(
          state,
          styles,
          (ButtonStyle s) => s.decoration,
        );
        if (decoration == null &&
            !styles.any((ButtonStyle? s) => s?.decoration != null)) {
          content = Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: selected || today || focused ? 1 : 0,
                  duration: duration,
                  child: CustomPaint(
                    painter: _CellIndicator(
                      color:
                          IconTheme.of(context).color ??
                          textStyle.color ??
                          const Color(0xFF000000),
                      today: today,
                      focused: focused,
                      selected: selected,
                    ),
                  ),
                ),
              ),
              content,
            ],
          );
        }
        final Size? fixed = resolveStateful(
          state,
          styles,
          (ButtonStyle s) => s.fixedSize,
        );
        return TapTarget(
          minSize:
              resolvePlain(styles, (ButtonStyle s) => s.tapTargetSize) ??
              Size.zero,
          child: AnimatedSurface(
            duration: duration,
            curve:
                resolvePlain(styles, (ButtonStyle s) => s.animationCurve) ??
                Curves.easeOutCubic,
            decoration: decoration,
            foregroundDecoration: resolveStateful(
              state,
              styles,
              (ButtonStyle s) => s.foregroundDecoration,
            ),
            padding: resolveStateful(
              state,
              styles,
              (ButtonStyle s) => s.padding,
            ),
            width: fixed?.width,
            height: fixed?.height,
            child: content,
          ),
        );
      },
    ),
  );
}

class _CellIndicator extends CustomPainter {
  const _CellIndicator({
    required this.color,
    required this.today,
    required this.focused,
    required this.selected,
  });
  final Color color;
  final bool today;
  final bool focused;
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 2 : 1;
    final double radius = size.shortestSide * .38;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
    if (focused) {
      canvas.drawLine(
        Offset(size.width * .35, size.height * .78),
        Offset(size.width * .65, size.height * .78),
        paint,
      );
    }
    if (today) {
      canvas.drawCircle(
        Offset(size.width * .5, size.height * .85),
        1.5,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_CellIndicator oldDelegate) =>
      color != oldDelegate.color ||
      today != oldDelegate.today ||
      focused != oldDelegate.focused ||
      selected != oldDelegate.selected;
}

/// A lazy, non-scrollable month grid for single and range calendars.
class PickerMonthView extends StatelessWidget {
  /// Creates a calendar month.
  const PickerMonthView({
    super.key,
    required this.month,
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.onChanged,
    required this.style,
    required this.calendarDelegate,
    this.selectedDate,
    this.focusedDate,
    this.endDate,
    this.isRange = false,
    this.selectableDayPredicate,
  });

  /// The month to render.
  final DateTime month;

  /// Lower selectable bound.
  final DateTime firstDate;

  /// Upper selectable bound.
  final DateTime lastDate;

  /// The date marked as today.
  final DateTime currentDate;

  /// The selected date or range start.
  final DateTime? selectedDate;

  /// The date with virtual keyboard focus.
  final DateTime? focusedDate;

  /// The selected range end.
  final DateTime? endDate;

  /// Whether to draw range highlights.
  final bool isRange;

  /// Selection callback.
  final ValueChanged<DateTime> onChanged;

  /// Optional additional selection constraint.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Resolved calendar tokens.
  final DatePickerStyle style;

  /// Date arithmetic and formatting.
  final CalendarDelegate<DateTime> calendarDelegate;

  @override
  Widget build(BuildContext context) {
    final PureLocalizations l = PureLocalizations.of(context);
    final int offset = calendarDelegate.firstDayOffset(
      month.year,
      month.month,
      l,
    );
    final int days = calendarDelegate.getDaysInMonth(month.year, month.month);
    final double extent = style.dayExtent ?? 40;
    return Column(
      children: <Widget>[
        SizedBox(
          height: extent,
          child: Row(
            children: List<Widget>.generate(7, (int index) {
              final int weekday = (index + l.firstDayOfWeekIndex) % 7;
              return Expanded(
                child: Center(
                  child: Text(
                    l.narrowWeekdays[weekday],
                    style: style.weekdayTextStyle,
                    semanticsLabel: l.weekdays[weekday],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: extent * 6,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: extent,
            ),
            itemBuilder: (BuildContext context, int index) {
              final int day = index - offset + 1;
              if (day < 1 || day > days) return const SizedBox.shrink();
              final DateTime date = calendarDelegate.getDay(
                month.year,
                month.month,
                day,
              );
              final bool enabled =
                  !date.isBefore(firstDate) &&
                  !date.isAfter(lastDate) &&
                  (selectableDayPredicate?.call(date) ?? true);
              final bool start = calendarDelegate.isSameDay(date, selectedDate);
              final bool end =
                  isRange && calendarDelegate.isSameDay(date, endDate);
              final bool inRange =
                  isRange &&
                  selectedDate != null &&
                  endDate != null &&
                  !date.isBefore(selectedDate!) &&
                  !date.isAfter(endDate!);
              final bool today = calendarDelegate.isSameDay(date, currentDate);
              final bool focused = calendarDelegate.isSameDay(
                date,
                focusedDate,
              );
              String label =
                  '${l.formatDecimal(day)}, '
                  '${calendarDelegate.formatFullDate(date, l)}'
                  '${today ? ', ${l.currentDateLabel}' : ''}';
              if (isRange && start) {
                label = l.dateRangeStartDateSemanticLabel(label);
              }
              if (isRange && end) {
                label = l.dateRangeEndDateSemanticLabel(label);
              }
              Widget cell = PickerCell(
                key: ValueKey<DateTime>(date),
                label: label,
                selected: start || end,
                today: today,
                focused: focused,
                canRequestFocus: false,
                onPressed: enabled ? () => onChanged(date) : null,
                styles: <ButtonStyle?>[
                  if (!enabled) style.disabledDayStyle,
                  if (start && isRange) style.rangeStartStyle,
                  if (end) style.rangeEndStyle,
                  if (start || end) style.selectedDayStyle,
                  if (inRange) style.inRangeDayStyle,
                  if (today) style.todayStyle,
                  style.dayStyle,
                  ButtonStyle(
                    animationDuration: style.animationDuration,
                    animationCurve: style.animationCurve,
                  ),
                ],
                child: Text(l.formatDecimal(day)),
              );
              if (isRange) {
                cell = Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    AnimatedFractionallySizedBox(
                      duration: reducedMotionDuration(
                        context,
                        style.animationDuration ??
                            const Duration(milliseconds: 200),
                      ),
                      curve: style.animationCurve ?? Curves.easeOutCubic,
                      alignment: start && !end
                          ? AlignmentDirectional.centerEnd
                          : end && !start
                          ? AlignmentDirectional.centerStart
                          : Alignment.center,
                      widthFactor: inRange ? (start != end ? .5 : 1) : 0,
                      heightFactor: .65,
                      child: AnimatedSurface(
                        duration: reducedMotionDuration(
                          context,
                          style.animationDuration ??
                              const Duration(milliseconds: 200),
                        ),
                        decoration: inRange ? style.rangeBandDecoration : null,
                        child: CustomPaint(
                          painter: style.rangeBandDecoration == null
                              ? _RangeBandPainter(
                                  IconTheme.of(context).color ??
                                      DefaultTextStyle.of(context)
                                          .style
                                          .color ??
                                      const Color(0xFF000000),
                                )
                              : null,
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                    cell,
                  ],
                );
              }
              return cell;
            },
          ),
        ),
      ],
    );
  }
}

class _RangeBandPainter extends CustomPainter {
  const _RangeBandPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawRect(
    Offset.zero & size,
    Paint()..color = color.withValues(alpha: color.a * .12),
  );

  @override
  bool shouldRepaint(_RangeBandPainter oldDelegate) =>
      color != oldDelegate.color;
}
