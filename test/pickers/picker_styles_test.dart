import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

void main() {
  Widget transition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) => child;
  test('DatePickerStyle.decoration inherits, copies and participates in value identity', () {
    final Decoration value = const BoxDecoration(color: Color(0xFF123456));
    final DatePickerStyle style = DatePickerStyle(decoration: value);
    expect(const DatePickerStyle().decoration, isNull);
    expect(const DatePickerStyle().copyWith(decoration: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(decoration: value).hashCode);
    expect(style.toString(), contains('decoration: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.padding inherits, copies and participates in value identity', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(
      start: 11,
    );
    final DatePickerStyle style = DatePickerStyle(padding: value);
    expect(const DatePickerStyle().padding, isNull);
    expect(const DatePickerStyle().copyWith(padding: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(padding: value).hashCode);
    expect(style.toString(), contains('padding: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.headerTextStyle inherits, copies and participates in value identity', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final DatePickerStyle style = DatePickerStyle(headerTextStyle: value);
    expect(const DatePickerStyle().headerTextStyle, isNull);
    expect(const DatePickerStyle().copyWith(headerTextStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(headerTextStyle: value).hashCode);
    expect(style.toString(), contains('headerTextStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.weekdayTextStyle inherits, copies and participates in value identity', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final DatePickerStyle style = DatePickerStyle(weekdayTextStyle: value);
    expect(const DatePickerStyle().weekdayTextStyle, isNull);
    expect(const DatePickerStyle().copyWith(weekdayTextStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(weekdayTextStyle: value).hashCode);
    expect(style.toString(), contains('weekdayTextStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.dayStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(dayStyle: value);
    expect(const DatePickerStyle().dayStyle, isNull);
    expect(const DatePickerStyle().copyWith(dayStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(dayStyle: value).hashCode);
    expect(style.toString(), contains('dayStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.todayStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(todayStyle: value);
    expect(const DatePickerStyle().todayStyle, isNull);
    expect(const DatePickerStyle().copyWith(todayStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(todayStyle: value).hashCode);
    expect(style.toString(), contains('todayStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.selectedDayStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(selectedDayStyle: value);
    expect(const DatePickerStyle().selectedDayStyle, isNull);
    expect(const DatePickerStyle().copyWith(selectedDayStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(selectedDayStyle: value).hashCode);
    expect(style.toString(), contains('selectedDayStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.inRangeDayStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(inRangeDayStyle: value);
    expect(const DatePickerStyle().inRangeDayStyle, isNull);
    expect(const DatePickerStyle().copyWith(inRangeDayStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(inRangeDayStyle: value).hashCode);
    expect(style.toString(), contains('inRangeDayStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.rangeStartStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(rangeStartStyle: value);
    expect(const DatePickerStyle().rangeStartStyle, isNull);
    expect(const DatePickerStyle().copyWith(rangeStartStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(rangeStartStyle: value).hashCode);
    expect(style.toString(), contains('rangeStartStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.rangeEndStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(rangeEndStyle: value);
    expect(const DatePickerStyle().rangeEndStyle, isNull);
    expect(const DatePickerStyle().copyWith(rangeEndStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(rangeEndStyle: value).hashCode);
    expect(style.toString(), contains('rangeEndStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.yearStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(yearStyle: value);
    expect(const DatePickerStyle().yearStyle, isNull);
    expect(const DatePickerStyle().copyWith(yearStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(yearStyle: value).hashCode);
    expect(style.toString(), contains('yearStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.disabledDayStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(disabledDayStyle: value);
    expect(const DatePickerStyle().disabledDayStyle, isNull);
    expect(const DatePickerStyle().copyWith(disabledDayStyle: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(disabledDayStyle: value).hashCode);
    expect(style.toString(), contains('disabledDayStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.navigationButtonStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(navigationButtonStyle: value);
    expect(const DatePickerStyle().navigationButtonStyle, isNull);
    expect(
      const DatePickerStyle().copyWith(navigationButtonStyle: value),
      style,
    );
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      DatePickerStyle(navigationButtonStyle: value).hashCode,
    );
    expect(style.toString(), contains('navigationButtonStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.entryModeButtonStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final DatePickerStyle style = DatePickerStyle(entryModeButtonStyle: value);
    expect(const DatePickerStyle().entryModeButtonStyle, isNull);
    expect(
      const DatePickerStyle().copyWith(entryModeButtonStyle: value),
      style,
    );
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      DatePickerStyle(entryModeButtonStyle: value).hashCode,
    );
    expect(style.toString(), contains('entryModeButtonStyle: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.rangeBandDecoration inherits, copies and participates in value identity', () {
    final Decoration value = const BoxDecoration(color: Color(0xFF123456));
    final DatePickerStyle style = DatePickerStyle(rangeBandDecoration: value);
    expect(const DatePickerStyle().rangeBandDecoration, isNull);
    expect(const DatePickerStyle().copyWith(rangeBandDecoration: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      DatePickerStyle(rangeBandDecoration: value).hashCode,
    );
    expect(style.toString(), contains('rangeBandDecoration: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.dayExtent inherits, copies and participates in value identity', () {
    final double value = 22.0;
    final DatePickerStyle style = DatePickerStyle(dayExtent: value);
    expect(const DatePickerStyle().dayExtent, isNull);
    expect(const DatePickerStyle().copyWith(dayExtent: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(dayExtent: value).hashCode);
    expect(style.toString(), contains('dayExtent: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.yearExtent inherits, copies and participates in value identity', () {
    final double value = 22.0;
    final DatePickerStyle style = DatePickerStyle(yearExtent: value);
    expect(const DatePickerStyle().yearExtent, isNull);
    expect(const DatePickerStyle().copyWith(yearExtent: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(yearExtent: value).hashCode);
    expect(style.toString(), contains('yearExtent: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.monthWidth inherits, copies and participates in value identity', () {
    final double value = 22.0;
    final DatePickerStyle style = DatePickerStyle(monthWidth: value);
    expect(const DatePickerStyle().monthWidth, isNull);
    expect(const DatePickerStyle().copyWith(monthWidth: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(monthWidth: value).hashCode);
    expect(style.toString(), contains('monthWidth: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.animationDuration inherits, copies and participates in value identity', () {
    final Duration value = const Duration(milliseconds: 177);
    final DatePickerStyle style = DatePickerStyle(animationDuration: value);
    expect(const DatePickerStyle().animationDuration, isNull);
    expect(const DatePickerStyle().copyWith(animationDuration: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(animationDuration: value).hashCode);
    expect(style.toString(), contains('animationDuration: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.animationCurve inherits, copies and participates in value identity', () {
    final Curve value = Curves.easeIn;
    final DatePickerStyle style = DatePickerStyle(animationCurve: value);
    expect(const DatePickerStyle().animationCurve, isNull);
    expect(const DatePickerStyle().copyWith(animationCurve: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(animationCurve: value).hashCode);
    expect(style.toString(), contains('animationCurve: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.placement inherits, copies and participates in value identity', () {
    final OverlayPlacement value = const OverlayPlacement(gap: 7);
    final DatePickerStyle style = DatePickerStyle(placement: value);
    expect(const DatePickerStyle().placement, isNull);
    expect(const DatePickerStyle().copyWith(placement: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(placement: value).hashCode);
    expect(style.toString(), contains('placement: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.outsideTapBehavior inherits, copies and participates in value identity', () {
    final OutsideTapBehavior value = OutsideTapBehavior.consume;
    final DatePickerStyle style = DatePickerStyle(outsideTapBehavior: value);
    expect(const DatePickerStyle().outsideTapBehavior, isNull);
    expect(const DatePickerStyle().copyWith(outsideTapBehavior: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(outsideTapBehavior: value).hashCode);
    expect(style.toString(), contains('outsideTapBehavior: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.transitionDuration inherits, copies and participates in value identity', () {
    final Duration value = const Duration(milliseconds: 177);
    final DatePickerStyle style = DatePickerStyle(transitionDuration: value);
    expect(const DatePickerStyle().transitionDuration, isNull);
    expect(const DatePickerStyle().copyWith(transitionDuration: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(transitionDuration: value).hashCode);
    expect(style.toString(), contains('transitionDuration: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.reverseTransitionDuration inherits, copies and participates in value identity', () {
    final Duration value = const Duration(milliseconds: 177);
    final DatePickerStyle style = DatePickerStyle(
      reverseTransitionDuration: value,
    );
    expect(const DatePickerStyle().reverseTransitionDuration, isNull);
    expect(
      const DatePickerStyle().copyWith(reverseTransitionDuration: value),
      style,
    );
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      DatePickerStyle(reverseTransitionDuration: value).hashCode,
    );
    expect(style.toString(), contains('reverseTransitionDuration: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.transitionBuilder inherits, copies and participates in value identity', () {
    final OverlayTransitionBuilder value = transition;
    final DatePickerStyle style = DatePickerStyle(transitionBuilder: value);
    expect(const DatePickerStyle().transitionBuilder, isNull);
    expect(const DatePickerStyle().copyWith(transitionBuilder: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DatePickerStyle(transitionBuilder: value).hashCode);
    expect(style.toString(), contains('transitionBuilder: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
  test('DatePickerStyle.dayStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(dayStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            dayStyle: ButtonStyle(spacing: 9, tapTargetSize: Size(48, 48)),
          ),
        );
    expect(merged.dayStyle!.spacing, 3);
    expect(merged.dayStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.todayStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(todayStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            todayStyle: ButtonStyle(spacing: 9, tapTargetSize: Size(48, 48)),
          ),
        );
    expect(merged.todayStyle!.spacing, 3);
    expect(merged.todayStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.selectedDayStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(selectedDayStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            selectedDayStyle: ButtonStyle(
              spacing: 9,
              tapTargetSize: Size(48, 48),
            ),
          ),
        );
    expect(merged.selectedDayStyle!.spacing, 3);
    expect(merged.selectedDayStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.inRangeDayStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(inRangeDayStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            inRangeDayStyle: ButtonStyle(
              spacing: 9,
              tapTargetSize: Size(48, 48),
            ),
          ),
        );
    expect(merged.inRangeDayStyle!.spacing, 3);
    expect(merged.inRangeDayStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.rangeStartStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(rangeStartStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            rangeStartStyle: ButtonStyle(
              spacing: 9,
              tapTargetSize: Size(48, 48),
            ),
          ),
        );
    expect(merged.rangeStartStyle!.spacing, 3);
    expect(merged.rangeStartStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.rangeEndStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(rangeEndStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            rangeEndStyle: ButtonStyle(spacing: 9, tapTargetSize: Size(48, 48)),
          ),
        );
    expect(merged.rangeEndStyle!.spacing, 3);
    expect(merged.rangeEndStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.yearStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(yearStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            yearStyle: ButtonStyle(spacing: 9, tapTargetSize: Size(48, 48)),
          ),
        );
    expect(merged.yearStyle!.spacing, 3);
    expect(merged.yearStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.disabledDayStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(disabledDayStyle: ButtonStyle(spacing: 3)).merge(
          const DatePickerStyle(
            disabledDayStyle: ButtonStyle(
              spacing: 9,
              tapTargetSize: Size(48, 48),
            ),
          ),
        );
    expect(merged.disabledDayStyle!.spacing, 3);
    expect(merged.disabledDayStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.navigationButtonStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(navigationButtonStyle: ButtonStyle(spacing: 3))
            .merge(
              const DatePickerStyle(
                navigationButtonStyle: ButtonStyle(
                  spacing: 9,
                  tapTargetSize: Size(48, 48),
                ),
              ),
            );
    expect(merged.navigationButtonStyle!.spacing, 3);
    expect(merged.navigationButtonStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.entryModeButtonStyle deep merges nested tokens', () {
    final DatePickerStyle merged =
        const DatePickerStyle(entryModeButtonStyle: ButtonStyle(spacing: 3))
            .merge(
              const DatePickerStyle(
                entryModeButtonStyle: ButtonStyle(
                  spacing: 9,
                  tapTargetSize: Size(48, 48),
                ),
              ),
            );
    expect(merged.entryModeButtonStyle!.spacing, 3);
    expect(merged.entryModeButtonStyle!.tapTargetSize, const Size(48, 48));
  });
  test('TimePickerStyle.decoration inherits, copies and participates in value identity', () {
    final Decoration value = const BoxDecoration(color: Color(0xFF123456));
    final TimePickerStyle style = TimePickerStyle(decoration: value);
    expect(const TimePickerStyle().decoration, isNull);
    expect(const TimePickerStyle().copyWith(decoration: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(decoration: value).hashCode);
    expect(style.toString(), contains('decoration: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.padding inherits, copies and participates in value identity', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(
      start: 11,
    );
    final TimePickerStyle style = TimePickerStyle(padding: value);
    expect(const TimePickerStyle().padding, isNull);
    expect(const TimePickerStyle().copyWith(padding: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(padding: value).hashCode);
    expect(style.toString(), contains('padding: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.headerTextStyle inherits, copies and participates in value identity', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final TimePickerStyle style = TimePickerStyle(headerTextStyle: value);
    expect(const TimePickerStyle().headerTextStyle, isNull);
    expect(const TimePickerStyle().copyWith(headerTextStyle: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(headerTextStyle: value).hashCode);
    expect(style.toString(), contains('headerTextStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.dialTextStyle inherits, copies and participates in value identity', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final TimePickerStyle style = TimePickerStyle(dialTextStyle: value);
    expect(const TimePickerStyle().dialTextStyle, isNull);
    expect(const TimePickerStyle().copyWith(dialTextStyle: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(dialTextStyle: value).hashCode);
    expect(style.toString(), contains('dialTextStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.inputTextStyle inherits, copies and participates in value identity', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final TimePickerStyle style = TimePickerStyle(inputTextStyle: value);
    expect(const TimePickerStyle().inputTextStyle, isNull);
    expect(const TimePickerStyle().copyWith(inputTextStyle: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(inputTextStyle: value).hashCode);
    expect(style.toString(), contains('inputTextStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.segmentStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final TimePickerStyle style = TimePickerStyle(segmentStyle: value);
    expect(const TimePickerStyle().segmentStyle, isNull);
    expect(const TimePickerStyle().copyWith(segmentStyle: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(segmentStyle: value).hashCode);
    expect(style.toString(), contains('segmentStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.selectedSegmentStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final TimePickerStyle style = TimePickerStyle(selectedSegmentStyle: value);
    expect(const TimePickerStyle().selectedSegmentStyle, isNull);
    expect(
      const TimePickerStyle().copyWith(selectedSegmentStyle: value),
      style,
    );
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      TimePickerStyle(selectedSegmentStyle: value).hashCode,
    );
    expect(style.toString(), contains('selectedSegmentStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.periodStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final TimePickerStyle style = TimePickerStyle(periodStyle: value);
    expect(const TimePickerStyle().periodStyle, isNull);
    expect(const TimePickerStyle().copyWith(periodStyle: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(periodStyle: value).hashCode);
    expect(style.toString(), contains('periodStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.selectedPeriodStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final TimePickerStyle style = TimePickerStyle(selectedPeriodStyle: value);
    expect(const TimePickerStyle().selectedPeriodStyle, isNull);
    expect(const TimePickerStyle().copyWith(selectedPeriodStyle: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      TimePickerStyle(selectedPeriodStyle: value).hashCode,
    );
    expect(style.toString(), contains('selectedPeriodStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.entryModeButtonStyle inherits, copies and participates in value identity', () {
    final ButtonStyle value = const ButtonStyle(spacing: 7);
    final TimePickerStyle style = TimePickerStyle(entryModeButtonStyle: value);
    expect(const TimePickerStyle().entryModeButtonStyle, isNull);
    expect(
      const TimePickerStyle().copyWith(entryModeButtonStyle: value),
      style,
    );
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      TimePickerStyle(entryModeButtonStyle: value).hashCode,
    );
    expect(style.toString(), contains('entryModeButtonStyle: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.dialDecoration inherits, copies and participates in value identity', () {
    final Decoration value = const BoxDecoration(color: Color(0xFF123456));
    final TimePickerStyle style = TimePickerStyle(dialDecoration: value);
    expect(const TimePickerStyle().dialDecoration, isNull);
    expect(const TimePickerStyle().copyWith(dialDecoration: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(dialDecoration: value).hashCode);
    expect(style.toString(), contains('dialDecoration: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.handDecoration inherits, copies and participates in value identity', () {
    final Decoration value = const BoxDecoration(color: Color(0xFF123456));
    final TimePickerStyle style = TimePickerStyle(handDecoration: value);
    expect(const TimePickerStyle().handDecoration, isNull);
    expect(const TimePickerStyle().copyWith(handDecoration: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(handDecoration: value).hashCode);
    expect(style.toString(), contains('handDecoration: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.handColor inherits, copies and participates in value identity', () {
    final Color value = const Color(0xFF123456);
    final TimePickerStyle style = TimePickerStyle(handColor: value);
    expect(const TimePickerStyle().handColor, isNull);
    expect(const TimePickerStyle().copyWith(handColor: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(handColor: value).hashCode);
    expect(style.toString(), contains('handColor: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.dialBackgroundColor inherits, copies and participates in value identity', () {
    final Color value = const Color(0xFF123456);
    final TimePickerStyle style = TimePickerStyle(dialBackgroundColor: value);
    expect(const TimePickerStyle().dialBackgroundColor, isNull);
    expect(const TimePickerStyle().copyWith(dialBackgroundColor: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      TimePickerStyle(dialBackgroundColor: value).hashCode,
    );
    expect(style.toString(), contains('dialBackgroundColor: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.dialSize inherits, copies and participates in value identity', () {
    final double value = 22.0;
    final TimePickerStyle style = TimePickerStyle(dialSize: value);
    expect(const TimePickerStyle().dialSize, isNull);
    expect(const TimePickerStyle().copyWith(dialSize: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(dialSize: value).hashCode);
    expect(style.toString(), contains('dialSize: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.handWidth inherits, copies and participates in value identity', () {
    final double value = 22.0;
    final TimePickerStyle style = TimePickerStyle(handWidth: value);
    expect(const TimePickerStyle().handWidth, isNull);
    expect(const TimePickerStyle().copyWith(handWidth: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(handWidth: value).hashCode);
    expect(style.toString(), contains('handWidth: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.handRadius inherits, copies and participates in value identity', () {
    final double value = 22.0;
    final TimePickerStyle style = TimePickerStyle(handRadius: value);
    expect(const TimePickerStyle().handRadius, isNull);
    expect(const TimePickerStyle().copyWith(handRadius: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(handRadius: value).hashCode);
    expect(style.toString(), contains('handRadius: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.animationDuration inherits, copies and participates in value identity', () {
    final Duration value = const Duration(milliseconds: 177);
    final TimePickerStyle style = TimePickerStyle(animationDuration: value);
    expect(const TimePickerStyle().animationDuration, isNull);
    expect(const TimePickerStyle().copyWith(animationDuration: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(animationDuration: value).hashCode);
    expect(style.toString(), contains('animationDuration: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.animationCurve inherits, copies and participates in value identity', () {
    final Curve value = Curves.easeIn;
    final TimePickerStyle style = TimePickerStyle(animationCurve: value);
    expect(const TimePickerStyle().animationCurve, isNull);
    expect(const TimePickerStyle().copyWith(animationCurve: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(animationCurve: value).hashCode);
    expect(style.toString(), contains('animationCurve: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.spring inherits, copies and participates in value identity', () {
    final MotionSpring value = MotionSpring.bouncy;
    final TimePickerStyle style = TimePickerStyle(spring: value);
    expect(const TimePickerStyle().spring, isNull);
    expect(const TimePickerStyle().copyWith(spring: value), style);
    expect(const TimePickerStyle().merge(style), style);
    expect(style.merge(const TimePickerStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TimePickerStyle(spring: value).hashCode);
    expect(style.toString(), contains('spring: $value'));
    expect(style, isNot(const TimePickerStyle()));
  });
  test('TimePickerStyle.segmentStyle deep merges nested tokens', () {
    final TimePickerStyle merged =
        const TimePickerStyle(segmentStyle: ButtonStyle(spacing: 3)).merge(
          const TimePickerStyle(
            segmentStyle: ButtonStyle(spacing: 9, tapTargetSize: Size(48, 48)),
          ),
        );
    expect(merged.segmentStyle!.spacing, 3);
    expect(merged.segmentStyle!.tapTargetSize, const Size(48, 48));
  });
  test('TimePickerStyle.selectedSegmentStyle deep merges nested tokens', () {
    final TimePickerStyle merged =
        const TimePickerStyle(selectedSegmentStyle: ButtonStyle(spacing: 3))
            .merge(
              const TimePickerStyle(
                selectedSegmentStyle: ButtonStyle(
                  spacing: 9,
                  tapTargetSize: Size(48, 48),
                ),
              ),
            );
    expect(merged.selectedSegmentStyle!.spacing, 3);
    expect(merged.selectedSegmentStyle!.tapTargetSize, const Size(48, 48));
  });
  test('TimePickerStyle.periodStyle deep merges nested tokens', () {
    final TimePickerStyle merged =
        const TimePickerStyle(periodStyle: ButtonStyle(spacing: 3)).merge(
          const TimePickerStyle(
            periodStyle: ButtonStyle(spacing: 9, tapTargetSize: Size(48, 48)),
          ),
        );
    expect(merged.periodStyle!.spacing, 3);
    expect(merged.periodStyle!.tapTargetSize, const Size(48, 48));
  });
  test('TimePickerStyle.selectedPeriodStyle deep merges nested tokens', () {
    final TimePickerStyle merged =
        const TimePickerStyle(selectedPeriodStyle: ButtonStyle(spacing: 3))
            .merge(
              const TimePickerStyle(
                selectedPeriodStyle: ButtonStyle(
                  spacing: 9,
                  tapTargetSize: Size(48, 48),
                ),
              ),
            );
    expect(merged.selectedPeriodStyle!.spacing, 3);
    expect(merged.selectedPeriodStyle!.tapTargetSize, const Size(48, 48));
  });
  test('TimePickerStyle.entryModeButtonStyle deep merges nested tokens', () {
    final TimePickerStyle merged =
        const TimePickerStyle(entryModeButtonStyle: ButtonStyle(spacing: 3))
            .merge(
              const TimePickerStyle(
                entryModeButtonStyle: ButtonStyle(
                  spacing: 9,
                  tapTargetSize: Size(48, 48),
                ),
              ),
            );
    expect(merged.entryModeButtonStyle!.spacing, 3);
    expect(merged.entryModeButtonStyle!.tapTargetSize, const Size(48, 48));
  });
  test('DatePickerStyle.transitionCurve inherits and participates in value identity', () {
    const Curve value = Curves.easeIn;
    const DatePickerStyle style = DatePickerStyle(transitionCurve: value);
    expect(const DatePickerStyle().transitionCurve, isNull);
    expect(const DatePickerStyle().copyWith(transitionCurve: value), style);
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(
      style.hashCode,
      const DatePickerStyle(transitionCurve: value).hashCode,
    );
    expect(style.toString(), contains('transitionCurve: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });

  test('DatePickerStyle.reverseTransitionCurve inherits and participates in value identity', () {
    const Curve value = Curves.easeIn;
    const DatePickerStyle style = DatePickerStyle(
      reverseTransitionCurve: value,
    );
    expect(const DatePickerStyle().reverseTransitionCurve, isNull);
    expect(
      const DatePickerStyle().copyWith(reverseTransitionCurve: value),
      style,
    );
    expect(const DatePickerStyle().merge(style), style);
    expect(style.merge(const DatePickerStyle()), style);
    expect(
      style.hashCode,
      const DatePickerStyle(reverseTransitionCurve: value).hashCode,
    );
    expect(style.toString(), contains('reverseTransitionCurve: $value'));
    expect(style, isNot(const DatePickerStyle()));
  });
}
