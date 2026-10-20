import 'package:flutter/widgets.dart';

import '../dates/date.dart';
import '../dates/time.dart';

/// The text and date conventions used by NeutralUI components.
///
/// Extend [DefaultNeutralLocalizations] to override individual English defaults,
/// or implement this interface for another language. Install a
/// [LocalizationsDelegate] with a type of [NeutralLocalizations] to provide it.
abstract class NeutralLocalizations {
  /// Creates localized resources.
  const NeutralLocalizations();

  /// The English delegate installed by NeutralApp.
  static const LocalizationsDelegate<NeutralLocalizations> delegate =
      NeutralLocalizationsDelegate();

  /// Resources from the nearest [Localizations], or English when none exist.
  static NeutralLocalizations of(BuildContext context) =>
      Localizations.of<NeutralLocalizations>(context, NeutralLocalizations) ??
      const DefaultNeutralLocalizations();

  /// Full month names, ordered January through December.
  List<String> get months;

  /// Abbreviated month names, ordered January through December.
  List<String> get shortMonths;

  /// Full weekday names, ordered Sunday through Saturday.
  List<String> get weekdays;

  /// Abbreviated weekday names, ordered Sunday through Saturday.
  List<String> get shortWeekdays;

  /// Single-character weekday labels, ordered Sunday through Saturday.
  List<String> get narrowWeekdays;

  /// The index into [narrowWeekdays] of the first day of a calendar week.
  int get firstDayOfWeekIndex;

  /// Formats a full month name and year.
  String formatMonthYear(DateTime date);

  /// Formats an unabbreviated year.
  String formatYear(DateTime date);

  /// Formats an abbreviated weekday, month and day.
  String formatMediumDate(DateTime date);

  /// Formats the full weekday, month, day and year for accessibility.
  String formatFullDate(DateTime date);

  /// Formats an abbreviated month, day and year.
  String formatShortDate(DateTime date);

  /// Formats an abbreviated month and day.
  String formatShortMonthDay(DateTime date);

  /// Formats a numeric date for text input.
  String formatCompactDate(DateTime date);

  /// Parses a compact date, returning null for invalid or incomplete input.
  DateTime? parseCompactDate(String? inputString);

  /// Formats an integer with localized digits and grouping.
  String formatDecimal(int number);

  /// The clock layout and punctuation for this locale.
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false});

  /// Formats an hour using the requested 12- or 24-hour convention.
  String formatHour(TimeOfDay timeOfDay, {bool alwaysUse24HourFormat = false});

  /// Formats a two-digit minute.
  String formatMinute(TimeOfDay timeOfDay);

  /// Formats a time using the requested 12- or 24-hour convention.
  String formatTimeOfDay(
    TimeOfDay timeOfDay, {
    bool alwaysUse24HourFormat = false,
  });

  /// The text shown for a count badge, capped at [maxCount].
  String formatBadgeCount(int count, {int maxCount = 99});

  /// Tooltip for revealing a password.
  String get showPasswordTooltip;

  /// Tooltip for concealing a password.
  String get hidePasswordTooltip;

  /// Tooltip for opening navigation.
  String get openAppDrawerTooltip;

  /// Tooltip for navigating back.
  String get backButtonTooltip;

  /// Tooltip for clearing input.
  String get clearButtonTooltip;

  /// Tooltip for closing a surface or notification.
  String get closeButtonTooltip;

  /// Tooltip for deleting a chip or item.
  String get deleteButtonTooltip;

  /// Tooltip for additional actions.
  String get moreButtonTooltip;

  /// Tooltip for the next calendar month.
  String get nextMonthTooltip;

  /// Tooltip for the previous calendar month.
  String get previousMonthTooltip;

  /// Tooltip for the first page.
  String get firstPageTooltip;

  /// Tooltip for the last page.
  String get lastPageTooltip;

  /// Tooltip for the next page.
  String get nextPageTooltip;

  /// Tooltip for the previous page.
  String get previousPageTooltip;

  /// Tooltip for opening a menu.
  String get showMenuTooltip;

  /// Announces a one-based tab position and total tab count.
  String tabLabel({required int tabIndex, required int tabCount});

  /// Label for a cancel action.
  String get cancelButtonLabel;

  /// Label for a close action.
  String get closeButtonLabel;

  /// Label for a continue action.
  String get continueButtonLabel;

  /// Label for a confirmation action.
  String get okButtonLabel;

  /// Label for a save action.
  String get saveButtonLabel;

  /// The abbreviation for the period before noon.
  String get anteMeridiemAbbreviation;

  /// The abbreviation for the period beginning at noon.
  String get postMeridiemAbbreviation;

  /// Announces that the dial is selecting an hour.
  String get timePickerHourModeAnnouncement;

  /// Announces that the dial is selecting a minute.
  String get timePickerMinuteModeAnnouncement;

  /// The action available on a dismissible modal barrier.
  String get modalBarrierDismissLabel;

  /// The action for dismissing a menu.
  String get menuDismissLabel;

  /// The semantic name of navigation drawers.
  String get drawerLabel;

  /// The semantic name of popup menus.
  String get popupMenuLabel;

  /// The semantic name of menu bar menus.
  String get menuBarMenuLabel;

  /// The semantic name of a dialog route.
  String get dialogLabel;

  /// The semantic name of an alert dialog route.
  String get alertDialogLabel;

  /// The label of an otherwise unnamed search field.
  String get searchFieldLabel;

  /// Identifies today's date in a calendar.
  String get currentDateLabel;

  /// Identifies the selected date in a calendar.
  String get selectedDateLabel;

  /// The semantic name of a modal scrim.
  String get scrimLabel;

  /// The semantic name of a bottom sheet.
  String get bottomSheetLabel;

  /// The semantic name of a snack bar notification.
  String get snackBarLabel;

  /// Explains that tapping the scrim closes its modal content.
  String scrimOnTapHint(String modalRouteContentName);

  /// Separates numeric date components.
  String get dateSeparator;

  /// The compact date input format hint.
  String get dateHelpText;

  /// The action that opens the year grid.
  String get selectYearSemanticsLabel;

  /// Placeholder for a date that has not been selected.
  String get unspecifiedDate;

  /// Placeholder for a range that has not been selected.
  String get unspecifiedDateRange;

  /// Label of a date input field.
  String get dateInputLabel;

  /// Label of the range start input.
  String get dateRangeStartLabel;

  /// Label of the range end input.
  String get dateRangeEndLabel;

  /// Identifies the selected range start in spoken feedback.
  String dateRangeStartDateSemanticLabel(String formattedDate);

  /// Identifies the selected range end in spoken feedback.
  String dateRangeEndDateSemanticLabel(String formattedDate);

  /// Error for malformed date input.
  String get invalidDateFormatLabel;

  /// Error for a reversed or otherwise invalid range.
  String get invalidDateRangeLabel;

  /// Error for a date outside the allowed interval or disabled by a predicate.
  String get dateOutOfRangeLabel;

  /// The date picker heading.
  String get datePickerHelpText;

  /// The date range picker heading.
  String get dateRangePickerHelpText;

  /// The action that switches date input to a calendar.
  String get calendarModeButtonLabel;

  /// The action that switches a calendar to date input.
  String get inputDateModeButtonLabel;

  /// The dial time picker heading.
  String get timePickerDialHelpText;

  /// The text input time picker heading.
  String get timePickerInputHelpText;

  /// Label of the hour input.
  String get timePickerHourLabel;

  /// Label of the minute input.
  String get timePickerMinuteLabel;

  /// Error for an invalid time.
  String get invalidTimeLabel;

  /// The action that switches time input to the dial.
  String get dialModeButtonLabel;

  /// The action that switches the dial to time input.
  String get inputTimeModeButtonLabel;

  /// The action that collapses expanded content.
  String get expandedIconTapHint;

  /// The action that expands collapsed content.
  String get collapsedIconTapHint;

  /// Spoken gesture hint on an expanded expansion tile.
  String get expansionTileExpandedHint;

  /// Spoken gesture hint on a collapsed expansion tile.
  String get expansionTileCollapsedHint;

  /// Tap action on an expanded expansion tile.
  String get expansionTileExpandedTapHint;

  /// Tap action on a collapsed expansion tile.
  String get expansionTileCollapsedTapHint;

  /// Announces the collapsed state after an expansion action.
  String get expandedHint;

  /// Announces the expanded state after a collapse action.
  String get collapsedHint;

  /// Announces the number of remaining input characters.
  String remainingTextFieldCharacterCount(int remaining);

  /// The semantic label of a refresh indicator.
  String get refreshIndicatorSemanticLabel;
}

/// English resources with US numeric date and 12-hour time conventions.
class DefaultNeutralLocalizations extends NeutralLocalizations {
  /// Creates the default English resources.
  const DefaultNeutralLocalizations();

  /// The default English localization delegate.
  static const LocalizationsDelegate<NeutralLocalizations> delegate =
      NeutralLocalizationsDelegate();

  /// Loads English resources without an external localization dependency.
  static Future<NeutralLocalizations> load(Locale locale) =>
      Future<NeutralLocalizations>.value(const DefaultNeutralLocalizations());

  @override
  List<String> get months => const <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  List<String> get shortMonths => const <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  List<String> get weekdays => const <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  List<String> get shortWeekdays => const <String>[
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  List<String> get narrowWeekdays => const <String>[
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  @override
  int get firstDayOfWeekIndex => 0;

  @override
  String formatMonthYear(DateTime date) =>
      '${months[date.month - 1]} ${formatYear(date)}';

  @override
  String formatYear(DateTime date) => date.year.toString();

  @override
  String formatMediumDate(DateTime date) =>
      '${shortWeekdays[date.weekday % 7]}, ${formatShortMonthDay(date)}';

  @override
  String formatFullDate(DateTime date) =>
      '${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}, ${formatYear(date)}';

  @override
  String formatShortDate(DateTime date) =>
      '${formatShortMonthDay(date)}, ${formatYear(date)}';

  @override
  String formatShortMonthDay(DateTime date) =>
      '${shortMonths[date.month - 1]} ${date.day}';

  @override
  String formatCompactDate(DateTime date) =>
      '${_twoDigits(date.month)}$dateSeparator${_twoDigits(date.day)}$dateSeparator${formatYear(date).padLeft(4, '0')}';

  @override
  DateTime? parseCompactDate(String? inputString) {
    if (inputString == null) {
      return null;
    }
    final List<String> parts = inputString.split(dateSeparator);
    if (parts.length != 3) {
      return null;
    }
    final int? month = int.tryParse(parts[0], radix: 10);
    final int? day = int.tryParse(parts[1], radix: 10);
    final int? year = int.tryParse(parts[2], radix: 10);
    if (year == null ||
        year < 1 ||
        month == null ||
        month < 1 ||
        month > 12 ||
        day == null ||
        day < 1 ||
        day > DateUtils.getDaysInMonth(year, month)) {
      return null;
    }
    try {
      final DateTime date = DateTime(year, month, day);
      // DateTime can normalize or overflow input without throwing.
      return date.year == year && date.month == month && date.day == day
          ? date
          : null;
    } on ArgumentError {
      return null;
    }
  }

  @override
  String formatDecimal(int number) {
    final String value = number.toString();
    final String digits = number < 0 ? value.substring(1) : value;
    final StringBuffer result = StringBuffer(number < 0 ? '-' : '');
    for (int i = 0; i < digits.length; i += 1) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(digits[i]);
    }
    return result.toString();
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) =>
      alwaysUse24HourFormat
      ? TimeOfDayFormat.HH_colon_mm
      : TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String formatHour(
    TimeOfDay timeOfDay, {
    bool alwaysUse24HourFormat = false,
  }) => switch (hourFormat(
    of: timeOfDayFormat(alwaysUse24HourFormat: alwaysUse24HourFormat),
  )) {
    HourFormat.HH => _twoDigits(timeOfDay.hour),
    HourFormat.H => formatDecimal(timeOfDay.hour),
    HourFormat.h => formatDecimal(timeOfDay.hourOfPeriod),
  };

  @override
  String formatMinute(TimeOfDay timeOfDay) => _twoDigits(timeOfDay.minute);

  @override
  String formatTimeOfDay(
    TimeOfDay timeOfDay, {
    bool alwaysUse24HourFormat = false,
  }) {
    final String hour = formatHour(
      timeOfDay,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );
    final String minute = formatMinute(timeOfDay);
    final String period = timeOfDay.period == DayPeriod.am
        ? anteMeridiemAbbreviation
        : postMeridiemAbbreviation;
    return switch (timeOfDayFormat(
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    )) {
      TimeOfDayFormat.HH_colon_mm ||
      TimeOfDayFormat.H_colon_mm => '$hour:$minute',
      TimeOfDayFormat.HH_dot_mm => '$hour.$minute',
      TimeOfDayFormat.frenchCanadian => '$hour h $minute',
      TimeOfDayFormat.h_colon_mm_space_a => '$hour:$minute $period',
      TimeOfDayFormat.a_space_h_colon_mm => '$period $hour:$minute',
    };
  }

  @override
  String formatBadgeCount(int count, {int maxCount = 99}) {
    assert(count >= 0);
    assert(maxCount > 0);
    return count > maxCount
        ? '${formatDecimal(maxCount)}+'
        : formatDecimal(count);
  }

  @override
  String get showPasswordTooltip => 'Show password';
  @override
  String get hidePasswordTooltip => 'Hide password';
  @override
  String get openAppDrawerTooltip => 'Open navigation menu';
  @override
  String get backButtonTooltip => 'Back';
  @override
  String get clearButtonTooltip => 'Clear text';
  @override
  String get closeButtonTooltip => 'Close';
  @override
  String get deleteButtonTooltip => 'Delete';
  @override
  String get moreButtonTooltip => 'More';
  @override
  String get nextMonthTooltip => 'Next month';
  @override
  String get previousMonthTooltip => 'Previous month';
  @override
  String get firstPageTooltip => 'First page';
  @override
  String get lastPageTooltip => 'Last page';
  @override
  String get nextPageTooltip => 'Next page';
  @override
  String get previousPageTooltip => 'Previous page';
  @override
  String get showMenuTooltip => 'Show menu';

  @override
  String tabLabel({required int tabIndex, required int tabCount}) {
    assert(tabIndex >= 1 && tabCount >= 1 && tabIndex <= tabCount);
    return 'Tab ${formatDecimal(tabIndex)} of ${formatDecimal(tabCount)}';
  }

  @override
  String get cancelButtonLabel => 'Cancel';
  @override
  String get closeButtonLabel => 'Close';
  @override
  String get continueButtonLabel => 'Continue';
  @override
  String get okButtonLabel => 'OK';
  @override
  String get saveButtonLabel => 'Save';
  @override
  String get anteMeridiemAbbreviation => 'AM';
  @override
  String get postMeridiemAbbreviation => 'PM';
  @override
  String get timePickerHourModeAnnouncement => 'Select hours';
  @override
  String get timePickerMinuteModeAnnouncement => 'Select minutes';
  @override
  String get modalBarrierDismissLabel => 'Dismiss';
  @override
  String get menuDismissLabel => 'Dismiss menu';
  @override
  String get drawerLabel => 'Navigation menu';
  @override
  String get popupMenuLabel => 'Popup menu';
  @override
  String get menuBarMenuLabel => 'Menu bar menu';
  @override
  String get dialogLabel => 'Dialog';
  @override
  String get alertDialogLabel => 'Alert';
  @override
  String get searchFieldLabel => 'Search';
  @override
  String get currentDateLabel => 'Today';
  @override
  String get selectedDateLabel => 'Selected';
  @override
  String get scrimLabel => 'Scrim';
  @override
  String get bottomSheetLabel => 'Bottom Sheet';
  @override
  String get snackBarLabel => 'Notification';
  @override
  String scrimOnTapHint(String modalRouteContentName) =>
      'Close $modalRouteContentName';
  @override
  String get dateSeparator => '/';
  @override
  String get dateHelpText => 'mm/dd/yyyy';
  @override
  String get selectYearSemanticsLabel => 'Select year';
  @override
  String get unspecifiedDate => 'Date';
  @override
  String get unspecifiedDateRange => 'Date Range';
  @override
  String get dateInputLabel => 'Enter Date';
  @override
  String get dateRangeStartLabel => 'Start Date';
  @override
  String get dateRangeEndLabel => 'End Date';
  @override
  String dateRangeStartDateSemanticLabel(String formattedDate) =>
      'Start date $formattedDate';
  @override
  String dateRangeEndDateSemanticLabel(String formattedDate) =>
      'End date $formattedDate';
  @override
  String get invalidDateFormatLabel => 'Invalid format.';
  @override
  String get invalidDateRangeLabel => 'Invalid range.';
  @override
  String get dateOutOfRangeLabel => 'Out of range.';
  @override
  String get datePickerHelpText => 'Select date';
  @override
  String get dateRangePickerHelpText => 'Select range';
  @override
  String get calendarModeButtonLabel => 'Switch to calendar';
  @override
  String get inputDateModeButtonLabel => 'Switch to input';
  @override
  String get timePickerDialHelpText => 'Select time';
  @override
  String get timePickerInputHelpText => 'Enter time';
  @override
  String get timePickerHourLabel => 'Hour';
  @override
  String get timePickerMinuteLabel => 'Minute';
  @override
  String get invalidTimeLabel => 'Enter a valid time';
  @override
  String get dialModeButtonLabel => 'Switch to dial picker mode';
  @override
  String get inputTimeModeButtonLabel => 'Switch to text input mode';
  @override
  String get expandedIconTapHint => 'Collapse';
  @override
  String get collapsedIconTapHint => 'Expand';
  @override
  String get expansionTileExpandedHint => 'double tap to collapse';
  @override
  String get expansionTileCollapsedHint => 'double tap to expand';
  @override
  String get expansionTileExpandedTapHint => 'Collapse';
  @override
  String get expansionTileCollapsedTapHint => 'Expand for more details';
  @override
  String get expandedHint => 'Collapsed';
  @override
  String get collapsedHint => 'Expanded';
  @override
  String remainingTextFieldCharacterCount(int remaining) => switch (remaining) {
    0 => 'No characters remaining',
    1 => '1 character remaining',
    _ => '${formatDecimal(remaining)} characters remaining',
  };
  @override
  String get refreshIndicatorSemanticLabel => 'Refresh';
}

/// Loads [DefaultNeutralLocalizations] for English locales.
class NeutralLocalizationsDelegate
    extends LocalizationsDelegate<NeutralLocalizations> {
  /// Creates the default delegate.
  const NeutralLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<NeutralLocalizations> load(Locale locale) =>
      DefaultNeutralLocalizations.load(locale);

  @override
  bool shouldReload(NeutralLocalizationsDelegate old) => false;

  @override
  String toString() => 'NeutralLocalizationsDelegate(en)';
}
